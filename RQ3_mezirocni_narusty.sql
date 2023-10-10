-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? --

-- pro přehled meziročních nárůstů Y-o-Y ve všech kategoriích --
SELECT 
    category_code,
    name,
    CAST(SUBSTRING(CONCAT(YEAR(date_to), ' Q', CEILING(MONTH(date_to) / 3.0)), 1, 4) AS INT) AS 'year',
    ROUND(AVG(cp.value), 2) AS 'Average_Price',
    LAG(ROUND(AVG(cp.value), 2)) OVER (PARTITION BY cp.category_code 
    ORDER BY YEAR(date_to)) AS 'prev_year_avg_price'
FROM czechia_price cp 
JOIN czechia_price_category cpc ON cpc.code = cp.category_code 
WHERE 
	region_code IS NULL
GROUP BY 
    category_code,
    YEAR(date_to)
;

-- pro srovnání procentuálních nárůstů ve srovnání průměrné ceny v prvním a posledním roce ve všech kategoriích --
-- vzestupně --

WITH yearly_data AS (
    SELECT
        cp.category_code,
        cpc.name,
        YEAR(cp.date_to) AS year,
        AVG(cp.value) AS average_price,
        ROW_NUMBER() OVER (PARTITION BY cp.category_code 
        	ORDER BY YEAR(cp.date_to)) AS row_num_asc,
        ROW_NUMBER() OVER (PARTITION BY cp.category_code 
        	ORDER BY YEAR(cp.date_to) DESC) AS row_num_desc
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
    category_code,
    name,
    MIN(year) AS 'First_Year',
    MAX(year) AS 'Last_Year',
    AVG(CASE WHEN row_num_asc = 1 THEN average_price END) AS 'Average_Price_First_Year',
    AVG(CASE WHEN row_num_desc = 1 THEN average_price END) AS 'Average_Price_Last_Year',
    ROUND(((AVG(CASE WHEN row_num_desc = 1 THEN average_price END) - AVG(CASE WHEN row_num_asc = 1 THEN average_price END)) 
    / AVG(CASE WHEN row_num_asc = 1 THEN average_price END)) * 100, 2) AS 'Percent_Change_First_Last_Year'
FROM
    yearly_data
GROUP BY
    category_code, name
ORDER BY Percent_Change_First_Last_Year ASC
;
