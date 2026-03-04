const statusEl = document.querySelector("#status");
const importOutputEl = document.querySelector("#import-output");
const csvFileEl = document.querySelector("#csv-file");
const csvTextEl = document.querySelector("#csv-text");
const importTypeEl = document.querySelector("#import-type");
const importHintEl = document.querySelector("#import-hint");
const previewModeEl = document.querySelector("#preview-mode");
const previewWrapEl = document.querySelector("#preview-wrap");
const resultSummaryEl = document.querySelector("#result-summary");
const resultTableWrapEl = document.querySelector("#result-table-wrap");

const IMPORT_CONFIG = {
  invoices: {
    endpoint: "/imports/invoices/csv",
    groupKeys: ["invoicenumber", "refnumber"],
    hint:
      "Invoice Number,Customer,Email,Terms,Invoice Date,Due Date,Shipping To,Shipping Via,Shipping Date,Tracking No.,P.O. Number,Sales Rep,Sec,Product/Service,Service Date,SKU,Description,Quantity,Rate,Amount,Class,Tax,Memo,Message On Invoice,Send later,Subtotal,Taxable Subtotal,Tax Rate,Tax Rate %,Sales Tax Amount,Shipping Amt,Total,Attachments"
  },
  estimates: {
    endpoint: "/imports/estimates/csv",
    groupKeys: ["refnumber", "invoicenumber"],
    hint:
      "RefNumber,Customer,TxnDate,ExpirationDate,SalesTerm,Class,BillAddrLine1..4,BillAddrCity,BillAddrState,BillAddrPostalCode,BillAddrCountry,ShipAddrLine1..4,ShipAddrCity,ShipAddrState,ShipAddrPostalCode,ShipAddrCountry,PrivateNote,Msg,BillEmail,LineItem,LineDesc,LineQty,LineUnitPrice,LineAmount,LineClass"
  },
  "purchase-orders": {
    endpoint: "/imports/purchase-orders/csv",
    groupKeys: ["refnumber", "invoicenumber"],
    hint:
      "RefNumber,Vendor,TxnDate,DueDate,SalesTerm,ShipMethodName,Class,AddressLine1..4,AddressCity,AddressState,AddressPostalCode,AddressCountry,PrivateNote,LineItem,LineDesc,LineQty,LineUnitPrice,LineAmount,LineClass"
  }
};

function normalizeHeader(text) {
  return String(text ?? "")
    .trim()
    .toLowerCase()
    .replace(/[_-]+/g, "")
    .replace(/\s+/g, "")
    .replace(/[.#]/g, "");
}

function escapeHtml(text) {
  return String(text ?? "")
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
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

function setStatus(message, isError = false) {
  statusEl.textContent = message;
  statusEl.classList.toggle("error", isError);
}

function setImportOutput(data) {
  importOutputEl.textContent = typeof data === "string" ? data : JSON.stringify(data, null, 2);
}

function getImportConfig() {
  return IMPORT_CONFIG[importTypeEl.value] ?? IMPORT_CONFIG.invoices;
}

function renderPreviewGrid(csvText) {
  const records = parseCsvRecords(csvText);
  if (records.length < 2) {
    previewWrapEl.innerHTML = "";
    return;
  }

  const config = getImportConfig();
  const headers = records[0];
  const keyIndex = headers.findIndex((h) => config.groupKeys.includes(normalizeHeader(h)));
  if (keyIndex < 0) {
    previewWrapEl.innerHTML = `<div class="summary">Missing grouping key column (${config.groupKeys.join(" or ")}).</div>`;
    return;
  }

  const rows = records.slice(1).map((row, idx) => ({ row, rowNumber: idx + 2 }));
  const groups = new Map();
  for (const rowInfo of rows) {
    const key = String(rowInfo.row[keyIndex] ?? "").trim() || "(blank)";
    if (!groups.has(key)) groups.set(key, []);
    groups.get(key).push(rowInfo);
  }

  const mode = previewModeEl?.value || "split";
  if (mode === "grouped-full") {
    const thead = `<tr><th>Row</th>${headers.map((h) => `<th>${escapeHtml(h)}</th>`).join("")}</tr>`;
    const bodyRows = [];

    for (const [docKey, groupRows] of groups.entries()) {
      const first = groupRows[0]?.row ?? [];
      groupRows.forEach(({ row, rowNumber }, idx) => {
        const tds = headers
          .map((_, i) => {
            const value = idx === 0 ? row[i] : String(row[i] ?? "").trim() === String(first[i] ?? "").trim() ? "" : row[i];
            return `<td>${escapeHtml(value ?? "")}</td>`;
          })
          .join("");
        bodyRows.push(`<tr class="${idx === 0 ? "group-start" : ""}" data-doc="${escapeHtml(docKey)}"><td>${rowNumber}</td>${tds}</tr>`);
      });
    }

    previewWrapEl.innerHTML = `
      <div class="summary">Whole grid view: ${groups.size} group(s), ${rows.length} row(s). Duplicate values hidden after first row per group.</div>
      <table><thead>${thead}</thead><tbody>${bodyRows.join("")}</tbody></table>
    `;
    return;
  }

  const sections = [];
  const keyLabel = headers[keyIndex] || "Key";

  for (const [docKey, groupRows] of groups.entries()) {
    const diffIndexes = [];
    headers.forEach((_, i) => {
      const values = new Set(groupRows.map(({ row }) => String(row[i] ?? "").trim()));
      if (values.size > 1) diffIndexes.push(i);
    });

    const diffSet = new Set(diffIndexes);
    const baseIndexes = headers.map((_, i) => i).filter((i) => !diffSet.has(i));
    const firstRow = groupRows[0]?.row ?? [];

    let baseBlock = "";
    if (baseIndexes.length > 0) {
      const baseHead = `<tr>${baseIndexes.map((i) => `<th>${escapeHtml(headers[i])}</th>`).join("")}</tr>`;
      const baseBody = `<tr>${baseIndexes.map((i) => `<td>${escapeHtml(firstRow[i] ?? "")}</td>`).join("")}</tr>`;
      baseBlock = `
        <div class="summary">Base fields (first row values)</div>
        <table><thead>${baseHead}</thead><tbody>${baseBody}</tbody></table>
      `;
    }

    let diffBlock = "";
    if (diffIndexes.length === 0) {
      diffBlock = `<div class="summary">No differing values across rows for this group.</div>`;
    } else {
      const thead = `<tr><th>Row</th>${diffIndexes.map((i) => `<th>${escapeHtml(headers[i])}</th>`).join("")}</tr>`;
      const tbody = groupRows
        .map(({ row, rowNumber }) => `<tr><td>${rowNumber}</td>${diffIndexes.map((i) => `<td>${escapeHtml(row[i] ?? "")}</td>`).join("")}</tr>`)
        .join("");
      diffBlock = `
        <div class="summary">Fields that differ by row</div>
        <table><thead>${thead}</thead><tbody>${tbody}</tbody></table>
      `;
    }

    sections.push(`
      <section class="group-card">
        <h3>${escapeHtml(keyLabel)} ${escapeHtml(docKey)} <span class="pill">${groupRows.length} row(s)</span></h3>
        ${baseBlock}${diffBlock}
      </section>
    `);
  }

  previewWrapEl.innerHTML = `
    <div class="summary">Grouped preview: ${groups.size} group(s), ${rows.length} row(s).</div>
    ${sections.join("")}
  `;
}

function renderResultsTable(result) {
  if (!result?.results || !Array.isArray(result.results)) {
    resultSummaryEl.textContent = "";
    resultTableWrapEl.innerHTML = "";
    return;
  }

  resultSummaryEl.textContent = [
    `Documents: ${result.totalDocs ?? result.totalInvoices ?? 0}`,
    `Created: ${result.created ?? 0}`,
    `Skipped existing: ${result.skippedExisting ?? 0}`,
    `Invalid: ${result.invalid ?? 0}`,
    `Failed: ${result.failed ?? 0}`
  ].join(" | ");

  const head = `
    <tr>
      <th>Document</th>
      <th>Status</th>
      <th>Rows</th>
      <th>Entity ID</th>
      <th>Issues</th>
    </tr>`;

  const body = result.results
    .map((row) => {
      const errors = Array.isArray(row.errors)
        ? row.errors.join("; ")
        : row.error
          ? typeof row.error === "string"
            ? row.error
            : JSON.stringify(row.error)
          : "";

      const rows = Array.isArray(row.rowNumbers) ? row.rowNumbers.join(", ") : "";
      const entityId = row.entityId ?? row.invoiceId ?? "";
      const docNumber = row.docNumber ?? row.invoiceNumber ?? "";
      const status = row.status ?? "";

      return `
        <tr>
          <td>${escapeHtml(docNumber)}</td>
          <td><span class="pill ${escapeHtml(status)}">${escapeHtml(status)}</span></td>
          <td>${escapeHtml(rows)}</td>
          <td>${escapeHtml(entityId)}</td>
          <td>${escapeHtml(errors)}</td>
        </tr>`;
    })
    .join("");

  resultTableWrapEl.innerHTML = `<table><thead>${head}</thead><tbody>${body}</tbody></table>`;
}

async function loadStatus() {
  try {
    const response = await fetch("/auth/intuit/status");
    const json = await response.json();

    if (!response.ok) {
      setStatus(json.error || "Failed to load status", true);
      return;
    }

    if (!json.connected) {
      setStatus(`Not connected (${json.intuitEnv})`);
      return;
    }

    setStatus(`Connected (${json.intuitEnv}) · Realm ${json.realmId} · Token expires ${json.accessTokenExpiresAt || "unknown"}`);
  } catch (error) {
    setStatus(error instanceof Error ? error.message : "Failed to load status", true);
  }
}

async function readSelectedCsv() {
  if (csvTextEl.value.trim()) return csvTextEl.value.trim();

  const file = csvFileEl.files?.[0];
  if (!file) return "";
  return file.text();
}

async function runImport(dryRun) {
  try {
    const config = getImportConfig();
    const csv = (await readSelectedCsv()).trim();
    if (!csv) {
      setImportOutput("Select a CSV file or paste CSV text first.");
      return;
    }

    setImportOutput("Running import...");
    renderPreviewGrid(csv);

    const response = await fetch(config.endpoint, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ dryRun, csv })
    });

    const json = await response.json();
    setImportOutput(json);
    renderResultsTable(json);
  } catch (error) {
    const msg = error instanceof Error ? error.message : "Import request failed";
    setImportOutput(msg);
    resultSummaryEl.textContent = msg;
    resultTableWrapEl.innerHTML = "";
  }
}

async function refreshToken() {
  try {
    setStatus("Refreshing token...");
    const response = await fetch("/auth/intuit/refresh", { method: "POST" });
    const json = await response.json();
    if (!response.ok) {
      setStatus(json.error || "Refresh failed", true);
      return;
    }
    setStatus("Token refreshed successfully.");
    await loadStatus();
  } catch (error) {
    setStatus(error instanceof Error ? error.message : "Refresh failed", true);
  }
}

function runExport() {
  const fromDate = document.querySelector("#from-date").value;
  const toDate = document.querySelector("#to-date").value;
  const maxRows = document.querySelector("#max-rows").value;

  const params = new URLSearchParams();
  if (fromDate) params.set("fromDate", fromDate);
  if (toDate) params.set("toDate", toDate);
  if (maxRows) params.set("maxRows", maxRows);

  const url = `/exports/invoices/csv${params.toString() ? `?${params.toString()}` : ""}`;
  window.location.href = url;
}

function applyImportTypeHint() {
  const config = getImportConfig();
  importHintEl.innerHTML = `Required headers: <code>${escapeHtml(config.hint)}</code>`;
}

document.querySelector("#connect-btn").addEventListener("click", () => {
  window.location.href = "/auth/intuit/connect";
});

document.querySelector("#refresh-token-btn").addEventListener("click", refreshToken);
document.querySelector("#reload-status-btn").addEventListener("click", loadStatus);
document.querySelector("#preview-btn").addEventListener("click", async () => {
  const csv = await readSelectedCsv();
  if (!csv.trim()) {
    previewWrapEl.innerHTML = "";
    return;
  }
  renderPreviewGrid(csv);
});
previewModeEl.addEventListener("change", async () => {
  const csv = await readSelectedCsv();
  if (!csv.trim()) return;
  renderPreviewGrid(csv);
});
importTypeEl.addEventListener("change", async () => {
  applyImportTypeHint();
  const csv = await readSelectedCsv();
  if (!csv.trim()) return;
  renderPreviewGrid(csv);
});
document.querySelector("#dry-run-btn").addEventListener("click", () => runImport(true));
document.querySelector("#import-btn").addEventListener("click", () => runImport(false));
document.querySelector("#export-btn").addEventListener("click", runExport);

csvFileEl.addEventListener("change", async () => {
  const file = csvFileEl.files?.[0];
  if (!file) return;
  const text = await file.text();
  csvTextEl.value = text;
  renderPreviewGrid(text);
});

applyImportTypeHint();
loadStatus();
