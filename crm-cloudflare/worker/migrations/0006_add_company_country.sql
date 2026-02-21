ALTER TABLE companies ADD COLUMN country TEXT;

UPDATE companies
SET country = 'US'
WHERE country IS NULL OR TRIM(country) = '';
