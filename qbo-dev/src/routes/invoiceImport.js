import express from "express";
import { qboApiRequest } from "../lib/qboClient.js";

const router = express.Router();

const TEMPLATE_HEADERS = [
  "Invoice Number",
  "Customer",
  "Email",
  "Terms",
  "Invoice Date",
  "Due Date",
  "Shipping To",
  "Shipping Via",
  "Shipping Date",
  "Tracking No.",
  "P.O. Number",
  "Sales Rep",
  "Sec",
  "Product/Service",
  "Service Date",
  "SKU",
  "Description",
  "Quantity",
  "Rate",
  "Amount",
  "Class",
  "Tax",
  "Memo",
  "Message On Invoice",
  "Send later",
  "Subtotal",
  "Taxable Subtotal",
  "Tax Rate",
  "Tax Rate %",
  "Sales Tax Amount",
  "Shipping Amt",
  "Total",
  "Attachments"
];

const HEADER_ALIASES = {
  "invoice number": "invoiceNumber",
  customer: "customer",
  email: "email",
  terms: "terms",
  "invoice date": "invoiceDate",
  "due date": "dueDate",
  "shipping to": "shippingTo",
  "shipping via": "shippingVia",
  "shipping date": "shippingDate",
  "tracking no": "trackingNo",
  "tracking no.": "trackingNo",
  "p.o. number": "poNumber",
  "po number": "poNumber",
  "sales rep": "salesRep",
  sec: "sec",
  "product/service": "productService",
  "service date": "serviceDate",
  sku: "sku",
  description: "description",
  quantity: "quantity",
  rate: "rate",
  amount: "amount",
  class: "className",
  tax: "tax",
  memo: "memo",
  "message on invoice": "messageOnInvoice",
  "send later": "sendLater",
  subtotal: "subtotal",
  "taxable subtotal": "taxableSubtotal",
  "tax rate": "taxRate",
  "tax rate %": "taxRatePct",
  "sales tax amount": "salesTaxAmount",
  "shipping amt": "shippingAmt",
  total: "total",
  attachments: "attachments"
};

function normalizeHeader(header) {
  return String(header ?? "")
    .trim()
    .toLowerCase()
    .replace(/[_-]+/g, " ")
    .replace(/\s+/g, " ")
    .replace(/[\u2018\u2019]/g, "'");
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
      if (record.some((value) => value !== "")) records.push(record);
      record = [];
      continue;
    }

    field += ch;
  }

  if (field.length > 0 || record.length > 0) {
    record.push(field.trim());
    if (record.some((value) => value !== "")) records.push(record);
  }

  return records;
}

function parseCsv(csvText) {
  const records = parseCsvRecords(csvText);
  if (records.length < 2) return { rows: [] };

  const headers = records[0];
  const mappedHeaders = headers.map((header) => HEADER_ALIASES[normalizeHeader(header)] ?? null);

  const rows = records.slice(1).map((record, idx) => {
    const data = {};
    mappedHeaders.forEach((mapped, i) => {
      if (mapped) data[mapped] = record[i] ?? "";
    });
    return { rowNumber: idx + 2, data };
  });

  return { rows };
}

function escapeQboLiteral(value) {
  return String(value).replace(/\\/g, "\\\\").replace(/'/g, "\\'");
}

function toCsvValue(value) {
  const text = String(value ?? "");
  if (text.includes(",") || text.includes('"') || text.includes("\n")) {
    return `"${text.replace(/"/g, '""')}"`;
  }
  return text;
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

function formatDateForTemplate(value) {
  const iso = parseDateForQbo(value);
  if (!iso) return "";
  const [yyyy, mm, dd] = iso.split("-");
  return `${mm}/${dd}/${yyyy}`;
}

function isPositiveNumber(value) {
  const num = Number(value);
  return Number.isFinite(num) && num > 0;
}

const refCache = new Map();

async function resolveRefByName({ entity, fieldName, name }) {
  const text = String(name ?? "").trim();
  if (!text) return null;
  if (/^\d+$/.test(text)) return { value: text, name: null };

  const key = `${entity}|${fieldName}|${text.toLowerCase()}`;
  if (refCache.has(key)) return refCache.get(key);

  const safe = escapeQboLiteral(text);
  const query = `SELECT Id, ${fieldName} FROM ${entity} WHERE ${fieldName} = '${safe}' MAXRESULTS 1`;
  const { response, parsed } = await qboApiRequest({ method: "GET", path: "/query", query: { query } });

  if (!response.ok) {
    throw new Error(`QBO lookup failed for ${entity}: ${JSON.stringify(parsed)}`);
  }

  const match = parsed?.QueryResponse?.[entity]?.[0] ?? null;
  if (!match?.Id) throw new Error(`${entity} not found for \"${text}\"`);

  const resolved = { value: String(match.Id), name: String(match[fieldName] ?? text) };
  refCache.set(key, resolved);
  return resolved;
}

async function getExistingInvoiceByDocNumber(docNumber) {
  const safeDoc = escapeQboLiteral(docNumber);
  const query = `SELECT Id, DocNumber, SyncToken FROM Invoice WHERE DocNumber = '${safeDoc}' MAXRESULTS 1`;
  const { response, parsed } = await qboApiRequest({ method: "GET", path: "/query", query: { query } });
  if (!response.ok) throw new Error(`QBO duplicate check failed: ${JSON.stringify(parsed)}`);
  return parsed?.QueryResponse?.Invoice?.[0] ?? null;
}

function validateRow(data) {
  const errors = [];
  if (!String(data.invoiceNumber ?? "").trim()) errors.push("Missing required field: Invoice Number");
  if (!String(data.customer ?? "").trim()) errors.push("Missing required field: Customer");
  if (!String(data.invoiceDate ?? "").trim()) errors.push("Missing required field: Invoice Date");
  if (!String(data.productService ?? data.sku ?? "").trim()) errors.push("Missing required field: Product/Service (or SKU)");

  if (!parseDateForQbo(data.invoiceDate)) errors.push("Invoice Date must be MM/DD/YYYY or YYYY-MM-DD");
  if (String(data.dueDate ?? "").trim() && !parseDateForQbo(data.dueDate)) {
    errors.push("Due Date must be MM/DD/YYYY or YYYY-MM-DD");
  }
  if (String(data.shippingDate ?? "").trim() && !parseDateForQbo(data.shippingDate)) {
    errors.push("Shipping Date must be MM/DD/YYYY or YYYY-MM-DD");
  }

  if (!isPositiveNumber(data.quantity)) errors.push("Quantity must be a positive number");

  if (String(data.rate ?? "").trim()) {
    if (!Number.isFinite(Number(data.rate))) errors.push("Rate must be numeric");
  } else if (!isPositiveNumber(data.amount)) {
    errors.push("Provide Rate or a positive Amount");
  }

  return errors;
}

function groupByInvoice(rows) {
  const groups = new Map();

  for (const row of rows) {
    const data = row.data;
    const invoiceNumber = String(data.invoiceNumber ?? "").trim();
    const rowErrors = validateRow(data).map((e) => `Row ${row.rowNumber}: ${e}`);

    if (!invoiceNumber) {
      groups.set(`__invalid_${row.rowNumber}`, {
        invalid: true,
        rowNumbers: [row.rowNumber],
        errors: rowErrors
      });
      continue;
    }

    if (!groups.has(invoiceNumber)) {
      groups.set(invoiceNumber, {
        invoiceNumber,
        rowNumbers: [],
        header: {
          invoiceNumber,
          customer: String(data.customer ?? "").trim(),
          terms: String(data.terms ?? "").trim(),
          invoiceDate: String(data.invoiceDate ?? "").trim(),
          dueDate: String(data.dueDate ?? "").trim(),
          shippingTo: String(data.shippingTo ?? "").trim(),
          shippingVia: String(data.shippingVia ?? "").trim(),
          shippingDate: String(data.shippingDate ?? "").trim(),
          trackingNo: String(data.trackingNo ?? "").trim(),
          poNumber: String(data.poNumber ?? "").trim(),
          memo: String(data.memo ?? "").trim(),
          messageOnInvoice: String(data.messageOnInvoice ?? "").trim(),
          className: String(data.className ?? "").trim()
        },
        lines: [],
        errors: []
      });
    }

    const group = groups.get(invoiceNumber);
    group.rowNumbers.push(row.rowNumber);

    if (rowErrors.length > 0) {
      group.errors.push(...rowErrors);
      continue;
    }

    const compareKeys = [
      "customer",
      "terms",
      "invoiceDate",
      "dueDate",
      "shippingTo",
      "shippingVia",
      "shippingDate",
      "trackingNo",
      "poNumber",
      "memo",
      "messageOnInvoice",
      "className"
    ];

    for (const key of compareKeys) {
      const incoming = String(data[key] ?? "").trim();
      if (incoming && group.header[key] && incoming !== group.header[key]) {
        group.errors.push(`Row ${row.rowNumber}: ${key} differs from earlier row for Invoice Number ${invoiceNumber}`);
      }
      if (!group.header[key] && incoming) group.header[key] = incoming;
    }

    const qty = Number(data.quantity);
    const rate = String(data.rate ?? "").trim() ? Number(data.rate) : null;
    const amount = String(data.amount ?? "").trim() ? Number(data.amount) : qty * (rate ?? 0);

    group.lines.push({
      rowNumber: row.rowNumber,
      productService: String(data.productService ?? data.sku ?? "").trim(),
      description: String(data.description ?? "").trim(),
      quantity: qty,
      rate,
      amount
    });
  }

  return [...groups.values()];
}

async function buildPayload(group) {
  const customerRef = await resolveRefByName({ entity: "Customer", fieldName: "DisplayName", name: group.header.customer });

  const termsRef = group.header.terms
    ? await resolveRefByName({ entity: "Term", fieldName: "Name", name: group.header.terms })
    : null;

  const shipMethodRef = group.header.shippingVia
    ? await resolveRefByName({ entity: "ShipMethod", fieldName: "Name", name: group.header.shippingVia })
    : null;

  const classRef = group.header.className
    ? await resolveRefByName({ entity: "Class", fieldName: "Name", name: group.header.className })
    : null;

  const lines = [];
  for (const line of group.lines) {
    const itemRef = await resolveRefByName({ entity: "Item", fieldName: "Name", name: line.productService });

    const lineDetail = {
      ItemRef: { value: itemRef.value },
      Qty: line.quantity
    };

    if (line.rate !== null && Number.isFinite(line.rate)) lineDetail.UnitPrice = line.rate;
    if (classRef?.value) lineDetail.ClassRef = { value: classRef.value };

    lines.push({
      Amount: Number(line.amount.toFixed(2)),
      Description: line.description || line.productService,
      DetailType: "SalesItemLineDetail",
      SalesItemLineDetail: lineDetail
    });
  }

  const payload = {
    DocNumber: group.header.invoiceNumber,
    CustomerRef: { value: customerRef.value },
    TxnDate: parseDateForQbo(group.header.invoiceDate),
    Line: lines
  };

  if (group.header.dueDate) payload.DueDate = parseDateForQbo(group.header.dueDate);
  if (termsRef?.value) payload.SalesTermRef = { value: termsRef.value };
  if (shipMethodRef?.value) payload.ShipMethodRef = { value: shipMethodRef.value };
  if (group.header.shippingDate) payload.ShipDate = parseDateForQbo(group.header.shippingDate);
  if (group.header.trackingNo) payload.TrackingNum = group.header.trackingNo;
  if (group.header.poNumber) payload.PONumber = group.header.poNumber;
  if (group.header.shippingTo) payload.ShipAddr = { Line1: group.header.shippingTo };
  if (group.header.memo) payload.PrivateNote = group.header.memo;
  if (group.header.messageOnInvoice) payload.CustomerMemo = { value: group.header.messageOnInvoice };

  return payload;
}

router.post("/imports/invoices/csv", async (req, res) => {
  try {
    const csv = String(req.body?.csv ?? "");
    const dryRun = Boolean(req.body?.dryRun);
    if (!csv.trim()) return res.status(400).json({ error: "Request body requires csv string" });

    const { rows } = parseCsv(csv);
    if (rows.length === 0) return res.status(400).json({ error: "CSV must include header and at least one row" });

    const groups = groupByInvoice(rows);
    const results = [];

    for (const group of groups) {
      if (group.invalid) {
        results.push({ status: "invalid", rowNumbers: group.rowNumbers, errors: group.errors });
        continue;
      }

      if (!group.lines.length || group.errors.length > 0) {
        results.push({
          invoiceNumber: group.invoiceNumber,
          rowNumbers: group.rowNumbers,
          status: "invalid",
          errors: [...group.errors, ...(group.lines.length ? [] : ["No valid lines for invoice"]) ]
        });
        continue;
      }

      let payload;
      try {
        payload = await buildPayload(group);
      } catch (error) {
        results.push({
          invoiceNumber: group.invoiceNumber,
          rowNumbers: group.rowNumbers,
          status: "invalid",
          errors: [error instanceof Error ? error.message : "Lookup failed"]
        });
        continue;
      }

      if (dryRun) {
        results.push({
          invoiceNumber: group.invoiceNumber,
          rowNumbers: group.rowNumbers,
          status: "valid",
          lineCount: group.lines.length
        });
        continue;
      }

      const existing = await getExistingInvoiceByDocNumber(group.invoiceNumber);
      if (existing?.Id) {
        results.push({
          invoiceNumber: group.invoiceNumber,
          rowNumbers: group.rowNumbers,
          status: "skipped_existing",
          invoiceId: existing.Id,
          syncToken: existing.SyncToken ?? null
        });
        continue;
      }

      const { response, parsed } = await qboApiRequest({ method: "POST", path: "/invoice", body: payload });
      if (!response.ok) {
        results.push({
          invoiceNumber: group.invoiceNumber,
          rowNumbers: group.rowNumbers,
          status: "failed",
          qboStatus: response.status,
          error: parsed?.Fault ?? parsed ?? "Unknown QBO error"
        });
        continue;
      }

      results.push({
        invoiceNumber: group.invoiceNumber,
        rowNumbers: group.rowNumbers,
        status: "created",
        invoiceId: parsed?.Invoice?.Id ?? null,
        syncToken: parsed?.Invoice?.SyncToken ?? null,
        lineCount: group.lines.length
      });
    }

    const created = results.filter((r) => r.status === "created").length;
    const skippedExisting = results.filter((r) => r.status === "skipped_existing").length;
    const invalid = results.filter((r) => r.status === "invalid").length;
    const failed = results.filter((r) => r.status === "failed").length;

    return res.status(dryRun || invalid === 0 ? 200 : 400).json({
      dryRun,
      totalRows: rows.length,
      totalInvoices: groups.filter((g) => !g.invalid).length,
      created,
      skippedExisting,
      invalid,
      failed,
      results
    });
  } catch (error) {
    return res.status(500).json({ error: error instanceof Error ? error.message : "Import failed" });
  }
});

router.get("/exports/invoices/csv", async (req, res) => {
  try {
    const fromDate = String(req.query.fromDate ?? "").trim();
    const toDate = String(req.query.toDate ?? "").trim();
    const maxRows = Math.max(1, Math.min(Number(req.query.maxRows ?? 500), 2000));

    const fromQbo = fromDate ? parseDateForQbo(fromDate) : "";
    const toQbo = toDate ? parseDateForQbo(toDate) : "";
    if (fromDate && !fromQbo) return res.status(400).json({ error: "fromDate must be MM/DD/YYYY or YYYY-MM-DD" });
    if (toDate && !toQbo) return res.status(400).json({ error: "toDate must be MM/DD/YYYY or YYYY-MM-DD" });

    const filters = [];
    if (fromQbo) filters.push(`TxnDate >= '${escapeQboLiteral(fromQbo)}'`);
    if (toQbo) filters.push(`TxnDate <= '${escapeQboLiteral(toQbo)}'`);
    const whereClause = filters.length ? ` WHERE ${filters.join(" AND ")}` : "";

    const invoices = [];
    let start = 1;

    while (invoices.length < maxRows) {
      const batchSize = Math.min(100, maxRows - invoices.length);
      const query = `SELECT * FROM Invoice${whereClause} STARTPOSITION ${start} MAXRESULTS ${batchSize}`;
      const { response, parsed } = await qboApiRequest({ method: "GET", path: "/query", query: { query } });

      if (!response.ok) return res.status(400).json({ error: "QBO query failed", details: parsed });

      const batch = parsed?.QueryResponse?.Invoice ?? [];
      if (!Array.isArray(batch) || batch.length === 0) break;

      invoices.push(...batch);
      if (batch.length < batchSize) break;
      start += batch.length;
    }

    const lines = [TEMPLATE_HEADERS.join(",")];

    for (const inv of invoices) {
      const base = {
        invoiceNumber: inv.DocNumber ?? "",
        customer: inv.CustomerRef?.name ?? inv.CustomerRef?.value ?? "",
        email: "",
        terms: inv.SalesTermRef?.name ?? inv.SalesTermRef?.value ?? "",
        invoiceDate: formatDateForTemplate(inv.TxnDate),
        dueDate: formatDateForTemplate(inv.DueDate),
        shippingTo: inv.ShipAddr?.Line1 ?? "",
        shippingVia: inv.ShipMethodRef?.name ?? inv.ShipMethodRef?.value ?? "",
        shippingDate: formatDateForTemplate(inv.ShipDate),
        trackingNo: inv.TrackingNum ?? "",
        poNumber: inv.PONumber ?? "",
        salesRep: "",
        sec: "",
        serviceDate: "",
        sku: "",
        className: "",
        tax: "",
        memo: inv.PrivateNote ?? "",
        messageOnInvoice: inv.CustomerMemo?.value ?? "",
        sendLater: "",
        subtotal: "",
        taxableSubtotal: "",
        taxRate: "",
        taxRatePct: "",
        salesTaxAmount: "",
        shippingAmt: "",
        total: inv.TotalAmt ?? "",
        attachments: ""
      };

      const salesLines = Array.isArray(inv.Line) ? inv.Line.filter((line) => line.DetailType === "SalesItemLineDetail") : [];
      if (salesLines.length === 0) {
        lines.push(
          [
            base.invoiceNumber, base.customer, base.email, base.terms, base.invoiceDate, base.dueDate, base.shippingTo,
            base.shippingVia, base.shippingDate, base.trackingNo, base.poNumber, base.salesRep, base.sec, "", base.serviceDate,
            base.sku, "", "", "", "", base.className, base.tax, base.memo, base.messageOnInvoice, base.sendLater,
            base.subtotal, base.taxableSubtotal, base.taxRate, base.taxRatePct, base.salesTaxAmount, base.shippingAmt,
            base.total, base.attachments
          ].map(toCsvValue).join(",")
        );
        continue;
      }

      for (const line of salesLines) {
        const qty = line.SalesItemLineDetail?.Qty ?? "";
        const rate = line.SalesItemLineDetail?.UnitPrice ?? "";
        const amount = line.Amount ?? "";
        const className = line.SalesItemLineDetail?.ClassRef?.name ?? line.SalesItemLineDetail?.ClassRef?.value ?? "";
        const productService = line.SalesItemLineDetail?.ItemRef?.name ?? line.SalesItemLineDetail?.ItemRef?.value ?? "";
        const description = line.Description ?? "";

        lines.push(
          [
            base.invoiceNumber, base.customer, base.email, base.terms, base.invoiceDate, base.dueDate, base.shippingTo,
            base.shippingVia, base.shippingDate, base.trackingNo, base.poNumber, base.salesRep, base.sec, productService,
            base.serviceDate, base.sku, description, qty, rate, amount, className, base.tax, base.memo,
            base.messageOnInvoice, base.sendLater, base.subtotal, base.taxableSubtotal, base.taxRate, base.taxRatePct,
            base.salesTaxAmount, base.shippingAmt, base.total, base.attachments
          ].map(toCsvValue).join(",")
        );
      }
    }

    const stamp = new Date().toISOString().slice(0, 10);
    return res
      .status(200)
      .set("Content-Type", "text/csv; charset=utf-8")
      .set("Content-Disposition", `attachment; filename=\"qbo-invoices-${stamp}.csv\"`)
      .send(lines.join("\n"));
  } catch (error) {
    return res.status(500).json({ error: error instanceof Error ? error.message : "Export failed" });
  }
});

export default router;
