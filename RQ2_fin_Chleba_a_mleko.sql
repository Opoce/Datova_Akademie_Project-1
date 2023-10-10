-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd? --

--  111301 Chléb, 114201 Mléko --

SELECT
	YEAR,
    Quarter,
    Food_category_name,
    ROUND(AVG(Average_price), 2) AS 'Average_Price',
    ROUND(AVG(Wage), 0) AS 'Average_Wage',
    ROUND(AVG(Wage) / AVG(Average_price), 2) AS 'Average_Wage_to_Average_Price_Ratio'
FROM
	t_daniela_cerna_project_sql_primary_final tdcpspf 
WHERE
	Food_category_code = 111301 OR 
	Food_category_code = 114201
GROUP BY
	Food_category_name,
	YEAR,
	Quarter
ORDER BY
	Food_category_name,
	year ASC,
	quarter ASC  
;


