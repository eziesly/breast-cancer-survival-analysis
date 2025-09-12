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

