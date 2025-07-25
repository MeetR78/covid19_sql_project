
-- covid_daily_queries.sql

-- Table Creation
CREATE TABLE covid_daily (
    Date DATE,
    Country TEXT,
    Province TEXT,
    Confirmed INTEGER,
    Deaths INTEGER,
    Recovered INTEGER,
    Active INTEGER
);

-- Sample Queries

-- 1. Top 10 Countries by Total Confirmed Cases
SELECT Country,
       MAX(Confirmed) AS TotalConfirmed
FROM covid_daily
GROUP BY Country
ORDER BY TotalConfirmed DESC
LIMIT 10;

-- 2. 7‑Day Moving Average of Daily New Confirmed Cases per Country
SELECT Country,
       Date,
       Confirmed - LAG(Confirmed) OVER (PARTITION BY Country ORDER BY Date) AS new_cases,
       AVG(Confirmed - LAG(Confirmed) OVER (PARTITION BY Country ORDER BY Date))
         OVER (PARTITION BY Country ORDER BY Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
         AS moving_avg_7d
FROM covid_daily
ORDER BY Country, Date;

-- 3. Global Daily New Cases and Death Rate
SELECT Date,
       SUM(Confirmed - LAG(Confirmed) OVER (ORDER BY Date)) AS global_new_cases,
       SUM(Deaths - LAG(Deaths) OVER (ORDER BY Date)) AS global_new_deaths,
       CASE WHEN SUM(Confirmed - LAG(Confirmed) OVER (ORDER BY Date)) = 0
            THEN 0
            ELSE ROUND(
               100.0 * SUM(Deaths - LAG(Deaths) OVER (ORDER BY Date)) /
               SUM(Confirmed - LAG(Confirmed) OVER (ORDER BY Date)), 2)
       END AS death_rate_percent
FROM covid_daily
GROUP BY Date
ORDER BY Date;

-- 4. Rank Countries by Highest Single-Day New Cases
WITH daily_new AS (
  SELECT Country,
         Date,
         Confirmed - LAG(Confirmed) OVER (PARTITION BY Country ORDER BY Date) AS new_cases
  FROM covid_daily
)
SELECT Country, Date, new_cases,
       RANK() OVER (ORDER BY new_cases DESC) AS rank_by_newcases
FROM daily_new
WHERE new_cases IS NOT NULL
ORDER BY rank_by_newcases
LIMIT 10;
