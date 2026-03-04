PRAGMA foreign_keys = ON;
DELETE FROM attachments WHERE entity_type IN ('company', 'customer', 'interaction');
DELETE FROM interactions;
DELETE FROM customer_reps;
DELETE FROM company_reps;
DELETE FROM customers;
DELETE FROM companies;
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('3H CYCLING', '11436 ARTESIA BLVD UNIT A', 'ARTESIA', 'CA', 'US', '90701', 'https://3hcycling.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', '3HCYCLING@GMAIL.COM', '562-402-0159', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = '3H CYCLING'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('3HCYCLING@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('3HCYCLING@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('406 Service Course', '412 E Aspen Street', 'Bozeman', 'MT', 'US', '59715', 'https://www.bosch-ebike.com/en/service/dealer-search/406-service-course-bike-clinic-65492', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Gal', 'Alon', '406servicecourse@gmail.com', '406-404-7761', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = '406 Service Course'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('406servicecourse@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('406servicecourse@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Gal'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Alon'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('562 E-Bikes - LA South', '9345 Alondra Blvd.', 'Bellflower', 'CA', 'US', '90706', 'https://562ebikes.com/collections/e-bikes', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jose', '', 'admin@562ebikes.com', '562-609-8164', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = '562 E-Bikes - LA South'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('admin@562ebikes.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('admin@562ebikes.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jose'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('805 Bicycles - LA North', '1555 Simi Town Center Way #225', 'Simi Valley', 'CA', 'US', '93065', 'https://www.facebook.com/805bikes/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Nick', 'Mencuri', 'flatsociety@yahoo.com', '805-791-3007', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = '805 Bicycles - LA North'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('flatsociety@yahoo.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('flatsociety@yahoo.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Nick'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Mencuri'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('A Main', '424 Otterson Dr', 'Chico', 'CA', 'US', '95928', 'https://www.danscomp.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Matt', 'Heaps', 'heaps@danscomp.com', '(530) 715-1005', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'A Main'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('heaps@danscomp.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('heaps@danscomp.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Matt'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Heaps'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Aberdeen Bikes', '1101 S. Main Street', 'Chelsea', 'MI', 'US', '48118', 'https://www.aberdeenbike.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Kevin', 'Sanchez', NULL, '734-475-8203', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Aberdeen Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Kevin'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Sanchez'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Action Sports  - LA Desert', '9500 Brimhall Rd #400', 'Bakersfield', 'CA', 'US', '93312', 'https://www.teamactionsports.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Kerry', '', 'kerry@teamactionsports.com', '661-833-4000', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Action Sports  - LA Desert'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('kerry@teamactionsports.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('kerry@teamactionsports.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Kerry'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Adams Avenue Bikes', '2602 Adams Ave', 'San Diego', 'CA', 'US', '92116', 'https://www.aabikes.net/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Chuck', 'Cofer', 'adamsavebike@gmail.com', '(619) 295-8500', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Adams Avenue Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('adamsavebike@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('adamsavebike@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Chuck'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Cofer'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Adrenaline Bike Works, LLC', '206 N. Highland St.', 'Mount Dora', 'FL', 'US', '32778', 'https://www.rideabw.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Shawn', 'Lukens/Brian Beck', 'accounting@rideabw.com', '(352) 805-2297', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Adrenaline Bike Works, LLC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('accounting@rideabw.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('accounting@rideabw.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Shawn'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Lukens/Brian Beck'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Advanced Cycles PR', '1248 Cavender Creek RD', 'Minneola', 'FL', 'US', '34715', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Maria', '', NULL, '787-731-4175', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Advanced Cycles PR'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Maria'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Adventures Edge', '650 10th Street', 'Arcata', 'CA', 'US', '95521', 'https://www.adventuresedge.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jeff', 'Farnum', 'jeff@adventuresedge.com', '707-822-4673', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Adventures Edge'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('jeff@adventuresedge.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('jeff@adventuresedge.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jeff'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Farnum'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('AJ''S BICYCLES', '1538 BLOOMINGDALE AVE', 'VALRICO', 'FL', 'US', '33596', 'https://www.ajsbikes.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'DARRIN@AJSBIKES.COM', '813-685-2453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'AJ''S BICYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('DARRIN@AJSBIKES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('DARRIN@AJSBIKES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Albright''s Cycling & Fitness', '2720 Lincolnway W', 'Mishawaka', 'IN', 'US', '46544', 'https://albrights.bike/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Greg', 'Albright', NULL, '574-255-8988', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Albright''s Cycling & Fitness'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Greg'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Albright'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Alex''s Bicycle Pro Shop', '16098 W. STATE ROAD 84 Ste 3', 'WESTON', 'FL', 'US', '33326', 'https://www.alexbicycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Alex', '', 'info@alexbicycles.com', '954-990-0836', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Alex''s Bicycle Pro Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@alexbicycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@alexbicycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Alex'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('ALL ABOUT BIKES', '4904 Poplar ave.', 'MEMPHIS', 'TN', 'US', '38117', 'https://www.allaboutbikesllc.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'tommy@allaboutbikesllc.com', '901-767-6240', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'ALL ABOUT BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('tommy@allaboutbikesllc.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('tommy@allaboutbikesllc.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('ALL KEYS CYCLES', '103400 Overseas Hwy', 'Key Largo', 'FL', 'US', '33037', 'https://allkeyscycles.com/index.html', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Steve', 'Troeger', 'steve@allkeyscycles.com', '305-453-6221', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'ALL KEYS CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('steve@allkeyscycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('steve@allkeyscycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Steve'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Troeger'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('ALL STAR BIKE SHOP', '1241 KILDARIE FARM ROAD', 'CARY', 'NC', 'US', '27511', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'ALLSTARBIKESHOPCARY@GMAIL.COM', '502-882-2453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'ALL STAR BIKE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ALLSTARBIKESHOPCARY@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ALLSTARBIKESHOPCARY@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Allez LA', '5227 York Blvd.', 'Los Angeles', 'CA', 'US', '90042', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Kyle', '', 'info@allez-la.com', '323-274-4577', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Allez LA'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@allez-la.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@allez-la.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Kyle'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('ALLIED CYCLE', '23101 GRATIOT AVE.', 'EASTPOINTE', 'MI', 'US', '48021', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '586-772-3411', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'ALLIED CYCLE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('AL''S BICYCLES', '8900 S WALKER', 'OKLAHOMA CITY', 'OK', 'US', '73139', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'TYLERLAUBACH2@GMAIL.COM', '(877) 574-0656', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'AL''S BICYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('TYLERLAUBACH2@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('TYLERLAUBACH2@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Al''s Cycle Shop', NULL, 'Skokie', 'IL', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Larry', 'Binder', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Al''s Cycle Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Larry'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Binder'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Al''s Quick Release Bicycle Inc', '322 W Flint St', 'Davison', 'MI', 'US', '48423', 'https://www.aqrbike.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Steve', 'Phillips', 'quickrelease.inc@gmail.com', '810-658-9215', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Al''s Quick Release Bicycle Inc'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('quickrelease.inc@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('quickrelease.inc@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Steve'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Phillips'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('ALTA OUTFITTERS', '2035 PLACENTIA AVE #E', 'COSTA MESA', 'CA', 'US', '92627', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '714-594-3844', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'ALTA OUTFITTERS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Americas Bike Company', '29219 Juba Rd.', 'Valley Center', 'CA', 'US', '92082', 'https://www.americasbikecompany.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Nik', 'Kjaer', 'info@americasbikecompany.com', '(760) 542-8473', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Americas Bike Company'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@americasbikecompany.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@americasbikecompany.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Nik'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Kjaer'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Annapolis Velo', '436 Chinquapin Round Rd', 'Annapolis', 'MD', 'US', '21401', 'http://www.annapolisvelo.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Chris', 'Adair', 'ANNAPOLISVELO@GMAIL.COM', '(667) 225-4482', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Annapolis Velo'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ANNAPOLISVELO@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ANNAPOLISVELO@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Chris'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Adair'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Antioch Schwinn Cyclery', NULL, 'Antioch', 'IL', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Brian', 'Paschke', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Antioch Schwinn Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Brian'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Paschke'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Archer Bicycles', '431 13th St', 'Oakland', 'CA', 'US', '94612', 'https://www.facebook.com/archerbicycle/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Greg', 'Archer', 'greg@archerbike.com', '(510) 681-1141', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Archer Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('greg@archerbike.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('greg@archerbike.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Greg'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Archer'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Area Cycles', '3052 Castro Valley Blvd', 'Castro Valley', 'CA', 'US', '94546', 'https://areacycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Kenji', 'Iwahashi', 'areacycles@gmail.com', '(510) 589-7291', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Area Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('areacycles@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('areacycles@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Kenji'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Iwahashi'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('ARNOLDS BICYCLE REPAIR', '9890 Forest ST', 'DYER', 'IN', 'US', '46311', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'ARNOLDSMOBILEBIKEREPAIR@GMAIL.COM', '219-713-1463', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'ARNOLDS BICYCLE REPAIR'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ARNOLDSMOBILEBIKEREPAIR@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ARNOLDSMOBILEBIKEREPAIR@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('ARNOLD''S BIKE SHOP', '3891 MILLER RD., STE 2', 'COLUMBUS', 'GA', 'US', '31909', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'KIMSAUNDERS@YAHOO.COM', '336-258-2294', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'ARNOLD''S BIKE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('KIMSAUNDERS@YAHOO.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('KIMSAUNDERS@YAHOO.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Around the Cycle', '1270 Lincoln Ave', 'Pasadena', 'CA', 'US', '91103', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ryan', '', 'info@aroundthecycle.com', '626-534-8098', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Around the Cycle'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@aroundthecycle.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@aroundthecycle.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ryan'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('ASHEVILLE BICYCLE CO', '1000 MERRIMON AVENUE', 'ASHEVILLE', 'NC', 'US', '28804', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'ASHEVILLE BICYCLE CO'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('ASSENDMACHERS CYCLERY', '1272 WHILL RD', 'FLINT', 'MI', 'US', '48507', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '810-232-2994', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'ASSENDMACHERS CYCLERY'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Attitude Sports', '209 N. Macy St.', 'Fon dul Lac', 'WI', 'US', '54935', 'https://www.attitudesports.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Dave', 'Haase', 'dave@attitudesports.com', '(920) 923-2323', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Attitude Sports'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('dave@attitudesports.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('dave@attitudesports.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Dave'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Haase'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BACARDI BIKES', '3437 N. MILWAUKEE AVE', 'CHICAGO', 'IL', 'US', '60641', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'BACARDIBIKES@GMAIL.COM', '773-719-0487', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BACARDI BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BACARDIBIKES@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BACARDIBIKES@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bacardi Bikes', NULL, 'Chicago', 'IL', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Fidel', 'Talevera', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bacardi Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Fidel'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Talevera'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BACK TO DIRT BIKES/STORM ENDURANCE SPORTS INC.', '235 WICKER ST', 'SANFORD', 'NC', 'US', '27330', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BACK TO DIRT BIKES/STORM ENDURANCE SPORTS INC.'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BALLWIN CYCLES', '15340 MANCHESTER RD', 'BALLWIN', 'MO', 'US', '63011', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'BSCHWINN@PRIMARY.NET', '636-391-2666', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BALLWIN CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BSCHWINN@PRIMARY.NET' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BSCHWINN@PRIMARY.NET')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BALTIMORE HYBRID PEDALS', '1901 MONKTON RD., UNIT 1', 'MONKTON', 'MD', 'US', '21111', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'JOHN.LEBO@ELECTRIC-MOTOR.US', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BALTIMORE HYBRID PEDALS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('JOHN.LEBO@ELECTRIC-MOTOR.US' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('JOHN.LEBO@ELECTRIC-MOTOR.US')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Barcelo Bicycles', '1650 Superior Ave', 'Costa Mesa', 'CA', 'US', '92627', 'https://www.instagram.com/barcelobicycles/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Dennis', '', 'dennis@barcelobicycles.com', '949-722-7002', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Barcelo Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('dennis@barcelobicycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('dennis@barcelobicycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Dennis'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BEARDEN BIKE AND TRAIL', '126 N FOREST PARK BLVD.', 'KNOXVILLE', 'TN', 'US', '37919', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'BIKEANDTRAIL@GMAIL.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BEARDEN BIKE AND TRAIL'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BIKEANDTRAIL@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BIKEANDTRAIL@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bedlam Bicycle Co', NULL, 'Benton Harbor', 'MI', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Kevin', 'Haddox', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bedlam Bicycle Co'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Kevin'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Haddox'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bellflower Bicycles', '16442 Woodruff Ave', 'Bellflower', 'CA', 'US', '90706', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Aaron', '', 'bellflowerbikes1@gmail.com', '562-867-2306', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bellflower Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('bellflowerbikes1@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('bellflowerbikes1@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Aaron'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bennett Bike & Fitness', NULL, 'Mason City', 'IA', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Robin', 'Bennett', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bennett Bike & Fitness'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Robin'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Bennett'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BENNETTS BIKES', '517 JEWETT AVENUE', 'STATEN ISLAND', 'NY', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '718-447-8652', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BENNETTS BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Ben''s Bikes', '7431 S Houghton Rd., #100', 'Tucson', 'AZ', 'US', '85747', 'https://www.bensbikestucson.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ben', 'Chandler', 'ben@bensbikestucson.com', '(520) 574-2453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Ben''s Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ben@bensbikestucson.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ben@bensbikestucson.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ben'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Chandler'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('bEn''s Bikes - LA Inland', 'Closed', NULL, NULL, 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ben', '', 'bensebikes@gmail.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'bEn''s Bikes - LA Inland'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('bensebikes@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('bensebikes@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ben'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Berkeley Cycle Works', '1619 San Pablo Dr', 'Berkeley', 'CA', 'US', '94702', 'https://www.berkeleycycleworks.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Mike', 'Britton', 'mike@berkeleycycleworks.com', '510-525-2453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Berkeley Cycle Works'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('mike@berkeleycycleworks.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('mike@berkeleycycleworks.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Mike'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Britton'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Berkshire Bike & Board', '29 State Rd', 'Great Barrington', 'MA', 'US', '01230', 'https://www.berkshirebikeandboard.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Kenny', 'Rand', 'saleseast@berkshirebikeandboard.com', '(413) 528-5555', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Berkshire Bike & Board'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('saleseast@berkshirebikeandboard.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('saleseast@berkshirebikeandboard.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Kenny'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Rand'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BICYCLE BARN', '839 READING RD', 'EAST EARL', 'PA', 'US', '17519', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '717-445-8508', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BICYCLE BARN'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bicycle Central', '121 W Route 66', 'Glendora', 'CA', 'US', '91740', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Adam', '', 'adam@thebicyclecentral.com', '(626)963-2312', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bicycle Central'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('adam@thebicyclecentral.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('adam@thebicyclecentral.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Adam'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bicycle Central - LA Inland', 'Route 66', 'Glendora', 'CA', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Adam', '', 'adam@thebicyclecentral', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bicycle Central - LA Inland'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('adam@thebicyclecentral' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('adam@thebicyclecentral')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Adam'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BICYCLE FACE', '331 E SHORT ST', 'LEXINGTON', 'KY', 'US', '40507', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '(864) 284-0040', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BICYCLE FACE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BICYCLE JOHN''S', '1038 N HOLLYWOOD AVE', 'BURBANK', 'CA', 'US', '91505', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '760-436-2786', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BICYCLE JOHN''S'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bicycle John''s', '26635 Valley Center Dr. #108', 'Santa Clarita', 'CA', 'US', '91351', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'John', '', 'info@bicyclejohnsscv.com', '661-254-7300', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bicycle John''s'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@bicyclejohnsscv.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@bicyclejohnsscv.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('John'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BICYCLE OUTFITTER', '963 FREMONT AVENUE', 'LOS ALTOS', 'CA', 'US', '94024', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BICYCLE OUTFITTER'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BICYCLE SPORT', '2916 SELWYN AVE.', 'CHARLOTTE', 'NC', 'US', '28209', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '334-356-7271', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BICYCLE SPORT'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BICYCLE THERAPY', '2211 SOUTH ST.', 'PHILADELPHIA', 'PA', 'US', '19146', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '215-735-7849', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BICYCLE THERAPY'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BICYCLE TRANSIT SYSTEMS', '1330 N. 5TH ST.', 'PHILADELPHIA', 'PA', 'US', '19122', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '215-668-4586', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BICYCLE TRANSIT SYSTEMS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bicycle Warehouse', '680 W Bradley Ave', 'El Cajon', 'CA', 'US', '92020', 'https://bicyclewarehouse.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ethan', 'Vance', 'ethan@bicyclewarehouse.com', '(888) 231-2453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bicycle Warehouse'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ethan@bicyclewarehouse.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ethan@bicyclewarehouse.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ethan'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Vance'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bicycle Warehouse - SD', '4670 Santa Fe St.', 'San Diego', 'CA', 'US', '92109', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Debbe', '', 'debbe@bicyclewarehouse.com', '858-273-7300', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bicycle Warehouse - SD'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('debbe@bicyclewarehouse.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('debbe@bicyclewarehouse.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Debbe'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bicycle World', '7 E Main St', 'Mt. Kisco', 'NY', 'US', '10549', 'https://www.bicycleworldny.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Eric', 'Marcos', 'ericjmarcos@gmail', '(914) 666-4044', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bicycle World'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ericjmarcos@gmail' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ericjmarcos@gmail')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Eric'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Marcos'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Big Dave''s Bikes', '609 GREGORY LANE, #120', 'Pleasant Grove', 'CA', 'US', '94523', 'https://www.bigdavesbikes.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Dave', 'Bzdula', 'bigdavesbikes@gmail.com', '(925) 954-1956', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Big Dave''s Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('bigdavesbikes@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('bigdavesbikes@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Dave'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Bzdula'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BIG WHEEL CYCLES', '7035 TAFT ST.', 'HOLLYWOOD', 'FL', 'US', '33024', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'BIGWHEELCYCLES@GMAIL.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BIG WHEEL CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BIGWHEELCYCLES@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BIGWHEELCYCLES@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bike Attack - LA', '12775 W. Millenium', 'Playa Vista', 'CA', 'US', '90094', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ericson', '', 'info@bikeattack.com', '310-461-7451', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bike Attack - LA'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@bikeattack.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@bikeattack.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ericson'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bike Care', '251D Clifton Ave', 'Clifton', 'NJ', 'US', '07011', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Lajos', 'Horvadh', NULL, '(973) 246-7077', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bike Care'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Lajos'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Horvadh'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bike Craze - OC', '1171 N Kraemer Blvd', 'Anaheim', 'CA', 'US', '92806', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Scott', '', 'bikecraze1@gmail.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bike Craze - OC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('bikecraze1@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('bikecraze1@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Scott'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bike Depot', '91 W Main St', 'East Islip', 'NY', 'US', '11730', 'https://bikedepotei.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Richard', 'Gutowitz', 'bikedepotei@gmail.com', '(631) 581-5557', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bike Depot'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('bikedepotei@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('bikedepotei@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Richard'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Gutowitz'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BIKE DEPOT OF WAXHAW', '122 W NORTH ST.', 'WAXHAW', 'NC', 'US', '28173', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'TEELO34@HOTMAIL.COM', '828-633-2227', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BIKE DEPOT OF WAXHAW'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('TEELO34@HOTMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('TEELO34@HOTMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bike Fix', NULL, 'Tekonsha', 'MI', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Bruce', 'Brown', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bike Fix'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Bruce'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Brown'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BIKE LINK OF HOOVER', '2766 JOHN HAWKINSPKWY, #104', 'BIRMINGHAM', 'AL', 'US', '35244', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'JOE@BIKELINKBAM.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BIKE LINK OF HOOVER'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('JOE@BIKELINKBAM.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('JOE@BIKELINKBAM.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bike Loft LLC', '717 South Bay Road', 'North Syracuse', 'NY', 'US', '13212', 'https://www.bikeloft.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'James', 'Hunter', 'info@bikeloft.com', '(315) 458-5260', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bike Loft LLC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@bikeloft.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@bikeloft.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('James'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Hunter'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bike Palm Springs', '194 Indian Canyon Dr.', 'Pam Springs', 'CA', 'US', '92262', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Antonio', '', 'ynotbikeps@aol.com', '760-832-8912', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bike Palm Springs'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ynotbikeps@aol.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ynotbikeps@aol.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Antonio'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BIKE PRO SERVICE', NULL, NULL, NULL, 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'BIKEPROSERVICE@GMAIL.COM', '647-210-1210', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BIKE PRO SERVICE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BIKEPROSERVICE@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BIKEPROSERVICE@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bike Share Pittsburgh', '6592 Hamilton Ave. FL. 2 (rear)', 'Pittsburgh', 'PA', 'US', '15206', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Sara', 'Khalil', 'account@pghbikeshare.org / sara@pghbikeshare.org', '(412) 621-0464', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bike Share Pittsburgh'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('account@pghbikeshare.org / sara@pghbikeshare.org' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('account@pghbikeshare.org / sara@pghbikeshare.org')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Sara'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Khalil'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BIKE TECH USA', '4316 SW 73RD AVE.', 'MIAMI', 'FL', 'US', '33155', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'JOYLE@BIKETECHUSA.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BIKE TECH USA'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('JOYLE@BIKETECHUSA.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('JOYLE@BIKETECHUSA.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BIKE TOWN', '829 TERRACE PARK, #103', 'ROCK HILL', 'SC', 'US', '29730', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'BIKETOWNSC@GMAIL.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BIKE TOWN'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BIKETOWNSC@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BIKETOWNSC@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Biked', NULL, 'Grand Rapids', 'MI', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Eric', 'Mentalewcz', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Biked'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Eric'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Mentalewcz'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bikeland', '146 Main St', 'Chatham', 'NJ', 'US', '07928', 'https://bikeland.xyz/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Oscar', 'Mejia', 'chatham@bikeland.xyz', '(973) 635-8066', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bikeland'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('chatham@bikeland.xyz' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('chatham@bikeland.xyz')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Oscar'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Mejia'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BIKES AND MOORE', '2133 NW 6TH ST.', 'GAINESVILLE', 'FL', 'US', '32609', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'MARILYNSCHMIDT1@GMAIL.COM;BIKESANDMOREGAINESVILLE@GMAIL.COM', '352-373-6574', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BIKES AND MOORE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('MARILYNSCHMIDT1@GMAIL.COM;BIKESANDMOREGAINESVILLE@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('MARILYNSCHMIDT1@GMAIL.COM;BIKESANDMOREGAINESVILLE@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BIKES MAKE LIFE BETTER', '1 HACKER WAY', 'MENLO PARK', 'CA', 'US', '94025', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'GUSHAMILTON@FB.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BIKES MAKE LIFE BETTER'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('GUSHAMILTON@FB.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('GUSHAMILTON@FB.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bilenky Cycle Works LTD', '5319 N 2nd St', 'Philadelphia', 'PA', 'US', '19120', 'https://www.bilenky.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Stephen', 'Bilenky', 'artistry@bilenky.com', '(215) 329-4744', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bilenky Cycle Works LTD'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('artistry@bilenky.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('artistry@bilenky.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Stephen'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Bilenky'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BILOXI BICYCLE WORKS', '993 HOWARD AVE', 'BILOXI', 'MS', 'US', '39530', 'https://biloxibicycleworks.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'DANIEL@SPORTIFVENTURES.COM', '480-690-5030', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BILOXI BICYCLE WORKS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('DANIEL@SPORTIFVENTURES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('DANIEL@SPORTIFVENTURES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bingham Cyclery', '2317 N. Main St.', 'Sunset', 'UT', 'US', '84015', 'https://www.binghamcyclery.com/about/bingham-cyclery-sandy-pg104.htm', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Michelle', 'Schmid', 'invoices@binghamcyclery.com', '(801) 580-1800', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bingham Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('invoices@binghamcyclery.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('invoices@binghamcyclery.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Michelle'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Schmid'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Black Saddle Bike Shop', NULL, 'Madison', 'WI', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Mitch', 'Pilon', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Black Saddle Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Mitch'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Pilon'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BLACK TIRE BIKE CO.', '117 WEST MAIN ST.', 'MARSHALLTOWN', 'IA', 'US', '50158', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'BLACKTIREBIKES@GMAIL.COM', '641-753-3320', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BLACK TIRE BIKE CO.'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BLACKTIREBIKES@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BLACKTIREBIKES@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Blacktop Cyclery - LA Desert', '1018 18th St.', 'Bakersfield', 'CA', 'US', '93301', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Laurence', '', 'laurence@blacktopcyclery.com', '661-833-4141', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Blacktop Cyclery - LA Desert'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('laurence@blacktopcyclery.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('laurence@blacktopcyclery.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Laurence'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Blue Heron Bikes', '1306 Gilman St', 'Berkeley', 'CA', 'US', '94706', 'https://www.blueheronbikesberkeley.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jordan', 'Chase', 'purchasing@blueheronbikesberkeley.com, JOSH.SCHLEE@TERNBICYCLES.COM', '(510) 524-1937', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Blue Heron Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('purchasing@blueheronbikesberkeley.com, JOSH.SCHLEE@TERNBICYCLES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('purchasing@blueheronbikesberkeley.com, JOSH.SCHLEE@TERNBICYCLES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jordan'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Chase'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Blue Line Bike Lab / Blue Bike Bike Lab', '1504 Yale St', 'Houston', 'TX', 'US', '77008', 'https://www.bluelinebikelab.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Fred', 'Zapalac', 'bluelinebikes@hotmail.com', '713-802-1707', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Blue Line Bike Lab / Blue Bike Bike Lab'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('bluelinebikes@hotmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('bluelinebikes@hotmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Fred'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Zapalac'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BLUE MOUNTAIN RESORT', '1660 BLUE MOUNTAIN DR', 'PALMERTON', 'PA', 'US', '18071', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'CTAKACS@SKIBLUEMT.COM', '610-826-7700 EXT 1219', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BLUE MOUNTAIN RESORT'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('CTAKACS@SKIBLUEMT.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('CTAKACS@SKIBLUEMT.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BLUE SKY ENDURANCE', '725 COLEMAN BLVD SUITE 126', 'MOUNT PLEASANT', 'SC', 'US', '29464', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '828-230-4274', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BLUE SKY ENDURANCE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Blue Spruce Cyclery / Ajax Sports, LLC', '12201 E. Arapahoe Rd. Suite B6', 'Centennial', 'CO', 'US', '80112', 'https://about.bluesprucecyclery.com/contact', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Andrew', 'Clark', 'andrewfclark@gmail.com', '303-525-4705', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Blue Spruce Cyclery / Ajax Sports, LLC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('andrewfclark@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('andrewfclark@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Andrew'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Clark'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BOB GABEL & ASSOCIATES, LLC', 'PO BOX 4561', 'SKOKIE', 'IL', 'US', '60077', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'BGABEL12@GMAIL.COM', '312-401-8647', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BOB GABEL & ASSOCIATES, LLC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BGABEL12@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BGABEL12@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bob''s Cycle Center Inc', '9920 FAIR OAKS BLVD', 'Fair Oaks', 'CA', 'US', '95628', 'https://www.bobscyclecenter.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'info@bobscyclecenter.com', '916-961-6700', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bob''s Cycle Center Inc'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@bobscyclecenter.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@bobscyclecenter.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BOOST BIKE SHOP', '125 W MARION STREET', 'SHELBY', 'NC', 'US', '28150', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'BOOSTBIKESHOP@GMAIL.COM', '502-718-7246', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BOOST BIKE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BOOSTBIKESHOP@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BOOSTBIKESHOP@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BRANDS CYCLE AND FITNESS', '11793 WANTAGH AVE', 'WANTAGH', 'NY', 'US', '11793', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BRANDS CYCLE AND FITNESS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Breakaway Bikes', '4235 Montgomery Dr', 'Santa Rosa', 'CA', 'US', '95405', 'https://www.breakawaybikes.co/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Kevin', 'Gambini', 'kevin@breakawaybikes.com', '(707) 506-3400', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Breakaway Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('kevin@breakawaybikes.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('kevin@breakawaybikes.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Kevin'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Gambini'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Briar Ridge Bikes', NULL, 'Solon', 'IA', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Larry', 'Lutz', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Briar Ridge Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Larry'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Lutz'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BRICK WHEELS', '736 EIGHTH ST', 'TRAVERSE CITY', 'MI', 'US', '49686', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '231-947-4274', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BRICK WHEELS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Brielle Cyclery', '205 Union Ave', 'Brielle', 'NJ', 'US', '08730', 'https://www.briellecyclery.com/about/brielle-cyclery-pg278.htm', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'James', 'Erbe', 'info@briellecyclery.com', '(732) 528-9121', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Brielle Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@briellecyclery.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@briellecyclery.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('James'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Erbe'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Broken Spoke Bicycles', '1426 Cerrillos Rd.', 'Santa Fe', 'NM', 'US', '87505', 'https://brokenspokesantafe.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Mike', 'Chapman', 'brokenspokesantafe@gmail.com', '(505) 992-3102', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Broken Spoke Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('brokenspokesantafe@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('brokenspokesantafe@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Mike'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Chapman'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BROOMWAGON BIKES', '800 NORTH LIMESTONE ST.', 'LEXINGTON', 'KY', 'US', '40505', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'BROOMWAGONBIKES@GMAIL.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BROOMWAGON BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BROOMWAGONBIKES@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BROOMWAGONBIKES@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Brumble Bikes', '166 Main St', 'Westerly', 'RI', 'US', '02891', 'https://www.brumblebikes.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Mark', 'Young', 'amos@brumblebikes.com', '(401) 315-0230', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Brumble Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('amos@brumblebikes.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('amos@brumblebikes.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Mark'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Young'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bruno''s Bicycles', '19 S Main St', 'Allentown', 'NJ', 'US', '08501', 'https://www.facebook.com/BrunosBicycles/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Christopher', 'Lee', 'Heatherbrunosonesweetride@gmail.com', '(609) 208-0544', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bruno''s Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('Heatherbrunosonesweetride@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('Heatherbrunosonesweetride@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Christopher'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Lee'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('BULLSEYE BICYCLES', '102 MORRIS ST', 'DURHAM', 'NC', 'US', '27701', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'BULLSEYE BICYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Bumstaed''s Bicycles - LA Inland', '1038 W 4th St', 'Ontario', 'CA', 'US', '91763', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Lloyd', '', 'info@bumpstaedsbikes.com', '909-984-9067', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Bumstaed''s Bicycles - LA Inland'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@bumpstaedsbikes.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@bumpstaedsbikes.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Lloyd'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Burn the Ships Electrics - LA Southbay', '1012 S. Pacific Coast Hwy', 'Redondo Beach', 'CA', 'US', '90277', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jonathan', '', 'jon@burntheships.com', '310-372-1122', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Burn the Ships Electrics - LA Southbay'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('jon@burntheships.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('jon@burntheships.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jonathan'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('C Street Bikes', '3717 Cahuenga Blvd', 'Studio City', 'CA', 'US', '91604', 'https://www.cstreetbikes.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ian', 'Barner', 'contact@cstreetbikes.com', '(818) 980-7456', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'C Street Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('contact@cstreetbikes.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('contact@cstreetbikes.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ian'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Barner'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CAHABA CYCLES WAREHOUSE', '1200 SECOND AVE. SOUTH', 'BRIRMINGHAM', 'AL', 'US', '35233', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'INFO@CAHABACYCLES.COM', '(828) 774-5215', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CAHABA CYCLES WAREHOUSE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('INFO@CAHABACYCLES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('INFO@CAHABACYCLES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CAHABA CYCLES-CAHABA HEIGHTS', '3179 CAHABA HEIGHTS RD.', 'BIRMINGHAM', 'AL', 'US', '35243', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'INFO@CAHABACYCLES.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CAHABA CYCLES-CAHABA HEIGHTS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('INFO@CAHABACYCLES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('INFO@CAHABACYCLES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CAHABA CYCLES-HOMEWOOD', '2834 SOUTH 18TH ST.', 'BIRMINGHAM', 'AL', 'US', '35209', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'INFO@CAHABACYCLES.COM', '901-767-6240', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CAHABA CYCLES-HOMEWOOD'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('INFO@CAHABACYCLES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('INFO@CAHABACYCLES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CAHABA CYCLES-OAK MOUNTAIN', '271 PELHAM PARKWAY', 'PELHAM', 'AL', 'US', '35124', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'INFO@CAHABACYCLES.COM', '919-469-1849', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CAHABA CYCLES-OAK MOUNTAIN'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('INFO@CAHABACYCLES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('INFO@CAHABACYCLES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CAHABA CYCLES-TRUSSVILLE', '183 MAIN ST.', 'TRUSSVILLE', 'AL', 'US', '35173', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'INFO@CAHABACYCLES.COM', '706-568-1806', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CAHABA CYCLES-TRUSSVILLE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('INFO@CAHABACYCLES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('INFO@CAHABACYCLES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('California Bicycle Inc', '7462 La Jolla Blvd', 'La Jolla', 'CA', 'US', '92037', 'https://calbike.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jason', 'Millard', 'kevin@calbike.com', '(858) 454-0316', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'California Bicycle Inc'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('kevin@calbike.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('kevin@calbike.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jason'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Millard'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('California Bike & Snowboard', '1483 Danille Blvd.', 'Alamo', 'CA', 'US', '94507', 'http://www.calbikeandboard.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'David', 'Chu', 'cabikensnowboard@gmail.com', '925-837-8444', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'California Bike & Snowboard'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('cabikensnowboard@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('cabikensnowboard@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('David'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Chu'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CAMBRIA BICYCLE OUTFITTERS', '1645 COMMERCE WAY', 'PASO ROBLES', 'CA', 'US', '93446', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'ROBERTY@CAMBRIABIKE.COM', '859-888-2453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CAMBRIA BICYCLE OUTFITTERS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ROBERTY@CAMBRIABIKE.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ROBERTY@CAMBRIABIKE.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Canadian Tire', '2180 Yonge St.', 'Toronto', 'ON', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'TBD', '', 'TBD', '416-480-3000', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Canadian Tire'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('TBD' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('TBD')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('TBD'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Canyon Country Bicycles', '18833 Soledad Cyn Rd', 'Canyon Country', 'CA', 'US', '91351', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Lonnie', '', 'lonnie.dilan@gmail.com', '661-252-7217', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Canyon Country Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('lonnie.dilan@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('lonnie.dilan@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Lonnie'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CAROLINA TRIATHLON', '123 WELBORN ST., #102', 'GREENVILLE', 'SC', 'US', '29601', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'RANDY@CAROLINATRIATHLON.COM', '423-472-9881', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CAROLINA TRIATHLON'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('RANDY@CAROLINATRIATHLON.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('RANDY@CAROLINATRIATHLON.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Cartersville Bicycle Service & Supply & Porkchop BMX', '5 S Public Square', 'Cartersville', 'GA', 'US', '30120', 'https://www.cartersvillebicycle.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Justin', 'Earl', 'justin@porkchopbmx.com', '470-315-2453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Cartersville Bicycle Service & Supply & Porkchop BMX'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('justin@porkchopbmx.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('justin@porkchopbmx.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Justin'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Earl'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Castle Hill Bike Shop', '3467 E Tremont Ave', 'Bronx', 'NY', 'US', '10465', 'https://castlehillbikeshop.wixsite.com/castle-hill-bike-sho', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jose', 'Santiago', 'info@mysite.com', '(718) 597-2083', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Castle Hill Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@mysite.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@mysite.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jose'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Santiago'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CAT EYE', '2825 WILDERNESS PLACE SUITE 1200', 'BOULDER', 'CO', 'US', '80301', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'RYAN@CATEYE.COM', '303-501-1303', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CAT EYE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('RYAN@CATEYE.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('RYAN@CATEYE.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CBS Cycling', '23120 Lyons Ave. #B', 'Newhall', 'CA', 'US', '91321', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Paul', '', 'cbscycling@gmail.com', '661-259-9800', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CBS Cycling'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('cbscycling@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('cbscycling@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Paul'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Cedar Lane Bike Shop', NULL, 'Nappanee', 'IN', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jeff', 'Voder', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Cedar Lane Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jeff'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Voder'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Central Cycle', NULL, 'Holton', 'MI', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Joe', 'Bontrager', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Central Cycle'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Joe'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Bontrager'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CENTRIPEDAL BIKES', '3636 THORNTON AVE', 'FREMONT', 'CA', 'US', '94536', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'ALEX@CENTRIPEDALBIKES.COM', '510-742-2265', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CENTRIPEDAL BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ALEX@CENTRIPEDALBIKES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ALEX@CENTRIPEDALBIKES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CHAIN REACTION', '3409 W UNIVERSITY AVE', 'GAINESVILLE', 'FL', 'US', '32603', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'RALEIGHFAUST@GMAIL.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CHAIN REACTION'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('RALEIGHFAUST@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('RALEIGHFAUST@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Chainline Bikes', '1444 Pioneer Way #3', 'El Cajon', 'CA', 'US', '92020', 'https://www.chainlinebikes.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jason', 'Guthrie', 'jguthrie@chainline.com', '619-383-1005', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Chainline Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('jguthrie@chainline.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('jguthrie@chainline.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jason'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Guthrie'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Champion Cycling Inc', '1025 Arlington Rd N.', 'Jacksonville', 'FL', 'US', '32211', 'https://www.championcycling.net/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Phil', 'Foreman', 'championcycling1@gmail.com', '(904) 724-4922', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Champion Cycling Inc'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('championcycling1@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('championcycling1@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Phil'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Foreman'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Chelsea Bicycles', '586 32nd St', 'Union City', 'NJ', 'US', '07087', 'https://www.chelsea.bike/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Eugenio', 'Osorio', 'INFO@CHELSEA.BIKE', '(201) 325-8881', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Chelsea Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('INFO@CHELSEA.BIKE' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('INFO@CHELSEA.BIKE')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Eugenio'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Osorio'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Chuck N Roll Bikes', '1067 Avenue C', 'Bayonne', 'NJ', 'US', '07002', 'https://www.facebook.com/Chucknrollbikes/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Charlie', 'Schroth', 'chucknrollbikes@gmail.com', '(551) 358-1337', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Chuck N Roll Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('chucknrollbikes@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('chucknrollbikes@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Charlie'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Schroth'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CHUCK''S BIKES', '45 BRIDGE ST.', 'MORRISVILLE', 'VT', 'US', '05661', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'CHUCKSBIKESVT@YAHOO.COM', '407-894-3531', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CHUCK''S BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('CHUCKSBIKESVT@YAHOO.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('CHUCKSBIKESVT@YAHOO.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CITRUS PARK BIKES', '7424 DGEMERE ROAD', 'TAMPA', 'FL', 'US', '33625', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '786-636-8192', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CITRUS PARK BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('City Bike', '6915 Montgomery Blvd NE', 'Albuquerque', 'NM', 'US', '87109', 'https://www.nmsportsystems.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'David', 'Green', 'davidgreen@nmsportsystems.com', '(505) 837-9400', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'City Bike'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('davidgreen@nmsportsystems.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('davidgreen@nmsportsystems.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('David'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Green'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CITY BIKE SHOP', '747 EIGHTH ST.', 'TRAVERSE CITY', 'MI', 'US', '49686', 'https://www.citybikeshop.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Hunter', 'Gardner', 'hunter@citybikeshop.com', '231-947-1312', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CITY BIKE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('hunter@citybikeshop.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('hunter@citybikeshop.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Hunter'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Gardner'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CLEMMONS BICYCLE', '2307 LEWISVILLE CLEMMONS ROAD', 'CLEMMONS', 'NC', 'US', '27012', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '(919) 436-0527', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CLEMMONS BICYCLE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('COLLEGE CYCLES', '361 OAKLAND AVE.', 'ROCK HILL', 'SC', 'US', '29730', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '770-599-0308', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'COLLEGE CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('COMET TRAIL CYCLES', '4342 FLOYD ROAD SW', 'MABLETON', 'GA', 'US', '30126', 'https://comettrailcycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jeph', 'Burgoon', 'COMETTRAILBICYCLES@GMAIL.COM', '770-819-3279', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'COMET TRAIL CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('COMETTRAILBICYCLES@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('COMETTRAILBICYCLES@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jeph'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Burgoon'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Competitive Edge Cyclery', '1869 W Foothill Blvd. Ste 100', 'Upland', 'CA', 'US', '91786', 'https://www.compedgebikes.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Mark', 'Ceccarelli', 'compedgebikes@earthlink.net', '(909) 985-2453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Competitive Edge Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('compedgebikes@earthlink.net' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('compedgebikes@earthlink.net')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Mark'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Ceccarelli'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Comrade Cycles', NULL, 'Chicago', 'IL', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Mike', 'Okelman', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Comrade Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Mike'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Okelman'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CONTES BIKE SHOP', '2028 VIGINIA BEACH BLVD.', 'VIGINIA BEACH', 'VA', 'US', '23454', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CONTES BIKE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Conte''s Bike Shop', '228 N. Lynnhaven Rd. # 130', 'Virginia Beach', 'VA', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Gary', 'Caudill', 'g.caudill@contebikes.com', '757-491-4505', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Conte''s Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('g.caudill@contebikes.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('g.caudill@contebikes.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Gary'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Caudill'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('COOKVILLE BICYCLES', '610 W JACKSON ST.', 'COOKVILLE', 'TN', 'US', '38501', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'COOKBIKE@CITLINK.NET', '904-310-0003', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'COOKVILLE BICYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('COOKBIKE@CITLINK.NET' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('COOKBIKE@CITLINK.NET')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('COSMIC BIKES', '4641 N MILWAUKEE AVE', 'CHICAGO', 'IL', 'US', '60630', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'RONIE@COSMICBIKES.COM', '773-930-4076', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'COSMIC BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('RONIE@COSMICBIKES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('RONIE@COSMICBIKES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Cosmic Bikes Inc', NULL, 'Chicago', 'IL', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Chris', 'Stodder', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Cosmic Bikes Inc'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Chris'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Stodder'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Country Acres Bicycles', NULL, 'Millersburgh', 'OH', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Roy', 'Hershberger', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Country Acres Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Roy'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Hershberger'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('County Line Bicycle Shop', NULL, 'Millersburgh', 'IN', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'John', 'Mullett', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'County Line Bicycle Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('John'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Mullett'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('COWBELL MOBILE BIKE SHOP', '6 CRAFTS AVE', 'WEST LEBANAN', 'NH', 'US', '03784', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'COWBELL.BIKE@GMAIL.COM', '802-373-3411', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'COWBELL MOBILE BIKE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('COWBELL.BIKE@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('COWBELL.BIKE@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CRANK REVOLUTION BIKE SHOP', '1636 W ALGONQUIN ROAD', 'HOFFMAN ESTATES', 'IL', 'US', '60192', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'CRANKREVOLUTIONCYCLING@GMAIL.COM', '224-877-0064', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CRANK REVOLUTION BIKE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('CRANKREVOLUTIONCYCLING@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('CRANKREVOLUTIONCYCLING@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CRAZY BEAR BIKES', '930 N AMELIA AVE', 'SAN DIMAS', 'CA', 'US', '91773', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'XAVIER@CRAZYBEARBIKES.COM', '(626) 287-6936', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CRAZY BEAR BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('XAVIER@CRAZYBEARBIKES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('XAVIER@CRAZYBEARBIKES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Curbside Bicycles', '446A W SURF ST., APT2', 'Chicago', 'IL', 'US', '60657', 'https://www.curbsidebicycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Amber', 'Heun', 'amber@curbsidebicycles.com', '(414) 405-3851', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Curbside Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('amber@curbsidebicycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('amber@curbsidebicycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Amber'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Heun'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Curbside Bicycles LLC', '2885 Forest Down', 'Fitchburg', 'WI', 'US', '53711', 'https://www.curbsidebicycles.com/madison/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ian', 'Oestreich', 'info@curbsidebicycles.com', '(608) 571-7330', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Curbside Bicycles LLC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@curbsidebicycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@curbsidebicycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ian'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Oestreich'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CYCLE BIKYLE', '1046 LANCASTER AVE.', 'BRYN MAWR', 'PA', 'US', '19010', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'SUPPORT@BIKYLE.COM', '610-525-8442', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CYCLE BIKYLE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('SUPPORT@BIKYLE.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('SUPPORT@BIKYLE.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Cycle City', '3027 N. San Fernando Rd. #101', 'Los Angeles', 'CA', 'US', '90065', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Adam', '', 'info@cyclecitybicycles.com', '747-295-8707', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Cycle City'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@cyclecitybicycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@cyclecitybicycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Adam'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Cycle Craft', '99 US-46, Parsippany-Troy Hills', 'Parsippany', 'NJ', 'US', '07054', 'https://www.cyclecraft.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Brendan', 'Poh', 'gen_mgr@cyclecraft.com', '(973) 227-4462', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Cycle Craft'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('gen_mgr@cyclecraft.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('gen_mgr@cyclecraft.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Brendan'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Poh'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Cycle Fit Bicycles', '12794 Forest Hill Blvd', 'Wellington', 'FL', 'US', '33414', 'https://www.cyclefitstudio.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Rudy', 'Z', NULL, '561-295-3038', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Cycle Fit Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Rudy'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Z'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CYCLE LOGIC', '1211 HILLSBOROUGH ST.', 'RALEIGH', 'NC', 'US', '27603', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CYCLE LOGIC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CYCLE SURGEON', '1256 NW MAYNARD ROAD', 'CARY', 'NC', 'US', '27513', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CYCLE SURGEON'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Cycle World', '8476 SW 40 St.', 'Miami', 'FL', 'US', '33155', 'https://www.cycleworldmiami.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Owen', 'Lee', 'info@cycleworldmiami.com', '(305) 833-2839', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Cycle World'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@cycleworldmiami.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@cycleworldmiami.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Owen'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Lee'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Cycleast Bike Shop', '1619 E Cesar Chavez St.', 'Austin', 'TX', 'US', '78702', 'https://www.cycleast.com/articles/cycleast-austin-pg194.htm', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Amber', 'Brunner', 'amber@cycleast.com', '(512) 585-6398', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Cycleast Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('amber@cycleast.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('amber@cycleast.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Amber'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Brunner'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Cyclepath LLC Giant Las Vegas', '2910 S. Highland St., Suite M', 'Las Vegas', 'NV', 'US', '89109', 'https://www.giantlasvegas.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Dennie', 'Leffier', 'dennis@giantlasvegas.com', '(702) 575-5483', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Cyclepath LLC Giant Las Vegas'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('dennis@giantlasvegas.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('dennis@giantlasvegas.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Dennie'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Leffier'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Cyclepro Bicycle Service', '22762 Aspan St., #213', 'Lake Forest', 'CA', 'US', '92630', 'https://www.cyclepro.biz/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Juan', 'Martinez', 'juanroad@cycleprobz.com', '(949) 597-1100', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Cyclepro Bicycle Service'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('juanroad@cycleprobz.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('juanroad@cycleprobz.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Juan'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Martinez'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CYCLERIE', '515 Briggs St., Suite D', 'Erie', 'CO', 'US', '80516', 'https://store.cyclerie.net/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Daniel', 'Johnson', 'dj@cyclerie.net', '(720) 818-6234', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CYCLERIE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('dj@cyclerie.net' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('dj@cyclerie.net')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Daniel'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Johnson'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CYCLES DE ORO', '701-A HILL STREET', 'GREENSBORO', 'NC', 'US', '27408', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CYCLES DE ORO'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Cyclical Nature Bicycles', '4566 Cemetery Rd', 'Hilliard', 'OH', 'US', '43026', 'https://www.cyclicalnaturebicycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Andrew', 'Nelsen (or Bill Suckow)', 'andrewcnbicycles@gmail.com', '(614) 575-2453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Cyclical Nature Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('andrewcnbicycles@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('andrewcnbicycles@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Andrew'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Nelsen (or Bill Suckow)'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CYCLING FORZA', '7547 W. Sample Rd', 'CORAL SPRINGS', 'FL', 'US', '33065', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'ED@ALEXBICYCLES.COM', '803-329-2453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CYCLING FORZA'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ED@ALEXBICYCLES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ED@ALEXBICYCLES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CYCLING SOLUTIONS BICYCLE SHOP', '7766 FRUITWOOD LN', 'NEWBURGH', 'IN', 'US', '47630', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'BEN@CYCLINGSOLUTIONSMBS.COM', '821-518-2720', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CYCLING SOLUTIONS BICYCLE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BEN@CYCLINGSOLUTIONSMBS.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BEN@CYCLINGSOLUTIONSMBS.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CYCLIST CONNECTION', '200 CEMETERY RD.', 'CANAL WINCHESTER', 'OH', 'US', '43110', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '614-833-2453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CYCLIST CONNECTION'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Cyclologic - AZ', '9376 E. Bahia Dr', 'Scottsdale', 'AZ', 'US', '85260', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Paraic/Brian', '', 'cmcglynn@cyclologic.com', '480-699-5358', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Cyclologic - AZ'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('cmcglynn@cyclologic.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('cmcglynn@cyclologic.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Paraic/Brian'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('CYCOLOGY BIKES', '2408 EAST LAMAR ALEXANDER PARKWAY', 'MARYVILLE', 'TN', 'US', '37804', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'TIM@CYCOLOGYBIKES.COM; JORDAN@CYCOLOGYBIKES.COM; CWOODY@LITTLERIVERTRADINGCO.COM (PAYABLES)', '(865) 540-9979', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'CYCOLOGY BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('TIM@CYCOLOGYBIKES.COM; JORDAN@CYCOLOGYBIKES.COM; CWOODY@LITTLERIVERTRADINGCO.COM (PAYABLES)' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('TIM@CYCOLOGYBIKES.COM; JORDAN@CYCOLOGYBIKES.COM; CWOODY@LITTLERIVERTRADINGCO.COM (PAYABLES)')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Dad Sharp''s Outfitters', '153 W. Higgins Lake Drive', 'Roscommon', 'MI', 'US', '48653', 'https://www.facebook.com/DadSharps/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Heather', 'Sharpe', 'hlsharpe75@gmail.com', '989-302-2252', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Dad Sharp''s Outfitters'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('hlsharpe75@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('hlsharpe75@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Heather'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Sharpe'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('D''Aniello''s Amity Bicycles', '18 Selden St', 'Woodbridge', 'CT', 'US', '06525', 'https://www.amitybicycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Kurt', 'D''Aniello', 'amitybikes@yahoo.com', '(203) 387-6734', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'D''Aniello''s Amity Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('amitybikes@yahoo.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('amitybikes@yahoo.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Kurt'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('D''Aniello'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('DANS BICYCLE SHOP', '6715 ROOSEVELT ROAD', 'BERWYN', 'IL', 'US', '06402', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '708-484-5000', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'DANS BICYCLE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Danville Bike', '175 Hartz Ave', 'Danville', 'CA', 'US', '94526', 'https://www.danvillebikes.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Joe', 'Gutierrez', 'danvillebike@aol.com', '(925) 837-0966', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Danville Bike'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('danvillebike@aol.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('danvillebike@aol.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Joe'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Gutierrez'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Dave''s Bike Shop', '163 E. GOBBI ST.', 'Ukiah', 'CA', 'US', '95482', 'https://davesbikeshop.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'John', 'Minsinger', 'daves_bike_shop@yahoo.com', '(707) 462-3230', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Dave''s Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('daves_bike_shop@yahoo.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('daves_bike_shop@yahoo.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('John'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Minsinger'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Dave''s Road Bikes', '1238 Forrest Ave', 'Dover', 'DE', 'US', '19904', 'https://www.davesroadbikes.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'David', 'Moses', 'airwave.dave@verizon.net', '(302) 632-8448', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Dave''s Road Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('airwave.dave@verizon.net' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('airwave.dave@verizon.net')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('David'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Moses'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Diamond Cycle', '409 Bloomfield Ave', 'Montclar', 'NJ', 'US', '07042', 'https://www.diamondcycle.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Tomas', 'Corominas', 'info@diamondcycle.com', '(973) 509-0233', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Diamond Cycle'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@diamondcycle.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@diamondcycle.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Tomas'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Corominas'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('DIAMOND CYCLE', '409 BLOOMFIELD AVE.', 'MONTCLAIR', 'NJ', 'US', '07042', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'CHRIS@DIAMONDCYCLE.COM', '973-509-0233', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'DIAMOND CYCLE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('CHRIS@DIAMONDCYCLE.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('CHRIS@DIAMONDCYCLE.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Dick''s Sporting Goods', '345 Court St.', 'Corapolis', 'PA', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Dan', 'Fischer', 'TBD', '724-273-3400', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Dick''s Sporting Goods'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('TBD' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('TBD')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Dan'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Fischer'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('DL Cycles LLC', '8001 Plaza Del Laro Dr STE 101', 'Estero', 'FL', 'US', '33928-5303', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Michael', 'Scholz', 'mscholz@trekbikesflorida.com', '954-292-1492', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'DL Cycles LLC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('mscholz@trekbikesflorida.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('mscholz@trekbikesflorida.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Michael'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Scholz'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('DNA CYCLING LLC', '430 PORTER AVE', 'OCEAN SPRINGS', 'MS', 'US', '39564', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'TRIHARDSPORTS.MS@GMAIL.COM', '601-336-7625', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'DNA CYCLING LLC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('TRIHARDSPORTS.MS@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('TRIHARDSPORTS.MS@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Dover Cyclery', '12 Chestnut St', 'Dover', 'NH', 'US', '03820', 'http://dovercyclery.net/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Mitch', 'Purington', NULL, '(603) 617-3844', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Dover Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Mitch'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Purington'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('DOWNTOWN BMX', '4521 US-220', 'SUMMERFIELD', 'NC', 'US', '27358', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '727-723-2453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'DOWNTOWN BMX'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Downtown Cycles', '7 N 3rd St', 'Newark', 'OH', 'US', '43055', 'http://ohiodowntowncycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jutt', 'Wood', NULL, '(740) 281-0231', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Downtown Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jutt'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Wood'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Dublin Cyclery', '7001 Dublin Blvd', 'Dublin', 'CA', 'US', '94568', 'https://www.dublincyclery.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Danny', 'Beaman', 'dublincycles@gmail.com', '(925) 828-8676', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Dublin Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('dublincycles@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('dublincycles@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Danny'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Beaman'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('DURHAM CYCLES', '756 9TH ST.', 'DURHAM', 'NC', 'US', '27705', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'DURHAMCYCLES@GMAIL.COM', '252-480-3399', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'DURHAM CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('DURHAMCYCLES@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('DURHAMCYCLES@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('E Ryde - LA Southbay', '209 E. El Segundo Blvd', 'El Segundo', 'CA', 'US', '90245', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Blake', '', 'ErydeLA@gmail.com', '310-640-2453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'E Ryde - LA Southbay'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ErydeLA@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ErydeLA@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Blake'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('EaDo Bike Shop', '912 Saint Charles St., Suite Bike', 'Houston', 'TX', 'US', '77003', 'https://www.eadobikeco.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Desmond', 'Bitner', 'purchasing@eado.com', '(281) 826-2453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'EaDo Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('purchasing@eado.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('purchasing@eado.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Desmond'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Bitner'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('EARTH MOUNTAIN BICYCLE COMPANY', '66 EAST MAIN ST.', 'BREVARD', 'NC', 'US', '28712', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'SALES@EARTHMOUNTAINBICYCLES.COM', '502-384-0668', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'EARTH MOUNTAIN BICYCLE COMPANY'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('SALES@EARTHMOUNTAINBICYCLES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('SALES@EARTHMOUNTAINBICYCLES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('East Coast Electric Speed Shop', '203 E Franklin St Floor 2', 'Chapel Hill', 'NC', 'US', '27514', 'https://www.eastcoastelectricspeedshop.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jacob', 'Torbert', 'service.ecess@gmail.com', '(828) 656-5606', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'East Coast Electric Speed Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('service.ecess@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('service.ecess@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jacob'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Torbert'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('East Idaho Cyclery / Wallace Mountain Sports LLC', '3035 E 17th St', 'Ammon', 'ID', 'US', '83406', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Brian', 'Wallace', 'bwallace2453@gmail.com', '208-607-4871', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'East Idaho Cyclery / Wallace Mountain Sports LLC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('bwallace2453@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('bwallace2453@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Brian'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Wallace'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('EAST RIDGE BICYCLES', '5910 RINGGOLD RD', 'CHATTANOOGA', 'TN', 'US', '37412', 'https://www.eastridgebicycles.net/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'ZACH.EASTRIDGEBIKES@GMAIL.COM, eastridgebicycles83@gmail.com', '423-400-8338', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'EAST RIDGE BICYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ZACH.EASTRIDGEBIKES@GMAIL.COM, eastridgebicycles83@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ZACH.EASTRIDGEBIKES@GMAIL.COM, eastridgebicycles83@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('East Side Pedal Pushers', '4607 Bolm Rd', 'Austin', 'TX', 'US', '78749', 'https://eastsidepedalpushers.org/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Austin', '', 'eastsidepedalpushers@yahoo.com', '512-826-3414', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'East Side Pedal Pushers'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('eastsidepedalpushers@yahoo.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('eastsidepedalpushers@yahoo.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Austin'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('EASTERN SHORE BICYCLE', '6845 US-90 #102', 'DAPHNE', 'AL', 'US', '36526', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '(919) 776-2453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'EASTERN SHORE BICYCLE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('E-Bike Central - SD', '1851 San Diego Ave. #100B', 'San Diego', 'CA', 'US', '92110', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Matt', '', 'matt@ebikecentral.com', '619-564-7028', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'E-Bike Central - SD'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('matt@ebikecentral.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('matt@ebikecentral.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Matt'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Ebike Marketplace', NULL, 'Las Vegas', 'NV', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Robert', 'Raya', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Ebike Marketplace'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Robert'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Raya'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('e-bike of Colorado', '544 Front Street', 'Louisville', 'CO', 'US', '80027', 'https://ebikeofcolorado.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Nick', 'or Randi Caranci', 'contact@ebikeofcolorado.com', '720-739-0299', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'e-bike of Colorado'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('contact@ebikeofcolorado.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('contact@ebikeofcolorado.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Nick'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('or Randi Caranci'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('E-Bike Premier', '18247 Parthenia St.', 'Northridge', 'CA', 'US', '91325', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Tim', '', 'ebikes@boostmore.com', '818-684-6507', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'E-Bike Premier'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ebikes@boostmore.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ebikes@boostmore.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Tim'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('ECHELON BICYCLES & TAPROOM', '138 WEST END AVE.', 'KNOXVILLE', 'TN', 'US', '37934', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'KELLY@ECHELONBICYCLES.COM', '863-299-9907', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'ECHELON BICYCLES & TAPROOM'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('KELLY@ECHELONBICYCLES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('KELLY@ECHELONBICYCLES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Echelon Cyclery', '125 5th St', 'Santa Rosa', 'CA', 'US', '95401', 'https://www.echeloncycle.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Kevin', 'Bucholz', 'kevin@echeloncycle.com', '(707) 528-1133', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Echelon Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('kevin@echeloncycle.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('kevin@echeloncycle.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Kevin'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Bucholz'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('EINSTEIN CYCLES', '1990 US-31NORH', 'TRAVERSE CITY', 'MI', 'US', '49686', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'EINSTEIN CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('El Camino Bike Shop', '581 N Twin Oaks Valley Rd., suite E', 'San Marcos', 'CA', 'US', '92069', 'https://www.elcaminobikeshop.biz/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Will', 'Scellenger', 'info@elcaminobikeshop.com', '(760) 436-2340', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'El Camino Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@elcaminobikeshop.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@elcaminobikeshop.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Will'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Scellenger'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Electric Cyclery - South OC', 'Coast Hwy', 'Laguna Beach', 'CA', 'US', '92651', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Kevin', '', 'kevin@electriccyclery.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Electric Cyclery - South OC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('kevin@electriccyclery.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('kevin@electriccyclery.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Kevin'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Electrify Bike Co.', '8415 S 700 W #32', 'Sandy', 'UT', 'US', '84070', 'www.electrifybike.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Lex', 'Madsen', 'lex@electrifybike.com', '(925) 997-9595', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Electrify Bike Co.'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('lex@electrifybike.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('lex@electrifybike.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Lex'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Madsen'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Elite Cycling and Fitness', '13108 S. Dixie Hwy', 'Miami', 'FL', 'US', '33156', 'https://www.elitecycling.net/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Marcelo', 'Penengo', 'info@elitecycling.net', '(786) 242-3733', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Elite Cycling and Fitness'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@elitecycling.net' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@elitecycling.net')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Marcelo'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Penengo'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Endurance Cycle Service', '6440 N Business Park Loop Rd, Unit K', 'Park City', 'UT', 'US', '84098', 'https://www.endurancecycleservice.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Chris', 'Peters', 'chrispc.ecs@gmail.com', '435-658-4620', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Endurance Cycle Service'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('chrispc.ecs@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('chrispc.ecs@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Chris'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Peters'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('EPIC CYCLES', '12 SUTTONN ST.', 'BLACK MOUNTAIN', 'NC', 'US', '28711', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '843-839-4657', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'EPIC CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Erik''s Bike Shop', '2800 Lyndale Ave S Ste 1', 'MPLS', 'MN', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Cory', 'Dempster', 'coryd@eriksbikeshop.com', '952-351-9148', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Erik''s Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('coryd@eriksbikeshop.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('coryd@eriksbikeshop.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Cory'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Dempster'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Erlton Bike Shop', '1011 Marlton Pike W', 'Cherry Hill', 'NJ', 'US', '08002', 'http://www.erltonbikes.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Richard', 'Tustin', 'erltonbicycleshop@gmail.com', '(856) 428-2344', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Erlton Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('erltonbicycleshop@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('erltonbicycleshop@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Richard'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Tustin'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('EV Rideables - OC', 'Closed', NULL, NULL, 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Tony', '', 'tony@evrideabbles', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'EV Rideables - OC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('tony@evrideabbles' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('tony@evrideabbles')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Tony'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Excel Sports', '2045 32nd St', 'Boulder', 'CO', 'US', '80301', 'https://www.excelsports.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ira', 'Haimann or Adam Brown', 'ira@excelsports.com or adam@excelsports.com', '(303) 444-6737', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Excel Sports'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ira@excelsports.com or adam@excelsports.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ira@excelsports.com or adam@excelsports.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ira'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Haimann or Adam Brown'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Excite Bikes', '108 W. Main St', 'Locust', 'NC', 'US', '28097', 'https://www.excitebikes.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Charles', 'Robinson', 'excitebikesllc@gmail.com', '(704) 781-5737', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Excite Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('excitebikesllc@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('excitebikesllc@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Charles'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Robinson'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Fat Tire Cycles', '421 Montaño Rd NE', 'Albuquerque', 'NM', 'US', '87107', 'https://www.fattirecycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Erik', 'Faria', 'purchasing@fattirecycles.com', '(505) 345-9005', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Fat Tire Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('purchasing@fattirecycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('purchasing@fattirecycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Erik'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Faria'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Fenix Cycling  - OC', '23681 La Palma Ave. B', 'Yorba Linda', 'CA', 'US', '92887', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ozzy', '', 'fenixcycling@gmail.com', '714-692-2502', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Fenix Cycling  - OC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('fenixcycling@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('fenixcycling@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ozzy'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Fish Lake Bicycle', NULL, 'Lagrange', 'IL', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Mike', 'Hilty', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Fish Lake Bicycle'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Mike'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Hilty'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Flat Tire Bike Shop', '6032 E. Cave Greek Rd', 'Cave Creek', 'AZ', 'US', '85331', 'https://flattirebikes.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'John', 'Tyler III', 'info@flattirebikes.com', '(480) 488-5261', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Flat Tire Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@flattirebikes.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@flattirebikes.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('John'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Tyler III'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Fletcher Bike Studio', '2404 Taft Street', 'Houston', 'TX', 'US', '77006', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Kevin', 'Fletcher', 'kevin@fletcherbikestudio.com', '(823) 487-9650', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Fletcher Bike Studio'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('kevin@fletcherbikestudio.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('kevin@fletcherbikestudio.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Kevin'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Fletcher'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('FLINT CREEK OUTFITTERS', '14233 7TH ST.', 'DADE CITY', 'FL', 'US', '33525', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'kcomer@flintcreekoutfitters.com', '(843) 800-5330', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'FLINT CREEK OUTFITTERS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('kcomer@flintcreekoutfitters.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('kcomer@flintcreekoutfitters.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Flint Hills Mobile Bike Repair LLC', NULL, 'Manhattan', 'KS', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'David', 'Colburn', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Flint Hills Mobile Bike Repair LLC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('David'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Colburn'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('FOES FABRICATIONS', '930 AMELIA AVE', 'SAN DIMAS', 'CA', 'US', '91773', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'GBOISSE@FOESRACING.COM', '818-516-1157', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'FOES FABRICATIONS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('GBOISSE@FOESRACING.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('GBOISSE@FOESRACING.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Fort Wayne Outfitters & Bike Depot', NULL, 'Fort Wayne', 'IN', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Vince', 'Dawson or Forrest Bandor', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Fort Wayne Outfitters & Bike Depot'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Vince'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Dawson or Forrest Bandor'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Fox E-Bikes Inc', '19051 San Carlos Blvd., Unit 13', 'Fort Myers Beach', 'FL', 'US', '33931', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Sandy', 'Les Gorsuch', 'foxelectricbikes@gmail.com', '239-560-7636', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Fox E-Bikes Inc'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('foxelectricbikes@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('foxelectricbikes@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Sandy'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Les Gorsuch'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Foy''s Bike Shop', '352 W. Main St', 'Woodland', 'CA', 'US', '95695', 'https://www.foysbikeshopca.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Tim', 'Dachtler', 'foysbike@sbcglobal.net', '(530) 662-4306', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Foy''s Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('foysbike@sbcglobal.net' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('foysbike@sbcglobal.net')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Tim'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Dachtler'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('FREEHUB BICYCLES', '1616 WOODRUFF RD', 'GREENVILLE', 'SC', 'US', '29607', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'MATT@FREEHUBBICYCLES.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'FREEHUB BICYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('MATT@FREEHUBBICYCLES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('MATT@FREEHUBBICYCLES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Fresch Electrics - OC', '21206 Beach Blvd.', 'Huntington Beach', 'CA', 'US', '92648', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jay', '', 'jpickens51@verizon.net', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Fresch Electrics - OC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('jpickens51@verizon.net' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('jpickens51@verizon.net')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jay'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Fresh Bikes', 'MOBILE', 'Newprot Beach', 'CA', 'US', NULL, 'https://www.freshbikes.net/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jon', 'Christeson', 'jon@freshbikes.com', '(949) 533-4366', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Fresh Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('jon@freshbikes.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('jon@freshbikes.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jon'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Christeson'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Friendly Cycle', '1014 E 8th Ave', 'Hialeah', 'FL', 'US', '33010', 'https://www.friendlycycle.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Alejandro', 'Sanchez', 'info@friendlycycle.com', '305-967-8012', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Friendly Cycle'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@friendlycycle.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@friendlycycle.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Alejandro'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Sanchez'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Fullerton Bicycles', '424 E Commonwealth Ave', 'Fullerton', 'CA', 'US', '92832', 'https://www.fullertonbicycle.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ricardo', 'Pena', 'Ricardo@buenaparkbicycle.com', '714-879-8410', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Fullerton Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('Ricardo@buenaparkbicycle.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('Ricardo@buenaparkbicycle.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ricardo'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Pena'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Fullerton Electric Bicycle - OC', '400 E. Commonwealth Ave', 'Fullerton', 'CA', 'US', '92832', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Dave', '', 'info@feb.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Fullerton Electric Bicycle - OC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@feb.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@feb.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Dave'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Gary''s Bikes', '779 N 1890 W', 'Provo', 'UT', 'US', '84601', 'https://garysbikesutah.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Gary', 'Adamson', 'garysbikesutah@gmail.com', '(801) 900-7453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Gary''s Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('garysbikesutah@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('garysbikesutah@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Gary'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Adamson'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('GBOL LLC', '112 Allen St', 'Lansing', 'MI', 'US', '48912', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ajeet', 'Koul', 'mishiganbooks@yahoo.com', '517-410-6306', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'GBOL LLC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('mishiganbooks@yahoo.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('mishiganbooks@yahoo.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ajeet'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Koul'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Gear Monkey Bike Repair', '1910 Country Place Pkway #158', 'Pearland', 'TX', 'US', '77584', 'https://www.gearmonkey.bike/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Garner', 'Dotson', 'garner@gearmonkey.bike', '832-432-7100', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Gear Monkey Bike Repair'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('garner@gearmonkey.bike' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('garner@gearmonkey.bike')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Garner'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Dotson'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('GEARIN UP BICYCLES', '314 RANDOLPH PI NE', 'WASHINGTON', 'DC', 'US', '20002', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'DAIQUAN@GEARINUPBICYCLES.ORG', '202-780-5174+A96:A113', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'GEARIN UP BICYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('DAIQUAN@GEARINUPBICYCLES.ORG' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('DAIQUAN@GEARINUPBICYCLES.ORG')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Gears n Grinds', '85 Main St', 'Sparta', 'NJ', 'US', '07871', 'https://gearsngrinds.net/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Conno', 'Sokol', 'connor@gearsngrinds.net', '(973) 206-1674', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Gears n Grinds'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('connor@gearsngrinds.net' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('connor@gearsngrinds.net')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Conno'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Sokol'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Gemline Cycle Repair', NULL, 'Gremen', 'IN', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Galen', 'Lehman', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Gemline Cycle Repair'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Galen'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Lehman'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('GEORGIA CYCLE SPORT', '1029 BAXTER ST', 'ATHENS', 'GA', 'US', '30606', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '828-862-5111', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'GEORGIA CYCLE SPORT'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('GIANT LEWISBURG', '427 FAIRGROUND ROAD', 'LEWISBURG', 'PA', 'US', '17837', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'EARL@GIANTLEWISBURG.COM', '570-524-1249', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'GIANT LEWISBURG'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('EARL@GIANTLEWISBURG.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('EARL@GIANTLEWISBURG.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Giant of Centennial', '12201 E Arapahoe Rd B6', 'Centennial', 'CO', 'US', '80104', 'https://www.giantofcentennial.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Chris', 'Samson/Ian Latta', 'orders@Giantofcentennial.com', '(720) 750-5932', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Giant of Centennial'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('orders@Giantofcentennial.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('orders@Giantofcentennial.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Chris'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Samson/Ian Latta'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('GIANT UNIVERSITY', '8528 UNIVERSITY RD.', 'CHARLOTTE', 'NC', 'US', '28213', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'GIANT UNIVERSITY'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('GLENVIEW CYCLE', '1011 HARLEM AVE', 'GLENVIEW', 'IL', 'US', '60025', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'ALAN@GLENVIEWCYCLE.COM', '847-998-5900', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'GLENVIEW CYCLE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ALAN@GLENVIEWCYCLE.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ALAN@GLENVIEWCYCLE.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Go Green Bikes - LA Valley', 'Closed', NULL, NULL, 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Mark', '', 'mark@gogreenbikes.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Go Green Bikes - LA Valley'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('mark@gogreenbikes.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('mark@gogreenbikes.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Mark'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Godspeed Cyclery', '533 S. Western Ave #B', 'Los Angeles', 'CA', 'US', '90020', 'https://www.godspeed-cyclery.com/pages/contact', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Alex', '', 'godspeedcyclery@gmail.com', '323-793-2246', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Godspeed Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('godspeedcyclery@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('godspeedcyclery@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Alex'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Gold Star Bike Shop', NULL, 'Rodney', 'MI', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Marlin', 'Miller', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Gold Star Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Marlin'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Miller'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Golden Motor', '19231 van born Rd', 'Allen Park', 'MI', 'US', '48101', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Mujtaba', 'Merchant', 'admin@goldenmotor.ca', '407-922-6365', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Golden Motor'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('admin@goldenmotor.ca' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('admin@goldenmotor.ca')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Mujtaba'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Merchant'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Goldie''s Gears', '33 El Carmello Cir', 'Oakland', 'CA', 'US', '94619', 'https://www.goldiesgears.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Samuel', 'Goldenberg', 'goldiesgears@gmail.com', '408-471-7469', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Goldie''s Gears'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('goldiesgears@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('goldiesgears@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Samuel'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Goldenberg'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('GOODBIKE', '210 NW 10TH AVE.', 'GAINESVILLE', 'FL', 'US', '32601', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'GOODBIKE352@GMAIL.COM', '480-244-9457', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'GOODBIKE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('GOODBIKE352@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('GOODBIKE352@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Go-Ride', '2066 S 2100 E', 'Salt Lake City', 'UT', 'US', '84108', 'https://www.go-ride.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Manny', 'Nogales', 'manny@go-ride.com', '801-474-0081', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Go-Ride'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('manny@go-ride.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('manny@go-ride.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Manny'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Nogales'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Grandview Cycles', '1411 Grandview Ave', 'Columbus', 'OH', 'US', '43212', 'https://grandviewcycle.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'David', 'Baer', 'info@grandviewcycle.com', '(614) 299-8300', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Grandview Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@grandviewcycle.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@grandviewcycle.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('David'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Baer'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Green Bay Cycles', '999 Green Bay Rd #1', 'Winnetka', 'IL', 'US', '60093', 'https://www.greenbaycycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Nate', 'Perkins', 'info@greenbaycycles.com', '(847) 446-7433', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Green Bay Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@greenbaycycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@greenbaycycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Nate'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Perkins'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Green Bicycle Depot', '965 Olive Dr., Suite G', 'Davis', 'CA', 'US', '95616', 'http://greenbicycledepot.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Nelson', 'Go', 'greenbicycledepot@gmail.com', '(530) 759-6888', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Green Bicycle Depot'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('greenbicycledepot@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('greenbicycledepot@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Nelson'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Go'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('GREEN FLEET BIKES', '934 JEFFERSON ST.', 'NASHVILLE', 'TN', 'US', '37208', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '478-953-6225', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'GREEN FLEET BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Green Mountain Cyclery', '285 S Reading Rd', 'Ephrata', 'PA', 'US', '17522', 'https://www.greenmtncyclery.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Kirk', 'Hunsecker', 'mike@greenmtncyclery.com', '(717) 859-2422', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Green Mountain Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('mike@greenmtncyclery.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('mike@greenmtncyclery.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Kirk'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Hunsecker'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('GREEN RIVER CYCLERY', '[PERMANENTLY CLOSED]', 'DIXON', 'IL', 'US', '61021', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Timothy', 'Grosnick', 'BJ@GRC.BIKE', '815-622-8180', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'GREEN RIVER CYCLERY'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BJ@GRC.BIKE' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BJ@GRC.BIKE')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Timothy'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Grosnick'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('GreenRoom OC', '18093 Newhope St.', 'Fountain Valley', 'CA', 'US', '92708', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jared', '', 'Jared@greenroom-oc.com', '(714)916-0033', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'GreenRoom OC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('Jared@greenroom-oc.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('Jared@greenroom-oc.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jared'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('GREENWAY 500 BIKE SHOP', '5551 E CR 500 S', 'MEDFORD', 'IN', 'US', '47302', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'BIKEMIKE@GREENWAY500.COM', '765-744-3414', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'GREENWAY 500 BIKE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BIKEMIKE@GREENWAY500.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BIKEMIKE@GREENWAY500.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Grind and Gears', '10 Easy St', 'Carefree', 'AZ', 'US', '85377', 'https://thegrindandgears.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Don', 'Little', 'info@thegrindandgears.com', '(480) 488-7981', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Grind and Gears'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@thegrindandgears.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@thegrindandgears.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Don'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Little'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('GROWLER BIKES', '1645 LYELL AVE. SUITE 154', 'ROCHESTER', 'NY', 'US', '14606', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'BEN@GROWLERBIKES.COM', '510-524-1937', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'GROWLER BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BEN@GROWLERBIKES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BEN@GROWLERBIKES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('HALL BICYCLE COMPANY', '419 2ND AVE SE', 'CEDAR RAPIDS', 'IA', 'US', '52401', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'JOE@HALLBICYCLE.COM', '319-362-1052', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'HALL BICYCLE COMPANY'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('JOE@HALLBICYCLE.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('JOE@HALLBICYCLE.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Hammertime Pro Shop', '720 W Monument Street, Suite 100', 'Colorado Springs', 'CO', 'US', '80904', 'https://performance-united.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Andy', 'Weathers', 'weathers.andy@gmail.com', '(832) 724-4422', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Hammertime Pro Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('weathers.andy@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('weathers.andy@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Andy'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Weathers'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('HAMPTON TRAILS BIKE SHOP', '446 US-321', 'HAMPTON', 'TN', 'US', '37658', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'BRIAN@HAMPTONTRAILS.COM', '727-826-0501', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'HAMPTON TRAILS BIKE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BRIAN@HAMPTONTRAILS.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BRIAN@HAMPTONTRAILS.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Handlebar Cyclery', '24948 FM 1093, Suite 220', 'Richmond', 'TX', 'US', '77406', 'https://www.handlebarcyclery.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Stephen', 'Crew', 'stephan.crew@handlebarcyclery.com', '(832) 437-7584', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Handlebar Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('stephan.crew@handlebarcyclery.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('stephan.crew@handlebarcyclery.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Stephen'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Crew'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Handy Bikes LLC', '3800 Wheeler Ave', 'Alexandria', 'VA', 'US', '22304', 'https://www.handybikesdc.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Peter', 'Buck', 'service@handybikesdc.com', '(703) 598-7795', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Handy Bikes LLC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('service@handybikesdc.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('service@handybikesdc.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Peter'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Buck'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Hangar 15 Bicycles', '762 East 12300 South', 'Draper', 'UT', 'US', '84020', 'https://www.hangar15bicycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Mike', 'Pratt', 'mike@hanger15bicycles.com', '801-576-8844', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Hangar 15 Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('mike@hanger15bicycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('mike@hanger15bicycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Mike'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Pratt'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Harbor Bike & Beach Shop', '9828 3rd Ave', 'Stone Harbor', 'NJ', 'US', '08247', 'http://harborbike.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Michael', 'Mills', 'Info@harborbike.com', '(609) 368-3691', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Harbor Bike & Beach Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('Info@harborbike.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('Info@harborbike.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Michael'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Mills'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('HARPERS BIKE SHOP', '118 S NORTHSHORE DR.', 'KNOXVILLE', 'TN', 'US', '37919', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'shawnatharpers@gmail.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'HARPERS BIKE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('shawnatharpers@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('shawnatharpers@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Hart''s Cyclery', '7 NJ-31', 'Pennington', 'NJ', 'US', '08534', 'https://www.hartscyclery.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ross', 'Hart', NULL, '(609) 737-3008', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Hart''s Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ross'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Hart'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('HAVASU BIKE & FITNESS', '151 SWANSON AVENUE', 'LAKE HAVASU CITY', 'AZ', 'US', '86403', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'HAVASUBIKE@NPGCABLE.COM', '805-794-0284', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'HAVASU BIKE & FITNESS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('HAVASUBIKE@NPGCABLE.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('HAVASUBIKE@NPGCABLE.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('HB CYCLES', '19729 BEACH BLVD', 'HUNTINGTON BEACH', 'CA', 'US', '92648', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '760-438-8888', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'HB CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('HB Velo Cyclery', '21032 Brookhurst St', 'Huntington Beach', 'CA', 'US', '92646', 'https://hbvelocyclery.net/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Candy', 'Lopez', 'candy@hbvelocyclery.net', '(714) 587-9043', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'HB Velo Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('candy@hbvelocyclery.net' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('candy@hbvelocyclery.net')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Candy'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Lopez'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Helen''s Cycles', '2501 Broadway', 'Santa Monica', 'CA', 'US', '90404', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Adam', '', 'adam@helenscycles.com', '(310)321-5290', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Helen''s Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('adam@helenscycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('adam@helenscycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Adam'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Helfrich Bicycles', '102 Farmhouse Ln', 'Mountville', 'PA', 'US', '17554', 'https://helfrichbicycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Scott', 'Helfrich', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Helfrich Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Scott'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Helfrich'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Hermosa Cyclery', '20 13th St', 'Hermosa Beach', 'CA', 'US', '90254', 'https://www.hermosacyclery.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ken', 'Liebowitz', 'info@hermosacyclery.com', '(310) 374-7816', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Hermosa Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@hermosacyclery.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@hermosacyclery.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ken'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Liebowitz'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Hershey Cycles', '101 W Granada Ave', 'Hershey', 'PA', 'US', '17033', 'https://www.hersheycycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Tony', 'Stagliano', 'tstagliano@HersheyCyles.com', '(717) 500-3626', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Hershey Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('tstagliano@HersheyCyles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('tstagliano@HersheyCyles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Tony'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Stagliano'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Hi Torque Media Group', '25233 Anza Dr', 'Valencia', 'CA', 'US', '91355', 'www.hi-torque.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Derreck', 'Bernard', 'derreck@hi-torque.com', '(661) 609-8309', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Hi Torque Media Group'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('derreck@hi-torque.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('derreck@hi-torque.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Derreck'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Bernard'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('HIGH GEAR SPORTS', '1171 US 31 NORTH, STE# A', 'PETOSKEY', 'MI', 'US', '49770', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'MAIL@HIGHGEARSPORTS.COM', '231-347-6118', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'HIGH GEAR SPORTS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('MAIL@HIGHGEARSPORTS.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('MAIL@HIGHGEARSPORTS.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('High Peaks Cyclery', '2733 Main St', 'Lake Placid', 'NY', 'US', '12946', 'https://www.highpeakscyclery.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Matt', 'Delaney', 'brian@highpeakscyclery.com', '(518) 523-3764', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'High Peaks Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('brian@highpeakscyclery.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('brian@highpeakscyclery.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Matt'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Delaney'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('HIGHER GROUND BIKES', '1410 MARKET ST.,SUITE#A-1', 'TALLAHASSEE', 'FL', 'US', '32312', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'HGBIKES@GMAIL.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'HIGHER GROUND BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('HGBIKES@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('HGBIKES@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('HOBBIES CYCLES', '1202 W WASHINGTON ST', 'SANDUSKY', 'OH', 'US', '44870', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '419-625-4242', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'HOBBIES CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Hometown Bicycles LLC', '10595 Grand River', 'Brighton', 'MI', 'US', '48116', 'https://myhometownbicycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Shaun', 'Bhajan', 'shaun@myhometownbicycles.com', '(810) 225-2441', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Hometown Bicycles LLC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('shaun@myhometownbicycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('shaun@myhometownbicycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Shaun'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Bhajan'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Hornings Bike Shop', '941 Martindale Rd', 'Ephrata', 'PA', 'US', '17522', 'https://justplainbusiness.com/hornings-bike-shop/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Clair', 'Horning', NULL, '(717) 445-4305', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Hornings Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Clair'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Horning'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Hostel Shoppe', '3201 John Joanis Drive', 'Stevens Point', 'WI', 'US', '54482', 'https://hostelshoppe.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Scott', 'Cole', 'scott@hostelshoppe.com', '(715) 341-4340 ext 301', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Hostel Shoppe'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('scott@hostelshoppe.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('scott@hostelshoppe.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Scott'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Cole'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Houston Bicycle Co', '404 1/2 Westheimer', 'Houston', 'TX', 'US', '77006', 'http://houstonbicyclecompany.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jeffrey', 'Gielo', 'jeffreyagielow@gmail.com', '(713) 522-4622', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Houston Bicycle Co'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('jeffreyagielow@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('jeffreyagielow@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jeffrey'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Gielo'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('HURRICANE CYCLES', '138 NORTH MAIN STREET', 'CROSSVILLE', 'TN', 'US', '38555', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'HURRICANECYCLES@ICLOUD.COM', '717-252-1509', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'HURRICANE CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('HURRICANECYCLES@ICLOUD.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('HURRICANECYCLES@ICLOUD.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('I Cycle Bike Shop', '4721 Watonga Blvd', 'Houston', 'TX', 'US', '77092', 'https://www.icycletexas.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Matt', 'Worth', 'matt@icyclebikeshop.com', '(713) 862-8520', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'I Cycle Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('matt@icyclebikeshop.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('matt@icyclebikeshop.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Matt'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Worth'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Imaginary Bikeworks', '108-B Mohawk Dr', 'Greenville', 'SC', 'US', '29609', 'https://www.imaginarybikeworks.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Josh', 'Squier', 'ImaginaryBikeWorks@gmail.com', '846-581-2068', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Imaginary Bikeworks'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ImaginaryBikeWorks@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ImaginaryBikeWorks@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Josh'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Squier'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('INCYCLE BICYCLES WHS', '133 S EUCLA AVE', 'SAN DIMAS', 'CA', 'US', '91773', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'KATHRYN@INCYCLE.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'INCYCLE BICYCLES WHS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('KATHRYN@INCYCLE.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('KATHRYN@INCYCLE.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Incycle San Dimas', '501 E Arrow Hwy', 'San Dimas', 'CA', 'US', '91773', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Kevin,', 'Jacob, Jesse', 'Kevin.Miller@specialized.com', '(909)592-2181 cell', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Incycle San Dimas'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('Kevin.Miller@specialized.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('Kevin.Miller@specialized.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Kevin,'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Jacob, Jesse'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('INDIAN CYCLE FITNESS & OUTDOOR', '677 PEAR ORCHARD RD.', 'RIDGELAND', 'MS', 'US', '39157', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'FITNESS@INDIANCYCLEFITNESS.COM', '865-240-3499', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'INDIAN CYCLE FITNESS & OUTDOOR'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('FITNESS@INDIANCYCLEFITNESS.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('FITNESS@INDIANCYCLEFITNESS.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Irvine Bicyles', '6604 Irvine Center Drive', 'Irvine', 'CA', 'US', '92618', 'https://www.irvinebicycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Frank', '', 'sales@irvinebicycles.com', '(949) 453 9999', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Irvine Bicyles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('sales@irvinebicycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('sales@irvinebicycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Frank'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Irwin Cycles - Vegas', NULL, NULL, NULL, 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Lifan/Carl', '', 'lifan@irwincycles.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Irwin Cycles - Vegas'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('lifan@irwincycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('lifan@irwincycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Lifan/Carl'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Island Bike Shop', '1095 Bald Eagle Drive', 'Marco Island', 'FL', 'US', '34145', 'https://islandbikeshops.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Matt', 'Walthour', 'marco@islandbikeshops.com', '239-394-8400', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Island Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('marco@islandbikeshops.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('marco@islandbikeshops.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Matt'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Walthour'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Isle Bicycles', '3500 Boardwalk Ste 23&24', 'Sea Isle City', 'NJ', 'US', '08243', 'https://islebicycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Andrew', 'Scrivani', 'info@islebicycles.com', '(609) 515-2100', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Isle Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@islebicycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@islebicycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Andrew'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Scrivani'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('J&R BICYCLES', '7000 BRYAN DAIRY RD, UNIT B1', 'LARGO', 'FL', 'US', '33777', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Kirk', 'Morrigan', 'KIRK@JRBICYCLES.COM', '859-913-7331', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'J&R BICYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('KIRK@JRBICYCLES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('KIRK@JRBICYCLES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Kirk'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Morrigan'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('J&R Cycle & Ski', NULL, 'Vela Park', 'IL', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Bob', 'Pecora', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'J&R Cycle & Ski'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Bob'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Pecora'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Jason''s Bikes', '435 Linden Rd', 'Mertztown', 'PA', 'US', '19539', 'https://justplainbusiness.com/jasons-bikes/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Irvin', 'Brubacher', NULL, '(610) 641-0183', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Jason''s Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Irvin'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Brubacher'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Jax Bicycle Center - OC South', '14210 Culver Dr.', 'Irvine', 'CA', 'US', '92604', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Pat', '', 'pat@jaxbiccycecenter.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Jax Bicycle Center - OC South'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('pat@jaxbiccycecenter.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('pat@jaxbiccycecenter.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Pat'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('JB BIKE SHOP', '7430 Collins Ave', 'Miami Beach', 'FL', 'US', '33141', 'https://jbbikeshop.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Samuel', 'Perl', 'info@jbbikeshop.com', '305-866-3622', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'JB BIKE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@jbbikeshop.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@jbbikeshop.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Samuel'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Perl'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('JBL Group, Inc. / The Bike Hangar', '2403 SE Dixie Hwy', 'Stuart', 'FL', 'US', '34996', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Julie', 'Liles', 'julie@thebikehangar.bike; bryan@thebikehangar.bike', '772-888-3195', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'JBL Group, Inc. / The Bike Hangar'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('julie@thebikehangar.bike; bryan@thebikehangar.bike' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('julie@thebikehangar.bike; bryan@thebikehangar.bike')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Julie'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Liles'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('JC''s Bike Shop (JC''s Bikes and Boards)', '345 S Woodland BLVD', 'Deland', 'FL', 'US', '32724', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ryan', 'Flash', 'jcsbikesandboards@yahoo.com', '(386) 736-3620', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'JC''s Bike Shop (JC''s Bikes and Boards)'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('jcsbikesandboards@yahoo.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('jcsbikesandboards@yahoo.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ryan'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Flash'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('JED''S PERFECT ENDURANCE', '37 KING ROAD', 'HATTIESBURG', 'MS', 'US', '39402', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'DEBDARBY7@GMAIL.COM', '828-466-0624', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'JED''S PERFECT ENDURANCE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('DEBDARBY7@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('DEBDARBY7@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Jibe Cycleworks', '1388 S 300 W, Unit 700', 'Salt Lake City', 'UT', 'US', '84115', 'https://www.jibebike.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jason', 'Halverson', 'jasonh@filltheflow.com', '385-481-0412', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Jibe Cycleworks'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('jasonh@filltheflow.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('jasonh@filltheflow.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jason'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Halverson'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('JOE FIX ITS', '20 MAIN ST', 'GOSHEN', 'NY', 'US', '10924', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'INFO@JOEFIXITS.COM', '645-294-7242', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'JOE FIX ITS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('INFO@JOEFIXITS.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('INFO@JOEFIXITS.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Jonny Rock Bikes', '8890 Excelsior Blvd', 'Hopkins', 'MN', 'US', '55343', 'https://www.jonnyrockbikes.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jonathan', 'Minks', 'jonnyrockbikes@gmail.com, jonnyrockbikesteam@gmail.com', '(952) 594-5333', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Jonny Rock Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('jonnyrockbikes@gmail.com, jonnyrockbikesteam@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('jonnyrockbikes@gmail.com, jonnyrockbikesteam@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jonathan'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Minks'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('JP PARTLAND (WRITER)', '370 SAINT NICHOLAS AVE, 4B', 'NEW YORK', 'NY', 'US', '10027', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'MUGWUMP@PARTLAND.NET', '212-316-1582', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'JP PARTLAND (WRITER)'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('MUGWUMP@PARTLAND.NET' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('MUGWUMP@PARTLAND.NET')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('JP''s Bike Shop', '423 S. State College Blvd', 'Anaheim', 'CA', 'US', '92806', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Juan', 'Pablo Tovar', 'jpsbikeshop2025@gmail.com', '714-926-8994', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'JP''s Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('jpsbikeshop2025@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('jpsbikeshop2025@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Juan'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Pablo Tovar'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Juiced Wheels', '221 Spencer Rd STE N', 'St Peters', 'MO', 'US', '63376', 'https://www.juicedwheels.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Brett', 'Bartrum', 'hello@juicedwheels.com', '(636) 373-8135', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Juiced Wheels'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('hello@juicedwheels.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('hello@juicedwheels.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Brett'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Bartrum'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Junction Bike Co (Junction Bicycle)', '10908 E Apache Trail', 'Apache Junction', 'AZ', 'US', '85120', 'https://junctionbikecompany.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jared', 'Anderson', 'info@junctionbikecompany.com', '(480) 380-0811', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Junction Bike Co (Junction Bicycle)'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@junctionbikecompany.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@junctionbikecompany.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jared'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Anderson'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('JUST RIDE LA', '1626 HILL ST', 'LOS ANGELES', 'CA', 'US', '90015', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Danny', '', 'info@justridela.com', '(213) 745-6783', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'JUST RIDE LA'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@justridela.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@justridela.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Danny'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('KCAZ Power Sports', '1035 N McQueen Rd', 'Gilbert', 'AZ', 'US', '85233', 'https://www.kcazpowersports.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Blake', 'Chiles', 'info@kcazpowersports.com', '(480) 287-4858', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'KCAZ Power Sports'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@kcazpowersports.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@kcazpowersports.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Blake'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Chiles'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('KENT INTERNATIONAL', '60 E HALSEY ROAD', 'PARSIPANNY', 'NJ', 'US', '07054', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'RBARBAGALLO@KENT.BIKE', '973-434-8181 EXT: 209', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'KENT INTERNATIONAL'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('RBARBAGALLO@KENT.BIKE' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('RBARBAGALLO@KENT.BIKE')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('KEVIN''S BIKE', '2820 G ST.', 'MERCED', 'CA', 'US', '95340', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'KEVINSBIKES@COMCAST.NET', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'KEVIN''S BIKE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('KEVINSBIKES@COMCAST.NET' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('KEVINSBIKES@COMCAST.NET')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Kike  Bike Shop - LA', '1916 W. 7th St.', 'Los Angeles', 'CA', 'US', '90057', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Terry/Jesus', '', 'terrybkshop@hotmail.com', '213-413-0178', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Kike  Bike Shop - LA'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('terrybkshop@hotmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('terrybkshop@hotmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Terry/Jesus'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('KIM''S BIKE SHOP', '111 FRENCH ST.', 'NEW BRUNSWICK', 'NJ', 'US', '08901', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'KIM''SBIKESHOP@GMAIL.COM', '732-846-3880', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'KIM''S BIKE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('KIM''SBIKESHOP@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('KIM''SBIKESHOP@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('KINETIC SYSTEMS', '60 S MAIN', 'CLARKSTON', 'MI', 'US', '48346', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'KINETIC SYSTEMS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('King Kog', '327 17th St', 'Oakland', 'CA', 'US', '94612', 'https://kingkog.bigcartel.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Siam', '', 'flymaestro@gmail.com', '510-858-7514', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'King Kog'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('flymaestro@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('flymaestro@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Siam'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('KNOXVILLE BICYCLE COMPANY', '10657 HARDIN VALLEY ROAD', 'KNOXVILLE', 'TN', 'US', '37932', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'MYRON@KNOXVILLEBICYCLECOMPANY.COM', '706-363-0291', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'KNOXVILLE BICYCLE COMPANY'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('MYRON@KNOXVILLEBICYCLECOMPANY.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('MYRON@KNOXVILLEBICYCLECOMPANY.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('La Cicla', '14428 Ventura Blvd', 'Sherman Oaks', 'CA', 'US', '91423', 'https://laciclabicycleshop.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Lucy', 'or Jaime', 'ciclabikeshop@gmail.com', '747-217-4388', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'La Cicla'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ciclabikeshop@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ciclabikeshop@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Lucy'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('or Jaime'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('LA DOLCE VELO', '1280 THE ALAMEDA', 'SAN JOSE', 'CA', 'US', '95126', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'ROB@LADOLCEVELO.COM', '408-244-8356', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'LA DOLCE VELO'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ROB@LADOLCEVELO.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ROB@LADOLCEVELO.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('LA E-Bikes - South Central LA', '2218 E 92nd St', 'Los Angeles', 'CA', 'US', '90002', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Nator', '', 'sales@laebikes.com', '323-537-4336', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'LA E-Bikes - South Central LA'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('sales@laebikes.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('sales@laebikes.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Nator'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('LA Fly Rides - LA', 'Closed', NULL, NULL, 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ike', '', 'ike@flyrides.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'LA Fly Rides - LA'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ike@flyrides.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ike@flyrides.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ike'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Lake Breeze Bicycle', '10707 Millers Rd #9742', 'Lyndonville', 'NY', 'US', '14098', 'https://lake-breeze-bicycle.business.site/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Conrad', 'Miller', NULL, '(585) 735-5970', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Lake Breeze Bicycle'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Conrad'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Miller'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Lake Town Bicycles', '1403 W 9000 S', 'West Jordan', 'UT', 'US', '84088', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Will', 'Ridd', 'willridd@yahoo.com', '801-432-2995', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Lake Town Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('willridd@yahoo.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('willridd@yahoo.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Will'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Ridd'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('LAKESHORE BIKE', '505 LAKESHORE BLVD.', 'MARQUETTE', 'MI', 'US', '49855', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'LAKESHORE BIKE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('LAKESHORE CYCLERY AND FITNESS INC.', '1523 E LAKESHORE DR', 'STORM LAKE', 'IA', 'US', '50588', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'LAKESHORECYCLERY@YAHOO.COM', '712-732-4115', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'LAKESHORE CYCLERY AND FITNESS INC.'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('LAKESHORECYCLERY@YAHOO.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('LAKESHORECYCLERY@YAHOO.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Lakeside Bicycle', NULL, 'Wolcottville', 'IN', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Maynard', 'Miller', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Lakeside Bicycle'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Maynard'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Miller'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Las Vegas Cyclery - Vegas', '10575 Discovery Dr', 'Las Vegas', 'NV', 'US', '89135', 'https://www.lasvegascyclery.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Kurt,', 'Jen', 'shopguy@lasvegascyclery.com, jen@lasvegascyclery.com', '702-596-2953', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Las Vegas Cyclery - Vegas'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('shopguy@lasvegascyclery.com, jen@lasvegascyclery.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('shopguy@lasvegascyclery.com, jen@lasvegascyclery.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Kurt,'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Jen'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('LC Tri Shop', '1909 S Dixie Hwy', 'West Palm Beach', 'FL', 'US', '33401', 'https://www.lctrishop.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Leo', 'Contreras', 'lctrishop@gmail.com', '561-249-1333', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'LC Tri Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('lctrishop@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('lctrishop@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Leo'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contreras'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('LEOS MOBILE BICYCLE SERVICE', '10 Roosevelt Rd', 'VALPARAISO', 'IN', 'US', '46383', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'INFO@LEOSMOBILE.COM', '219-246-2504', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'LEOS MOBILE BICYCLE SERVICE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('INFO@LEOSMOBILE.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('INFO@LEOSMOBILE.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Let''s Ride Cyclery', '1038 N Hollywood Way', 'Burbank', 'CA', 'US', '91505', 'https://www.letsridecyclery.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Mike', 'Kalenda', 'mike@letsridecyclery.com', '(818) 848-8330', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Let''s Ride Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('mike@letsridecyclery.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('mike@letsridecyclery.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Mike'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Kalenda'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('LEUCADIA CYCLERY', '923 VULCAN AVE', 'ENCINITAS', 'CA', 'US', '92024', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '(949) 338-7013', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'LEUCADIA CYCLERY'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Lifestyle Cycle', NULL, 'Libertyville', 'IL', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Fred', 'Kuehn', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Lifestyle Cycle'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Fred'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Kuehn'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('LIGHTNING CYCLES', '575 10TH ST. BLVD. NW', 'HICKORY', 'NC', 'US', '28601', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'LIGHTNINGCYCLESNC@GMAIL.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'LIGHTNING CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('LIGHTNINGCYCLESNC@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('LIGHTNINGCYCLESNC@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('LOCAL MOTION CYCLERY', '701 EAST MAPLE STREET', 'JOHNSON CITY', 'TN', 'US', '37601', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'LOCALMOTIONCYCLERY@GMAIL.COM', '850-224-7461', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'LOCAL MOTION CYCLERY'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('LOCALMOTIONCYCLERY@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('LOCALMOTIONCYCLERY@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('LOUI''S BIKES', '14580 TAMIAMI TRAIL, UNIT C', 'VENICE', 'FL', 'US', '34287', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '205-967-2003', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'LOUI''S BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('MACKINAC WHEELS', '6929 Main St', 'MACKINAC ISLAND', 'MI', 'US', '49757', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '517-575-8585', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'MACKINAC WHEELS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Main Steet Bicycle Co.', '201 E. Main Ave', 'Zeeland', 'MI', 'US', '49464', 'https://www.mainstreetbicycleco.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Aaron', 'Schutter', 'mainstreetbicycleco@gmail.com', '(616) 772-6223', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Main Steet Bicycle Co.'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('mainstreetbicycleco@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('mainstreetbicycleco@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Aaron'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Schutter'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('MANSFIELD GROUP', NULL, NULL, NULL, 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'MANSFIELD GROUP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Marin Service Course', '85 Bolinas Rd, #6', 'Fairfax', 'CA', 'US', '94930', 'https://marinservicecourse.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Peter', 'Lucas', 'peter@marinservicecourse.com', '(415) 307-3488', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Marin Service Course'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('peter@marinservicecourse.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('peter@marinservicecourse.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Peter'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Lucas'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('MARTINS BICYCLE', '4762 STATE ROAD 14A', 'DUNDEE', 'NY', 'US', '14837', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '607-243-7150', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'MARTINS BICYCLE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Martin''s Bicycle', '4762 NY-14A', 'Dundee', 'NY', 'US', '14837', 'https://www.martinsbicycleny.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Edward', 'Martin', 'martinsbicycle@gmail.com', '(607) 243-7150', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Martin''s Bicycle'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('martinsbicycle@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('martinsbicycle@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Edward'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Martin'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Marty''e Reliable Cycle', '173 Speedwell Ave', 'Morristown', 'NJ', 'US', '07960', 'https://www.martysreliable.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Adam', 'Augenzucker', 'jimmy@martysreliable.com', '(973) 538-7773', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Marty''e Reliable Cycle'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('jimmy@martysreliable.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('jimmy@martysreliable.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Adam'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Augenzucker'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Marty''s Cycle Center', '453 Avon Belden Rd.', 'Avon Lake', 'OH', 'US', '44012', 'https://www.martyscycle.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Marty', '', '68p1800s@gmail.com', '440-933-4204', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Marty''s Cycle Center'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('68p1800s@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('68p1800s@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Marty'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('MARTY''S RELIABLE MORRISTOWN', '173 SPEEDWELL AVE.', 'MORRISTOWN', 'NJ', 'US', '07960', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '973-538-7773', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'MARTY''S RELIABLE MORRISTOWN'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('MARTY''S RELIABLE RANDOLPH', '1164 STATE ROUTE 10 WEST', 'DOVER', 'NJ', 'US', '07869', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'MARTY''S RELIABLE RANDOLPH'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Matthew''s Bike Mart (Matthew''s Bikes)', '7272 Pendleton Pike', 'Indianapolis', 'IN', 'US', '46226', 'https://matthewsbikes.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Nancy', 'Parent', 'nparent@matthewsbikes.com', '(317) 547-3456', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Matthew''s Bike Mart (Matthew''s Bikes)'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('nparent@matthewsbikes.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('nparent@matthewsbikes.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Nancy'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Parent'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Merlyn Mechanics', NULL, 'Alexandria', 'VA', 'US', '22314', 'http://merlynmechanics.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'merlyn', 'Townley', 'merlyn@merlynmechanics.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Merlyn Mechanics'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('merlyn@merlynmechanics.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('merlyn@merlynmechanics.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('merlyn'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Townley'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Merv''s Bike Shop', '300 Fire House Rd', 'Shippensburg', 'PA', 'US', '17257', 'https://www.facebook.com/pages/Mervs-Bike-Shop/162646200421967', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Sylvan', 'Martin; Ervin Burkholder', NULL, '(717) 776-4177', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Merv''s Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Sylvan'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Martin; Ervin Burkholder'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Metropolis Bikes - LA Valley', '4660 Lanh=kershim Blvd', 'North Hollywood', 'CA', 'US', '91602', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Brad', '', 'sales@metropolisbikes.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Metropolis Bikes - LA Valley'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('sales@metropolisbikes.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('sales@metropolisbikes.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Brad'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('METROPOLIS CYCLES', '2117 MICHIGAN AVE', 'DETROIT', 'MI', 'US', '48216', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '313-818-3248', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'METROPOLIS CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Miami Beach Bicycle Center', '746 5th St', 'Miami Beach', 'FL', 'US', '33139', 'https://www.bikemiamibeach.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Alex', 'Buiz', 'alex@bikemiamibeach.com', '305-674-0150', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Miami Beach Bicycle Center'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('alex@bikemiamibeach.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('alex@bikemiamibeach.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Alex'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Buiz'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('MICHAEL''S BICYCLES', '2253 MICHAEL DRIVE', 'NEWBURY PARK', 'CA', 'US', '91320', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'MICHAELSBICYCLES@AOL.COM', '805-498-6633', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'MICHAEL''S BICYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('MICHAELSBICYCLES@AOL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('MICHAELSBICYCLES@AOL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Michael''s Bicycles', '2257 Michael Dr', 'Newbury Park', 'CA', 'US', '91320', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Mike', '', 'info@michaelsbicycles.com', '805-498-6633', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Michael''s Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@michaelsbicycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@michaelsbicycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Mike'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('MIDDLE OF TOWN CYCLING', '2140 GARDINER LANE', 'LOUISVILLE', 'KY', 'US', '40205', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'INFO@MIDDLEOFTOWNCYCLING.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'MIDDLE OF TOWN CYCLING'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('INFO@MIDDLEOFTOWNCYCLING.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('INFO@MIDDLEOFTOWNCYCLING.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('MIKE''S HIKE & BIKE', '309 WMAIN ST', 'RICHMOND', 'KY', 'US', '40475', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'MIKE@MIKESHIKEANDBIKE.COM', '850-942-2453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'MIKE''S HIKE & BIKE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('MIKE@MIKESHIKEANDBIKE.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('MIKE@MIKESHIKEANDBIKE.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Millersburg Bike Shop', NULL, 'Millersburg', 'PA', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Marlin', 'Yoder', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Millersburg Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Marlin'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Yoder'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('MISSION CYCLES', '1125 E EIGHTH ST.', 'TRAVERSE CITY', 'MI', 'US', '49686', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'SALES@MISSIONCYCLES.COM', '231-421-4923', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'MISSION CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('SALES@MISSIONCYCLES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('SALES@MISSIONCYCLES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('MOAB BICYCLE SHOP', '710 MEMORIAL BLVD.', 'MURFREESBORO', 'TN', 'US', '37129', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'BIKER''SCHOICESTAFFTN@GMAIL.COM', '706-355-3989', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'MOAB BICYCLE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BIKER''SCHOICESTAFFTN@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BIKER''SCHOICESTAFFTN@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Mobile Bike Repair', NULL, 'Three Rivers', 'MI', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Diane', 'Ruggles', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Mobile Bike Repair'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Diane'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Ruggles'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('MONTGOMERY CYCLERY', '8975 CINCINNATTI-COLUMBUS RD', 'WEST CHESTER', 'OH', 'US', '45069', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'JEFF', '513-520-8884', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'MONTGOMERY CYCLERY'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('JEFF' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('JEFF')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('MONTGOMERY MULTISPORT', '8107 VAUGHN ROAD', 'MONTGOMERY', 'AL', 'US', '36116', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '865-200-8710', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'MONTGOMERY MULTISPORT'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('MOORE AND SONS', '2-1431 E CLIFF DRIVE', 'SANTA CRUZ', 'CA', 'US', '95062', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'MOORE AND SONS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('MOOSEJAW', '32200 N. AVIS, STE 100', 'MADISON HEIGHTS', 'MI', 'US', '48071', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'MOOSEJAW'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('MOTION MAKERS', '878 BREVARD RD.', 'ASHEVILLE', 'NC', 'US', '28806', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '214-370-9010', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'MOTION MAKERS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('MOTORLESS MOTION', '121 S MAIN ST.', 'MOUNT PLEASANT', 'MI', 'US', '48858', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '989-772-2008', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'MOTORLESS MOTION'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Mountain Road Cycles', NULL, 'Chagrin Falls', 'OH', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jon', 'Loparo', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Mountain Road Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jon'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Loparo'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('MOVATIK', '6701 NW 7th Street, SUITE 140', 'MIAMI', 'FL', 'US', '33126', 'https://movatik.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Joaquin', 'Gascue', 'sales@movatik.com', '833-668-2845', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'MOVATIK'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('sales@movatik.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('sales@movatik.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Joaquin'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Gascue'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Mr. B''s Bicycles', '1870 4th Ave', 'Yuma', 'AZ', 'US', '85364', 'www.mrbsbicycles.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Donnie', 'Bennett', 'donnie@mrbsbicycles.com', '(928) 783-2916', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Mr. B''s Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('donnie@mrbsbicycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('donnie@mrbsbicycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Donnie'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Bennett'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('N + 1 Cyclery', '57 Waverly St', 'Framingham', 'MA', 'US', '01702', 'https://www.nplusonecyclery.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Francisco', 'Cornelio', 'info@nplusonecyclery.com', '(508) 620-6600', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'N + 1 Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@nplusonecyclery.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@nplusonecyclery.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Francisco'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Cornelio'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('N+1 BIKES', '1201 HERRLANE, STE#115', 'LOUISVILLE', 'KY', 'US', '40222', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'SHANN@N1BIKE.COM', '931 250 7224', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'N+1 BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('SHANN@N1BIKE.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('SHANN@N1BIKE.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Napa River Velo', '1721 Action Ave, Suite B', 'Napa', 'CA', 'US', '94559', 'https://www.facebook.com/naparivervelo/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Duke', 'Tuchman', 'duke@naparivervelo.com', '(707) 258-8759', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Napa River Velo'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('duke@naparivervelo.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('duke@naparivervelo.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Duke'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Tuchman'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('NEC Bikes N Music', NULL, 'Streamwood', 'IL', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ryan', 'Gable', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'NEC Bikes N Music'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ryan'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Gable'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Never Ending Cycles', '1060 E Schaumburg Rd', 'Streamwood', 'IL', 'US', '60107', 'https://www.neverendingcyclesshop.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jesse', 'Olivares; Mike Geigel', 'info@neverendingcyclesshop.com', '(630) 882-0822', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Never Ending Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@neverendingcyclesshop.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@neverendingcyclesshop.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jesse'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Olivares; Mike Geigel'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Newark Sport Center', '2 Park Pl 2nd Floor,', 'Newark', 'NJ', 'US', '07102', 'https://www.newarkccc.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Derrick', 'Washington', 'bikenewarknj@gmail.com', '(201) 431-6237', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Newark Sport Center'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('bikenewarknj@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('bikenewarknj@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Derrick'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Washington'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Newbury Park Bike Shop - LA North', '1602 Newbury Rd.', 'Newbury Park', 'CA', 'US', '91320', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Carly', '', 'sales@npbikeshop.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Newbury Park Bike Shop - LA North'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('sales@npbikeshop.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('sales@npbikeshop.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Carly'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Newtown Bicycle Shop', '30 N. State St.', 'Newtown', 'PA', 'US', '18940', 'https://www.newtownbike.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Harry', 'Betza', 'info@newtownbike.com', '(215) 968-3200', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Newtown Bicycle Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@newtownbike.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@newtownbike.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Harry'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Betza'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Next Adventure Bikes', '1332 Hermosa Ave.', 'Hermosa Beach', 'CA', 'US', '90254', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Travis', '', 'info@nextadventureebikes.com', '323-673-5222', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Next Adventure Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@nextadventureebikes.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@nextadventureebikes.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Travis'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Nice Bike', '4314 South Broadway', 'Englewood', 'CO', 'US', '80113', 'https://ridenicebike.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'David', '', 'information@ridenicebike.com', '720-242-6455', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Nice Bike'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('information@ridenicebike.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('information@ridenicebike.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('David'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('NORRIS BICYCLES', '1412 KNOB CREEK RD.', 'JOHNSON CITY', 'TN', 'US', '37604', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '704-786-2453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'NORRIS BICYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('NORTHBOUND OUTFITTERS', '6041 WEST M72 HIGHWAY', 'GRAYLING', 'MI', 'US', '49738', 'https://www.northboundoutfittersmi.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jorden', 'Wakeley', 'northboundoutfitters@gmail.com', '989-348-8558', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'NORTHBOUND OUTFITTERS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('northboundoutfitters@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('northboundoutfitters@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jorden'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Wakeley'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Northtowne Cycling & Fitness', NULL, 'Cedar Rapids', 'IA', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Mike', 'Murray', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Northtowne Cycling & Fitness'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Mike'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Murray'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('OAK CITY CYCLING', '706 E JONES ST', 'RALEIGH', 'NC', 'US', '27604', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'SQUIRRELY@OAKCITYCYCLING.COM', '404-892-3400', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'OAK CITY CYCLING'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('SQUIRRELY@OAKCITYCYCLING.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('SQUIRRELY@OAKCITYCYCLING.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('OCALA BICYCLE CENTER', '2801 SW 20TH ST. STE#203', 'OCALA', 'FL', 'US', '34474', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'OCALABICYCLES@GMAIL.COM', '205-879-3244', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'OCALA BICYCLE CENTER'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('OCALABICYCLES@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('OCALABICYCLES@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('ON YOUR MARK', '821 N FEDERAL HWY', 'LAKE PARK', 'FL', 'US', '33403', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'ONYOURMARKPERFORMANCE@GMAIL.COM;MATTGOSPORTS@GMAIL.COM', '205-987-4043', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'ON YOUR MARK'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ONYOURMARKPERFORMANCE@GMAIL.COM;MATTGOSPORTS@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ONYOURMARKPERFORMANCE@GMAIL.COM;MATTGOSPORTS@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Open Road Bicycles', '1560 Business Center Dr STE. #4', 'Fleming Island', 'FL', 'US', '32003', 'https://www.openroadbicycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'RegisterOneSales', '', NULL, '(904) 541-1816', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Open Road Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('RegisterOneSales'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Open Trails E-Bikes - LA', '467 N. Lake Ave', 'Pasadena', 'CA', 'US', '91101', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Dave', '', 'info@opentrails.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Open Trails E-Bikes - LA'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@opentrails.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@opentrails.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Dave'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Orange Cycle', '210 S Glassell', 'Orange', 'CA', 'US', '92866', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Armando', '', 'orangecycle@aol.com', '(714)532-6838', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Orange Cycle'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('orangecycle@aol.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('orangecycle@aol.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Armando'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Outback Bikes', '484 Moreland Ave NE', 'Atlanta', 'GA', 'US', '30307', 'https://www.outback-bikes.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Tracey', 'Delbridge', 'info@outback-bikes.com', '(404) 688-4878', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Outback Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@outback-bikes.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@outback-bikes.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Tracey'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Delbridge'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('OUTER BANKS BICYCLE', '203 S VIRGINIA DARE TRAIL', 'KILL DEVIL HILLS', 'NC', 'US', '27948', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'OUTER BANKS BICYCLE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('OUTLAND USA', '7223 HALEY INDUSTRIAL DR.', 'NOLENSVILLE', 'TN', 'US', '37135', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '864-642-2347', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'OUTLAND USA'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('OUTSPOKIN BICYCLES', '2241 GULF TO BAY BLVD.', 'CLEARWATER', 'FL', 'US', '33756', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '205-655-6090', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'OUTSPOKIN BICYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Oxford Bike Shoppe', '18 N Washington St. Ste B', 'Oxford', 'MI', 'US', '48371', 'https://oxfordbikeshoppe.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Larry', 'Buss', 'oxfordbikeshoppe@gmail.com', '248-572-4558', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Oxford Bike Shoppe'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('oxfordbikeshoppe@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('oxfordbikeshoppe@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Larry'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Buss'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('PALMARES CYCLING', NULL, 'PONCHATOULA', 'LA', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'INFO@PALMARESCYCLING.COM', '504-644-8680', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'PALMARES CYCLING'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('INFO@PALMARESCYCLING.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('INFO@PALMARESCYCLING.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('PALO ALTO BIKE SHOP', '171 UNIVERSITY AVE', 'PALO ALTO', 'CA', 'US', '94301', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'PALO ALTO BIKE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Par Cycles', '403 Weaver Street', 'Carrboro', 'NC', 'US', '27510', 'https://www.parcycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Parker', 'McConville', 'jeff@parcycles.com', '(919) 525-6135', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Par Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('jeff@parcycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('jeff@parcycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Parker'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('McConville'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('PARKSIDE BIKES', '1377 BARDSTOWN ROAD', 'LOUISVILLE', 'KY', 'US', '40204', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'JIMMY@PARKSIDEBIKES.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'PARKSIDE BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('JIMMY@PARKSIDEBIKES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('JIMMY@PARKSIDEBIKES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Pasadena Cyclery', '1670 E Walnut St', 'Pasadena', 'CA', 'US', '91106', 'https://www.pasadenacyclery.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Daniel', 'Purnell', 'daniel@pasadenacyclery.com; margaret@pasadenacyclery.com; info@pasadenacyclery.com', '(626) 795-2866', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Pasadena Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('daniel@pasadenacyclery.com; margaret@pasadenacyclery.com; info@pasadenacyclery.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('daniel@pasadenacyclery.com; margaret@pasadenacyclery.com; info@pasadenacyclery.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Daniel'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Purnell'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Pat''s 605 Cyclery', '12310 Studebaker Rd', 'Norwalk', 'CA', 'US', '90650', 'https://ridepats605.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ian', 'Morin / Tristan Patterson', 'pats605cyclery@gmail.com; teampats605@gmail.com', '(562) 864-0740', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Pat''s 605 Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('pats605cyclery@gmail.com; teampats605@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('pats605cyclery@gmail.com; teampats605@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ian'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Morin / Tristan Patterson'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('PEARLAND BICYCLES', '9330 BROADWAY ST. STE 422', 'PEARLAND', 'TX', 'US', '77584', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'INFO@PEARLANDBICYCLES.COM', '281-741-2115', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'PEARLAND BICYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('INFO@PEARLANDBICYCLES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('INFO@PEARLANDBICYCLES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('PEDAL & PLAY SPORTS', '14 E MAIN ST', 'NEW HAMPTON', 'IA', 'US', '50659', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'BAHEMANN@PEDALPLAYSPORTSNH.COM', '641-394-2459', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'PEDAL & PLAY SPORTS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BAHEMANN@PEDALPLAYSPORTSNH.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BAHEMANN@PEDALPLAYSPORTSNH.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Pedal Movement', '223 E 1st St,', 'Long Beach', 'CA', 'US', '90802', 'https://pedalmovement.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Dylan', 'Ambrose', 'shop@pedalmovement.com', '(562) 436-2453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Pedal Movement'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('shop@pedalmovement.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('shop@pedalmovement.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Dylan'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Ambrose'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Pedaler''s Corner', '840 9th Avenue', 'Sidney', 'NE', 'US', '69162', 'https://www.facebook.com/pedalerscorner/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Victoria', 'Corner', 'pedalers.sidney@gmail.com', '(308) 203-1977', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Pedaler''s Corner'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('pedalers.sidney@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('pedalers.sidney@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Victoria'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Corner'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Pedalers Fork - LA Valley', '23504 Calabasas Rd.', 'Calabasas', 'CA', 'US', '91320', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Gideon', '', 'info@pedalersfork.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Pedalers Fork - LA Valley'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@pedalersfork.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@pedalersfork.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Gideon'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Pedalers West - LA Valley', 'Van Nuys Blvd', 'Van Nuys', 'CA', 'US', '91406', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'John', '', 'info@pedalerswest.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Pedalers West - LA Valley'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@pedalerswest.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@pedalerswest.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('John'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Pedego', '11230 Grace Ave. #B', 'Fountain Valley', 'CA', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Paul', 'Auclair', 'paul@pedego.com', '949-205-9975', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Pedego'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('paul@pedego.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('paul@pedego.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Paul'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Auclair'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('PEDEGO ELECTRIC BIKES', '157 RIVER ST.', 'CHATTANOOGA', 'TN', 'US', '37405', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '727-384-6608', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'PEDEGO ELECTRIC BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Pedego Las Vegas', NULL, 'Las Vegas', 'NV', 'US', NULL, 'www.pedegolasvegas.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Charles', 'Beason', 'charles@pedegolasvegas.com', '(702) 886-5812', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Pedego Las Vegas'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('charles@pedegolasvegas.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('charles@pedegolasvegas.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Charles'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Beason'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('PEE DEE BICYCLE COMPANY', '1620 FARROW PARKWAY, UNIT A1', 'MYRTLE BEACH', 'SC', 'US', '29577', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'PEE DEE BICYCLE COMPANY'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Pegasus Bicycle Works, INC', '721 Castro St', 'Martinez', 'CA', 'US', '94553', 'https://www.pegasusbicycleworks.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Chris', 'Rodriguez', 'chris@pegasusbicycleworks.com', '925-362-2220', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Pegasus Bicycle Works, INC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('chris@pegasusbicycleworks.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('chris@pegasusbicycleworks.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Chris'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Rodriguez'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Peninsula Bikes', '146 W. San Ysidro', 'San Diego', 'CA', 'US', '92173', 'https://www.peninsulabikes.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Cris', 'Adams', 'cris@oeninsulabikes.com', '(619) 362-6936', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Peninsula Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('cris@oeninsulabikes.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('cris@oeninsulabikes.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Cris'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Adams'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('PERRY RUBBER BIKE SHOP', '240 BULL ST', 'SAVANNAH', 'GA', 'US', '31401', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'DAVID@PERRYRUBBERBIKESHOP.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'PERRY RUBBER BIKE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('DAVID@PERRYRUBBERBIKESHOP.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('DAVID@PERRYRUBBERBIKESHOP.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('PLAYTRI', '6465 E MOCKINGBIRD LANE, #358', 'DALLAS', 'TX', 'US', '75214', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'JULIAN.DASILVA@PLAYTRI.COM, STACI@PLAYTRI.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'PLAYTRI'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('JULIAN.DASILVA@PLAYTRI.COM, STACI@PLAYTRI.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('JULIAN.DASILVA@PLAYTRI.COM, STACI@PLAYTRI.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Pocono Biking', '7 Hazard Sq.', 'Jim Thorpe', 'PA', 'US', '18229', 'https://poconobiking.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Reed', 'Confir', 'info@poconobiking.com', '(800) 944-8392', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Pocono Biking'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@poconobiking.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@poconobiking.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Reed'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Confir'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('PODIUM MUTI SPORT', '1167 ZONOLITE PLACE NE, #A2', 'ATLANTA', 'GA', 'US', '30306', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'PODIUM MUTI SPORT'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('POWER BICYCLES BMX', '9911 S ORANGE BLOSSOM TRAIL', 'ORLANDO', 'FL', 'US', '32837', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'BMXPARTUSA@HOTMAIL.COM', '205-616-8558', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'POWER BICYCLES BMX'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BMXPARTUSA@HOTMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BMXPARTUSA@HOTMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Power on Site Ltd', '7 Campden Court', 'Lower Shotover', 'QUEENSTOWN, AOTEAROA NEW ZEALAND', 'US', '09304', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Steven', 'Meek & D Macintosh', 'goldcoastmtb@gmail.com', '0061-27200-1943', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Power on Site Ltd'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('goldcoastmtb@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('goldcoastmtb@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Steven'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Meek & D Macintosh'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Pro Cyclery - Vegas', '9440 W. Sahara Ave', 'Las Vegas', 'NV', 'US', '89117', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Lelani', '', 'lelani@procyclery.com', '702-228-9460', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Pro Cyclery - Vegas'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('lelani@procyclery.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('lelani@procyclery.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Lelani'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Psimet LLC', NULL, 'East Dundee', 'IL', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Robert', 'Curtis', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Psimet LLC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Robert'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Curtis'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Pure Energy Cycling', '99 S Main St', 'Lambertville', 'NJ', 'US', '08530', 'https://pureenergycycling.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Arounkone', 'Sananikone', 'info@pureenergycycling.com', '(609) 397-7008', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Pure Energy Cycling'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@pureenergycycling.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@pureenergycycling.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Arounkone'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Sananikone'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Pure Ride Cycles', '24844 Muirlands Blvd.', 'Lake Forest', 'CA', 'US', '92630', 'https://www.pureridecycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Kristen', 'Lawrence', 'kll@pureridecycles.com', '(949) 581-8900', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Pure Ride Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('kll@pureridecycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('kll@pureridecycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Kristen'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Lawrence'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('QUALITY BIKE SHOP', '1127 E MONTGOMERY CROSS RD.', 'SAVANNAH', 'GA', 'US', '31406', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Mike', 'Maynor', 'QUALITYBIKESHOP@ICLOUD.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'QUALITY BIKE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('QUALITYBIKESHOP@ICLOUD.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('QUALITYBIKESHOP@ICLOUD.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Mike'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Maynor'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('QUICKY CYCLES', '17284 SAN CARLOS BLVD., #102', 'FORT MYERS BEACH', 'FL', 'US', '33931', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'QUICKY CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Rage Cycles', '6411 E Thomas Rd', 'Scottsdale', 'AZ', 'US', '85251', 'https://ragecycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Peter', 'Perreault', 'peter@ragecycles.com', '(480) 968-8116', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Rage Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('peter@ragecycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('peter@ragecycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Peter'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Perreault'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Rampage Bikes', '12022 Centralia Rd #C', 'Hawaiian Gardens', 'CA', 'US', '90716', 'www.rampagebikes.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '(562) 402-3003', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Rampage Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Rancho Endurance', '2901 Sunrise Blvd', 'Rancho Cordova', 'CA', 'US', '95742', 'https://www.ranchoendurance.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Rich', 'Burns', 'rich@ranchoendurance.com', '(916) 346-4956', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Rancho Endurance'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('rich@ranchoendurance.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('rich@ranchoendurance.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Rich'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Burns'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Ray''s Bike Shop', '303 Salzburg Ave', 'Bay City', 'MI', 'US', '48706', 'https://www.raysbike.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Clark', 'Menough', NULL, '989-892-7516', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Ray''s Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Clark'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Menough'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Ray''s Bike Shop', '7814 Eastman Ave', 'Midland', 'MI', 'US', '48642', 'https://www.raysbike.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Brad', 'Alvesteffer', 'brad@raysbike.com', '989-486-9490', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Ray''s Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('brad@raysbike.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('brad@raysbike.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Brad'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Alvesteffer'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Ray''s Cycle', '400 Main St', 'Vacaville', 'CA', 'US', '95688', 'https://www.rayscyclebicycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ray', 'Posen', 'ray@rayscyclebicycle.com', '(707) 448-1911', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Ray''s Cycle'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ray@rayscyclebicycle.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ray@rayscyclebicycle.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ray'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Posen'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('RB Cycles', '7890 NW 34th St', 'Doral', 'FL', 'US', '33122', 'https://www.rbcycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '305-592-1600', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'RB Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('RB''S CYCLERY', '99 SEABOARD LANE, #1000', 'BRENTWOOD', 'TN', 'US', '37027', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'RB@RBSCYCLERY.COM', '352-390-6342', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'RB''S CYCLERY'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('RB@RBSCYCLERY.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('RB@RBSCYCLERY.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Recycle Bicycle Harrisburg', '1722 Chestnut St', 'Harrisburg', 'PA', 'US', '17104', 'https://rbhburg.org/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ross', 'Willard', 'contact@RBHburg.org', '(717) 978-3919', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Recycle Bicycle Harrisburg'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('contact@RBHburg.org' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('contact@RBHburg.org')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ross'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Willard'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Recycle Bike Shop', NULL, 'Boyceville', 'WI', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Larry', 'Theberge', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Recycle Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Larry'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Theberge'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Recycled Cycling Bike Shop', NULL, 'Warrenville', 'IL', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Bob', 'Marcuccelli or Jeremy Behnken', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Recycled Cycling Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Bob'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Marcuccelli or Jeremy Behnken'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('RECYCLES BIKE SHOP', '908-A SPRING GARDEN ST', 'GREENSBORO', 'NC', 'US', '27403', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '239-765-7500', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'RECYCLES BIKE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('REEDY CREEK', '154 COMMERCE ST.', 'KINGSPORT', 'TN', 'US', '37660', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'REEDYCREEKBICYCLES@GMAIL.COM', '615-499-4634', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'REEDY CREEK'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('REEDYCREEKBICYCLES@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('REEDYCREEKBICYCLES@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('REI CO-OP', '901 N. MILWAUKEE AVE, UNIT 100', 'VERNON HILLS', 'IL', 'US', '60061', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'RDICKSO@REI.COM', '847-573-0356', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'REI CO-OP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('RDICKSO@REI.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('RDICKSO@REI.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('REM BICYCLE & FITNESS', '804 MAIN ST', 'JASPER', 'IN', 'US', '47546', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'REMBICYCLE@GMAIL.COM', '812-634-1454', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'REM BICYCLE & FITNESS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('REMBICYCLE@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('REMBICYCLE@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Reno Bike Project', '216 E Grove St', 'Reno', 'NV', 'US', '89502', 'https://renobikeproject.org/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Shay', 'Daylami', 'shay@renobikeproject.com', '(775) 323-4488', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Reno Bike Project'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('shay@renobikeproject.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('shay@renobikeproject.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Shay'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Daylami'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Reseda Bicycles', '7056 Reseda Blvd.', 'Reseda', 'CA', 'US', '91335', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Brad', '', 'bicyclebrad1@gmail.com', '818-345-8844', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Reseda Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('bicyclebrad1@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('bicyclebrad1@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Brad'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Resurrection Cycles', '725 W. Lancaster Blvd', 'Lancaster', 'CA', 'US', '93534', 'https://rescycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ken', 'Bayard', 'res.cycles.av@gmail.com', '(661) 992-6107', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Resurrection Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('res.cycles.av@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('res.cycles.av@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ken'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Bayard'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Revolt Cyclery', '1305 Shotgun Rd', 'Sunrise', 'FL', 'US', '33326', 'https://revoltcyclery.company.site/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Nick', 'Vargas', 'revoltcyclery@gmail.com', '305-834-5595', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Revolt Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('revoltcyclery@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('revoltcyclery@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Nick'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Vargas'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Revolution Bike Shop', '235 S. Highway 101', 'Solana Beach', 'CA', 'US', '92075', 'https://revolutionbikeshop.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Joel', 'Moody', 'joel@revolutionbikeshop.com', '(858) 222-2453 / 310-567-5327', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Revolution Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('joel@revolutionbikeshop.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('joel@revolutionbikeshop.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Joel'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Moody'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('REVOLUTION CYCLES NC', '1907 SPRING GARDEN ST', 'GREENSBORO', 'NC', 'US', '27403', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'REVOLUTION CYCLES NC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('RHODDIE BICYCLE OUTFITTERS', '257 SUNSET DR.', 'BLOWING ROCK', 'NC', 'US', '28605', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '877-574-0656', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'RHODDIE BICYCLE OUTFITTERS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('RIDE A BIKE BICYCLE SHOP', '140 E MAIN AVE', 'GASTONIA', 'NC', 'US', '28052', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'BRANTLEY@RIDEABIKE.COM', '706-324-1132', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'RIDE A BIKE BICYCLE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BRANTLEY@RIDEABIKE.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BRANTLEY@RIDEABIKE.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Ride Bike Shop', '2 Lenape Rd', 'Andover', 'NJ', 'US', '07821', 'https://www.ridebikesnj.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Dennis', 'Yuroshek', 'ridebikesnj@gmail.com', '(973) 786-0307', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Ride Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ridebikesnj@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ridebikesnj@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Dennis'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Yuroshek'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Ride Cyclery', '449 S. Coast Hwy 101', 'Encinitas', 'CA', 'US', '92024', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Chase', '', 'info@ridecyclery.com', '760-632-1500', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Ride Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@ridecyclery.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@ridecyclery.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Chase'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('RIDE ON BIKES', '1036 BROADWAY', 'COLUMBUS', 'GA', 'US', '31901', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'INFO@RIDEONBIKES.COM', '828-669-5969', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'RIDE ON BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('INFO@RIDEONBIKES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('INFO@RIDEONBIKES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('RIDERS ONLY BIKE SHOP', '123 N. US Highway 1', 'Tequesta', 'FL', 'US', '33469', 'https://www.ridersonlybikes.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Cody', 'Infante', 'INFO@RIDERSONLY.COM  /INFO@RIDERSONLYBIKES.COM', '561-510-6659', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'RIDERS ONLY BIKE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('INFO@RIDERSONLY.COM  /INFO@RIDERSONLYBIKES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('INFO@RIDERSONLY.COM  /INFO@RIDERSONLYBIKES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Cody'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Infante'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('RIDGE & RIVER OUTFITTERS', '6610 FAIRFIELD DR. SUITE C', 'TOLEDO', 'OH', 'US', '43619', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '419-250-0945', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'RIDGE & RIVER OUTFITTERS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Ridgeline Service', '38925 Cherry Valley blvd Suite C', 'Cherry Valley', 'CA', 'US', '92223', 'https://ridgeline.services/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Joseph', '', 'ridelineservice@yahoo.com', '951-434-8421', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Ridgeline Service'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ridelineservice@yahoo.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ridelineservice@yahoo.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Joseph'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('RIVER BICYCLES', '138 HAMILTON AVE', 'GREENWICH', 'CT', 'US', '06830', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'RIVERBICYCLES@YAHOO.COM', '914-374-4153', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'RIVER BICYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('RIVERBICYCLES@YAHOO.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('RIVERBICYCLES@YAHOO.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('ROAD & TRAIL BICYCLES', '5113 US HWY 98 SOUTH', 'LAKELAND', 'FL', 'US', '33812', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'RTBI@TAMPABAY.RR.COM', '352-373-4052', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'ROAD & TRAIL BICYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('RTBI@TAMPABAY.RR.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('RTBI@TAMPABAY.RR.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Roberio Cycling Lab', '1891 NE 146 St', 'North Miami', 'FL', 'US', '33181', 'https://roberiocyclinglab.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Roberio', 'Bezerra', 'roberio@bikesvc.com', '302-915-5930', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Roberio Cycling Lab'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('roberio@bikesvc.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('roberio@bikesvc.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Roberio'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Bezerra'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Robinson Wheel Works', '1235 MacArthur Blvd', 'San Leandro', 'CA', 'US', '94577', 'https://www.robinsonbikeshop.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Chris', 'Robinson', 'robinsonwheelworks@sbcglobal.net', '(510) 388-6973', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Robinson Wheel Works'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('robinsonwheelworks@sbcglobal.net' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('robinsonwheelworks@sbcglobal.net')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Chris'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Robinson'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('ROCK N ROAD CYCLE', '100 N. 7TH ST.', 'GRAND HAVEN', 'MI', 'US', '49417', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'MATT@ROCJNROADCYCLE.COM', '616-846-2800', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'ROCK N ROAD CYCLE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('MATT@ROCJNROADCYCLE.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('MATT@ROCJNROADCYCLE.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Roll Models Bike Shop', '6641 Park Ave', 'Allen Park', 'MI', 'US', '48101', 'https://rollmodelsbikeshop.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Chris', 'Gee', 'rollmodels@sbcglobal.net', '(313) 382-1990', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Roll Models Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('rollmodels@sbcglobal.net' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('rollmodels@sbcglobal.net')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Chris'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Gee'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Roque Cycles RVC', '278 Sunrise Hwy', 'Rockville Center', 'NY', 'US', '11570', 'https://roguecyclesrvc.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Chris', 'Pulomena', 'roguecyclesrvc@gmail.com', '(516) 208-5908', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Roque Cycles RVC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('roguecyclesrvc@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('roguecyclesrvc@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Chris'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Pulomena'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Roswell Bicycles', '670 Houze Way', 'Roswell', 'GA', 'US', '30076', 'https://roswellbicycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'W/KG', 'Agency', NULL, '770-642-4057', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Roswell Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('W/KG'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Agency'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Roy''s Cyclery', '106 E. 9th Street', 'Upland', 'CA', 'US', '91786', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Lala', 'or Mike', NULL, '(909)982-8849', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Roy''s Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Lala'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('or Mike'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('ROYS SHEEPSHEAD CYCLE', '2679 CONEY ISLAND AVE', 'BROOKLYN', 'NY', 'US', '11235', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '718-648-1440', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'ROYS SHEEPSHEAD CYCLE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Rudy''s Cycle & Fitness', NULL, 'Chicago', 'IL', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Bill', 'Zielinski', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Rudy''s Cycle & Fitness'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Bill'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Zielinski'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Safety Cycles - LA', '1018 N Western Ave', 'Hollywood', 'CA', 'US', '90038', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Eric', '', 'safetycycles@yahoo.com', '323-464-5765', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Safety Cycles - LA'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('safetycycles@yahoo.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('safetycycles@yahoo.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Eric'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Salt Cycles', '2073 E 9400 S', 'Sandy', 'UT', 'US', '84093', 'https://www.saltcycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Chris', 'Austin', 'chris@saltcycles.com', '(801) 943-8502', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Salt Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('chris@saltcycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('chris@saltcycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Chris'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Austin'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Sanba Bicycle Shop', '3912 5th Ave', 'Brooklyn', 'NY', 'US', '11232', 'https://www.facebook.com/people/Sanba-bicycle-shop/100046888785746/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Daniel', 'Perez', 'Sanba.bicycle@gmail.com', '(347) 689-2770', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Sanba Bicycle Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('Sanba.bicycle@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('Sanba.bicycle@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Daniel'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Perez'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Santa Barbara Bcycle', '218 E Cota St', 'Santa Barbara', 'CA', 'US', '93101', 'https://santabarbara.bcycle.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'santabarbara@bcycle.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Santa Barbara Bcycle'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('santabarbara@bcycle.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('santabarbara@bcycle.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('SANTA MONICA CYCLE', '3850 COTTONWOOD GROVE TRAIL', 'CALABASAS', 'CA', 'US', '91301', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'SANTAMONICACYCLE@GMAIL.COM', '928-453-9777', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'SANTA MONICA CYCLE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('SANTAMONICACYCLE@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('SANTAMONICACYCLE@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Santos Trailhead Bike Shop LLC', '8924 US-441', 'Ocala', 'FL', 'US', '34480', 'https://santosbikeshop.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Chris', 'Fernandez', 'info@santosbikeshop.com', '352-307-2453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Santos Trailhead Bike Shop LLC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@santosbikeshop.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@santosbikeshop.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Chris'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Fernandez'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('SARIS', '5253 VERONA ROAD', 'MADISON', 'WI', 'US', '53711', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'ESANTIAGO@SARIS.COM', '608-729-6218', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'SARIS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ESANTIAGO@SARIS.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ESANTIAGO@SARIS.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('SCHOENAUER SERVICE COURSE', '59 COMMERCE ST., STE#A', 'OLD FORT', 'NC', 'US', '28762', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'CHAD@SSCBIKEREPAIR.COM', '336-370-9099', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'SCHOENAUER SERVICE COURSE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('CHAD@SSCBIKEREPAIR.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('CHAD@SSCBIKEREPAIR.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('SCOTTS BICYCLE CENTER', '2544 GEORGETOWN RD NW', 'CLVEVELAND', 'TN', 'US', '37311', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '423-472-9899', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'SCOTTS BICYCLE CENTER'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('SEA TO SUMMIT', '1901 CENTRAL AVE', 'BOULDER', 'CO', 'US', '80301', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'MARK.COLINO@YAHOO.COM', '732-604-4211', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'SEA TO SUMMIT'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('MARK.COLINO@YAHOO.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('MARK.COLINO@YAHOO.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Seagull''s Cycles', '422 McIntire St', 'Eagle', 'CO', 'US', '81631', 'https://seagullscycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Kyle', 'Foster', 'kyle@seagullscycles.com', '720-327-8429', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Seagull''s Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('kyle@seagullscycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('kyle@seagullscycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Kyle'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Foster'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('SENOIA BICYCLE', '34 MAIN ST.', 'SENOIA', 'GA', 'US', '30276', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'RETAIL@SENOIABICYCLE.COM', '706-549-2453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'SENOIA BICYCLE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('RETAIL@SENOIABICYCLE.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('RETAIL@SENOIABICYCLE.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Serious Cycling - LA North', '29041 Thousand Oaks Blvd', 'Agoura', 'CA', 'US', '91301', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Scott', '', 'Scott@seriouscycling.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Serious Cycling - LA North'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('Scott@seriouscycling.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('Scott@seriouscycling.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Scott'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Shade Tree Cycling', '1417 Mt. Willing Road', 'Leesville', 'SC', 'US', '29006', 'https://www.facebook.com/shadetreecyclingsoaz/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Peter', '', 'prkbikes1@me.com', '(803) 580-1474', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Shade Tree Cycling'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('prkbikes1@me.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('prkbikes1@me.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Peter'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Shift Bicycle', '665 Valley Dr.', 'Hermosa Beach', 'CA', 'US', '90254', 'https://www.shiftbicycle.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Bill', 'Carr', 'info@shiftbicycle.com', '310-374-2453', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Shift Bicycle'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@shiftbicycle.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@shiftbicycle.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Bill'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Carr'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Shirks Bike Shop', '1649 Ligalaw Rd', 'East Earl', 'PA', 'US', '17519', 'https://reallancastercounty.com/shirks-bike-shop/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Eric', 'Woods', 'shirksbike@gmail.com', '(717) 445-5731', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Shirks Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('shirksbike@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('shirksbike@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Eric'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Woods'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('SILVER CYCLES', '8307 DIXON AVE', 'SILVER SPRINGS', 'MD', 'US', '20910', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'LMACK@SILVERCYCLES.COM', '301-585-1889', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'SILVER CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('LMACK@SILVERCYCLES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('LMACK@SILVERCYCLES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Siren Skate Shop', '8430 Tidewater Dr', 'Norfolk', 'VA', 'US', '23518', 'https://www.facebook.com/SirenSkateShop/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Michael', 'Merritt', 'sirenskateshop@gmail.com', '(757) 962-3351', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Siren Skate Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('sirenskateshop@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('sirenskateshop@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Michael'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Merritt'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('SIREN SKATE SHOP', '8430 TIDEWATER DR.', 'NORFOLK', 'CA', 'US', '23513', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'SIRENSKATESHOP@GMAIL.COM', '757-515-7192', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'SIREN SKATE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('SIRENSKATESHOP@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('SIRENSKATESHOP@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Skunk River Cycles', '308 Main Street', 'Ames', 'IA', 'US', '50010', 'https://www.skunkrivercycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ronn', 'Ritz', 'sales@skunkrivercycles.com', '(515) 232-0322', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Skunk River Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('sales@skunkrivercycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('sales@skunkrivercycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ronn'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Ritz'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Slippery Pig Bicycles - SD', NULL, NULL, NULL, 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Erik', '', 'info@slipperypigbikes.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Slippery Pig Bicycles - SD'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@slipperypigbikes.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@slipperypigbikes.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Erik'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Slope Style Ski and Bike', '110 S Main St', 'Breckenridge', 'CO', 'US', '80424', 'https://www.slopestylebreck.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Chris', 'Brophy', 'slopestylebrophy@gmail.com', '970-547-4417', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Slope Style Ski and Bike'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('slopestylebrophy@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('slopestylebrophy@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Chris'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Brophy'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Sole'' Bike Shop', '835 W. Jefferson Ave. #1750', 'Los Angeles', 'CA', 'US', '90089', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Eddie', '', 'service@solebicycles.com', '877-617-3977', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Sole'' Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('service@solebicycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('service@solebicycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Eddie'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Solon Bicycle', '33113 Aurora Rd', 'Solon', 'OH', 'US', '44139', 'https://www.solonbicycle.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Dan', 'Sirkin', 'dan@solonbicycle.com', '(440) 349-5225', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Solon Bicycle'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('dan@solonbicycle.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('dan@solonbicycle.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Dan'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Sirkin'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('SOMI BIKE', '6600 SW 80TH STREET', 'MIAMI', 'FL', 'US', '33143', 'https://www.somibike.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jean', 'Palau', 'INFO@SOMIBIKE.COM', '802-888-7642 or 786-298-8403', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'SOMI BIKE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('INFO@SOMIBIKE.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('INFO@SOMIBIKE.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jean'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Palau'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Sourland Cycles', '53 E Broad St', 'Hopewell', 'NJ', 'US', '08525', 'https://www.sourlandcycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Alex', 'Robuck', 'info@sourlandcycles.com', '(609) 333-8553', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Sourland Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@sourlandcycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@sourlandcycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Alex'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Robuck'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('SOUTHPAW CYCLES', '103 CANOY LANE', 'CLEMSON', 'SC', 'US', '29631', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '305-666-7702', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'SOUTHPAW CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('SPARTAN RIDES', '2974 N ALMA SCHOOL RD', 'CHANDLER', 'AZ', 'US', '85224', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'SPARTAN RIDES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('SPEC', '5311 Topanga Canyon Blvd, Suite 301', 'Woodland Hills', 'CA', 'US', '91361', 'www.specpr.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Julie', 'Kelly', 'julie.kelly@specpr.com', '(760) 672-2527', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'SPEC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('julie.kelly@specpr.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('julie.kelly@specpr.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Julie'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Kelly'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('SPEED SHOP CYCLES', '2902 D NORTH MAIN ST.', 'ANDERSON', 'SC', 'US', '29621', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'DAVE@SPEEDSHOPCYCLES.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'SPEED SHOP CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('DAVE@SPEEDSHOPCYCLES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('DAVE@SPEEDSHOPCYCLES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Spinful Bike Shop', '1140 Monroe Ave NW, #2102', 'Grand Rapids', 'MI', 'US', '49503', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Nate', 'Phelps', 'nate@spinfulbike.com', '(616) 446-1420', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Spinful Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('nate@spinfulbike.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('nate@spinfulbike.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Nate'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Phelps'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('SPLENDID CYCLES', '407 SE IVON ST.', 'PORTLAND', 'OR', 'US', '97202', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'DARYL@SPLENDDIDCYCLES.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'SPLENDID CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('DARYL@SPLENDDIDCYCLES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('DARYL@SPLENDDIDCYCLES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Spoke Folk Cyclery', '201 Center St.', 'Healdsburg', 'CA', 'US', '95448', 'https://www.spokefolk.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Steve', 'Michel', 'bikerentals@spokefolk.com', '(707) 433-7171', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Spoke Folk Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('bikerentals@spokefolk.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('bikerentals@spokefolk.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Steve'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Michel'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Spoked Wheel''z LTD', '601 W Main St', 'Mount Pleasant', 'PA', 'US', '15666', 'http://swzservice.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Daniel', 'Slezak', NULL, '(724) 547-8886', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Spoked Wheel''z LTD'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Daniel'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Slezak'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Sports Basement', '1881 Ygnacio Valley Rd.', 'Walnut Creek', 'CA', 'US', '94598', 'https://shop.sportsbasement.com/blogs/stores/walnut-creek?srsltid=AfmBOopLq1CUAFyqMussiO1C2pWxeeCq-9u5aFkoS6w_0wzyI1A4Q4tw', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Phillip', 'Holenstein', 'pholenstein@sportsbasement.com', '925-941-6100', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Sports Basement'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('pholenstein@sportsbasement.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('pholenstein@sportsbasement.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Phillip'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Holenstein'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Sports Plus Bikes', NULL, 'Cedar Lake', 'IN', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ed', 'Nowdomski', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Sports Plus Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ed'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Nowdomski'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('SPRINGFIELD BICYCLE DOCTOR', '1037 N 5TH ST', 'SPRINGFIELD', 'IL', 'US', '62702', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '217-670-0761', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'SPRINGFIELD BICYCLE DOCTOR'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('SQUATCH BIKES', '170 KING ST.', 'BREVARD', 'NC', 'US', '28712', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'SQUATCH BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('ST.MATTHEWS CYCLING', '131 ST. MATTHEWS AVE.', 'LOUISVILLE', 'KY', 'US', '40207', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', '502-749-2003', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'ST.MATTHEWS CYCLING'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('502-749-2003' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('502-749-2003')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Stage 2 Cyclery', '41539 Kalmia St, #1129', 'Murrieta', 'CA', 'US', '92562', 'https://stage2cyclery.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Rigoberto', 'Meza Flores', 'rigo2stage2cyclery.com', '(951) 304-1212', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Stage 2 Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('rigo2stage2cyclery.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('rigo2stage2cyclery.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Rigoberto'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Meza Flores'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('STATE STREET BICYCLES', '25 STATE STREET', 'COMMERCE', 'GA', 'US', '30529', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', '706-336-0023', '704-549-8804', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'STATE STREET BICYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('706-336-0023' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('706-336-0023')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('STONEY CREEK BIKE', '58235 VAN DYKE', 'WASHINGTON', 'MI', 'US', '48094', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '586-781-4451', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'STONEY CREEK BIKE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Stott''s Bicycles', '509 N.Victory Blvd.', 'Burbank', 'CA', 'US', '91502', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Rob', '', 'info@stottsbicycles.com', '818-848-8551', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Stott''s Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@stottsbicycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@stottsbicycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Rob'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Strand Electric Bikes - LA Southbay', 'Pacific Coast Hwy', 'Hermosa Beach', 'CA', 'US', '90254', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Geoff', '', 'jeff@strandelectric.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Strand Electric Bikes - LA Southbay'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('jeff@strandelectric.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('jeff@strandelectric.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Geoff'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Subversive Cycling Company', NULL, 'Rockford', 'IL', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Alan', 'Goft', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Subversive Cycling Company'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Alan'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Goft'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('SUCK CREEK CYCLE', '630 W BELL AVE.', 'CHATTANOOGA', 'TN', 'US', '37405', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'SUCKCREEKCYCLES@GMAIL.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'SUCK CREEK CYCLE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('SUCKCREEKCYCLES@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('SUCKCREEKCYCLES@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('SUN BIKE SHOPS', '2646 ALUM ROCK AVE', 'SAN JOSE', 'CA', 'US', '95116', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'SUNBIKESHOP@YAHOO.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'SUN BIKE SHOPS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('SUNBIKESHOP@YAHOO.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('SUNBIKESHOP@YAHOO.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Sunset Cycles', NULL, 'Aurthur', 'IL', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Marcus', 'Schrock', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Sunset Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Marcus'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Schrock'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('SUPERCORSA CYCLES', '4925 FIRST COAST HWY', 'FERNANDINA BEACH', 'FL', 'US', '32034', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'DREW@SUPERCORSACYCLES.COM', '(813) 749-6732', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'SUPERCORSA CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('DREW@SUPERCORSACYCLES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('DREW@SUPERCORSACYCLES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Sutterville Bicycle Co', '2365 Sutterville Rd', 'Sacramento', 'CA', 'US', '95822', 'http://www.suttervillebicycle.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jeff', 'Dzurinko', 'jeffdzurinko@aol.com', '(916) 737-7537', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Sutterville Bicycle Co'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('jeffdzurinko@aol.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('jeffdzurinko@aol.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jeff'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Dzurinko'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('SUTTONS BAY BIKES', '318 North St. Joseph Street', 'Suttons Bay', 'MI', 'US', '49682', 'https://www.suttonsbaybikes.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Nick', 'Wierzba', 'NICK@GRANDTRAVERSEBIKETOURS.COM', '231-421-6815', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'SUTTONS BAY BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('NICK@GRANDTRAVERSEBIKETOURS.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('NICK@GRANDTRAVERSEBIKETOURS.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Nick'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Wierzba'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Sweet Bikes', '39946 Ford Rd', 'Canton', 'MI', 'US', '48187', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Seth', 'Kleinglass', 'sweetbikes@me.com', '(248) 403-8049', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Sweet Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('sweetbikes@me.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('sweetbikes@me.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Seth'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Kleinglass'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('T Road Cycles', NULL, 'Topeaka', 'IN', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Steven', 'Yoder', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'T Road Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Steven'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Yoder'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Tandems East / Vineland Syrup Inc', '723 Southeast BLVD', 'Vineland', 'NJ', 'US', '08360', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Mel', '', 'tandemseast@gmail.com', '856-451-5104', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Tandems East / Vineland Syrup Inc'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('tandemseast@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('tandemseast@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Mel'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Taylor''s Bike Shop', '2600 W 12600 S', 'Riverton', 'UT', 'US', '84065', 'https://www.taylorsbikeshop.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Brandon', 'Knight', 'Brandon@taylorsbikeshop.com', '801-253-1881', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Taylor''s Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('Brandon@taylorsbikeshop.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('Brandon@taylorsbikeshop.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Brandon'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Knight'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Team Bike Works', '8462 Indianapolis Ave', 'Huntington Beach', 'CA', 'US', '92646', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Mike', 'Milan', 'teambikeretail@gmail.com', '(714) 969-5480', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Team Bike Works'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('teambikeretail@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('teambikeretail@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Mike'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Milan'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('TEMPLE CITY BIKE SHOP', '9628 E LAS TUNAS DR', 'TEMPLE CITY', 'CA', 'US', '91780', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '415-524-7362', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'TEMPLE CITY BIKE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('TENAFLY BICYCLE WORKSHOP', '175 COUNTY ROAD', 'TENAFLY', 'NJ', 'US', '07670', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'INFO@BICYCLEWORKSHOP.COM', '201-568-9372', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'TENAFLY BICYCLE WORKSHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('INFO@BICYCLEWORKSHOP.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('INFO@BICYCLEWORKSHOP.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('TENNESSEE VALLEY BICYCLES', '210 WEST MAGNOLIA AVE', 'KNOXVILLE', 'TN', 'US', '37917', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'SCOTT@TNVALLEYBIKES.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'TENNESSEE VALLEY BICYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('SCOTT@TNVALLEYBIKES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('SCOTT@TNVALLEYBIKES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('THE BIKE CROSSING', '115 W JACKSON ST., STE 1-D', 'RIDGELAND', 'MS', 'US', '39157', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'TBCRIDGELAND@GMAIL.COM', '(423) 328-9049', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'THE BIKE CROSSING'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('TBCRIDGELAND@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('TBCRIDGELAND@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('THE BIKE SCHACK', '63 SHANK PAINTER ROAD', 'PROVINCETOWN', 'MA', 'US', '02657', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'eathineos@comcast.net', '978-660-7183', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'THE BIKE SCHACK'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('eathineos@comcast.net' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('eathineos@comcast.net')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('THE BIKE SHOP OF WINTER HAVEN', '249 3RD STREET SW', 'WINTER HAVEN', 'FL', 'US', '33880', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '336-766-5564', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'THE BIKE SHOP OF WINTER HAVEN'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('THE BIKE STORE', '4025 WATSON BLVD., STE#240', 'WARNER ROBINS', 'GA', 'US', '31093', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'THEBIKESTORE@WINDSTREAM.NET', '352-327-3727', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'THE BIKE STORE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('THEBIKESTORE@WINDSTREAM.NET' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('THEBIKESTORE@WINDSTREAM.NET')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('THE BIKER''S CHOICE', '709 W. MAIN ST.', 'HENDERSONVILLE', 'TN', 'US', '37075', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'BC@THEBIKERSCHOICE.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'THE BIKER''S CHOICE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BC@THEBIKERSCHOICE.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BC@THEBIKERSCHOICE.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('THE BIKERY', '2222 1ST AVE. SOUTH', 'SAINT PETERSBURG', 'FL', 'US', '33712', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'TAYLOR@THEBIKERY.BIKE; INFO@THEBIKERY.BIKE', '803-329-0992', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'THE BIKERY'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('TAYLOR@THEBIKERY.BIKE; INFO@THEBIKERY.BIKE' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('TAYLOR@THEBIKERY.BIKE; INFO@THEBIKERY.BIKE')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('THE BIKESMITHS', '2865 N Murray Ave,', 'MILWAUKEE', 'WI', 'US', '53211', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'BIKESMITHS@THEBIKESMITHS.COM', '414-332-1330', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'THE BIKESMITHS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BIKESMITHS@THEBIKESMITHS.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BIKESMITHS@THEBIKESMITHS.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('The Cargo Bike Shop', NULL, 'Madison', 'WI', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Camden', 'Powell', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'The Cargo Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Camden'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Powell'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('THE CYCLE WORKS', '207 HELLAM ST.', 'WRIGHTSVILLE', 'PA', 'US', '17368', 'https://thecycleworks.net/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jason', 'Blome', 'JASON@THECYCLEWORKS.NET', '717-252-1509', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'THE CYCLE WORKS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('JASON@THECYCLEWORKS.NET' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('JASON@THECYCLEWORKS.NET')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jason'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Blome'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('The Cyclist', '1785 Newport Blvd', 'Costa Mesa', 'CA', 'US', '92627', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Colt', '', 'Colt@thecyclist.com; ANTHONY@THECYCLIST.COM', '(949)645-8691', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'The Cyclist'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('Colt@thecyclist.com; ANTHONY@THECYCLIST.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('Colt@thecyclist.com; ANTHONY@THECYCLIST.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Colt'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('The Devil''s Gear Bike Shop', '845 Chapel St', 'New Haven', 'CT', 'US', '06510', 'https://www.thedevilsgear.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'John', 'Brehon', 'greg@thedevilsgear.com', '(203) 773-9288', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'The Devil''s Gear Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('greg@thedevilsgear.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('greg@thedevilsgear.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('John'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Brehon'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('The Dropout Cyclery', '1272 Sartori Ave.', 'Torrance', 'CA', 'US', '90501', 'https://thedropoutcyclery.shop/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'JP', '', 'jp@thedropout.bike', '(424) 478-2099', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'The Dropout Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('jp@thedropout.bike' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('jp@thedropout.bike')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('JP'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('The E-Bike Shop - LA Inland', 'Closed', NULL, NULL, 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'John', '', 'sandimasebikes@gmail.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'The E-Bike Shop - LA Inland'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('sandimasebikes@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('sandimasebikes@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('John'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('THE GEAR ATTIC', '1367 W BROAD ST', 'ATHENS', 'GA', 'US', '30606', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'THEGEARATTIC@GMAIL.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'THE GEAR ATTIC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('THEGEARATTIC@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('THEGEARATTIC@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('THE GREAT BICYCLE SHOP', '1909 THOMASVILLE RD', 'TALLAHASSEE', 'FL', 'US', '32303', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'MATTHEW@GREATBICYCLE.COM', '(813) 749-6732', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'THE GREAT BICYCLE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('MATTHEW@GREATBICYCLE.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('MATTHEW@GREATBICYCLE.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('THE HUB BICYCLES', '1220 S MILLEDGE AVE.', 'ATHENS', 'GA', 'US', '30605', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'BRIAN@HUBBIKES.COM', '813-681-1888', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'THE HUB BICYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('BRIAN@HUBBIKES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('BRIAN@HUBBIKES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('The Hub Bike Shop', '973 S Westlake Blvd', 'Thosand Oaks', 'CA', 'US', '91361', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jeff', '', 'info@thehubwestlake.com', '805-371-6432', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'The Hub Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@thehubwestlake.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@thehubwestlake.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jeff'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('The Loose Wheel Bicycle Shop', '10 Bowden Rd', 'Cedar Grove', 'NJ', 'US', '07009', 'https://www.theloosewheel.co/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'info@theloosewheel.co', '(973) 433-0260', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'The Loose Wheel Bicycle Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@theloosewheel.co' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@theloosewheel.co')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('THE NEW WHEEL', '2283 PALOU AVE', 'SAN FRANCISCO', 'CA', 'US', '94124', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '585-478-0113', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'THE NEW WHEEL'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('The New Wheel - NorCal', '420 Cortland Ave.', 'San Francisco', 'CA', 'US', '94110', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Karen', '', 'Karen@thenewwheel.com', '415-524-7362', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'The New Wheel - NorCal'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('Karen@thenewwheel.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('Karen@thenewwheel.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Karen'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('The Path Bicycle Shop', '649 South B St', 'Tustin', 'CA', 'US', '92780', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Brian', 'Blair', 'Brian@thepathbikeshop.com', '(714)669-0754', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'The Path Bicycle Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('Brian@thepathbikeshop.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('Brian@thepathbikeshop.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Brian'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Blair'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('The Peddler', '13010 W Parmer Ln., #500', 'Cedar Park', 'TX', 'US', '78613', 'https://www.peddlerbike.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Aj', 'Camp', 'peddlerbikeshop@gmail.com', '(512) 528-5238', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'The Peddler'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('peddlerbikeshop@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('peddlerbikeshop@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Aj'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Camp'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('The Peddler', '5015 Duval St', 'Austin', 'TX', 'US', '78751', 'https://www.peddlerbike.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Aj', 'Camp', 'peddlerbikeshop@gmail.com', '(512) 220-6766', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'The Peddler'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('peddlerbikeshop@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('peddlerbikeshop@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Aj'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Camp'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('THE RIGHT GEAR', '808 CHURCH ST. N', 'CONCORD', 'NC', 'US', '28025', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '336-852-3972', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'THE RIGHT GEAR'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('THE SPEED SHOP', '3501CLEMSON BLVD., UNIT 9', 'ANDERSON', 'SC', 'US', '29621', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'DAVE@SPEEDSHOPCYCLES.COM', '864-642-2347', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'THE SPEED SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('DAVE@SPEEDSHOPCYCLES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('DAVE@SPEEDSHOPCYCLES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('The Spoke', '250 Main St', 'Williamstown', 'MA', 'US', '01267', 'https://www.spokebicycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Paul', 'Rinehart', 'paul@spokebicycles.com', '(413) 458-3456', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'The Spoke'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('paul@spokebicycles.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('paul@spokebicycles.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Paul'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Rinehart'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('THE SPORTS DEN', '1202 S CENTRAL AVE', 'MARSHFIELD', 'WI', 'US', '54449', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'SERVICE@THESPORTSDEN.COM', '715-384-8313', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'THE SPORTS DEN'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('SERVICE@THESPORTSDEN.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('SERVICE@THESPORTSDEN.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('The Twisted Spoke', '3142 E. Plaza Blvd #P', 'National City', 'CA', 'US', '91950', 'https://the-twisted-spoke.ueniweb.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'Sales@TheTwistedSpoke.com', '(619) 512-1181', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'The Twisted Spoke'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('Sales@TheTwistedSpoke.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('Sales@TheTwistedSpoke.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('The Urban Cyclery Shop', '353 Central Ave', 'East Orange', 'NJ', 'US', '07018', 'https://www.theurbancycleryshop.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ozzie', 'Hanson', 'ucbikeshop@gmail.com', '(862) 930-7504', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'The Urban Cyclery Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('ucbikeshop@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('ucbikeshop@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ozzie'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Hanson'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('THOW''S RACE READY REPAIR', '7318 COATI PLACE', 'VENTURA', 'CA', 'US', '93003', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'DTFV@OUTLOOK.COM', '602-647-2286', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'THOW''S RACE READY REPAIR'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('DTFV@OUTLOOK.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('DTFV@OUTLOOK.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Thrive Swin & Ride Shop', NULL, 'Avondale', 'AZ', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Patrick', 'Coulter', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Thrive Swin & Ride Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Patrick'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Coulter'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('TONYS BICYCLE', '35-01 23RD AVE', 'ASTORIA', 'NY', 'US', '11105', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '718-278-3355', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'TONYS BICYCLE'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('TONY''S BIKE SHOP', '19 21ST STREET N', 'SAINT PETERSBURG', 'FL', 'US', '33713', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'TONYSBIKESHOP@GMAIL.COM', '931-520-6161', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'TONY''S BIKE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('TONYSBIKESHOP@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('TONYSBIKESHOP@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('TOP GEAR BICYCLES INC.', '923 N. MAGNOLIA AVE. SUITE 1500', 'OCALA', 'FL', 'US', '34475', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'SANDRA@TOPGEARBICYCLES.COM', '919-819-1060', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'TOP GEAR BICYCLES INC.'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('SANDRA@TOPGEARBICYCLES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('SANDRA@TOPGEARBICYCLES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Touright Bicycle Shop', NULL, 'Little Falls', 'MN', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'David', 'Sperstad', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Touright Bicycle Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('David'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Sperstad'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Town & Country Bike & Boards', '148 N. Center St.', 'Northville', 'MI', 'US', '48167', 'https://www.townandcountrybikeandboards.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Richard', 'Anway', 'townandcountrybb@comcast.net', '(248) 349-7140', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Town & Country Bike & Boards'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('townandcountrybb@comcast.net' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('townandcountrybb@comcast.net')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Richard'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Anway'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Traction Bicycles', 'MOBILE', 'Fairbanks', 'AK', 'US', '99709', 'https://www.facebook.com/TractionBicyclesMR/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Matt', 'McDaniel', 'tractionbicycles@yahoo.com', '(907) 378-6700', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Traction Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('tractionbicycles@yahoo.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('tractionbicycles@yahoo.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Matt'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('McDaniel'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('TRAIL AND FITNESS BICYCLES', '5133 HARDING PIKE, STE A-6', 'NASHVILLE', 'TN', 'US', '37205', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'GEORGE@TFB.BIKE', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'TRAIL AND FITNESS BICYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('GEORGE@TFB.BIKE' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('GEORGE@TFB.BIKE')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('TRAIL BLAZERS BIKE BARN', '11 N HOBART RD', 'HOBART', 'IN', 'US', '46342', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'INFO@TRAILBLAZERSBIKEBARN.COM', '219-940-3477', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'TRAIL BLAZERS BIKE BARN'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('INFO@TRAILBLAZERSBIKEBARN.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('INFO@TRAILBLAZERSBIKEBARN.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('TRAIL SPORTS BICYCLES', '6201 SEMINOLE BLVD', 'SEMINOLE', 'FL', 'US', '33772', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'SALES@TRAILSPORTBICYCLES.COM;RON@TRAILSPORTBICYCLE.COM', '336-274-5959', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'TRAIL SPORTS BICYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('SALES@TRAILSPORTBICYCLES.COM;RON@TRAILSPORTBICYCLE.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('SALES@TRAILSPORTBICYCLES.COM;RON@TRAILSPORTBICYCLE.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('TRAILHEAD BIKES', '225 1ST ST. NE', 'CLEVELAND', 'TN', 'US', '37311', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '910-799-6444', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'TRAILHEAD BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Trans Port Station', '6519 S. Sepulveda Blvd', 'Los Angekles', 'CA', 'US', '90045', 'https://www.tportstation.com/about-us', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'tportstation@gmail.com', '(424) 312-1148', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Trans Port Station'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('tportstation@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('tportstation@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('TREK RETAIL', '801 W MADISON ST', 'WATERLOO', 'MI', 'US', '53594', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'RAYMOND_YEUNG@TREKBIKES.COM', '1800-879-8735 EXT 129998', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'TREK RETAIL'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('RAYMOND_YEUNG@TREKBIKES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('RAYMOND_YEUNG@TREKBIKES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('TRI HARD SPORTS', '438 PORTER AVE.', 'OCEAN SPRINGS', 'MS', 'US', '39564', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '941-423-2613', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'TRI HARD SPORTS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Triathlon Lab - LA Southbay', '1512 Aviation Blvd', 'Redondo Beach', 'CA', 'US', '90278', 'https://triathlonlab.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Guillaume', 'Reynet or Robert', 'guillaume@triathlonlab.com / sales@triathlonlab.com', '310-374-9100', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Triathlon Lab - LA Southbay'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('guillaume@triathlonlab.com / sales@triathlonlab.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('guillaume@triathlonlab.com / sales@triathlonlab.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Guillaume'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Reynet or Robert'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('TRIDENT PEDAL BOATS', '4310 LAKE INDUSTRIAL BLVD.', 'TAVARES', 'FL', 'US', '32778', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'KENT@TRIDENTPEDAL.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'TRIDENT PEDAL BOATS'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('KENT@TRIDENTPEDAL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('KENT@TRIDENTPEDAL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Trimarni Coaching And Nutrition LLC', '115 War Admiral Way', 'Greenville', 'SC', 'US', '29617', 'https://www.trimarnicoach.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Karel', 'Sumbal', 'karel@trimarnicoach.com', '(904) 514-1800', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Trimarni Coaching And Nutrition LLC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('karel@trimarnicoach.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('karel@trimarnicoach.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Karel'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Sumbal'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('TRULY SPOKIN BIKES', '5172 STEWART STREET', 'MILTON', 'FL', 'US', '32570', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'TRULYSPOKINBIKES@GMAIL.COM', '954.796.9200', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'TRULY SPOKIN BIKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('TRULYSPOKINBIKES@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('TRULYSPOKINBIKES@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Tune Cycle', '3500 NW 2nd Ave Ste 508', 'Boca Raton', 'FL', 'US', '33431', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ethan', 'Bell', 'tunecycles@yahoo.com', '561-392-7311', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Tune Cycle'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('tunecycles@yahoo.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('tunecycles@yahoo.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ethan'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Bell'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Twin Ports Cyclery', NULL, 'Duluth', 'MN', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ethan', 'Reilly', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Twin Ports Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ethan'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Reilly'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('TWO BROKE SPOKES', '4640 N Florida Ave', 'TAMPA', 'FL', 'US', '33603', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'GEOFF.HEWETT@TWOBROKESPOKES.BIKE', '919-833-4588', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'TWO BROKE SPOKES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('GEOFF.HEWETT@TWOBROKESPOKES.BIKE' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('GEOFF.HEWETT@TWOBROKESPOKES.BIKE')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('TWO WHEELER DEALER', '4408 WRIGHTSVILLE AVE.', 'WILMINGTON', 'NC', 'US', '28403', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '828-414-9800', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'TWO WHEELER DEALER'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Two Wheeler Dealers', '1034 E Imperial Hwy', 'Brea', 'CA', 'US', '92821', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Scott', '', NULL, '(714)671-1730', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Two Wheeler Dealers'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Scott'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Upway Upcenter', '2400 Marine Ave', 'Redondo Beach', 'CA', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Colin', '', 'colin@upway.shop', '516-469-7562', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Upway Upcenter'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('colin@upway.shop' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('colin@upway.shop')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Colin'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Urban Bicycle Gallery', '801 Durham Drive', 'Houston', 'TX', 'US', '77007', 'https://www.urbanbicyclegallery.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Hunter', 'Dickerson', 'hunter@urbanbicyclegallery.com', '713-863-0991', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Urban Bicycle Gallery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('hunter@urbanbicyclegallery.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('hunter@urbanbicyclegallery.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Hunter'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Dickerson'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Urban Cycle Outfitters', NULL, 'Dumont', 'NJ', 'US', '07628', 'https://urbancycleoutfitters.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Chris', 'Tierno', 'urbancycleservices@yahoo.com', '(201) 790-2571', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Urban Cycle Outfitters'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('urbancycleservices@yahoo.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('urbancycleservices@yahoo.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Chris'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Tierno'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('US Pro Scooters - LA Southbay', '5107 Pacific Coast Hwy', 'Long Beach', 'CA', 'US', '90804', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Nick', '', 'usproscooters@gmail.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'US Pro Scooters - LA Southbay'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('usproscooters@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('usproscooters@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Nick'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Valley Bike and Ski', NULL, 'Apple Valley', 'MN', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jim', 'Basso', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Valley Bike and Ski'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jim'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Basso'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Velo Pasadena', '2562 E Colorado Blvd', 'Pasadena', 'CA', 'US', '91107', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Matthew', '', 'info@velopasadena.com', '(626)304-0064', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Velo Pasadena'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@velopasadena.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@velopasadena.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Matthew'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim(NULL))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('VELO PRO CYCLERY', '15 HITCHCOCK WAY', 'SANTA BARBARA', 'CA', 'US', '93105', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'FERNANDO@VELOPRO.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'VELO PRO CYCLERY'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('FERNANDO@VELOPRO.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('FERNANDO@VELOPRO.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Velofix - Minnesota', NULL, 'Bloomington', 'MN', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jason', 'Blake', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Velofix - Minnesota'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jason'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Blake'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Velorangutan', '3924 Woodbury Dr, Suite A', 'Austin', 'TX', 'US', '789704', 'https://velorangutan.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Wesley', 'Hayslip', 'wes@velorangutan.com', '(512) 468-0397', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Velorangutan'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('wes@velorangutan.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('wes@velorangutan.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Wesley'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Hayslip'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Velotech Inc / Bike Tires Direct', '5741 NE 87th Ave', 'Portland', 'OR', 'US', '97220', 'https://www.biketiresdirect.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Tyler', 'Aquino', 'purchasing@velotech.com', '407-488-4704', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Velotech Inc / Bike Tires Direct'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('purchasing@velotech.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('purchasing@velotech.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Tyler'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Aquino'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('VIC''S BIKE SHOP', '3503 W TEMPLE AVE', 'POMONA', 'CA', 'US', '91768', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'VICSBIKES@YAHOO.COM', '909-971-3774', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'VIC''S BIKE SHOP'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('VICSBIKES@YAHOO.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('VICSBIKES@YAHOO.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('VICTORY BICYCLE STUDIO', '2549 BROAD AVE', 'MEMPHIS', 'TN', 'US', '38112', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '(901) 746-8466', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'VICTORY BICYCLE STUDIO'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Village Peddler', '1111 Magnolia Ave', 'Larkspur', 'CA', 'US', '94939', 'https://www.villagepeddler.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Steve', 'Wilson', 'info@villagepeddler.com', '415-461-3091', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Village Peddler'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@villagepeddler.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@villagepeddler.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Steve'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Wilson'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Virtuous Cycles', NULL, 'Lafayette', 'IN', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Zoe', 'Neal', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Virtuous Cycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Zoe'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Neal'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('VISTA BIKE CURACAO', '7 Kaya W.F.G. Mensing', 'WILLEMSTED', 'CURACAO', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'VISTABIKE2013@GMAIL.COM', '5999-465-9577', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'VISTA BIKE CURACAO'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('VISTABIKE2013@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('VISTABIKE2013@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('VO2 MAX CYCLES', '32755 PENNSYLVANIA AVE.', 'SAN ANTONIO', 'FL', 'US', '33576', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'VO2 MAX CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('VOLTAIRE CYCLES', '21 Broadway', 'DENVILLE', 'NJ', 'US', '07834', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '919 438 9541', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'VOLTAIRE CYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Wally''s Bicycle Works', '209 Bonetti Dr,', 'San Luis Obispo', 'CA', 'US', '93401', 'http://www.wallysbikes.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Walter', 'AJ', 'Wallysbicycleworks@yahoo.com', '(805) 544-4116', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Wally''s Bicycle Works'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('Wallysbicycleworks@yahoo.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('Wallysbicycleworks@yahoo.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Walter'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('AJ'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Weavers Bicycle Shop', '338 NY-14A', 'Pennyan', 'NY', 'US', '14527', 'https://www.weaversbicycleshop.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Nelson', 'Weaver', 'weaversbicycleshop@gmail.com', '(315) 536-3012', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Weavers Bicycle Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('weaversbicycleshop@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('weaversbicycleshop@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Nelson'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Weaver'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Weaver''s Bike Shop', '230 Sheaffers School Rd', 'Ephrata', 'PA', 'US', '17522', 'https://reallancastercounty.com/see-do/outdoors/biking-lancaster-county/bike-shops/weavers-bike-shop/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Andrew', 'Hoover', NULL, '(717) 656-9385', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Weaver''s Bike Shop'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Andrew'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Hoover'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('WeCycle', '51670 Overseas Hwy', 'Key West', 'FL', 'US', '33040', 'https://wecyclekw.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Evan', 'Haskell', 'even@wecyclekw.com', '(305) 393-5797', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'WeCycle'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('even@wecyclekw.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('even@wecyclekw.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Evan'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Haskell'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('WE-Cycle', '695 Buggy Circle Unit B1', 'Carbondale', 'CO', 'US', '81623', 'https://www.we-cycle.org/carbondale/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Wes', 'Higginbotham', 'buyer@we-cycle.org', '970-205-9222', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'WE-Cycle'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('buyer@we-cycle.org' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('buyer@we-cycle.org')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Wes'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Higginbotham'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('WEST BICYCLES', '1531 KINGSTON PIKE', 'KNOXVILLE', 'TN', 'US', '37934', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '352-534-0888', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'WEST BICYCLES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('West Chester Cyclery', NULL, 'West Chester', 'OH', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jim', 'Rolfes', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'West Chester Cyclery'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jim'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Rolfes'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('WEST END SKI & TRAIL', '118 E PEARL ST', 'ISHPEMING', 'MI', 'US', '49849', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'WEST END SKI & TRAIL'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Wheel and Sprocket', NULL, 'Oak Park', 'IL', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Justin', 'McCormick', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Wheel and Sprocket'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Justin'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('McCormick'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('WHEEL SPORT', '422 EAST BERNARD AVE.', 'GREENEVILLE', 'TN', 'US', '37745', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'WHEELSPORTS1570@GMAIL.COM', '865-671-7591', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'WHEEL SPORT'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('WHEELSPORTS1570@GMAIL.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('WHEELSPORTS1570@GMAIL.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('WHEELSPORT SERVICES', '11 TOWPATH LANE', 'STANHOPE', 'NJ', 'US', '07874', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'RAY@WHEELSPORTSERVICES.COM', '908-813-2908', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'WHEELSPORT SERVICES'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('RAY@WHEELSPORTSERVICES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('RAY@WHEELSPORTSERVICES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Wild Card Cycle Works / 3 WHISKEY LLC', '1029 Hannah Ave', 'Traverse City', 'MI', 'US', '49686', 'https://www.wildcardcw.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Peter', 'Trucco', 'peter@wildcardcw.com', '231-421-3187', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Wild Card Cycle Works / 3 WHISKEY LLC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('peter@wildcardcw.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('peter@wildcardcw.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Peter'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Trucco'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('WILMETTE BICYCLE & SPORT SHOP, INC', '605 GREEN BAY RD', 'WILMETTE', 'IL', 'US', '60091', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', NULL, '847-251-1404', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'WILMETTE BICYCLE & SPORT SHOP, INC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Windham Outfitters', '61 NY-296', 'Windham', 'NY', 'US', '12496', 'https://windhamoutfitters.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'nick', 'Bove', NULL, '(518) 734-4700', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Windham Outfitters'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('nick'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Bove'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('WINTER PARK CYCLES, LLC', '3014 CORRINE DRIVE', 'ORLANDO', 'FL', 'US', '32803', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'LEE@WINTERPARKCYCLES.COM', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'WINTER PARK CYCLES, LLC'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('LEE@WINTERPARKCYCLES.COM' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('LEE@WINTERPARKCYCLES.COM')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Won-Ago-Biking', NULL, 'Muckwonago', 'WI', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Kyle', 'Rickert', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Won-Ago-Biking'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Kyle'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Rickert'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Wonder Lake Bicycle', NULL, 'Wonder Lake', 'IL', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Richard', 'Roman', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Wonder Lake Bicycle'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Richard'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Roman'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Woodside Bikes', '1800 EL CAMINO REAL', 'Menlo Park', 'CA', 'US', '94025', 'https://www.woodsidebikeshop.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Anthony', 'Fernadez', 'gregdt1@yahoo.com', '(650) 299-1071', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Woodside Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('gregdt1@yahoo.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('gregdt1@yahoo.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Anthony'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Fernadez'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Work Horse Bicycles', '486 Washington St.', 'Monterey', 'CA', 'US', '93940', 'https://www.workhorsebicycles.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ryan', 'Tibbs', 'workhorsebicycles@gmail.com', '(831) 375-2144', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Work Horse Bicycles'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('workhorsebicycles@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('workhorsebicycles@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ryan'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Tibbs'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('World of Bikes', NULL, 'Iowa City', 'IA', 'US', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Ryan', 'Egan', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'World of Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               (NULL IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim(NULL)))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Ryan'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Egan'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('You Bet! Bicycle Sales & Service', '556 Searls Ave', 'Nevada City', 'CA', 'US', '95959', 'https://www.youbetbike.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Jay', 'Barre', 'youbetbike@gmail.com', '530-264-7447', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'You Bet! Bicycle Sales & Service'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('youbetbike@gmail.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('youbetbike@gmail.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Jay'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Barre'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Zeitbike', '2646 Palma Dr', 'Ventura', 'CA', 'US', '93003', 'www.zeitbike.com', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Fritz', 'Bohl', 'fritz@zeitbike.com', '(312) 375-3275', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Zeitbike'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('fritz@zeitbike.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('fritz@zeitbike.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Fritz'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Bohl'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Zion Guru', '1013 Zion Park Blvd', 'Springdale', 'UT', 'US', '84767', 'https://www.zionguru.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Nicholas', 'Martino', 'nick@zionguru.com', '435-632-0432', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Zion Guru'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('nick@zionguru.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('nick@zionguru.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Nicholas'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Martino'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Neuhaus Metalworks', '26 Commercial Blvd STE L', 'Neuhaus', 'CA', 'US', '94949', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Unknown', 'Contact', 'info@neuahausmetalworks.com', '(415) 717-3517', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Neuhaus Metalworks'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@neuahausmetalworks.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@neuahausmetalworks.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Unknown'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Contact'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Martins Bike & Fitness', '1891 Division Hwy', 'Ephrata', 'PA', 'US', '17522', NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Bruce', 'Martin', 'bruce@martinsbike.com', '(717) 354-9127', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Martins Bike & Fitness'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('bruce@martinsbike.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('bruce@martinsbike.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Bruce'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Martin'))
               )
             )
         );
INSERT INTO companies (name, address, city, state, country, zip, url, segment, customer_type, notes, main_phone, created_at, updated_at)
       VALUES ('Brickell Bikes', '70 SW 12 ST', 'Miami', 'FL', 'US', '33130', 'https://www.brickellbikes.com/', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
       ON CONFLICT(name) DO UPDATE SET
         address = excluded.address,
         city = excluded.city,
         state = excluded.state,
         country = excluded.country,
         zip = excluded.zip,
         url = excluded.url,
         updated_at = CURRENT_TIMESTAMP;
INSERT INTO customers (company_id, first_name, last_name, email, phone, other_phone, photo_key, notes, created_at, updated_at)
       SELECT id, 'Robbie', 'Zamora', 'info@brickellbikes.com', '(305) 373-3633', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
       FROM companies
       WHERE name = 'Brickell Bikes'
         AND NOT EXISTS (
           SELECT 1
           FROM customers cu
           WHERE cu.company_id = companies.id
             AND cu.deleted_at IS NULL
             AND (
               ('info@brickellbikes.com' IS NOT NULL AND lower(trim(coalesce(cu.email, ''))) = lower(trim('info@brickellbikes.com')))
               OR (
                 lower(trim(coalesce(cu.first_name, ''))) = lower(trim('Robbie'))
                 AND lower(trim(coalesce(cu.last_name, ''))) = lower(trim('Zamora'))
               )
             )
         );
