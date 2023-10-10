-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? --


-- pro srovnání procentuálních nárůstů ve srovnání průměrné ceny v prvním a posledním roce ve všech kategoriích --
-- vzestupně --

WITH yearly_data AS (
    SELECT
        Food_category_code,
        Food_category_name,
        YEAR,
        AVG(Average_price) AS 'Average_price',
        ROW_NUMBER() OVER (PARTITION BY Food_category_code 
        	ORDER BY YEAR) AS row_num_asc,
        ROW_NUMBER() OVER (PARTITION BY Food_category_code 
        	ORDER BY YEAR DESC) AS row_num_desc
    FROM
    t_daniela_cerna_project_sql_primary_final tdcpspf  
    GROUP BY
        Food_category_code, Food_category_name, YEAR
)
SELECT
    Food_category_code,
    food_category_name,
    MIN(year) AS 'First_Year',
    MAX(year) AS 'Last_Year',
    AVG(CASE WHEN row_num_asc = 1 THEN Average_price END) AS 'Average_Price_First_Year',
    AVG(CASE WHEN row_num_desc = 1 THEN Average_price END) AS 'Average_Price_Last_Year',
    ROUND(((AVG(CASE WHEN row_num_desc = 1 THEN Average_price END) - AVG(CASE WHEN row_num_asc = 1 THEN Average_price END)) 
    / AVG(CASE WHEN row_num_asc = 1 THEN Average_price END)) * 100, 2) AS 'Percent_Change_First_Last_Year'
FROM
    yearly_data
GROUP BY
    Food_category_code, Food_category_name
ORDER BY Percent_Change_First_Last_Year ASC
;
