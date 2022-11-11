###########Harnessing the power of RECURSIVE CTES###########

-- Generating a series numbers of 1 to 100

WITH RECURSIVE number_series AS
(
	SELECT 1 AS my_number  -- } Anchor Member

	UNION ALL
    
    SELECT my_number + 1   -- } 
    FROM number_series     -- } Recursive Member
    WHERE my_number <100   -- } 
)
SELECT my_number
FROM number_series ;

-- Generating an ODD number series betweeen 1 to 100
-- You only need to introduce an extra condition in the where clause of the outer SELECT statement

WITH RECURSIVE odd_number_series AS
(
	SELECT 1 AS my_number

	UNION ALL
    
    SELECT my_number + 1
    FROM odd_number_series
    WHERE my_number < 100
)
SELECT my_number
FROM odd_number_series
WHERE my_number % 2 = 1;

/*
Now, let's leverage the power of RECURSIVE CTE to build a Calendar Lookup Table.
First Let's generate a date series from 2022-01-01 to 2030-12-31
*/

SET SESSION cte_max_recursion_depth = 10000; /* We need to set the cte_max_recursion_depth to a value larger than that what is expected
										     in our RECURIVE CTE query output. So, let's use 10000 in our case*/

WITH RECURSIVE date_series AS
(
	SELECT '2022-01-01' AS my_date

	UNION ALL
    
    SELECT DATE_ADD(my_date, INTERVAL 1 DAY) 
    FROM date_series
    WHERE my_date < '2030-12-31'
)
SELECT my_date
FROM date_series;

-- Now that we written a query to generate our date, let's create a calendar_lookup table and insert the values

DROP TABLE IF EXISTS Calendar_Lookup;
CREATE TABLE Calendar_Lookup 
(
	Date DATE,
    Day_of_week_no INT,
    Day_of_week_name VARCHAR(32),
    Month_no INT,
    Month_name VARCHAR(32),
    Year INT,
    Weekend_Weekday VARCHAR(32)
);

-- Using the RECURSIVE CTE query earlier written for the date_series, we can fill up the "Date" column of the Calendar_Lookup Table

INSERT INTO Calendar_Lookup (date)
WITH RECURSIVE date_series AS
(
	SELECT '2022-01-01' AS my_date

	UNION ALL
    
    SELECT DATE_ADD(my_date, INTERVAL 1 DAY) 
    FROM date_series
    WHERE my_date < '2030-12-31'
)
SELECT my_date
FROM date_series;


-- We can run the query below to confirm our date column is filled in correctly
SELECT * FROM calendar_lookup;

-- Next, we populate the rest of the columns using the update statement


UPDATE calendar_lookup
SET 
	day_of_week_no = dayofweek(date),
    day_of_week_name = DATE_FORMAT(date, '%W'),
	Month_no = MONTH(date),
    Month_name = DATE_FORMAT(date, '%M'),
    Year = YEAR(date),
    Weekend_Weekday =     CASE
								WHEN dayofweek(date) IN (1, 7) THEN 'Weekend'
								ELSE 'Weekday'
							END
;

-- Run the query again to confirm we have our complete Calendar_Lookup table
SELECT
	*
FROM calendar_lookup;