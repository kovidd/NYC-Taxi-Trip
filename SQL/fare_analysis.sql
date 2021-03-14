SELECT COUNT(*)
FROM trip_data_raw
WHERE trip_time_in_secs <> 0 AND
trip_distance <> 0 AND
((trip_distance * 1.609 * 1000) / trip_time_in_secs) * 3.6 > 70; -- 34252

SELECT trip_time_in_secs, trip_distance, ((trip_distance * 1.609 * 1000) / trip_time_in_secs) * 3.6 AS speed_km_h
FROM trip_data_raw
WHERE trip_time_in_secs <> 0 AND
trip_distance <> 0 AND
((trip_distance * 1.609 * 1000) / trip_time_in_secs) * 3.6 > 70
LIMIT 2000; -- 33


SELECT COUNT(*) FROM raw_master
WHERE trip_time_in_secs >= 60*60;

SELECT * FROM raw_master
WHERE trip_time_in_secs/60 = 180;

SELECT * FROM raw_master
WHERE fare_amount = 500;

SELECT * FROM raw_master
WHERE trip_time_in_secs < 30
	AND trip_distance > 70;
	
SELECT COUNT(DISTINCT(trip_time_in_mins)) FROM fare_analysis;
