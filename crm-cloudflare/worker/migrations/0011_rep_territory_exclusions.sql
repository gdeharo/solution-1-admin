ALTER TABLE rep_territories ADD COLUMN is_exclusion INTEGER NOT NULL DEFAULT 0;

CREATE INDEX IF NOT EXISTS idx_rep_territories_exclusion ON rep_territories(is_exclusion);
