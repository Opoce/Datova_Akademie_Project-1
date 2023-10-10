-- Má výška HDP vliv na změny ve mzdách a cenách potravin? -- 
-- Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem? --


-- porovnání změn(%) ve mzdách, cenách po kategoriích a HDP Y-o-Y --
WITH yearly_wage_data AS (
    SELECT
        year,
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
        AVG(Average_price) AS Average_price,
        LAG(AVG(Average_price)) OVER (PARTITION BY Food_category_code ORDER BY YEAR) AS prev_year_avg_price
    FROM
        t_daniela_cerna_project_sql_primary_final
    GROUP BY
        Food_category_code, Food_category_name, Year
),
gdp_data AS (
    SELECT
        YEAR,
        country,
        GDP,
        LAG(GDP) OVER (ORDER BY YEAR) AS prev_year_gdp
    FROM
        t_daniela_cerna_project_sql_secondary_final
    WHERE
        country = 'Czech Republic'
    ORDER BY
        YEAR ASC
)
SELECT
    w.Year,
    ROUND(((w.Average_Wage - w.Previous_Average_Wage) / w.Previous_Average_Wage) * 100, 2) AS 'Yearly_Wage_Percent_Change',
    p.Food_category_name AS "Food_Category_Name",
    ROUND(((p.Average_price - p.prev_year_avg_price) / p.prev_year_avg_price) * 100, 2) AS 'Yearly_Price_Percent_Change_Per_Category',
    ROUND(((g.GDP - g.prev_year_gdp) / g.prev_year_gdp) * 100, 2) AS 'GDP_Percent_Change'
FROM
    yearly_wage_data w
JOIN
    yearly_price_data p ON w.Year = p.year
JOIN
    gdp_data g ON w.Year = g.YEAR
ORDER BY
    w.YEAR
;


-- porovnání změn(%) ve mzdách, průměrných cenách a HDP Y-o-Y --
WITH yearly_wage_data AS (
    SELECT
        year,
        ROUND(AVG(Wage), 0) AS 'Average_Wage',
        LAG(ROUND(AVG(Wage), 0), 1) OVER (ORDER BY Year) AS 'Previous_Average_Wage'
    FROM
        t_daniela_cerna_project_sql_primary_final
    GROUP BY
        Year
),
yearly_price_data AS (
    SELECT
        Year,
        AVG(Average_price) AS Average_price,
        LAG(AVG(Average_price)) OVER (ORDER BY YEAR) AS prev_year_avg_price
    FROM
        t_daniela_cerna_project_sql_primary_final
    GROUP BY
        Year
),
gdp_data AS (
    SELECT
        YEAR,
        country,
        GDP,
        LAG(GDP) OVER (ORDER BY YEAR) AS prev_year_gdp
    FROM
        t_daniela_cerna_project_sql_secondary_final
    WHERE
        country = 'Czech Republic'
    ORDER BY
        YEAR ASC
)
SELECT
    w.Year,
    ROUND(((w.Average_Wage - w.Previous_Average_Wage) / w.Previous_Average_Wage) * 100, 2) 
    AS 'Yearly_Wage_Percent_Change',
    ROUND(((p.Average_price - p.prev_year_avg_price) / p.prev_year_avg_price) * 100, 2) 
    AS 'Yearly_Price_Percent_Change',
    ROUND(((g.GDP - g.prev_year_gdp) / g.prev_year_gdp) * 100, 2) 
    AS 'GDP_Percent_Change'
FROM
    yearly_wage_data w
JOIN
    yearly_price_data p ON w.Year = p.year
JOIN
    gdp_data g ON w.Year = g.YEAR
ORDER BY
    w.YEAR
;


