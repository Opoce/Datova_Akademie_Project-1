--Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?--


SELECT  
	cpib.name AS 'Sector_name',
	cp.industry_branch_code AS 'Sector',
	round(avg(cp.value),0) AS 'Average_Wage',
	cp.payroll_year AS 'Year'
FROM czechia_payroll cp
JOIN czechia_payroll_industry_branch cpib 
	ON cpib.code = industry_branch_code 
WHERE unit_code = 200 AND cp.calculation_code = 200
GROUP BY cpib.name, cp.industry_branch_code, cp.payroll_year
;
-- ještě přidat flag na kontrolu navýšení průměrné mzdy Y-o-Y--

--kontrolní vzorek pro výpočet u vybraného sektoru--
SELECT
	cp.industry_branch_code,
	cp.payroll_year,
	count(cp.value_type_code),
	avg(cp.value)
FROM czechia_payroll cp 
WHERE cp.industry_branch_code = 'A' AND cp.calculation_code = 200 AND value_type_code = 5958
GROUP BY cp.payroll_year; 