-- Performance indexes for common CRM access patterns
CREATE INDEX IF NOT EXISTS idx_rep_territories_scope
  ON rep_territories(rep_id, segment, customer_type, territory_type, is_exclusion);

CREATE INDEX IF NOT EXISTS idx_rep_territories_geo_state
  ON rep_territories(state);

CREATE INDEX IF NOT EXISTS idx_rep_territories_geo_zip_prefix
  ON rep_territories(zip_prefix);

CREATE INDEX IF NOT EXISTS idx_rep_territories_geo_zip_exact
  ON rep_territories(zip_exact);

CREATE INDEX IF NOT EXISTS idx_companies_scope
  ON companies(deleted_at, state, zip, segment, customer_type);

CREATE INDEX IF NOT EXISTS idx_interactions_company_created
  ON interactions(company_id, deleted_at, created_at);

CREATE INDEX IF NOT EXISTS idx_interactions_followup
  ON interactions(deleted_at, next_action_at);

CREATE INDEX IF NOT EXISTS idx_interactions_created_by
  ON interactions(created_by_user_id, deleted_at, created_at);

CREATE INDEX IF NOT EXISTS idx_attachments_entity
  ON attachments(entity_type, entity_id, created_at);

CREATE INDEX IF NOT EXISTS idx_audit_log_created
  ON audit_log(created_at);

CREATE INDEX IF NOT EXISTS idx_audit_log_actor
  ON audit_log(actor_user_id, created_at);
