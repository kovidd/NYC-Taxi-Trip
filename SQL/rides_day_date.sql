-- Number of rides per day for the month of February
SELECT DATE_PART('day', pickup_datetime) AS date_feb, COUNT(*) as num_rides
FROM data_analysis 
GROUP BY 1
ORDER BY 2;

-- Number of rides per day of week for the entire month of February
SELECT TO_CHAR(pickup_datetime, 'Day') AS day_of_week, COUNT(*) as num_rides
FROM data_analysis 
GROUP BY 1
ORDER BY 2 DESC;

-- Percentage of above query
SELECT TO_CHAR(pickup_datetime, 'Day') AS day_of_week, COUNT(*) AS num_rides,
	   ROUND((COUNT(*)/((SELECT COUNT(*) FROM data_analysis)+1.0)) * 100, 2) as percentage
FROM data_analysis 
GROUP BY 1
ORDER BY 2 DESC;

-- Number of rides per hour of day for the entire month of February (peak travel hour)
SELECT DATE_PART('hour', pickup_datetime) AS hour_day, COUNT(*) as num_rides
FROM data_analysis 
GROUP BY 1
ORDER BY 2;

