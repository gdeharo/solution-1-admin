#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';

function usage() {
  console.error(
    'Usage: node scripts/import_companies_contacts_csv.mjs --input <file.csv> [--out <import.sql>] [--country <US>] [--reset] [--transaction]'
  );
  process.exit(1);
}

function parseArgs(argv) {
  const args = { country: 'US', reset: false, transaction: false };
  for (let i = 2; i < argv.length; i += 1) {
    const arg = argv[i];
    if (arg === '--input') args.input = argv[++i];
    else if (arg === '--out') args.out = argv[++i];
    else if (arg === '--country') args.country = argv[++i];
    else if (arg === '--reset') args.reset = true;
    else if (arg === '--transaction') args.transaction = true;
    else usage();
  }
  if (!args.input) usage();
  return args;
}

function parseCsv(text) {
  const rows = [];
  let row = [];
  let field = '';
  let inQuotes = false;
  for (let i = 0; i < text.length; i += 1) {
    const ch = text[i];
    if (ch === '"') {
      if (inQuotes && text[i + 1] === '"') {
        field += '"';
        i += 1;
      } else {
        inQuotes = !inQuotes;
      }
      continue;
    }
    if (!inQuotes && ch === ',') {
      row.push(field);
      field = '';
      continue;
    }
    if (!inQuotes && (ch === '\n' || ch === '\r')) {
      if (ch === '\r' && text[i + 1] === '\n') i += 1;
      row.push(field);
      field = '';
      if (row.some((v) => String(v).trim() !== '')) rows.push(row);
      row = [];
      continue;
    }
    field += ch;
  }
  row.push(field);
  if (row.some((v) => String(v).trim() !== '')) rows.push(row);
  return rows;
}

function normalizeHeader(s) {
  return String(s || '')
    .trim()
    .toLowerCase()
    .replace(/\s+/g, ' ');
}

function sqlString(value) {
  if (value == null) return 'NULL';
  const cleaned = String(value).trim();
  if (!cleaned) return 'NULL';
  return `'${cleaned.replace(/'/g, "''")}'`;
}

function sqlText(value) {
  const cleaned = String(value ?? '').trim();
  return `'${cleaned.replace(/'/g, "''")}'`;
}

function splitContact(fullName) {
  const parts = String(fullName || '')
    .trim()
    .split(/\s+/)
    .filter(Boolean);
  if (!parts.length) return { firstName: 'Unknown', lastName: 'Contact' };
  if (parts.length === 1) return { firstName: parts[0], lastName: '' };
  return { firstName: parts[0], lastName: parts.slice(1).join(' ') };
}

function normalizeZip(rawZip) {
  const raw = String(rawZip || '').trim();
  if (!raw) return '';
  return raw.replace(/\s+/g, '').replace(/[^0-9A-Za-z-]/g, '');
}

function main() {
  const args = parseArgs(process.argv);
  const inputPath = path.resolve(args.input);
  if (!fs.existsSync(inputPath)) {
    console.error(`Input not found: ${inputPath}`);
    process.exit(1);
  }
  const csv = fs.readFileSync(inputPath, 'utf8');
  const rows = parseCsv(csv);
  if (rows.length < 2) {
    console.error('CSV has no data rows.');
    process.exit(1);
  }

  const header = rows[0].map(normalizeHeader);
  const dataRows = rows.slice(1);
  const col = (name) => header.indexOf(normalizeHeader(name));
  const colAny = (...names) => {
    for (const name of names) {
      const idx = col(name);
      if (idx >= 0) return idx;
    }
    return -1;
  };

  const idxCompany = colAny('B2B Portal Name', 'Name', 'B2B Portal');
  const idxContact = col('Contact');
  const idxAddress = col('Address');
  const idxCity = col('City');
  const idxState = col('St');
  const idxZip = col('Zip Code');
  const idxPhone = col('Phone');
  const idxEmail = col('Email');
  const idxWebsite = col('Website');

  const required = [
    ['B2B Portal Name or Name', idxCompany],
    ['Contact', idxContact],
    ['Address', idxAddress],
    ['City', idxCity],
    ['St', idxState],
    ['Zip Code', idxZip],
    ['Phone', idxPhone],
    ['Email', idxEmail],
    ['Website', idxWebsite]
  ].filter(([, index]) => index < 0);
  if (required.length) {
    console.error(`Missing expected headers: ${required.map(([name]) => name).join(', ')}`);
    process.exit(1);
  }

  const seenNames = new Set();
  const duplicateNames = new Set();
  const statements = [];
  statements.push('PRAGMA foreign_keys = ON;');
  if (args.transaction) statements.push('BEGIN TRANSACTION;');

  if (args.reset) {
    statements.push('DELETE FROM attachments WHERE entity_type IN (\'company\', \'customer\', \'interaction\');');
    statements.push('DELETE FROM interactions;');
    statements.push('DELETE FROM customer_reps;');
    statements.push('DELETE FROM company_reps;');
    statements.push('DELETE FROM customers;');
    statements.push('DELETE FROM companies;');
  }

  let imported = 0;
  for (const row of dataRows) {
    const companyName = String(row[idxCompany] || '').trim();
    if (!companyName) continue;
    if (seenNames.has(companyName.toLowerCase())) duplicateNames.add(companyName);
    seenNames.add(companyName.toLowerCase());

    const contactRaw = String(row[idxContact] || '').trim();
    const { firstName, lastName } = splitContact(contactRaw);
    const address = String(row[idxAddress] || '').trim();
    const city = String(row[idxCity] || '').trim();
    const state = String(row[idxState] || '').trim().toUpperCase();
    const zip = normalizeZip(row[idxZip]);
    const phone = String(row[idxPhone] || '').trim();
    const email = String(row[idxEmail] || '').trim();
    const website = String(row[idxWebsite] || '').trim();

    statements.push(
      `INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES (${sqlString(companyName)}, ${sqlString(address)}, ${sqlString(city)}, ${sqlString(state)}, ${sqlString(
         args.country
       )}, ${sqlString(zip)}, ${sqlString(website)}, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;`
    );

    statements.push(
      `INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, ${sqlText(firstName || 'Unknown')}, ${sqlText(lastName)}, ${sqlString(email)}, ${sqlString(
         phone
       )}, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = ${sqlString(companyName)}
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (${sqlString(email)} IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(${sqlString(email)})))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim(${sqlString(firstName)}))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(${sqlString(lastName)}))
               )
             )
         );`
    );

    imported += 1;
  }

  if (args.transaction) statements.push('COMMIT;');
  const outPath = path.resolve(args.out || 'tmp/import_companies_contacts.sql');
  fs.mkdirSync(path.dirname(outPath), { recursive: true });
  fs.writeFileSync(outPath, `${statements.join('\n')}\n`, 'utf8');

  console.log(`Parsed rows: ${dataRows.length}`);
  console.log(`Prepared upserts: ${imported}`);
  console.log(`SQL file: ${outPath}`);
  if (duplicateNames.size) {
    console.log(`Duplicate company names in CSV (${duplicateNames.size}):`);
    for (const name of duplicateNames) console.log(`  - ${name}`);
  }
}

main();
