-- Release storage after row deletion
VACUUM ANALYZE raw_master;

-- Describe table
SELECT * FROM pg_stats WHERE tablename = 'raw_master';
SELECT attname, n_distinct, most_common_vals FROM pg_stats WHERE tablename = 'raw_master';

---------------------------------------------------

-----------------------
-- Varliable Analysis--
-----------------------



-- Counting distinct values for various attributes
SELECT COUNT( DISTINCT(medallion) ) FROM trip_data_raw; -- 13415
SELECT COUNT( DISTINCT(hack_license) ) FROM trip_data_raw; -- 32062
SELECT COUNT( DISTINCT(medallion) ) FROM trip_fare_raw; -- 13415
SELECT COUNT( DISTINCT(hack_license) ) FROM trip_fare_raw; -- 32062
SELECT DISTINCT(vendor_id) FROM trip_data_raw; -- 2 ("VTS", "CMT")
SELECT DISTINCT(rate_code)FROM trip_data_raw ORDER BY rate_code; -- 12 (0,1,2,3,4,5,6,7,28,79,210,221)
SELECT DISTINCT(vendor_id) FROM trip_fare_raw; -- 2 ("VTS", "CMT")
SELECT DISTINCT(payment_type)FROM trip_fare_raw ORDER BY payment_type; -- 5 ("CRD","CSH","DIS","NOC","UNK")


-- Unhasing the medallion/hack_license
SELECT md5('5433881'); -- BA96DE419E711691B9445D6A6307C170
SELECT md5('1V62'), md5('5457029');
SELECT COUNT( DISTINCT(medallion, hack_license) ) FROM trip_fare_raw; -- 95731

-- trip_time_in_secs AND trip_distance

-- trips covering 1km in less than 10 seconds
SELECT COUNT(*)
FROM trip_data_raw
WHERE trip_distance > 1
AND trip_time_in_secs < 10; --2386

-- trips having a duration of less than 1 min
SELECT COUNT(*)
FROM trip_data_raw 
WHERE trip_time_in_secs < 60; -- 79186

SELECT trip_time_in_secs, trip_distance 
FROM trip_data_raw 
WHERE trip_time_in_secs < 60
ORDER BY 2;

-- trips having a duration 1-60 seconds and distance < 2kms
SELECT COUNT(*) 
FROM trip_data_raw 
WHERE trip_time_in_secs BETWEEN 1 AND 60 AND
trip_distance BETWEEN 0.1 AND 2; -- 64602

SELECT trip_time_in_secs, trip_distance 
FROM trip_data_raw 
WHERE trip_time_in_secs BETWEEN 1 AND 60 AND
trip_distance BETWEEN 0.1 AND 2
ORDER BY 2;

-- trips having avg speed less than 70, duration 1-60 seconds
SELECT COUNT(*) 
FROM trip_data_raw 
WHERE trip_time_in_secs BETWEEN 1 AND 60 AND
trip_distance <> 0 AND
((trip_distance * 1.609 * 1000) / trip_time_in_secs) * 3.6 < 70; -- 64810 (using the speed formula (unit km/h))

SELECT trip_time_in_secs, trip_distance 
FROM trip_data_raw 
WHERE trip_time_in_secs BETWEEN 1 AND 60 AND
trip_distance <> 0 AND
((trip_distance * 1.609 * 1000) / trip_time_in_secs) * 3.6 < 70
ORDER BY 2;
---------------------------------------------------

-- rate_code
SELECT rate_code, COUNT(*) AS rate_code
FROM trip_data_raw
GROUP BY 1
ORDER BY 2 DESC;

-- total_amount
SELECT * FROM trip_fare_raw 
ORDER BY total_amount DESC
LIMIT 1;

SELECT total_amount, COUNT(*) AS total_amt_count
FROM fare_analysis 
GROUP BY 1
ORDER BY 1 DESC;

-- surcharge
SELECT surcharge, COUNT(*) AS occurences
FROM trip_fare_raw
GROUP BY 1
ORDER BY 2 DESC;

-- mta_tax
SELECT mta_tax, COUNT(*) AS mta_tax
FROM trip_fare_raw
GROUP BY 1
ORDER BY 2 DESC;

-- tip_amount
SELECT tip_amount, COUNT(*) AS tip_amount
FROM trip_fare_raw
GROUP BY 1
ORDER BY 2 DESC;

-- passenger_count
SELECT passenger_count, COUNT(*)
FROM trip_data_raw
GROUP BY 1
ORDER BY 2 DESC; -- 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 129, 208

SELECT COUNT(*)
FROM trip_data_raw
WHERE passenger_count NOT BETWEEN 1 AND 6; -- 213

SELECT passenger_count, COUNT(*)
FROM trip_data_raw
WHERE passenger_count BETWEEN 1 AND 6
GROUP BY 1
ORDER BY 2 DESC; -- 


-- co-ordinates
SELECT COUNT(*)
FROM trip_data_raw
WHERE pickup_longitude <> 0 AND pickup_latitude <> 0 AND
	  dropoff_longitude <> 0 AND dropoff_latitude <> 0 AND
	  pickup_latitude BETWEEN 39 AND 42 AND
	  dropoff_latitude BETWEEN 39 AND 42 AND
	  pickup_longitude BETWEEN -76 AND -72 AND
	  dropoff_longitude BETWEEN -76 AND -72 AND
	  (pickup_latitude = dropoff_latitude OR 
	  pickup_longitude = dropoff_longitude); -- 171036
	  
	  
SELECT trip_time_in_secs, trip_distance, pickup_latitude, dropoff_latitude, pickup_longitude, dropoff_longitude
FROM trip_data_raw
WHERE trip_distance > 0.5 AND
	  pickup_latitude BETWEEN 39 AND 42 AND
	  dropoff_latitude BETWEEN 39 AND 42 AND
	  pickup_longitude BETWEEN -76 AND -72 AND
	  dropoff_longitude BETWEEN -76 AND -72 AND
	  (pickup_latitude = dropoff_latitude OR 
	  pickup_longitude = dropoff_longitude)
LIMIT 200; -- 171036
---------------------------------------------------
