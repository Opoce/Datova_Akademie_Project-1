--Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?--


SELECT
    cpib.name AS 'Sector_name',
    cp.industry_branch_code AS 'Sector',
    ROUND(AVG(cp.value), 0) AS 'Average_Wage',
    cp.payroll_year AS 'Year',
    LAG(ROUND(AVG(cp.value), 0), 1) OVER (PARTITION BY cp.industry_branch_code 
    ORDER BY cp.payroll_year) AS 'Previous_Average_Wage',
    CASE
        WHEN ROUND(AVG(cp.value), 0) > LAG(ROUND(AVG(cp.value), 0), 1) 
        OVER (PARTITION BY cp.industry_branch_code ORDER BY cp.payroll_year) THEN 'Roste'
        WHEN ROUND(AVG(cp.value), 0) < LAG(ROUND(AVG(cp.value), 0), 1) 
        OVER (PARTITION BY cp.industry_branch_code ORDER BY cp.payroll_year) THEN 'Klesá'
        ELSE 'Bez změny'
    END AS 'Comparison'
FROM
    czechia_payroll cp
JOIN
    czechia_payroll_industry_branch cpib ON cpib.code = cp.industry_branch_code
WHERE
    unit_code = 200 AND cp.calculation_code = 200
GROUP BY
    cp.industry_branch_code, cp.payroll_year
ORDER BY
    cp.industry_branch_code, cp.payroll_year;
