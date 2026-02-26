DELETE FROM rep_territories
WHERE id IN (
  SELECT id
  FROM (
    SELECT
      id,
      ROW_NUMBER() OVER (
        PARTITION BY
          rep_id,
          territory_type,
          upper(trim(coalesce(state, ''))),
          upper(trim(coalesce(city, ''))),
          replace(replace(upper(trim(coalesce(zip_prefix, ''))), '-', ''), ' ', ''),
          replace(replace(upper(trim(coalesce(zip_exact, ''))), '-', ''), ' ', ''),
          coalesce(segment, ''),
          coalesce(customer_type, ''),
          coalesce(is_exclusion, 0)
        ORDER BY id
      ) AS rn
    FROM rep_territories
  ) dedupe
  WHERE rn > 1
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_rep_territories_unique_rule
ON rep_territories (
  rep_id,
  territory_type,
  upper(trim(coalesce(state, ''))),
  upper(trim(coalesce(city, ''))),
  replace(replace(upper(trim(coalesce(zip_prefix, ''))), '-', ''), ' ', ''),
  replace(replace(upper(trim(coalesce(zip_exact, ''))), '-', ''), ' ', ''),
  coalesce(segment, ''),
  coalesce(customer_type, ''),
  coalesce(is_exclusion, 0)
);
