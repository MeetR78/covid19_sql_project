
-- country_latest_queries.sql

-- Table Creation
CREATE TABLE country_latest (
    Country TEXT,
    Confirmed INTEGER,
    Deaths INTEGER,
    Recovered INTEGER,
    Active INTEGER,
    New_cases INTEGER,
    New_deaths INTEGER,
    New_recovered INTEGER,
    Deaths_per_100_Cases REAL,
    Recovered_per_100_Cases REAL,
    Deaths_per_100_Recovered REAL,
    Confirmed_last_week INTEGER,
    Week_change INTEGER,
    Week_percent_increase REAL,
    WHO_Region TEXT
);

-- Sample Queries

-- 1. Death Rate & Recovery Rate per Country
SELECT Country,
       Confirmed,
       Deaths,
       Recovered,
       ROUND(100.0 * Deaths / Confirmed, 2) AS death_rate_percent,
       ROUND(100.0 * Recovered / Confirmed, 2) AS recovery_rate_percent
FROM country_latest
WHERE Confirmed > 0
ORDER BY death_rate_percent DESC
LIMIT 10;

-- 2. Infected Population % (Assuming Population column exists)
-- SELECT Country,
--        Population,
--        Confirmed,
--        ROUND(100.0 * Confirmed / Population, 2) AS infected_percent
-- FROM country_latest
-- WHERE Population IS NOT NULL AND Population > 0
-- ORDER BY infected_percent DESC
-- LIMIT 10;

-- 3. Countries with Highest Weekly Case Increase
SELECT Country,
       Confirmed,
       Confirmed_last_week,
       Week_change,
       Week_percent_increase
FROM country_latest
ORDER BY Week_percent_increase DESC
LIMIT 10;

-- 4. Top 10 Countries by New Cases Today
SELECT Country,
       New_cases,
       New_deaths,
       New_recovered
FROM country_latest
ORDER BY New_cases DESC
LIMIT 10;
