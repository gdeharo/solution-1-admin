import express from "express";
import { qboApiRequest } from "../lib/qboClient.js";

const router = express.Router();

const ESTIMATE_ALIASES = {
  refnumber: "refNumber",
  customer: "customer",
  txndate: "txnDate",
  expirationdate: "expirationDate",
  statUs: "status",
  status: "status",
  acceptedby: "acceptedBy",
  accepteddate: "acceptedDate",
  salesterm: "salesTerm",
  location: "location",
  class: "className",
  billaddrline1: "billAddrLine1",
  billaddrline2: "billAddrLine2",
  billaddrline3: "billAddrLine3",
  billaddrline4: "billAddrLine4",
  billaddrcity: "billAddrCity",
  billaddrstate: "billAddrState",
  billaddrpostalcode: "billAddrPostalCode",
  billaddrcountry: "billAddrCountry",
  shipaddrline1: "shipAddrLine1",
  shipaddrline2: "shipAddrLine2",
  shipaddrline3: "shipAddrLine3",
  shipaddrline4: "shipAddrLine4",
  shipaddrcity: "shipAddrCity",
  shipaddrstate: "shipAddrState",
  shipaddrpostalcode: "shipAddrPostalCode",
  shipaddrcountry: "shipAddrCountry",
  privatenote: "privateNote",
  msg: "msg",
  billemail: "billEmail",
  lineitem: "lineItem",
  linedesc: "lineDesc",
  lineqty: "lineQty",
  lineunitprice: "lineUnitPrice",
  lineamount: "lineAmount",
  lineclass: "lineClass",
  crew: "crew",
  "crew #": "crew",
  "p.o. number": "poNumber"
};

const PO_ALIASES = {
  refnumber: "refNumber",
  vendor: "vendor",
  txndate: "txnDate",
  duedate: "dueDate",
  salesterm: "salesTerm",
  location: "location",
  postat: "poStat",
  poemail: "poEmail",
  shipmethodname: "shipMethodName",
  class: "className",
  addressline1: "addressLine1",
  addressline2: "addressLine2",
  addressline3: "addressLine3",
  addressline4: "addressLine4",
  addresscity: "addressCity",
  addressstate: "addressState",
  addresspostalcode: "addressPostalCode",
  addresscountry: "addressCountry",
  privatenote: "privateNote",
  lineitem: "lineItem",
  linedesc: "lineDesc",
  lineqty: "lineQty",
  lineunitprice: "lineUnitPrice",
  lineamount: "lineAmount",
  lineclass: "lineClass"
};

function normalizeHeader(text) {
  return String(text ?? "")
    .trim()
    .toLowerCase()
    .replace(/[_-]+/g, "")
    .replace(/\s+/g, "")
    .replace(/[.#]/g, "");
}

function parseCsvRecords(csvText) {
  const records = [];
  let record = [];
  let field = "";
  let inQuotes = false;

  for (let i = 0; i < csvText.length; i += 1) {
    const ch = csvText[i];
    const next = csvText[i + 1];

    if (ch === '"') {
      if (inQuotes && next === '"') {
        field += '"';
        i += 1;
      } else {
        inQuotes = !inQuotes;
      }
      continue;
    }

    if (ch === "," && !inQuotes) {
      record.push(field.trim());
      field = "";
      continue;
    }

    if ((ch === "\n" || ch === "\r") && !inQuotes) {
      if (ch === "\r" && next === "\n") i += 1;
      record.push(field.trim());
      field = "";
      if (record.some((v) => v !== "")) records.push(record);
      record = [];
      continue;
    }

    field += ch;
  }

  if (field.length > 0 || record.length > 0) {
    record.push(field.trim());
    if (record.some((v) => v !== "")) records.push(record);
  }

  return records;
}

function parseCsvWithAliases(csvText, aliases) {
  const records = parseCsvRecords(csvText);
  if (records.length < 2) return { rows: [] };

  const headers = records[0];
  const mapped = headers.map((h) => aliases[normalizeHeader(h)] ?? null);
  const rows = records.slice(1).map((record, idx) => {
    const data = {};
    mapped.forEach((key, i) => {
      if (key) data[key] = record[i] ?? "";
    });
    return { rowNumber: idx + 2, data };
  });

  return { rows };
}

function parseDateForQbo(value) {
  const text = String(value ?? "").trim();
  if (!text) return "";

  const iso = text.match(/^(\d{4})-(\d{2})-(\d{2})$/);
  if (iso) return `${iso[1]}-${iso[2]}-${iso[3]}`;

  const us = text.match(/^(\d{1,2})\/(\d{1,2})\/(\d{4})$/);
  if (us) {
    const mm = us[1].padStart(2, "0");
    const dd = us[2].padStart(2, "0");
    return `${us[3]}-${mm}-${dd}`;
  }
  return "";
}

function parseNumber(value) {
  const text = String(value ?? "").replace(/,/g, "").trim();
  if (!text) return NaN;
  return Number(text);
}

function escapeQboLiteral(value) {
  return String(value).replace(/\\/g, "\\\\").replace(/'/g, "\\'");
}

const refCache = new Map();

async function resolveRefByName({ entity, fieldName, name }) {
  const text = String(name ?? "").trim();
  if (!text) return null;
  if (/^\d+$/.test(text)) return { value: text, name: null };

  const key = `${entity}|${fieldName}|${text.toLowerCase()}`;
  if (refCache.has(key)) return refCache.get(key);

  const query = `SELECT Id, ${fieldName} FROM ${entity} WHERE ${fieldName} = '${escapeQboLiteral(text)}' MAXRESULTS 1`;
  const { response, parsed } = await qboApiRequest({ method: "GET", path: "/query", query: { query } });
  if (!response.ok) throw new Error(`QBO lookup failed for ${entity}: ${JSON.stringify(parsed)}`);

  const row = parsed?.QueryResponse?.[entity]?.[0] ?? null;
  if (!row?.Id) throw new Error(`${entity} not found for "${text}"`);

  const ref = { value: String(row.Id), name: String(row[fieldName] ?? text) };
  refCache.set(key, ref);
  return ref;
}

function buildAddr(prefix, src) {
  const addr = {};
  if (src[`${prefix}Line1`]) addr.Line1 = src[`${prefix}Line1`];
  if (src[`${prefix}Line2`]) addr.Line2 = src[`${prefix}Line2`];
  if (src[`${prefix}Line3`]) addr.Line3 = src[`${prefix}Line3`];
  if (src[`${prefix}Line4`]) addr.Line4 = src[`${prefix}Line4`];
  if (src[`${prefix}City`]) addr.City = src[`${prefix}City`];
  if (src[`${prefix}State`]) addr.CountrySubDivisionCode = src[`${prefix}State`];
  if (src[`${prefix}PostalCode`]) addr.PostalCode = src[`${prefix}PostalCode`];
  if (src[`${prefix}Country`]) addr.Country = src[`${prefix}Country`];
  return Object.keys(addr).length ? addr : null;
}

async function findExistingByDocNumber(entity, docNumber) {
  const query = `SELECT Id, DocNumber, SyncToken FROM ${entity} WHERE DocNumber = '${escapeQboLiteral(docNumber)}' MAXRESULTS 1`;
  const { response, parsed } = await qboApiRequest({ method: "GET", path: "/query", query: { query } });
  if (!response.ok) throw new Error(`QBO duplicate check failed: ${JSON.stringify(parsed)}`);
  return parsed?.QueryResponse?.[entity]?.[0] ?? null;
}

function summarizeResults(dryRun, groups, results) {
  return {
    dryRun,
    totalRows: groups.reduce((sum, g) => sum + (g.rowNumbers?.length ?? 0), 0),
    totalDocs: groups.length,
    created: results.filter((r) => r.status === "created").length,
    skippedExisting: results.filter((r) => r.status === "skipped_existing").length,
    invalid: results.filter((r) => r.status === "invalid").length,
    failed: results.filter((r) => r.status === "failed").length,
    results
  };
}

function groupRows(rows, keyField) {
  const map = new Map();
  for (const row of rows) {
    const key = String(row.data[keyField] ?? "").trim();
    if (!key) {
      const id = `__invalid_${row.rowNumber}`;
      map.set(id, { invalid: true, rowNumbers: [row.rowNumber], errors: [`Row ${row.rowNumber}: Missing required ${keyField}`], header: {}, lines: [] });
      continue;
    }
    if (!map.has(key)) map.set(key, { key, rowNumbers: [], header: {}, lines: [], errors: [] });
    const g = map.get(key);
    g.rowNumbers.push(row.rowNumber);
    g.lines.push({ rowNumber: row.rowNumber, ...row.data });
    Object.keys(row.data).forEach((k) => {
      const val = String(row.data[k] ?? "").trim();
      if (!val) return;
      if (!g.header[k]) g.header[k] = val;
      else if (g.header[k] !== val && !k.startsWith("line")) g.errors.push(`Row ${row.rowNumber}: ${k} differs from earlier row`);
    });
  }
  return [...map.values()];
}

async function importEstimates(csv, dryRun) {
  const { rows } = parseCsvWithAliases(csv, ESTIMATE_ALIASES);
  if (!rows.length) return { status: 400, body: { error: "CSV must include header and at least one row" } };

  const groups = groupRows(rows, "refNumber");
  const results = [];

  for (const g of groups) {
    const docNumber = g.key ?? null;
    if (g.invalid) {
      results.push({ docNumber, rowNumbers: g.rowNumbers, status: "invalid", errors: g.errors });
      continue;
    }

    if (!g.header.customer) g.errors.push("Missing required Customer");
    if (!g.header.refNumber) g.errors.push("Missing required RefNumber");

    const preparedLines = [];
    for (const line of g.lines) {
      const itemName = String(line.lineItem ?? "").trim();
      const qty = parseNumber(line.lineQty);
      const unitPrice = parseNumber(line.lineUnitPrice);
      const amount = Number.isFinite(parseNumber(line.lineAmount))
        ? parseNumber(line.lineAmount)
        : (Number.isFinite(qty) && Number.isFinite(unitPrice) ? qty * unitPrice : NaN);

      if (!itemName) g.errors.push(`Row ${line.rowNumber}: Missing LineItem`);
      if (!Number.isFinite(qty) || qty <= 0) g.errors.push(`Row ${line.rowNumber}: Invalid LineQty`);
      if (!Number.isFinite(amount)) g.errors.push(`Row ${line.rowNumber}: Invalid LineAmount/LineUnitPrice`);

      preparedLines.push({ ...line, itemName, qty, unitPrice, amount });
    }

    if (g.errors.length) {
      results.push({ docNumber, rowNumbers: g.rowNumbers, status: "invalid", errors: g.errors });
      continue;
    }

    let payload;
    try {
      const customerRef = await resolveRefByName({ entity: "Customer", fieldName: "DisplayName", name: g.header.customer });
      const termsRef = g.header.salesTerm ? await resolveRefByName({ entity: "Term", fieldName: "Name", name: g.header.salesTerm }) : null;
      const classRef = g.header.className ? await resolveRefByName({ entity: "Class", fieldName: "Name", name: g.header.className }) : null;

      const linePayload = [];
      for (const line of preparedLines) {
        const itemRef = await resolveRefByName({ entity: "Item", fieldName: "Name", name: line.itemName });
        const lineClassRef = line.lineClass ? await resolveRefByName({ entity: "Class", fieldName: "Name", name: line.lineClass }) : null;

        const salesDetail = {
          ItemRef: { value: itemRef.value },
          Qty: line.qty
        };
        if (Number.isFinite(line.unitPrice)) salesDetail.UnitPrice = line.unitPrice;
        if (lineClassRef?.value) salesDetail.ClassRef = { value: lineClassRef.value };
        else if (classRef?.value) salesDetail.ClassRef = { value: classRef.value };

        linePayload.push({
          Amount: Number(line.amount.toFixed(2)),
          Description: line.lineDesc || line.itemName,
          DetailType: "SalesItemLineDetail",
          SalesItemLineDetail: salesDetail
        });
      }

      payload = {
        DocNumber: g.header.refNumber,
        CustomerRef: { value: customerRef.value },
        Line: linePayload
      };

      const txnDate = parseDateForQbo(g.header.txnDate);
      if (txnDate) payload.TxnDate = txnDate;
      const expirationDate = parseDateForQbo(g.header.expirationDate);
      if (expirationDate) payload.ExpirationDate = expirationDate;
      if (termsRef?.value) payload.SalesTermRef = { value: termsRef.value };
      const billAddr = buildAddr("billAddr", g.header);
      if (billAddr) payload.BillAddr = billAddr;
      const shipAddr = buildAddr("shipAddr", g.header);
      if (shipAddr) payload.ShipAddr = shipAddr;
      if (g.header.privateNote) payload.PrivateNote = g.header.privateNote;
      if (g.header.msg) payload.CustomerMemo = { value: g.header.msg };
      if (g.header.billEmail) payload.BillEmail = { Address: g.header.billEmail };
    } catch (error) {
      results.push({ docNumber, rowNumbers: g.rowNumbers, status: "invalid", errors: [error instanceof Error ? error.message : "Reference lookup failed"] });
      continue;
    }

    if (dryRun) {
      results.push({ docNumber, rowNumbers: g.rowNumbers, status: "valid", lineCount: preparedLines.length });
      continue;
    }

    const existing = await findExistingByDocNumber("Estimate", g.header.refNumber);
    if (existing?.Id) {
      results.push({ docNumber, rowNumbers: g.rowNumbers, status: "skipped_existing", entityId: existing.Id, syncToken: existing.SyncToken ?? null });
      continue;
    }

    const { response, parsed } = await qboApiRequest({ method: "POST", path: "/estimate", body: payload });
    if (!response.ok) {
      results.push({ docNumber, rowNumbers: g.rowNumbers, status: "failed", qboStatus: response.status, error: parsed?.Fault ?? parsed ?? "Unknown QBO error" });
      continue;
    }

    results.push({ docNumber, rowNumbers: g.rowNumbers, status: "created", entityId: parsed?.Estimate?.Id ?? null, syncToken: parsed?.Estimate?.SyncToken ?? null, lineCount: preparedLines.length });
  }

  const body = summarizeResults(dryRun, groups.filter((g) => !g.invalid), results);
  return { status: dryRun || body.invalid === 0 ? 200 : 400, body };
}

async function importPurchaseOrders(csv, dryRun) {
  const { rows } = parseCsvWithAliases(csv, PO_ALIASES);
  if (!rows.length) return { status: 400, body: { error: "CSV must include header and at least one row" } };

  const groups = groupRows(rows, "refNumber");
  const results = [];

  for (const g of groups) {
    const docNumber = g.key ?? null;
    if (g.invalid) {
      results.push({ docNumber, rowNumbers: g.rowNumbers, status: "invalid", errors: g.errors });
      continue;
    }

    if (!g.header.vendor) g.errors.push("Missing required Vendor");
    if (!g.header.refNumber) g.errors.push("Missing required RefNumber");

    const preparedLines = [];
    for (const line of g.lines) {
      const itemName = String(line.lineItem ?? "").trim();
      const qty = parseNumber(line.lineQty);
      const unitPrice = parseNumber(line.lineUnitPrice);
      const amount = Number.isFinite(parseNumber(line.lineAmount))
        ? parseNumber(line.lineAmount)
        : (Number.isFinite(qty) && Number.isFinite(unitPrice) ? qty * unitPrice : NaN);

      if (!itemName) g.errors.push(`Row ${line.rowNumber}: Missing LineItem`);
      if (!Number.isFinite(qty) || qty <= 0) g.errors.push(`Row ${line.rowNumber}: Invalid LineQty`);
      if (!Number.isFinite(amount)) g.errors.push(`Row ${line.rowNumber}: Invalid LineAmount/LineUnitPrice`);

      preparedLines.push({ ...line, itemName, qty, unitPrice, amount });
    }

    if (g.errors.length) {
      results.push({ docNumber, rowNumbers: g.rowNumbers, status: "invalid", errors: g.errors });
      continue;
    }

    let payload;
    try {
      const vendorRef = await resolveRefByName({ entity: "Vendor", fieldName: "DisplayName", name: g.header.vendor });
      const termsRef = g.header.salesTerm ? await resolveRefByName({ entity: "Term", fieldName: "Name", name: g.header.salesTerm }) : null;
      const classRef = g.header.className ? await resolveRefByName({ entity: "Class", fieldName: "Name", name: g.header.className }) : null;
      const shipMethodRef = g.header.shipMethodName ? await resolveRefByName({ entity: "ShipMethod", fieldName: "Name", name: g.header.shipMethodName }) : null;

      const linePayload = [];
      for (const line of preparedLines) {
        const itemRef = await resolveRefByName({ entity: "Item", fieldName: "Name", name: line.itemName });
        const lineClassRef = line.lineClass ? await resolveRefByName({ entity: "Class", fieldName: "Name", name: line.lineClass }) : null;

        const itemBased = {
          ItemRef: { value: itemRef.value },
          Qty: line.qty
        };
        if (Number.isFinite(line.unitPrice)) itemBased.UnitPrice = line.unitPrice;
        if (lineClassRef?.value) itemBased.ClassRef = { value: lineClassRef.value };
        else if (classRef?.value) itemBased.ClassRef = { value: classRef.value };

        linePayload.push({
          Amount: Number(line.amount.toFixed(2)),
          Description: line.lineDesc || line.itemName,
          DetailType: "ItemBasedExpenseLineDetail",
          ItemBasedExpenseLineDetail: itemBased
        });
      }

      payload = {
        DocNumber: g.header.refNumber,
        VendorRef: { value: vendorRef.value },
        Line: linePayload
      };

      const txnDate = parseDateForQbo(g.header.txnDate);
      if (txnDate) payload.TxnDate = txnDate;
      const dueDate = parseDateForQbo(g.header.dueDate);
      if (dueDate) payload.DueDate = dueDate;
      if (termsRef?.value) payload.TermRef = { value: termsRef.value };
      if (shipMethodRef?.value) payload.ShipMethodRef = { value: shipMethodRef.value };
      const shipAddr = buildAddr("address", g.header);
      if (shipAddr) payload.ShipAddr = shipAddr;
      if (g.header.privateNote) payload.PrivateNote = g.header.privateNote;
      if (g.header.poEmail) payload.Memo = { value: `PO Email: ${g.header.poEmail}` };
    } catch (error) {
      results.push({ docNumber, rowNumbers: g.rowNumbers, status: "invalid", errors: [error instanceof Error ? error.message : "Reference lookup failed"] });
      continue;
    }

    if (dryRun) {
      results.push({ docNumber, rowNumbers: g.rowNumbers, status: "valid", lineCount: preparedLines.length });
      continue;
    }

    const existing = await findExistingByDocNumber("PurchaseOrder", g.header.refNumber);
    if (existing?.Id) {
      results.push({ docNumber, rowNumbers: g.rowNumbers, status: "skipped_existing", entityId: existing.Id, syncToken: existing.SyncToken ?? null });
      continue;
    }

    const { response, parsed } = await qboApiRequest({ method: "POST", path: "/purchaseorder", body: payload });
    if (!response.ok) {
      results.push({ docNumber, rowNumbers: g.rowNumbers, status: "failed", qboStatus: response.status, error: parsed?.Fault ?? parsed ?? "Unknown QBO error" });
      continue;
    }

    results.push({ docNumber, rowNumbers: g.rowNumbers, status: "created", entityId: parsed?.PurchaseOrder?.Id ?? null, syncToken: parsed?.PurchaseOrder?.SyncToken ?? null, lineCount: preparedLines.length });
  }

  const body = summarizeResults(dryRun, groups.filter((g) => !g.invalid), results);
  return { status: dryRun || body.invalid === 0 ? 200 : 400, body };
}

router.post("/imports/estimates/csv", async (req, res) => {
  try {
    const csv = String(req.body?.csv ?? "");
    const dryRun = Boolean(req.body?.dryRun);
    if (!csv.trim()) return res.status(400).json({ error: "Request body requires csv string" });

    const { status, body } = await importEstimates(csv, dryRun);
    return res.status(status).json(body);
  } catch (error) {
    return res.status(500).json({ error: error instanceof Error ? error.message : "Estimate import failed" });
  }
});

router.post("/imports/purchase-orders/csv", async (req, res) => {
  try {
    const csv = String(req.body?.csv ?? "");
    const dryRun = Boolean(req.body?.dryRun);
    if (!csv.trim()) return res.status(400).json({ error: "Request body requires csv string" });

    const { status, body } = await importPurchaseOrders(csv, dryRun);
    return res.status(status).json(body);
  } catch (error) {
    return res.status(500).json({ error: error instanceof Error ? error.message : "Purchase order import failed" });
  }
});

export default router;
