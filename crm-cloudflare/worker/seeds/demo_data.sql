PRAGMA foreign_keys = ON;

-- Reps
INSERT INTO reps (full_name, company_name, is_independent, email, phone, segment, customer_type)
SELECT 'Avery Stone', 'Northline Sales', 0, 'avery.stone@example.com', '415-555-0111', 'Industrial', 'Enterprise'
WHERE NOT EXISTS (SELECT 1 FROM reps WHERE full_name = 'Avery Stone');

INSERT INTO reps (full_name, company_name, is_independent, email, phone, segment, customer_type)
SELECT 'Maya Patel', 'Independent', 1, 'maya.patel@example.com', '408-555-0199', 'Retail', 'SMB'
WHERE NOT EXISTS (SELECT 1 FROM reps WHERE full_name = 'Maya Patel');

INSERT INTO reps (full_name, company_name, is_independent, email, phone, segment, customer_type)
SELECT 'Jordan Kim', 'WestBridge Partners', 0, 'jordan.kim@example.com', '213-555-0172', 'Healthcare', 'Mid-Market'
WHERE NOT EXISTS (SELECT 1 FROM reps WHERE full_name = 'Jordan Kim');

INSERT INTO reps (full_name, company_name, is_independent, email, phone, segment, customer_type)
SELECT 'Elena Cruz', 'Independent', 1, 'elena.cruz@example.com', '503-555-0141', 'Manufacturing', 'Enterprise'
WHERE NOT EXISTS (SELECT 1 FROM reps WHERE full_name = 'Elena Cruz');

-- Companies
INSERT INTO companies (name, address, city, state, zip, url, segment, customer_type, notes)
SELECT 'Redwood Fabrication', '210 Harbor Dr', 'Oakland', 'CA', '94607', 'https://redwoodfab.example.com', 'Manufacturing', 'Enterprise', 'High-priority account. Interested in annual service contract and expanded onboarding.'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Redwood Fabrication');

INSERT INTO companies (name, address, city, state, zip, url, segment, customer_type, notes)
SELECT 'Summit Outdoor Goods', '88 Canyon Way', 'Denver', 'CO', '80202', 'https://summitoutdoor.example.com', 'Retail', 'SMB', 'Seasonal demand spikes. Looking for shorter response times in Q3/Q4.'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Summit Outdoor Goods');

INSERT INTO companies (name, address, city, state, zip, url, segment, customer_type, notes)
SELECT 'Harbor Health Group', '740 Lakeview Blvd', 'Chicago', 'IL', '60601', 'https://harborhealth.example.com', 'Healthcare', 'Mid-Market', 'Compliance-sensitive account. Requires quarterly review documentation.'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Harbor Health Group');

INSERT INTO companies (name, address, city, state, zip, url, segment, customer_type, notes)
SELECT 'Atlas Freight Systems', '120 Terminal Ave', 'Portland', 'OR', '97204', 'https://atlasfreight.example.com', 'Logistics', 'Enterprise', 'Pilot completed. Awaiting final pricing package and implementation timeline.'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Atlas Freight Systems');

INSERT INTO companies (name, address, city, state, zip, url, segment, customer_type, notes)
SELECT 'Blue Mesa Retail', '55 Market St', 'Phoenix', 'AZ', '85004', 'https://bluemesa.example.com', 'Retail', 'Mid-Market', 'Expansion to 12 new stores next year. Opportunity for bundle deal.'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Blue Mesa Retail');

-- Company <-> rep assignments
INSERT OR IGNORE INTO company_reps (company_id, rep_id)
SELECT c.id, r.id FROM companies c, reps r WHERE c.name = 'Redwood Fabrication' AND r.full_name = 'Avery Stone';

INSERT OR IGNORE INTO company_reps (company_id, rep_id)
SELECT c.id, r.id FROM companies c, reps r WHERE c.name = 'Redwood Fabrication' AND r.full_name = 'Elena Cruz';

INSERT OR IGNORE INTO company_reps (company_id, rep_id)
SELECT c.id, r.id FROM companies c, reps r WHERE c.name = 'Summit Outdoor Goods' AND r.full_name = 'Maya Patel';

INSERT OR IGNORE INTO company_reps (company_id, rep_id)
SELECT c.id, r.id FROM companies c, reps r WHERE c.name = 'Harbor Health Group' AND r.full_name = 'Jordan Kim';

INSERT OR IGNORE INTO company_reps (company_id, rep_id)
SELECT c.id, r.id FROM companies c, reps r WHERE c.name = 'Atlas Freight Systems' AND r.full_name = 'Elena Cruz';

INSERT OR IGNORE INTO company_reps (company_id, rep_id)
SELECT c.id, r.id FROM companies c, reps r WHERE c.name = 'Blue Mesa Retail' AND r.full_name = 'Maya Patel';

-- Contacts (customers)
INSERT INTO customers (company_id, first_name, last_name, email, phone, notes)
SELECT c.id, 'Emma', 'Price', 'emma.price@redwoodfab.com', '510-555-2101', 'Primary operations contact. Prefers morning calls.'
FROM companies c
WHERE c.name = 'Redwood Fabrication'
  AND NOT EXISTS (
    SELECT 1 FROM customers cu
    WHERE cu.company_id = c.id AND cu.first_name = 'Emma' AND cu.last_name = 'Price' AND cu.deleted_at IS NULL
  );

INSERT INTO customers (company_id, first_name, last_name, email, phone, notes)
SELECT c.id, 'Victor', 'Hale', 'victor.hale@redwoodfab.com', '510-555-2102', 'Procurement lead. Focused on long-term pricing.'
FROM companies c
WHERE c.name = 'Redwood Fabrication'
  AND NOT EXISTS (
    SELECT 1 FROM customers cu
    WHERE cu.company_id = c.id AND cu.first_name = 'Victor' AND cu.last_name = 'Hale' AND cu.deleted_at IS NULL
  );

INSERT INTO customers (company_id, first_name, last_name, email, phone, notes)
SELECT c.id, 'Olivia', 'Grant', 'olivia.grant@summitoutdoor.com', '303-555-2201', 'Store operations manager for mountain region.'
FROM companies c
WHERE c.name = 'Summit Outdoor Goods'
  AND NOT EXISTS (
    SELECT 1 FROM customers cu
    WHERE cu.company_id = c.id AND cu.first_name = 'Olivia' AND cu.last_name = 'Grant' AND cu.deleted_at IS NULL
  );

INSERT INTO customers (company_id, first_name, last_name, email, phone, notes)
SELECT c.id, 'Ethan', 'Cole', 'ethan.cole@harborhealth.example.com', '312-555-2301', 'IT admin; responsible for security review paperwork.'
FROM companies c
WHERE c.name = 'Harbor Health Group'
  AND NOT EXISTS (
    SELECT 1 FROM customers cu
    WHERE cu.company_id = c.id AND cu.first_name = 'Ethan' AND cu.last_name = 'Cole' AND cu.deleted_at IS NULL
  );

INSERT INTO customers (company_id, first_name, last_name, email, phone, notes)
SELECT c.id, 'Monica', 'Reed', 'monica.reed@atlasfreight.example.com', '971-555-2401', 'Program manager. Weekly update cadence.'
FROM companies c
WHERE c.name = 'Atlas Freight Systems'
  AND NOT EXISTS (
    SELECT 1 FROM customers cu
    WHERE cu.company_id = c.id AND cu.first_name = 'Monica' AND cu.last_name = 'Reed' AND cu.deleted_at IS NULL
  );

INSERT INTO customers (company_id, first_name, last_name, email, phone, notes)
SELECT c.id, 'Noah', 'Kim', 'noah.kim@bluemesa.example.com', '602-555-2501', 'Regional purchasing contact for southwest stores.'
FROM companies c
WHERE c.name = 'Blue Mesa Retail'
  AND NOT EXISTS (
    SELECT 1 FROM customers cu
    WHERE cu.company_id = c.id AND cu.first_name = 'Noah' AND cu.last_name = 'Kim' AND cu.deleted_at IS NULL
  );

-- Territory rules
INSERT INTO rep_territories (rep_id, territory_type, state, city)
SELECT r.id, 'city_state', 'CA', 'Oakland'
FROM reps r
WHERE r.full_name = 'Avery Stone'
  AND NOT EXISTS (
    SELECT 1 FROM rep_territories t
    WHERE t.rep_id = r.id AND t.territory_type = 'city_state' AND t.state = 'CA' AND t.city = 'Oakland'
  );

INSERT INTO rep_territories (rep_id, territory_type, state)
SELECT r.id, 'state', 'CO'
FROM reps r
WHERE r.full_name = 'Maya Patel'
  AND NOT EXISTS (
    SELECT 1 FROM rep_territories t
    WHERE t.rep_id = r.id AND t.territory_type = 'state' AND t.state = 'CO'
  );

INSERT INTO rep_territories (rep_id, territory_type, state)
SELECT r.id, 'state', 'IL'
FROM reps r
WHERE r.full_name = 'Jordan Kim'
  AND NOT EXISTS (
    SELECT 1 FROM rep_territories t
    WHERE t.rep_id = r.id AND t.territory_type = 'state' AND t.state = 'IL'
  );

INSERT INTO rep_territories (rep_id, territory_type, zip_prefix)
SELECT r.id, 'zip_prefix', '97'
FROM reps r
WHERE r.full_name = 'Elena Cruz'
  AND NOT EXISTS (
    SELECT 1 FROM rep_territories t
    WHERE t.rep_id = r.id AND t.territory_type = 'zip_prefix' AND t.zip_prefix = '97'
  );

-- Interactions (use earliest active user as creator)
INSERT INTO interactions (company_id, customer_id, rep_id, interaction_type, meeting_notes, next_action, next_action_at, created_by_user_id, created_at)
SELECT
  c.id,
  cu.id,
  r.id,
  'Kickoff meeting',
  'Reviewed service goals and implementation schedule. Customer asked for SLA comparison and rollout timeline.',
  'Send SLA comparison and onboarding checklist',
  datetime('now', '+3 day'),
  (SELECT id FROM users WHERE is_active = 1 ORDER BY id ASC LIMIT 1),
  datetime('now', '-6 day')
FROM companies c
JOIN customers cu ON cu.company_id = c.id AND cu.first_name = 'Emma' AND cu.last_name = 'Price'
JOIN reps r ON r.full_name = 'Avery Stone'
WHERE c.name = 'Redwood Fabrication'
  AND NOT EXISTS (
    SELECT 1 FROM interactions i
    WHERE i.company_id = c.id AND i.meeting_notes LIKE 'Reviewed service goals and implementation schedule.%' AND i.deleted_at IS NULL
  );

INSERT INTO interactions (company_id, customer_id, rep_id, interaction_type, meeting_notes, next_action, next_action_at, created_by_user_id, created_at)
SELECT
  c.id,
  cu.id,
  r.id,
  'Quarterly review',
  'Discussed seasonal order trends and forecast variance. Team asked for faster escalation channel in peak months.',
  'Share escalation matrix and Q4 support plan',
  datetime('now', '+5 day'),
  (SELECT id FROM users WHERE is_active = 1 ORDER BY id ASC LIMIT 1),
  datetime('now', '-4 day')
FROM companies c
JOIN customers cu ON cu.company_id = c.id AND cu.first_name = 'Olivia' AND cu.last_name = 'Grant'
JOIN reps r ON r.full_name = 'Maya Patel'
WHERE c.name = 'Summit Outdoor Goods'
  AND NOT EXISTS (
    SELECT 1 FROM interactions i
    WHERE i.company_id = c.id AND i.meeting_notes LIKE 'Discussed seasonal order trends and forecast variance.%' AND i.deleted_at IS NULL
  );

INSERT INTO interactions (company_id, customer_id, rep_id, interaction_type, meeting_notes, next_action, next_action_at, created_by_user_id, created_at)
SELECT
  c.id,
  cu.id,
  r.id,
  'Compliance call',
  'Validated security controls and documentation requirements. Pending legal review for data retention clauses.',
  'Send legal redline summary',
  datetime('now', '+2 day'),
  (SELECT id FROM users WHERE is_active = 1 ORDER BY id ASC LIMIT 1),
  datetime('now', '-2 day')
FROM companies c
JOIN customers cu ON cu.company_id = c.id AND cu.first_name = 'Ethan' AND cu.last_name = 'Cole'
JOIN reps r ON r.full_name = 'Jordan Kim'
WHERE c.name = 'Harbor Health Group'
  AND NOT EXISTS (
    SELECT 1 FROM interactions i
    WHERE i.company_id = c.id AND i.meeting_notes LIKE 'Validated security controls and documentation requirements.%' AND i.deleted_at IS NULL
  );

INSERT INTO interactions (company_id, customer_id, rep_id, interaction_type, meeting_notes, next_action, next_action_at, created_by_user_id, created_at)
SELECT
  c.id,
  cu.id,
  r.id,
  'Pilot follow-up',
  'Pilot KPIs met baseline targets. Customer asked for cost breakdown per lane and support availability weekends.',
  'Provide lane-level cost breakdown',
  datetime('now', '+7 day'),
  (SELECT id FROM users WHERE is_active = 1 ORDER BY id ASC LIMIT 1),
  datetime('now', '-1 day')
FROM companies c
JOIN customers cu ON cu.company_id = c.id AND cu.first_name = 'Monica' AND cu.last_name = 'Reed'
JOIN reps r ON r.full_name = 'Elena Cruz'
WHERE c.name = 'Atlas Freight Systems'
  AND NOT EXISTS (
    SELECT 1 FROM interactions i
    WHERE i.company_id = c.id AND i.meeting_notes LIKE 'Pilot KPIs met baseline targets.%' AND i.deleted_at IS NULL
  );

INSERT INTO interactions (company_id, customer_id, rep_id, interaction_type, meeting_notes, next_action, next_action_at, created_by_user_id, created_at)
SELECT
  c.id,
  cu.id,
  r.id,
  'Planning session',
  'Mapped expansion plan for next fiscal year and reviewed target onboarding windows for new store regions.',
  'Draft rollout phases and budget scenarios',
  datetime('now', '+10 day'),
  (SELECT id FROM users WHERE is_active = 1 ORDER BY id ASC LIMIT 1),
  datetime('now', '-12 hour')
FROM companies c
JOIN customers cu ON cu.company_id = c.id AND cu.first_name = 'Noah' AND cu.last_name = 'Kim'
JOIN reps r ON r.full_name = 'Maya Patel'
WHERE c.name = 'Blue Mesa Retail'
  AND NOT EXISTS (
    SELECT 1 FROM interactions i
    WHERE i.company_id = c.id AND i.meeting_notes LIKE 'Mapped expansion plan for next fiscal year%' AND i.deleted_at IS NULL
  );
