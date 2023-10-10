-- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)? --

-- Výpočet procentuální změny ceny produktu Y-o-Y --
WITH yearly_data AS (
    SELECT
        cp.category_code,
        cpc.name,
        YEAR(cp.date_to) AS year,
        AVG(cp.value) AS average_price,
        LAG(AVG(cp.value)) OVER (PARTITION BY cp.category_code ORDER BY YEAR(cp.date_to)) AS prev_year_avg_price
    FROM
        czechia_price cp
    JOIN
        czechia_price_category cpc ON cpc.code = cp.category_code
    GROUP BY
        cp.category_code, cpc.name, YEAR(cp.date_to)
)
SELECT
    category_code,
    name,
    year,
    ROUND(((average_price - prev_year_avg_price) / prev_year_avg_price) * 100, 2) AS 'Yearly_Price_Percent_Change'
FROM
    yearly_data
;


-- výpočet procentuální změny průměrné mzdy Y-o-Y --
WITH yearly_wage_data AS (
	SELECT
    	cp.payroll_year AS 'Year',
    	ROUND(AVG(cp.value), 0) AS 'Average_Wage',
    	LAG(ROUND(AVG(cp.value), 0), 1) OVER (ORDER BY cp.payroll_year) AS 'Previous_Average_Wage'
	FROM
    	czechia_payroll cp
	JOIN
    	czechia_payroll_industry_branch cpib ON cpib.code = cp.industry_branch_code
	WHERE
    	unit_code = 200 AND cp.calculation_code = 200
	GROUP BY
   		cp.payroll_year
	ORDER BY
   		cp.payroll_year
)
SELECT 
	Year,
	ROUND(((Average_Wage - Previous_Average_Wage) / Previous_Average_Wage) * 100, 2) AS 'Yearly_Wage_Percent_Change'
FROM 
	yearly_wage_data
;

-- srovnání nárůstu průměrné mzdy v % a průměrné ceny produktů v % v jednotlivých letech --
-- označení rozdílů o více než 10% jako "Ano" --

WITH yearly_wage_data AS (
    SELECT
        cp.payroll_year AS 'Year',
        ROUND(AVG(cp.value), 0) AS 'Average_Wage',
        LAG(ROUND(AVG(cp.value), 0), 1) OVER (ORDER BY cp.payroll_year) AS 'Previous_Average_Wage'
    FROM
        czechia_payroll cp
    JOIN
        czechia_payroll_industry_branch cpib ON cpib.code = cp.industry_branch_code
    WHERE
        unit_code = 200 AND cp.calculation_code = 200
    GROUP BY
        cp.payroll_year
),
yearly_price_data AS (
    SELECT
        cp.category_code,
        cpc.name,
        YEAR(cp.date_to) AS year,
        AVG(cp.value) AS average_price,
        LAG(AVG(cp.value)) OVER (PARTITION BY cp.category_code ORDER BY YEAR(cp.date_to)) AS prev_year_avg_price
    FROM
        czechia_price cp
    JOIN
        czechia_price_category cpc ON cpc.code = cp.category_code
    WHERE 
		region_code IS NULL
    GROUP BY
        cp.category_code, cpc.name, YEAR(cp.date_to)
)
SELECT
    w.Year,
    ROUND(((w.Average_Wage - w.Previous_Average_Wage) / w.Previous_Average_Wage) * 100, 2) 
    	AS 'Yearly_Wage_Percent_Change',
    p.name,
    ROUND(((p.average_price - p.prev_year_avg_price) / p.prev_year_avg_price) * 100, 2) 
    	AS 'Yearly_Price_Percent_Change',
    ROUND((((p.average_price - p.prev_year_avg_price) / p.prev_year_avg_price) - ((w.Average_Wage - w.Previous_Average_Wage) / w.Previous_Average_Wage)) * 100, 2) 
    	AS 'Price_Wage_Difference',
    CASE
        WHEN ROUND((((p.average_price - p.prev_year_avg_price) / p.prev_year_avg_price) - ((w.Average_Wage - w.Previous_Average_Wage) / w.Previous_Average_Wage)) * 100, 2) > "10" THEN 'Ano'
        ELSE 'Ne'
    END AS 'Difference_Higher_Than_10%'
FROM
    yearly_wage_data w
JOIN
    yearly_price_data p ON w.Year = p.year
ORDER BY
    w.YEAR
;
