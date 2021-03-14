-----------------------------
-- Table : DRIVER_ANALYSIS --
-----------------------------

SELECT d.medallion,
	   d.hack_license,
	   d.vendor_id
INTO driver_analysis
FROM trip_fare_raw f, trip_data_raw d
WHERE d.trip_time_in_secs >= 60 AND
	  d.trip_distance > 0.5 AND
	  ((d.trip_distance * 1.609 * 1000) / d.trip_time_in_secs) * 3.6 < 70 AND
	  passenger_count BETWEEN 1 AND 6 AND
	  d.pickup_datetime IS NOT NULL AND
	  d.dropoff_datetime IS NOT NULL AND
	  d.pickup_latitude   BETWEEN  39 AND  42 AND
	  d.dropoff_latitude  BETWEEN  39 AND  42 AND
	  d.pickup_longitude  BETWEEN -76 AND -72 AND
	  d.dropoff_longitude BETWEEN -76 AND -72 AND
	  d.pickup_latitude <> d.dropoff_latitude AND
	  d.pickup_longitude <> d.dropoff_longitude AND
	  d.pickup_datetime = f.pickup_datetime AND
	  d.medallion = f.medallion AND
	  d.hack_license = f.hack_license AND
	  d.vendor_id = f.vendor_id 
ORDER BY f.pickup_datetime, f.medallion, f.hack_license, f.vendor_id;

SELECT COUNT(*) FROM driver_analysis; -- 12734965
SELECT * FROM driver_analysis LIMIT 1;
DROP TABLE driver_analysis;

ALTER TABLE driver_analysis
	ADD COLUMN id SERIAL PRIMARY KEY;
	
---------------------------
-- Table : DATA_ANALYSIS --
---------------------------

SELECT rate_code,
	   store_and_fwd_flag,
	   d.pickup_datetime,
	   dropoff_datetime,
	   passenger_count,
	   trip_time_in_secs,
	   trip_distance,
	   pickup_longitude,
	   pickup_latitude,
	   dropoff_longitude,
	   dropoff_latitude
INTO data_analysis
FROM trip_fare_raw f, trip_data_raw d
WHERE d.trip_time_in_secs >= 60 AND
	  d.trip_distance > 0.5 AND
	  ((d.trip_distance * 1.609 * 1000) / d.trip_time_in_secs) * 3.6 < 70 AND
	  passenger_count BETWEEN 1 AND 6 AND
	  d.pickup_datetime IS NOT NULL AND
	  d.dropoff_datetime IS NOT NULL AND
	  d.pickup_latitude   BETWEEN  39 AND  42 AND
	  d.dropoff_latitude  BETWEEN  39 AND  42 AND
	  d.pickup_longitude  BETWEEN -76 AND -72 AND
	  d.dropoff_longitude BETWEEN -76 AND -72 AND
	  d.pickup_latitude <> d.dropoff_latitude AND
	  d.pickup_longitude <> d.dropoff_longitude AND
	  d.pickup_datetime = f.pickup_datetime AND
	  d.medallion = f.medallion AND
	  d.hack_license = f.hack_license AND
	  d.vendor_id = f.vendor_id 
ORDER BY f.pickup_datetime, f.medallion, f.hack_license, f.vendor_id;

SELECT COUNT(*) FROM data_analysis; -- 12734965
SELECT * FROM data_analysis LIMIT 1;
DROP TABLE data_analysis;

ALTER TABLE data_analysis
	ADD COLUMN id SERIAL PRIMARY KEY,
	ALTER COLUMN store_and_fwd_flag TYPE BOOL USING store_and_fwd_flag::boolean,
	ALTER COLUMN trip_distance TYPE NUMERIC(5,2) USING ROUND(trip_distance * 1.609, 2),
	ALTER COLUMN pickup_longitude TYPE NUMERIC(7,4) USING ROUND(pickup_longitude, 4),
	ALTER COLUMN pickup_latitude TYPE NUMERIC(7,4) USING ROUND(pickup_latitude, 4),
	ALTER COLUMN dropoff_longitude TYPE NUMERIC(7,4) USING ROUND(dropoff_longitude, 4),
	ALTER COLUMN dropoff_latitude TYPE NUMERIC(7,4) USING ROUND(dropoff_latitude, 4);

---------------------------
-- Table : FARE_ANALYSIS --
---------------------------

SELECT f.payment_type,
	   f.fare_amount,
	   f.surcharge,
	   f.mta_tax,
	   f.tip_amount,
	   f.tolls_amount,
	   f.total_amount
INTO fare_analysis
FROM trip_fare_raw f, trip_data_raw d
WHERE d.trip_time_in_secs >= 60 AND
	  d.trip_distance > 0.5 AND
	  ((d.trip_distance * 1.609 * 1000) / d.trip_time_in_secs) * 3.6 < 70 AND
	  passenger_count BETWEEN 1 AND 6 AND
	  d.pickup_datetime IS NOT NULL AND
	  d.dropoff_datetime IS NOT NULL AND
	  d.pickup_latitude   BETWEEN  39 AND  42 AND
	  d.dropoff_latitude  BETWEEN  39 AND  42 AND
	  d.pickup_longitude  BETWEEN -76 AND -72 AND
	  d.dropoff_longitude BETWEEN -76 AND -72 AND
	  d.pickup_latitude <> d.dropoff_latitude AND
	  d.pickup_longitude <> d.dropoff_longitude AND
	  d.pickup_datetime = f.pickup_datetime AND
	  d.medallion = f.medallion AND
	  d.hack_license = f.hack_license AND
	  d.vendor_id = f.vendor_id 
ORDER BY f.pickup_datetime, f.medallion, f.hack_license, f.vendor_id;

SELECT COUNT(*) FROM fare_analysis; -- 12734965
SELECT * FROM fare_analysis LIMIT 1;
DROP TABLE fare_analysis;

ALTER TABLE fare_analysis
	ADD COLUMN id SERIAL PRIMARY KEY,
	ALTER COLUMN fare_amount TYPE NUMERIC(5,2),
	ALTER COLUMN surcharge TYPE NUMERIC(4,2),
	ALTER COLUMN mta_tax TYPE NUMERIC(3,2),
	ALTER COLUMN tip_amount TYPE NUMERIC(5,2),
	ALTER COLUMN tolls_amount TYPE NUMERIC(4,2),
	ALTER COLUMN total_amount TYPE NUMERIC(5,2);
	
-------------
-- Testing --
-------------

-- Compare records for PK id = 1 in all tables
SELECT * FROM
driver_analysis dr
JOIN fare_analysis fr
ON dr.id = fr.id
JOIN data_analysis da
ON da.id = fr.id
WHERE dr.id = 1; -- tip_amount = 1.4, total_amount = 8.9

SELECT * 
FROM trip_data_raw d
JOIN trip_fare_raw f
ON  d.pickup_datetime = f.pickup_datetime AND
	d.medallion = f.medallion AND
	d.hack_license = f.hack_license AND
	d.vendor_id = f.vendor_id
WHERE d.pickup_datetime = '2013-02-01 00:00:00'  AND
	  d.medallion = '00790C7BAD30B7A9E09689A13ED90042' AND
	  d.hack_license = '3EF1ED607505C991D26C703B2C8F9849'
; -- tip_amount = 1.4, total_amount = 8.9
	