CREATE TABLE IF NOT EXISTS trip_data_raw (
	medallion              TEXT,
	hack_license           TEXT,
	vendor_id              TEXT,
	rate_code              INT,
	store_and_fwd_flag     TEXT,
	pickup_datetime        TIMESTAMP,
	dropoff_datetime       TIMESTAMP,
	passenger_count        INT,
	trip_time_in_secs      INT,
	trip_distance          NUMERIC(10,6),
	pickup_longitude       NUMERIC(10,6),
	pickup_latitude        NUMERIC(10,6),
	dropoff_longitude      NUMERIC(10,6),
	dropoff_latitude       NUMERIC(10,6)
);

CREATE TABLE IF NOT EXISTS trip_fare_raw (
	medallion              TEXT,
	hack_license           TEXT,
	vendor_id              TEXT,
	pickup_datetime        TIMESTAMP,
	payment_type	       TEXT,
	fare_amount            NUMERIC(9,6),
	surcharge       	   NUMERIC(8,6),
	mta_tax				   NUMERIC(7,6),
	tip_amount      	   NUMERIC(9,6),
	tolls_amount       	   NUMERIC(8,6),
	total_amount       	   NUMERIC(9,6)
);

-- To delete table
DROP TABLE trip_data_raw;
DROP TABLE trip_fare_raw;

-- To delete all rows, restart the row_number
TRUNCATE trip_data_raw
RESTART IDENTITY;

TRUNCATE trip_fare_raw
RESTART IDENTITY;

-- Copy all data from csv
copy trip_data_raw FROM 'D:/trip_data_2_2.csv' DELIMITER ',' CSV null as E'\'\''; -- 3497545
--Linux: cat /path/trip_data_2_*.csv | psql -c 'COPY raw_data FROM stdin CSV HEADER'

copy trip_data_raw FROM 'D:/trip_data_2_1.csv' DELIMITER ',' CSV HEADER; -- 3497544
copy trip_data_raw FROM 'D:/trip_data_2_2.csv' DELIMITER ',' CSV; -- 3497545
copy trip_data_raw FROM 'D:/trip_data_2_3.csv' DELIMITER ',' CSV; -- 3497545
copy trip_data_raw FROM 'D:/trip_data_2_4.csv' DELIMITER ',' CSV; -- 3497542

copy trip_fare_raw FROM 'D:/trip_fare_2_1.csv' DELIMITER ',' CSV HEADER; -- 4663392
copy trip_fare_raw FROM 'D:/trip_fare_2_2.csv' DELIMITER ',' CSV; -- 4663393
copy trip_fare_raw FROM 'D:/trip_fare_2_3.csv' DELIMITER ',' CSV; -- 4663391


-- Check the first 5 records
SELECT * FROM trip_data_raw LIMIT 5;
SELECT * FROM trip_fare_raw LIMIT 5;


-- Checking total number of records in both tables, should be 13990176
SELECT COUNT(*) FROM trip_data_raw; -- 13990176
SELECT COUNT(*) FROM trip_fare_raw; -- 13990176


-- Counting distinct values for various attributes
SELECT COUNT(DISTINCT (medallion)) FROM trip_data_raw; -- 13415
SELECT COUNT(DISTINCT (hack_license)) FROM trip_data_raw; -- 32062
SELECT COUNT(DISTINCT (medallion)) FROM trip_fare_raw; -- 13415
SELECT COUNT(DISTINCT (hack_license)) FROM trip_fare_raw; -- 32062
SELECT DISTINCT(vendor_id) FROM trip_data_raw; -- 2 ("VTS", "CMT")
SELECT DISTINCT(rate_code)FROM trip_data_raw ORDER BY rate_code; -- 12 (0,1,2,3,4,5,6,7,28,79,210,221)
SELECT DISTINCT(vendor_id) FROM trip_fare_raw; -- 2 ("VTS", "CMT")
SELECT DISTINCT(payment_type)FROM trip_fare_raw ORDER BY payment_type; -- 5 ("CRD","CSH","DIS","NOC","UNK")

-- Unhasing the medallion/hack_license
SELECT md5('5433881'); -- BA96DE419E711691B9445D6A6307C170


-- Finding the composite key
SELECT COUNT(DISTINCT (medallion,hack_license,vendor_id,pickup_datetime)) FROM trip_fare_raw; -- 13990176 SHOULD BE 13990176
SELECT COUNT(DISTINCT (hack_license,vendor_id,pickup_datetime)) FROM trip_fare_raw; -- 13990025
SELECT COUNT(DISTINCT (medallion,vendor_id,pickup_datetime)) FROM trip_fare_raw; -- 13990159
SELECT COUNT(DISTINCT (medallion,hack_license,pickup_datetime)) FROM trip_fare_raw; -- 13990176
SELECT COUNT(DISTINCT (medallion,pickup_datetime)) FROM trip_fare_raw; -- 13990159
SELECT COUNT(DISTINCT (medallion,hack_license)) FROM trip_fare_raw; -- 95731


-- Make a master table with all fields
SELECT d.medallion, d.hack_license, d.vendor_id, d.rate_code, d.store_and_fwd_flag, d.pickup_datetime, 
	   d.dropoff_datetime, d.passenger_count, d.trip_time_in_secs, d.trip_distance, d.pickup_longitude, 
	   d.pickup_latitude, d.dropoff_longitude, d.dropoff_latitude, f.payment_type, f.fare_amount, f.surcharge, 
	   f.mta_tax, f.tip_amount, f.tolls_amount, f.total_amount
INTO raw_consolidated
FROM trip_data_raw d, trip_fare_raw f
WHERE d.medallion=f.medallion AND
	  d.hack_license=f.hack_license AND
	  d.vendor_id=f.vendor_id AND
	  d.pickup_datetime=f.pickup_datetime
ORDER BY d.pickup_datetime, d.medallion, d.hack_license;


-- Creating a master table
CREATE TABLE IF NOT EXISTS raw_master (
	id 					   INT GENERATED ALWAYS AS IDENTITY,
	medallion              TEXT,
	hack_license           TEXT,
	vendor_id              TEXT,
	pickup_datetime        TIMESTAMP,

	rate_code              INT,
	store_and_fwd_flag     BOOLEAN,
	dropoff_datetime       TIMESTAMP,
	passenger_count        INT,
	trip_time_in_secs      INT,
	trip_distance          NUMERIC(10,6),
	pickup_longitude       NUMERIC(10,6),
	pickup_latitude        NUMERIC(10,6),
	dropoff_longitude      NUMERIC(10,6),
	dropoff_latitude       NUMERIC(10,6),

	payment_type	       TEXT,
	fare_amount            NUMERIC(9,6),
	surcharge       	   NUMERIC(8,6),
	mta_tax				   NUMERIC(7,6),
	tip_amount      	   NUMERIC(9,6),
	tolls_amount       	   NUMERIC(8,6),
	total_amount       	   NUMERIC(9,6),
	PRIMARY KEY (id)
);


-- Populate raw_master from trip_fare and trip_data
INSERT INTO raw_master(medallion, hack_license, vendor_id, pickup_datetime, rate_code, 
					   store_and_fwd_flag, dropoff_datetime, passenger_count, 
					   trip_time_in_secs, trip_distance, pickup_longitude, pickup_latitude, 
					   dropoff_longitude, dropoff_latitude,	payment_type, fare_amount, 
					   surcharge, mta_tax, tip_amount, tolls_amount, total_amount)
SELECT d.medallion, d.hack_license, d.vendor_id, d.pickup_datetime, d.rate_code, 
	   CAST(d.store_and_fwd_flag AS BOOL), d.dropoff_datetime, d.passenger_count, 
	   d.trip_time_in_secs, d.trip_distance, d.pickup_longitude, d.pickup_latitude, 
	   d.dropoff_longitude, d.dropoff_latitude, f.payment_type, f.fare_amount, f.surcharge,
	   f.mta_tax, f.tip_amount, f.tolls_amount, f.total_amount 
FROM trip_data_raw d, trip_fare_raw f
WHERE d.medallion=f.medallion AND
	  d.hack_license=f.hack_license AND
	  d.vendor_id=f.vendor_id AND
	  d.pickup_datetime=f.pickup_datetime
ORDER BY d.pickup_datetime, d.medallion, d.hack_license;


-- Perform list deletion on raw_consolidated
DELETE FROM raw_master
WHERE trip_time_in_secs < 30 OR
	  trip_distance < 0.5 OR
	  ((trip_distance * 1.609 * 1000) / trip_time_in_secs) * 3.6 > 70 OR
	  pickup_longitude = 0 AND pickup_latitude = 0 OR
	  dropoff_longitude = 0 AND dropoff_latitude = 0 OR
	  pickup_latitude NOT BETWEEN 39 AND 42 OR
	  dropoff_latitude NOT BETWEEN 39 AND 42 OR
	  pickup_longitude NOT BETWEEN -76 AND -72 OR
	  dropoff_longitude NOT BETWEEN -76 AND -72 OR
	  pickup_latitude = dropoff_latitude OR 
	  pickup_longitude = dropoff_longitude
; -- 1052441
	  
SELECT COUNT(*) FROM raw_master; -- 12937735

-- Resize columns based on data-range
ALTER TABLE raw_master
ALTER COLUMN trip_distance TYPE NUMERIC(5,2) USING ROUND(trip_distance * 1.609, 2),
ALTER COLUMN pickup_longitude TYPE NUMERIC(7,4) USING ROUND(pickup_longitude, 4),
ALTER COLUMN pickup_latitude TYPE NUMERIC(7,4) USING ROUND(pickup_latitude, 4),
ALTER COLUMN dropoff_longitude TYPE NUMERIC(7,4) USING ROUND(dropoff_longitude, 4),
ALTER COLUMN dropoff_latitude TYPE NUMERIC(7,4) USING ROUND(dropoff_latitude, 4),
ALTER COLUMN fare_amount TYPE NUMERIC(5,2),
ALTER COLUMN surcharge TYPE NUMERIC(4,2),
ALTER COLUMN mta_tax TYPE NUMERIC(3,2),
ALTER COLUMN tip_amount TYPE NUMERIC(5,2),
ALTER COLUMN tolls_amount TYPE NUMERIC(4,2),
ALTER COLUMN total_amount TYPE NUMERIC(5,2);

SELECT * FROM raw_master 
ORDER BY total_amount DESC
LIMIT 1;

-- Release storage after row deletion
VACUUM ANALYZE raw_master;

-- Describe table
SELECT * FROM pg_stats WHERE tablename = 'raw_master';
---------------------------------------------------

-- Make tables for analysis

DROP TABLE fare_analysis;
-- time, fare
SELECT id,
	   vendor_id,
	   pickup_datetime,
	   CASE WHEN (trip_time_in_secs) <= 60  THEN 1 ELSE (trip_time_in_secs)/60 END AS trip_time_in_mins,
	   payment_type,
	   trip_distance, 
	   surcharge, 
	   fare_amount, 
	   total_amount
INTO fare_analysis
FROM raw_master
ORDER BY id;

SELECT * FROM distance_time LIMIT 5;

---------------------------------------------------

DROP TABLE data_analysis;
-- for distance, geolocation
SELECT id, 
	   vendor_id, 
	   pickup_datetime,
	   dropoff_datetime,
	   trip_time_in_secs,
	   pickup_longitude, 
	   pickup_latitude, 
	   dropoff_longitude, 
	   dropoff_latitude, 
	   trip_distance,
	   surcharge, 
	   fare_amount, 
	   total_amount
INTO data_analysis
FROM raw_master
ORDER BY id;

---------------------------------------------------

-- Create csv from analysis tables
COPY ( SELECT * FROM data_analysis ) TO 'D:/data_analysis.csv' With CSV DELIMITER ',' HEADER;
COPY ( SELECT * FROM fare_analysis ) TO 'D:/fare_analysis.csv' With CSV DELIMITER ',' HEADER;
