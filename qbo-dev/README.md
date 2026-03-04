# qbo-dev

Standalone QuickBooks Online OAuth starter project.

## What this does

- Starts a local Express server.
- Handles QuickBooks OAuth connect and callback.
- Stores tokens in a local JSON file at `data/qbo-connections.json` (dev only).

## Setup

1. Install dependencies:
   ```bash
   npm install
   ```
2. Copy env file and fill values:
   ```bash
   cp .env.example .env
   ```
3. Ensure Intuit app has redirect URL:
   `http://localhost:3000/auth/intuit/callback`
4. Set environment target in `.env`:
   `INTUIT_ENV=sandbox` for development, `INTUIT_ENV=production` for live companies
5. Start server:
   ```bash
   npm run dev
   ```

## Test OAuth

1. Open:
   [http://localhost:3000/ui](http://localhost:3000/ui)
2. Complete Intuit consent.
3. You should get JSON confirming `connected: true`.

## Endpoints

- `GET /` health and next steps
- `GET /ui` browser UI for connect/import/export
- `GET /auth/intuit/status` connection status summary
- `GET /auth/intuit/connect` start OAuth
- `GET /auth/intuit/callback` OAuth callback
- `POST /auth/intuit/refresh` refresh access token from stored refresh token
- `POST /imports/invoices/csv` import invoices from CSV text in JSON body
- `POST /imports/estimates/csv` import estimates from CSV text in JSON body
- `POST /imports/purchase-orders/csv` import purchase orders from CSV text in JSON body
- `GET /exports/invoices/csv` export invoices to CSV

## Invoice CSV import

Expected CSV headers:

`Invoice Number,Customer,Email,Terms,Invoice Date,Due Date,Shipping To,Shipping Via,Shipping Date,Tracking No.,P.O. Number,Sales Rep,Sec,Product/Service,Service Date,SKU,Description,Quantity,Rate,Amount,Class,Tax,Memo,Message On Invoice,Send later,Subtotal,Taxable Subtotal,Tax Rate,Tax Rate %,Sales Tax Amount,Shipping Amt,Total,Attachments`

Example request:

```bash
curl -X POST "http://localhost:3000/imports/invoices/csv" \
  -H "Content-Type: application/json" \
  -d '{
    "dryRun": true,
    "csv": "Invoice Number,Customer,Email,Terms,Invoice Date,Due Date,Shipping To,Shipping Via,Shipping Date,Tracking No.,P.O. Number,Sales Rep,Sec,Product/Service,Service Date,SKU,Description,Quantity,Rate,Amount,Class,Tax,Memo,Message On Invoice,Send later,Subtotal,Taxable Subtotal,Tax Rate,Tax Rate %,Sales Tax Amount,Shipping Amt,Total,Attachments\n5804,Cycle Gear Inc,,Net 30,02/17/2026,03/19/2026,\"Cycle Gear #12\n4455 N. Blackstone Ave\nFresno CA 93726\",USPS,02/18/2026,9400111206241812107547,AUT906582,,,RGC-06CSP,,,Display fixture,10,6.75,,,,,,,,,,,,,,"
  }'
```

Notes:

- Run `dryRun: true` first to validate rows without creating invoices.
- `Customer`, `Terms`, `Shipping Via`, and `Product/Service` are cross-referenced against QuickBooks by name.
- You can also provide numeric IDs in those fields and they will be used directly.
- Import is duplicate-safe by `Invoice Number`: existing invoices are returned as `skipped_existing` and are not recreated.
- Import accepts dates in either `MM/DD/YYYY` or `YYYY-MM-DD`.

Real import example:

```bash
curl -X POST "http://localhost:3000/imports/invoices/csv" \
  -H "Content-Type: application/json" \
  -d '{
    "dryRun": false,
    "csv": "Invoice Number,Customer,Email,Terms,Invoice Date,Due Date,Shipping To,Shipping Via,Shipping Date,Tracking No.,P.O. Number,Sales Rep,Sec,Product/Service,Service Date,SKU,Description,Quantity,Rate,Amount,Class,Tax,Memo,Message On Invoice,Send later,Subtotal,Taxable Subtotal,Tax Rate,Tax Rate %,Sales Tax Amount,Shipping Amt,Total,Attachments\n5804,Cycle Gear Inc,,Net 30,02/17/2026,03/19/2026,\"Cycle Gear #12\n4455 N. Blackstone Ave\nFresno CA 93726\",USPS,02/18/2026,9400111206241812107547,AUT906582,,,RGC-06CSP,,,Display fixture,10,6.75,,,,,,,,,,,,,,"
  }'
```

## Invoice CSV export

Export all available invoices:

```bash
curl -L "http://localhost:3000/exports/invoices/csv" -o invoices.csv
```

Export by date range:

```bash
curl -L "http://localhost:3000/exports/invoices/csv?fromDate=2026-01-01&toDate=2026-12-31&maxRows=1000" -o invoices-2026.csv
```

Query params:

- `fromDate` optional, format `MM/DD/YYYY` or `YYYY-MM-DD`
- `toDate` optional, format `MM/DD/YYYY` or `YYYY-MM-DD`
- `maxRows` optional, default `500`, max `2000`

## Notes

- This is a dev scaffold, not production security/storage.
- Replace local JSON token storage with your database before production.
