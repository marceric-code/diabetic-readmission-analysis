**Diabetic Patient Readmission Analysis**

 **Overview**
This project looks at 30-day hospital readmission rates among diabetic patients using a dataset of over 100,000 hospital encounters across 130 US hospitals between 1999 and 2008. The goal was to identify which patient groups are most at risk of being readmitted within 30 days of discharge and present those findings in a clear, interactive dashboard.

**Why This Matters** 
Hospitals in the US are financially penalized by the Centers for Medicare & Medicaid Services (CMS) under the Hospital Readmissions Reduction Program (HRRP) when their 30-day readmission rates are too high. For diabetic patients specifically, managing readmissions is a major challenge — diabetes is one of the most common conditions among readmitted patients. Understanding which patients are most likely to return can help hospitals take proactive steps before discharge.

**Tools Used**
- Microsoft Excel — data cleaning 
- PostgreSQL— database setup and analytical queries
- Power BI — interactive dashboard and data visualization

**The Dataset**
The data comes from the UCI Machine Learning Repository and covers 101,763 patient encounters across 130 US hospitals. It includes information like patient age, length of hospital stay, number of medications, diagnosis codes, and whether the patient was readmitted within 30 days, after 30 days, or not at all.

> **Source:** Beata Strack, et al. "Impact of HbA1c Measurement on Hospital Readmission Rates: Analysis of 70,000 Clinical Database Patient Records." BioMed Research International, 2014.

**Data Cleaning**
Before loading the data into PostgreSQL, I cleaned it in Excel:
- Replaced missing values stored as `?` using Find & Replace
- Removed columns that were very empty — specifically `weight`, `medical_specialty`, and `payer_code`
- Removed individual medication columns that weren't needed for this analysis
- Filtered out 3 rows with invalid gender values
- Saved the cleaned file as a CSV for import into PostgreSQL

The cleaned dataset came out to **101,763 rows and 25 columns**.
[`diabetic_project.csv`](diabetic_project.csv)
**SQL Analysis**
I used PostgreSQL to write analytical queries focused on readmission patterns:

1. Overall readmission breakdown — how patients are split across the three readmission categories
2. Readmission by age group — which age groups had the highest 30-day readmission rates
3. Readmission by days in hospital — whether longer stays were linked to higher readmission rates
4. Readmission by number of medications — whether patients on more medications were readmitted more often

The queries used GROUP BY, CASE WHEN, window functions, and aggregate functions. 
See [`diabetic_postgres_project.sql`](diabetic_postgres_project.sql) for the full code.

**Key Findings**

**Overall Rate**
About 11.16% of patients were readmitted within 30 days — this is the number hospitals are most concerned about from a financial and clinical standpoint.

**Age Group**
Patients aged 20–30 had the highest 30-day readmission rate at **14.24%**, which was actually surprising. You might expect older patients to struggle more, but this age group stood out significantly. The 80–90 age group came in second at 12.08%, which is more expected.

**Length of Stay**
There was a clear upward trend — the longer a patient stayed in the hospital, the more likely they were to come back. Patients who stayed just 1 day had a readmission rate of **8.18%**, while patients who stayed 10 days had a rate of **14.35%** — nearly double. This suggests that length of stay might be a useful predictor of readmission risk.

**Number of Medications**
Patients on more medications also showed higher readmission rates, rising from around 4% for patients on 1 medication up to about 16% for patients on 35 medications. Patients on 50+ medications were excluded from this part of the analysis since the sample sizes were too small to be meaningful.

 **Recommendations**
Based on the findings, here are a few things a hospital could consider:
- Target younger diabetic patients — the 20–30 age group had unexpectedly high readmission rates and may benefit from stronger post-discharge follow-up programs
- Flag long-stay patients before discharge — patients staying 7 or more days showed significantly higher readmission risk and could benefit from enhanced discharge planning
- Prioritize medication management — patients on a high number of medications may need extra support at home to manage their treatment plans after discharge

 **Dashboard**
The Power BI dashboard includes:
- KPI cards showing total patients and the overall 30-day readmission rate
- A donut chart breaking down the three readmission categories
- A bar chart showing readmission rates by age group
- A line chart showing the relationship between length of stay and readmission rate
- A scatter plot showing readmission rate by number of medications
![Dashboard Preview](hospital%20readmission%20data.png)

**What I Learned**
One thing that stood out to me was how easy it is to be misled by raw numbers. For example, the readmission counts dropped sharply for patients who stayed longer in the hospital, which at first looked like longer stays were safer. But once I looked at the rates instead of the counts, the opposite was true. That's something I'll carry into every analysis going forward.
