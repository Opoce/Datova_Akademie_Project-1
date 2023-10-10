-- Má výška HDP vliv na změny ve mzdách a cenách potravin? -- 
-- Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem? --

-- výpočet procentuální změny HDP Y-o-Y --
WITH gdp_data AS (
    SELECT
        YEAR,
        country,
        GDP,
        LAG(GDP) OVER (ORDER BY YEAR) AS prev_year_gdp
    FROM
        economies e 
    WHERE
        e.country = 'Czech Republic'
    ORDER BY
        YEAR ASC
)
SELECT
    YEAR,
    country,
    GDP,
    ROUND(((GDP - prev_year_gdp) / prev_year_gdp) * 100, 2) AS 'GDP_Percent_Change'
FROM
    gdp_data
;

-- porovnání změn(%) ve mzdách, cenách po kategoriích a HDP Y-o-Y --
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
),
gdp_data AS (
    SELECT
        YEAR,
        country,
        GDP,
        LAG(GDP) OVER (ORDER BY YEAR) AS prev_year_gdp
    FROM
        economies e 
    WHERE
        country = 'Czech Republic'
    ORDER BY
        YEAR ASC
)
SELECT
    w.Year,
    ROUND(((w.Average_Wage - w.Previous_Average_Wage) / w.Previous_Average_Wage) * 100, 2) AS 'Yearly_Wage_Percent_Change',
    p.name AS "Category_Name",
    ROUND(((p.average_price - p.prev_year_avg_price) / p.prev_year_avg_price) * 100, 2) AS 'Yearly_Price_Percent_Change_Per_Category',
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
        YEAR(cp.date_to) AS year,
        AVG(cp.value) AS average_price,
        LAG(AVG(cp.value)) OVER (ORDER BY YEAR(cp.date_to)) AS prev_year_avg_price
    FROM
        czechia_price cp
    JOIN
        czechia_price_category cpc ON cpc.code = cp.category_code
    WHERE 
		region_code IS NULL
    GROUP BY
        YEAR(cp.date_to)
),
gdp_data AS (
    SELECT
        YEAR,
        country,
        GDP,
        LAG(GDP) OVER (ORDER BY YEAR) AS prev_year_gdp
    FROM
        economies e 
    WHERE
        country = 'Czech Republic'
    ORDER BY
        YEAR ASC
)
SELECT
    w.Year,
    ROUND(((w.Average_Wage - w.Previous_Average_Wage) / w.Previous_Average_Wage) * 100, 2) AS 'Yearly_Wage_Percent_Change',
    ROUND(((p.average_price - p.prev_year_avg_price) / p.prev_year_avg_price) * 100, 2) AS 'Yearly_Price_Percent_Change',
    ROUND(((g.GDP - g.prev_year_gdp) / g.prev_year_gdp) * 100, 2) AS 'GDP_Percent_Change'
FROM
    yearly_wage_data w
JOIN
    yearly_price_data p ON w.Year = p.year
JOIN
    gdp_data g ON w.Year = g.YEAR
ORDER BY
    w.Year;
