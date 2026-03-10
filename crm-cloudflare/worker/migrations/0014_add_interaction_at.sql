ALTER TABLE interactions ADD COLUMN interaction_at TEXT;

UPDATE interactions
SET interaction_at = created_at
WHERE interaction_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_interactions_company_interaction_at
  ON interactions(company_id, deleted_at, interaction_at);

CREATE INDEX IF NOT EXISTS idx_interactions_interaction_at
  ON interactions(deleted_at, interaction_at);
