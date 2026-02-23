CREATE TABLE IF NOT EXISTS interaction_types (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT OR IGNORE INTO interaction_types (name) VALUES
  ('Store Visit'),
  ('Other Visit'),
  ('Phone Call'),
  ('Other');

CREATE TABLE IF NOT EXISTS app_settings (
  key TEXT PRIMARY KEY,
  value_json TEXT NOT NULL,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by_user_id INTEGER,
  FOREIGN KEY (updated_by_user_id) REFERENCES users(id)
);

INSERT OR IGNORE INTO app_settings (key, value_json)
VALUES (
  'theme',
  '{"bg":"#f8eef4","panel":"#ffffff","ink":"#2b1b25","muted":"#6a4d5d","line":"#e5cfdc","accent":"#c13a7d","accentSoft":"#f6deea","danger":"#9b234f"}'
);
