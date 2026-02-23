ALTER TABLE rep_territories ADD COLUMN segment TEXT;
ALTER TABLE rep_territories ADD COLUMN customer_type TEXT;

CREATE INDEX IF NOT EXISTS idx_rep_territories_segment ON rep_territories(segment);
CREATE INDEX IF NOT EXISTS idx_rep_territories_customer_type ON rep_territories(customer_type);
