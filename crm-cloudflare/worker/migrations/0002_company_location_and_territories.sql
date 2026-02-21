PRAGMA foreign_keys = ON;

ALTER TABLE companies ADD COLUMN city TEXT;
ALTER TABLE companies ADD COLUMN state TEXT;
ALTER TABLE companies ADD COLUMN zip TEXT;

CREATE INDEX IF NOT EXISTS idx_companies_city_state ON companies(city, state);
CREATE INDEX IF NOT EXISTS idx_companies_zip ON companies(zip);

CREATE TABLE IF NOT EXISTS rep_territories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  rep_id INTEGER NOT NULL,
  territory_type TEXT NOT NULL CHECK(territory_type IN ('state', 'city_state', 'zip_prefix', 'zip_exact')),
  state TEXT,
  city TEXT,
  zip_prefix TEXT,
  zip_exact TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (rep_id) REFERENCES reps(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_rep_territories_rep_id ON rep_territories(rep_id);
CREATE INDEX IF NOT EXISTS idx_rep_territories_state ON rep_territories(state);
CREATE INDEX IF NOT EXISTS idx_rep_territories_city_state ON rep_territories(city, state);
CREATE INDEX IF NOT EXISTS idx_rep_territories_zip_prefix ON rep_territories(zip_prefix);
CREATE INDEX IF NOT EXISTS idx_rep_territories_zip_exact ON rep_territories(zip_exact);
