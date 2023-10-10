--Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?--


SELECT
    Year,
    Sector_name,
    Industry_code AS 'Sector',
    ROUND(AVG(Wage), 0) AS 'Average_Wage',
    LAG(ROUND(AVG(Wage), 0), 1) OVER (PARTITION BY industry_code 
    ORDER BY Year) AS 'Previous_Average_Wage',
    CASE
        WHEN ROUND(AVG(Wage), 0) > LAG(ROUND(AVG(Wage), 0), 1) 
        OVER (PARTITION BY industry_code ORDER BY Year) THEN 'Roste'
        WHEN ROUND(AVG(Wage), 0) < LAG(ROUND(AVG(Wage), 0), 1) 
        OVER (PARTITION BY industry_code ORDER BY Year) THEN 'Klesá'
        ELSE 'Bez změny'
    END AS 'Comparison'
FROM
    t_daniela_cerna_project_sql_primary_final tdcpspf 
GROUP BY
    industry_code, Year
ORDER BY
    Industry_code, Year;
