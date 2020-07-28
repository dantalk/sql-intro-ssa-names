.bail on
.echo on
.headers on
DROP TABLE IF EXISTS national;
CREATE TABLE national(
  "year" INTEGER,
  "name" TEXT,
  "sex" TEXT,
  "count" INTEGER
);

---------------
-- import stuff
.mode csv
.import data/compiled/ssa-national-all-years.csv national

--------------
-- Index stuff
CREATE INDEX "name_sex_idx_national" ON national(name, sex);
CREATE INDEX "year_idx_national" ON national(year);
CREATE INDEX "year_name_national" ON national(year, name);


.changes on
---------------------------------------------------------
-- because .import brings in the table header, we need to
-- manually delete it
DELETE FROM national WHERE "year" = 'year' AND "count" = 'count';
.changes off




--------------------------
-- Inventory count by year

.mode line

SELECT
    COUNT(1) AS "total names by year"
FROM national;


.mode column

SELECT year
    , COUNT(1) AS "name count"
    , SUM(count) AS "record count"
FROM national
GROUP BY year
ORDER BY year DESC
LIMIT 5;



----------------------------------
-- Most popular female and male names
WITH tgroups AS (
    SELECT name
        , sex
        , SUM(count) AS count
    FROM national
    GROUP BY name, sex
    ORDER BY count DESC, sex ASC
), top_f AS (
    SELECT * FROM tgroups WHERE sex = 'F' LIMIT 5
), top_m AS (
    SELECT * FROM tgroups WHERE sex = 'M' LIMIT 5
)
SELECT * FROM top_f
UNION ALL
SELECT * FROM top_m
;
