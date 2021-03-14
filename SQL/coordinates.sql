SELECT MIN(pickup_longitude), MIN(pickup_latitude), MIN(dropoff_longitude),	MIN(dropoff_latitude),
	   MAX(pickup_longitude), MAX(pickup_latitude), MAX(dropoff_longitude),	MAX(dropoff_latitude)
FROM trip_data_raw
WHERE pickup_longitude <> 0 AND pickup_latitude <> 0 AND
	  dropoff_longitude <> 0 AND dropoff_latitude <> 0;
	  
SELECT * FROM trip_data_raw WHERE pickup_longitude=-2001.505100;

SELECT COUNT(*)
FROM raw_master
WHERE pickup_longitude <> 0 AND pickup_latitude <> 0 AND
	  dropoff_longitude <> 0 AND dropoff_latitude <> 0 AND
	  pickup_latitude BETWEEN 39 AND 42 AND
	  dropoff_latitude BETWEEN 39 AND 42 AND
	  pickup_longitude BETWEEN -76 AND -72 AND
	  dropoff_longitude BETWEEN -76 AND -72 AND
	  pickup_latitude <> dropoff_latitude AND
	  pickup_longitude <> dropoff_longitude; -- 12937735

SELECT COUNT(DISTINCT(pickup_latitude, pickup_longitude))
FROM data_analysis; -- 422008

SELECT COUNT(DISTINCT(ROUND(pickup_latitude, 2), ROUND(pickup_longitude,2)))
FROM data_analysis; -- 3415

SELECT COUNT(DISTINCT(dropoff_latitude, dropoff_longitude))
FROM data_analysis; -- 724224

SELECT COUNT(DISTINCT(ROUND(dropoff_latitude, 2), ROUND(dropoff_longitude,2)))
FROM data_analysis; -- 4562

-- Area with maximum number of pickups (best location)
SELECT ROUND(pickup_latitude, 1) pickup_latitude, 
	   ROUND(pickup_longitude,1) pickup_longitude,
	   COUNT(*) num_pickups
FROM data_analysis 
GROUP BY 1, 2
ORDER BY 3 DESC; -- 264

-- Area with maximum number of dropoffs
SELECT ROUND(dropoff_latitude, 2) dropoff_latitude, 
	   ROUND(dropoff_longitude,2) dropoff_longitude,
	   COUNT(*) num_dropoffs
FROM raw_master 
GROUP BY 1, 2
ORDER BY 3 DESC; -- 4562

-- Area with maximum number of dropoffs
SELECT ROUND(dropoff_latitude, 4) dropoff_latitude, 
	   ROUND(dropoff_longitude,4) dropoff_longitude,
	   COUNT(*) num_dropoffs
FROM raw_master 
GROUP BY 1, 2
ORDER BY 3 DESC; -- 303

-- Peak hour and area with maximum number of pickups (best location, time)
SELECT DATE_PART('hour', pickup_datetime) AS hour_day,
	   ROUND(pickup_latitude, 3) pickup_latitude, 
	   ROUND(pickup_longitude, 3) pickup_longitude,
	   COUNT(*) num_pickups
FROM data_analysis 
GROUP BY 1, 2, 3
ORDER BY 4 DESC; -- 1713

-- Peak time of day with maximum number of pickups (best time period)
SELECT CASE WHEN DATE_PART('hour', pickup_datetime) >= 3  AND DATE_PART('hour', pickup_datetime) <= 8  THEN 'Early Morning' 
			WHEN DATE_PART('hour', pickup_datetime) >= 9  AND DATE_PART('hour', pickup_datetime) <= 14 THEN 'Afternoon' 
			WHEN DATE_PART('hour', pickup_datetime) >= 15 AND DATE_PART('hour', pickup_datetime) <= 22 THEN 'Evening'
			ELSE 'Late Night' END AS hour_day,
	   COUNT(*) num_pickups
FROM data_analysis 
GROUP BY 1
ORDER BY 2 DESC; -- 582

-- Area with maximum number of pickups with hour of day (best location, time)
-- Location rounded to 0.1 = 11.132 km; 0.01 = 1.1132 km
SELECT CASE WHEN DATE_PART('hour', d.pickup_datetime) >= 3 AND DATE_PART('hour', d.pickup_datetime) <= 8 THEN 'Early Morning' 
			WHEN DATE_PART('hour', d.pickup_datetime) >= 9 AND DATE_PART('hour', d.pickup_datetime) <= 14 THEN 'Afternoon' 
			WHEN DATE_PART('hour', d.pickup_datetime) >= 15 AND DATE_PART('hour', d.pickup_datetime) <= 22 THEN 'Evening' ELSE 
			'Late Night' END AS hour_day,
	   ROUND(d.pickup_latitude, 1) pickup_latitude, 
	   ROUND(d.pickup_longitude,1) pickup_longitude,
	   COUNT(*) num_pickups
FROM data_analysis d
GROUP BY 1, 2, 3
ORDER BY 4 DESC; -- 582

