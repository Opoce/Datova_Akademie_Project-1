-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd? --

--  111301 Chléb, 114201 Mléko --

SELECT
	CAST(SUBSTRING(CONCAT(YEAR(date_to), ' Q', CEILING(MONTH(date_to) / 3.0)), 1, 4) AS INT) AS Year,
    CAST(SUBSTRING(CONCAT(YEAR(date_to), ' Q', CEILING(MONTH(date_to) / 3.0)), 7, 2) AS INT) AS Quarter,
    CASE
		WHEN category_code = 111301 THEN 'Chléb'
		WHEN category_code = 114201 THEN 'Mléko'
	END AS Category_Name,
    ROUND(AVG(cp.value), 2) AS 'Average_Price',
    ROUND(AVG(cp2.value), 0) AS 'Average_Wage',
    ROUND(AVG(cp2.value) / AVG(cp.value), 2) AS 'Average_Wage_to_Average_Price_Ratio'
FROM
	czechia_price cp
JOIN czechia_payroll cp2 ON cp2.payroll_year = YEAR (cp.date_to) AND cp2.payroll_quarter = quarter (cp.date_to)
WHERE
	(category_code = 111301
		OR category_code = 114201)
	AND region_code IS NULL
	AND cp2.unit_code = 200 
	AND cp2.calculation_code = 200
GROUP BY
	category_code,
	CONCAT(YEAR(date_to), ' Q', CEILING(MONTH(date_to) / 3.0))
ORDER BY
	category_code,
	year ASC,
	quarter ASC  
;
