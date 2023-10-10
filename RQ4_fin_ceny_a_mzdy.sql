-- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)? --


-- srovnání nárůstu průměrné mzdy v % a průměrné ceny produktů v % v jednotlivých letech --
-- označení rozdílů o více než 10% jako "Ano" --

WITH yearly_wage_data AS (
    SELECT
        Year,
        ROUND(AVG(Wage), 0) AS 'Average_Wage',
        LAG(ROUND(AVG(Wage), 0), 1) OVER (ORDER BY Year) AS 'Previous_Average_Wage'
    FROM
        t_daniela_cerna_project_sql_primary_final
    GROUP BY
        Year
),
yearly_price_data AS (
    SELECT
        Food_category_code,
        Food_category_name,
        Year,
        AVG(Average_price) AS average_price,
        LAG(AVG(Average_price)) OVER (PARTITION BY Food_category_code ORDER BY YEAR) AS prev_year_avg_price
    FROM
        t_daniela_cerna_project_sql_primary_final
    GROUP BY
        Food_category_code, Food_category_name, Year
)
SELECT
    w.Year,
    ROUND(((w.Average_Wage - w.Previous_Average_Wage) / w.Previous_Average_Wage) * 100, 2) 
    	AS 'Yearly_Wage_Percent_Change',
    p.Food_category_name,
    ROUND(((p.Average_price - p.prev_year_avg_price) / p.prev_year_avg_price) * 100, 2) 
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
