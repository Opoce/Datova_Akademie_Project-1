-- tabulka pro dodatečná data o dalších evropských státech --

CREATE OR REPLACE TABLE t_Daniela_Cerna_project_SQL_secondary_final  (
	YEAR INT,
	Country VARCHAR(255),
	GDP DOUBLE,
	GINI DOUBLE,
	Population DOUBLE
)
;

INSERT INTO t_daniela_cerna_project_sql_secondary_final 
	SELECT
    e.YEAR AS Year,
    c.Country AS Country,
    e.GDP AS GDP,
    e.gini AS GINI,
    c.population AS Population
FROM
    economies e
JOIN
    countries c ON c.country = e.country
WHERE
    c.continent = 'Europe' AND 
    e.YEAR BETWEEN 2006 AND 2018
ORDER BY
    e.Year ASC;
;
