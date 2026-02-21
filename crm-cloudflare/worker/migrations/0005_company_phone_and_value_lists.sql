ALTER TABLE companies ADD COLUMN main_phone TEXT;

CREATE TABLE IF NOT EXISTS company_segments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS company_types (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT OR IGNORE INTO company_segments (name) VALUES
  ('Bicycle'),
  ('Motorcycle'),
  ('Chainsaw'),
  ('Industrial'),
  ('Automotive');

INSERT OR IGNORE INTO company_types (name) VALUES
  ('Dealer'),
  ('Distributor'),
  ('OEM'),
  ('Other');

INSERT OR IGNORE INTO company_segments (name)
SELECT DISTINCT segment FROM companies WHERE segment IS NOT NULL AND TRIM(segment) <> '';

INSERT OR IGNORE INTO company_types (name)
SELECT DISTINCT customer_type FROM companies WHERE customer_type IS NOT NULL AND TRIM(customer_type) <> '';
