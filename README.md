# Breast Cancer Survival Analysis
This repository houses files containing the SQL queries, notes and visuals used to analyse a public breast cancer dataset. The analysis explores demographic and clinical predictors of survival (age, tumour size, grade, AJCC stage, Estrogen receptor/Progesterone receptor status) and produces visual dashboards  summarising major insights.

---

## Project Objectives
1. To gain baseline insights on survival status, demographics, tumour features, and survival range.
2. To identify trends and patterns in the dataset by comparing age, tumour size, grade, and nodal involvement across survival groups.
3. To identify relationships between groups and disease progression and outcomes by analysing race, hormone receptor status, and grade in relation to survival outcomes.
4. To observe disease risk factors by identifying age groups and stages most strongly linked to survival or mortality.

---

## Data Source
The dataset used in this project was downloaded as a CSV file from [Kaggle](https://www.kaggle.com/datasets/abdelrahmanmohamed75/breast-cancer?select=Breast_Cancer.csv)

## Analytic Tools
| Analytic Tool | Function |
|---------------|----------|
| MySQL | For cleaning, normalising, and analysing data |
| Power BI | Visualising  insights gained from SQL queries |
| Microsoft Powerpoint | Building a presentation for the project |
| Maria DB Connector | Open database connector (ODBC) for connecting MySQL database to Power BI for importing insights directly |
| Github | Documenting analysis process and sharing project files |

---

## Project Files
| File | Content |
|------|--------|
| `breast_cancer_raw.csv` | Dataset downloaded from Kaggle |
| `breast_cancer_cleaned.csv` | Final table obtained after cleaning and normalisation |
| `breast_cancer_project.sql` | SQL text file containing all queries used in the project |
| `breast_cancer_dashboard_page1` | Power BI dashboard 1 saved in JPG format |
| `breast_cancer_dashboard_page2` | Power BI dashboard 2 saved in JPG format |
| `breast_cancer_report.pptx` | Powerpoint presentation file for the project |
| `breast_cancer_report.pdf` | Powerpont presentation file saved in PDF format |

---

## The Data Analysis Process

### Importation and Cleaning

Created a new schema `breast_cancer` and imported the data downloaded from Kagggle in CSV format using the Data table import wizard.

This automatically created the table `breast_cancer_raw` in the schema, filled in the table contents and detected the data types for all columns. The table has 2024 entries(rows).

#### Viewing the table
```
SELECT *
FROM breast_cancer_raw
LIMIT 100;
```

### Data Transformation

#### Checking for missing values
```
SELECT*
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
```
This query did not return any result, showing that all fields were filled with data.

#### Saving the clean table with formatted headers and without duplicates.
```
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
```
This query created a new table `breast+_cancer_clean` with standardised headers and no duplicates. The table has only 4004 entries, showing that 20 entries(rows) in the raw table were duplicates.

#### Viewing cleaned table
```
SELECT *
FROM breast_cancer_clean
LIMIT 100;
```

### Exploratory Data Analysis

#### 1. Alive vs Dead count
```
SELECT `status`, count(*) AS patient_count
FROM breast_cancer_clean
GROUP BY `status`;
```

#### 2. Most Common Race
```
SELECT race, count(*) AS patient_count
FROM breast_cancer_clean
GROUP BY race
ORDER BY patient_count DESC
LIMIT 1;
```

#### 3. Most Common T-stage
```
SELECT t_stage, count(*) AS patient_count
FROM breast_cancer_clean
GROUP BY t_stage
ORDER BY patient_count DESC
LIMIT 1;
```

#### 4. Average Age
```
SELECT
	ROUND(AVG(age),0) AS average_age
FROM breast_cancer_clean;
```

#### 5. Tumour Size Distribution
```
SELECT ROUND(AVG(tumour_size),0) AS avg_tumour_size
FROM breast_cancer_clean;
```

#### 6. Survival Period Range
```
SELECT
	MIN(survival_months) AS shortest_survival_period,
	MAX(survival_months) AS longest_survival_period
FROM breast_cancer_clean;
```

### Trends & Patterns

#### 7. Average Age By Status
```
SELECT
	`status`,
    ROUND(AVG(age),0) AS avg_age
FROM
	breast_cancer_clean
GROUP BY
	`status`;
```
    
#### 8. Average Tumour Size By Status
```
SELECT
	`status`,
    ROUND(AVG(tumour_size)) AS avg_tumour_size
FROM
	breast_cancer_clean
GROUP BY
	`status`;
```
    
#### 9. Most Occuring Cancer Grade by Status
```
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
```
    
#### 10. Patients with Tumours Larger Than 50mm.
```
SELECT
	COUNT(*) AS patient_count
FROM
	breast_cancer_clean
WHERE
	tumour_size > 50;
```
    
#### 11. Patients with atleast 1 positive lymph node. 
```
SELECT
	COUNT(*) AS patient_count
FROM
	breast_cancer_clean
WHERE regional_nodes_positive > 0;
```

### Relationships

#### 12. Race & Survival Rates
```
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
```

#### 13. Survival Time Based on Estrogen Status
```
SELECT
	estrogen_status,
    ROUND(AVG(survival_months),0) AS avg_survival_time
FROM
	breast_cancer_clean
GROUP BY estrogen_status;
```

#### 14.	Hormone Status vs. Differentiation & Grade.
```
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
```
    
### Possible Risk Factors

#### 15. Age Group With Highest Survival Rate
```
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
```

#### 16. Stages Associated With Mortality
```
SELECT 
    `6th_Stage` AS stage,
    SUM(CASE WHEN Status = 'Dead' THEN 1 ELSE 0 END) AS dead_count,
    COUNT(*) AS total_cases,
    ROUND((SUM(CASE WHEN Status = 'Dead' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS mortality_rate_percent
FROM breast_cancer_clean
GROUP BY stage
ORDER BY mortality_rate_percent DESC, dead_count DESC;
```

---

## Visualisation

### Connecting MySQl Database to PowerBI
For a detailed description on this, watch the [youtube video](https://youtu.be/EL3DdMVAUnQ?si=4QM_euTpgzioCcTD)

### Importing Queries into PowerBI
After the database has been successfully connected to PowerBI, the queries were introduced to the workspace.
Using  power query advanced editor, The queries were imported and saved as individual tables, Each table being the same as the result MySQl provided.

In Power Query Advanced Editor, the queries are witten in the following format:

```
let
    Source = Odbc.Query("dsn=YourDSN", "sql_query")
in
    Source
```

For example, here is the query for Alive vs Dead count:
```
let
    Source = Odbc.Query("dsn=maria_db",
    "SELECT status, COUNT(*) AS patient_count
     FROM breast_cancer.breast_cancer_clean
     GROUP BY status;")
in
    Source
```

---

## Key Insights Uncovered
- Survival patterns in this dataset show higher survival among younger patients with smaller tumours and early AJCC stage.
- Mortality increases with stage and tumour size.
- Estrogen receptor and Progesterone receptor positivity is a favourable prognostic indicator and guides treatment decisions.
- Racial categorisations and missing clinical variables limit deeper exploration of disparities and treatment effects.
  
For all insights, view the presentation in the `breast_cancer_report.pptx` or `breast_cancer_report.pdf` file.

---

### ✍️ Author

**Onyedika Sylvester Chikezie**

Health and Environmental Data Analyst

**Connect with me**

On [Linkedin](https://www.linkedin.com/in/onyedika-chikezie-55978a21a/)

Or

Via email: chikeziesly@gmail.com

