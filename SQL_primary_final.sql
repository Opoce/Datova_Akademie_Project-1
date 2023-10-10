-- Tabulka pro mzdy a ceny potravin za Českou republiku sjednocené na totožné porovnatelné období – společné roky --

CREATE OR REPLACE TABLE t_Daniela_Cerna_project_SQL_primary_final (
	YEAR INT,
	Quarter INT,
	Food_category_code INT,
	Food_category_name VARCHAR(255),
	Average_price FLOAT(4),
	Wage INT,
	Industry_code VARCHAR(1),
	Sector_name VARCHAR(255)
);

INSERT INTO t_Daniela_Cerna_project_SQL_primary_final
SELECT
    CAST(SUBSTRING(CONCAT(YEAR(cp.date_to), ' Q', CEILING(MONTH(cp.date_to) / 3.0)), 1, 4) AS INT) AS Year,
    CAST(SUBSTRING(CONCAT(YEAR(cp.date_to), ' Q', CEILING(MONTH(cp.date_to) / 3.0)), 7, 2) AS INT) AS Quarter,
    cp.category_code AS Food_category_code,
    cpc.name AS Food_category_name,
    ROUND(AVG(cp.value), 2) AS Average_price,
    cp2.value AS Wage,
    cp2.industry_branch_code AS Industry_code,
    cpib.name AS Sector_name
FROM
    czechia_price cp
JOIN
    czechia_payroll cp2 ON cp2.payroll_year = YEAR(cp.date_to) AND cp2.payroll_quarter = QUARTER(cp.date_to)
JOIN
    czechia_payroll_industry_branch cpib ON cpib.code = cp2.industry_branch_code
JOIN
    czechia_price_category cpc ON cpc.code = cp.category_code 
WHERE
    region_code IS NULL
    AND cp2.unit_code = 200 
    AND cp2.calculation_code = 200
GROUP BY
    YEAR(cp.date_to),
    QUARTER(cp.date_to),
    cp.category_code,
    cpc.name,
    cp2.value,
    cp2.industry_branch_code,
    cpib.name 
ORDER BY
    Year ASC,
    Quarter ASC
;

