-- Data has been imported into MySQL. To look at the first 100 rows:

SELECT *
FROM breast_cancer_raw
LIMIT 100;

-- Data Transformation

	-- Check for missing values
    
SELECT *
FROM breast_cancer_raw
WHERE Age IS NULL
OR Race IS NULL
OR `Marital Status` IS NULL
OR `T Stage` IS NULL
OR `N Stage` IS NULL
OR `6th Stage` IS NULL
OR differentiate IS NULL
OR Grade IS NULL
OR `A Stage` IS NULL
OR `Tumor Size` IS NULL
OR `Estrogen Status` IS NULL
OR `Progesterone Status` IS NULL
OR `Regional Node Examined` IS NULL
OR `Reginol Node Positive` IS NULL
OR `Survival Months` IS NULL
OR `Status` IS NULL;

-- Save clean table with formatted headers and without duplicates.

CREATE TABLE breast_cancer_clean AS
	SELECT DISTINCT
    Age AS age,
    Race AS race,
    `Marital Status` AS marital_status,
    `T Stage` AS t_stage,
    `N Stage` AS n_stage,
    `6th Stage` AS `6th_stage`,
    differentiate,
    Grade AS grade,
    `A Stage` AS a_stage,
    `Tumor Size` AS tumour_size,
    `Estrogen Status` AS estrogen_status,
    `Progesterone Status` AS progesterone_status,
    `Regional Node Examined` AS regional_nodes_examined,
    `Reginol Node Positive` AS regional_nodes_positive,
    `Survival Months` AS survival_months,
    `Status` AS `status`
FROM breast_cancer_raw;
    
-- View cleaned table

SELECT *
FROM breast_cancer_clean
LIMIT 100;

-- Exploratory Data Analysis

	-- 1. Alive vs Dead count
SELECT `status`, count(*) AS patient_count
FROM breast_cancer_clean
GROUP BY `status`;

	-- 2. Most Common Race
SELECT race, count(*) AS patient_count
FROM breast_cancer_clean
GROUP BY race
ORDER BY patient_count DESC
LIMIT 1;

	-- 3. Most Common T-stage
SELECT t_stage, count(*) AS patient_count
FROM breast_cancer_clean
GROUP BY t_stage
ORDER BY patient_count DESC
LIMIT 1;

	-- 4. Average Age
SELECT
	ROUND(AVG(age),0) AS average_age
FROM breast_cancer_clean;

	-- 5. Tumour Size Distribution
SELECT ROUND(AVG(tumour_size),0) AS avg_tumour_size
FROM breast_cancer_clean;

	-- 6. Survival Period Range
SELECT
	MIN(survival_months) AS shortest_survival_period,
	MAX(survival_months) AS longest_survival_period
FROM breast_cancer_clean;

-- Trends & Patterns

	-- 7. Average Age By Status
SELECT
	`status`,
    ROUND(AVG(age),0) AS avg_age
FROM
	breast_cancer_clean
GROUP BY
	`status`;
    
	-- 8. Average Tumour Size By Status
SELECT
	`status`,
    ROUND(AVG(tumour_size)) AS avg_tumour_size
FROM
	breast_cancer_clean
GROUP BY
	`status`;
    
	-- 9. Most Occuring Cancer Grade by Status
SELECT
	`status`,
    grade, grade_frequency
FROM
	(
    SELECT `status`, grade, COUNT(*) AS grade_frequency, RANK() OVER(PARTITION BY `status` ORDER BY COUNT(*) DESC) AS grade_rank
    FROM breast_cancer_clean
    GROUP BY
	`status`,grade
    ) AS ranked_grades
WHERE grade_rank = 1;
    
    -- 10. Patients with Tumours Larger Than 50mm.
SELECT
	COUNT(*) AS patient_count
FROM
	breast_cancer_clean
WHERE
	tumour_size > 50;
    
    -- 11. Patients with atleast 1 positive lymph node. 
SELECT
	COUNT(*) AS patient_count
FROM
	breast_cancer_clean
WHERE regional_nodes_positive > 0;

-- Relationships

	-- 12. Race & Survival Rates
SELECT 
    Race,
    SUM(CASE WHEN Status = 'Alive' THEN 1 ELSE 0 END) AS alive_count,
    SUM(CASE WHEN Status = 'Dead' THEN 1 ELSE 0 END) AS dead_count,
    ROUND(
        (SUM(CASE WHEN Status = 'Alive' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2
	) AS survival_rate_percent
FROM
	breast_cancer_clean
GROUP BY
	race
ORDER BY
	survival_rate_percent DESC;

	-- 13. Survival Time Based on Estrogen Status
SELECT
	estrogen_status,
    ROUND(AVG(survival_months),0) AS avg_survival_time
FROM
	breast_cancer_clean
GROUP BY estrogen_status;

	-- 14.	Hormone Status vs. Differentiation & Grade.
SELECT
	estrogen_status,
    progesterone_status,
    differentiate,
    grade,
    COUNT(*) AS case_count
FROM
	breast_cancer_clean
GROUP BY
	estrogen_status,
    progesterone_status,
    differentiate,
    grade
ORDER BY
	case_count DESC;
    
-- Possible Risk Factors

	-- 15. Age Group With Highest Survival Rate
SELECT 
    CONCAT(
        FLOOR((Age - 21) / 5) * 5 + 21, 
        '-', 
        FLOOR((Age - 21) / 5) * 5 + 25
    ) AS age_group,
    SUM(CASE WHEN Status = 'Alive' THEN 1 ELSE 0 END) AS alive_count,
    COUNT(*) AS total_cases,
    ROUND((SUM(CASE WHEN Status = 'Alive' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS survival_rate_percent
FROM
	breast_cancer_clean
GROUP BY
	age_group
ORDER BY
	survival_rate_percent DESC, alive_count DESC;

	-- 16. Stages Associated With Mortality
SELECT 
    `6th_Stage` AS stage,
    SUM(CASE WHEN Status = 'Dead' THEN 1 ELSE 0 END) AS dead_count,
    COUNT(*) AS total_cases,
    ROUND((SUM(CASE WHEN Status = 'Dead' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS mortality_rate_percent
FROM breast_cancer_clean
GROUP BY stage
ORDER BY mortality_rate_percent DESC, dead_count DESC;