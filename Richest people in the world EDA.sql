select *
FROM 1000_richest_people_in_the_world;

-- Remove duplicates
-- Standardize the data
-- null values 
-- Remove any columns

CREATE TABLE richest_people_in_the_world
LIKE 1000_richest_people_in_the_world;

select *
FROM richest_people_in_the_world;

INSERT richest_people_in_the_world
select *
FROM 1000_richest_people_in_the_world;

-- Remove duplicates
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Name,Country,Industry, `Net Worth (in billions)`,Company) AS row_num
FROM richest_people_in_the_world;

WITH dublicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Name,Country,Industry, `Net Worth (in billions)`,Company) AS row_num
FROM richest_people_in_the_world
)

SELECT *
FROM dublicate_cte
WHERE row_num > 1;

SELECT *
FROM richest_people_in_the_world
WHERE Name = 'Alice Walton';


WITH dublicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Name,Country,Industry, `Net Worth (in billions)`,Company) AS row_num
FROM richest_people_in_the_world
)

DELETE 
FROM dublicate_cte
WHERE row_num > 1;

-- Standardize the data
select Company, TRIM(Company)
from richest_people_in_the_world;

update richest_people_in_the_world
set Company = trim(Company);

SELECT DISTINCT Industry
FROM richest_people_in_the_world
ORDER BY 1;

UPDATE richest_people_in_the_world
SET Name = TRIM(Name),
    Country = TRIM(Country),
    Industry = TRIM(Industry),
    Company = TRIM(Company);

--  Ensure Net_Worth_in_Billions is a decimal
ALTER TABLE richest_people_in_the_world
MODIFY `Net Worth (in billions)` DECIMAL(10, 2);

UPDATE richest_people_in_the_world
SET Country = 'Unknown'
WHERE Country IS NULL;

SELECT DISTINCT `Net Worth (in billions)`
FROM richest_people_in_the_world;


-- the number of records

SELECT COUNT(*) AS total_records
FROM richest_people_in_the_world;

SELECT Name, Country, Industry, `Net Worth (in billions)`, COUNT(*) as count
FROM richest_people_in_the_world
GROUP BY Name, Country, Industry, `Net Worth (in billions)`, Company
HAVING count > 1;

ALTER TABLE richest_people_in_the_world ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY;

DELETE t1
FROM richest_people_in_the_world t1
INNER JOIN richest_people_in_the_world t2 
WHERE 
    t1.id > t2.id AND 
    t1.Name = t2.Name AND 
    t1.Country = t2.Country AND 
    t1.Industry = t2.Industry AND 
    t1.`Net Worth (in billions)` = t2.`Net Worth (in billions)` AND 
    t1.Company = t2.Company;
    
SELECT COUNT(*) AS total_records
FROM richest_people_in_the_world;


SELECT Name, Country, Industry, `Net Worth (in billions)`, Company, COUNT(*) as count
FROM richest_people_in_the_world
GROUP BY Name, Country, Industry, `Net Worth (in billions)`, Company
HAVING count > 1;

-- sammary stastistic for Net Worth (in billions)
SELECT 
    MIN(`Net Worth (in billions)`) AS min_net_worth,
    MAX(`Net Worth (in billions)`) AS max_net_worth,
    AVG(`Net Worth (in billions)`) AS avg_net_worth,
    SUM(`Net Worth (in billions)`) AS total_net_worth
FROM richest_people_in_the_world;

-- Distribution of net worth
SELECT
    CASE
        WHEN `Net Worth (in billions)` < 10 THEN '0-10'
        WHEN `Net Worth (in billions)` BETWEEN 10 AND 50 THEN '10-50'
        WHEN `Net Worth (in billions)` BETWEEN 50 AND 100 THEN '50-100'
        ELSE '100+'
    END AS net_worth_range,
    COUNT(*) AS count
FROM richest_people_in_the_world
GROUP BY net_worth_range
ORDER BY net_worth_range;

-- Top 10 richest people:
SELECT Name, Country, Industry, `Net Worth (in billions)`, Company
FROM richest_people_in_the_world
ORDER BY `Net Worth (in billions)` DESC
LIMIT 10;

-- count by country
SELECT Country, COUNT(*) AS count
FROM richest_people_in_the_world
GROUP BY Country
ORDER BY count DESC;

-- count by industry
SELECT Industry, COUNT(*) AS count
FROM richest_people_in_the_world
GROUP BY Industry
ORDER BY count DESC;

-- Average net worth by industry:
SELECT Country, AVG(`Net Worth (in billions)`) AS avg_net_worth
FROM richest_people_in_the_world
GROUP BY Country
ORDER BY avg_net_worth DESC;

-- companies with most billioners
SELECT Company, COUNT(*) AS count
FROM richest_people_in_the_world
GROUP BY Company
ORDER BY count DESC;

-- Top 5 countries with the highest total net worth:
SELECT Country, SUM(`Net Worth (in billions)`) AS Total_net_worth
FROM richest_people_in_the_world
GROUP BY Country
ORDER BY Total_net_worth DESC;

-- 95th percentile of net worth:
SELECT CEIL(COUNT(*) * 0.95) AS percentile_rank
FROM richest_people_in_the_world;

WITH ranked_data AS (
    SELECT `Net Worth (in billions)`,
           ROW_NUMBER() OVER (ORDER BY `Net Worth (in billions)`) AS row_num
    FROM richest_people_in_the_world
)
SELECT `Net Worth (in billions)`
FROM ranked_data
WHERE row_num = (
    SELECT CEIL(COUNT(*) * 0.95) AS percentile_rank
    FROM richest_people_in_the_world
);
-- cumulative_net_worth
SELECT 
    `Net Worth (in billions)`,
    SUM(`Net Worth (in billions)`) OVER (ORDER BY `Net Worth (in billions)`) AS cumulative_net_worth
FROM richest_people_in_the_world
ORDER BY `Net Worth (in billions)`;

-- Average net worth by country and industry:
SELECT Country, Industry, AVG(`Net Worth (in billions)`) AS avg_net_worth
FROM richest_people_in_the_world
GROUP BY Country, Industry
ORDER BY avg_net_worth DESC;
