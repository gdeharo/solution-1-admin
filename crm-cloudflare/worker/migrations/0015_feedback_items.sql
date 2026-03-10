CREATE TABLE IF NOT EXISTS feedback_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  user_name TEXT NOT NULL,
  feedback_at TEXT NOT NULL,
  message TEXT NOT NULL,
  is_resolved INTEGER NOT NULL DEFAULT 0,
  resolved_at TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE INDEX IF NOT EXISTS idx_feedback_items_feedback_at
  ON feedback_items(feedback_at);

CREATE INDEX IF NOT EXISTS idx_feedback_items_resolved
  ON feedback_items(is_resolved, feedback_at);

CREATE INDEX IF NOT EXISTS idx_feedback_items_user
  ON feedback_items(user_id, feedback_at);
