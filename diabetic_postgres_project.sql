
CREATE TABLE diabetic_data (
    encounter_id             INT,
    patient_nbr              INT,
    race                     VARCHAR(50),
    gender                   VARCHAR(20),
    age                      VARCHAR(20),
    admission_type_id        INT,
    discharge_disposition_id INT,
    admission_source_id      INT,
    time_in_hospital         INT,
    num_lab_procedures       INT,
    num_procedures           INT,
    num_medications          INT,
    number_outpatient        INT,
    number_emergency         INT,
    number_inpatient         INT,
    diag_1                   VARCHAR(20),
    diag_2                   VARCHAR(20),
    diag_3                   VARCHAR(20),
    number_diagnoses         INT,
    max_glu_serum            VARCHAR(20),
    A1Cresult                VARCHAR(20),
    metformin_pioglitazone   VARCHAR(20),
    change                   VARCHAR(10),
    diabetesMed              VARCHAR(10),
    readmitted               VARCHAR(10)
);

/*it just shows how patients are split across the 3 readmission categories.*/
SELECT 
    readmitted,
    COUNT(*) AS total_patients,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM diabetic_data
GROUP BY readmitted
ORDER BY total_patients DESC;

/*This one shows which age groups have the highest 30 day readmission rates.*/
SELECT 
    age,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmitted_30_days,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2) AS readmission_rate
FROM diabetic_data
GROUP BY age
ORDER BY age;
/*This shows whether patients who stayed longer were more likely to be readmitted. */
SELECT 
    time_in_hospital,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmitted_30_days,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2) AS readmission_rate
FROM diabetic_data
GROUP BY time_in_hospital
ORDER BY time_in_hospital;
/*This shows whether patients on more medications were more likely to be readmitted.*/
SELECT 
    num_medications,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmitted_30_days,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2) AS readmission_rate
FROM diabetic_data
GROUP BY num_medications
ORDER BY num_medications;

/*Average length of stay by age group
Shows which age groups occupy hospital beds the longest — 
useful for resource planning.*/
SELECT 
    age,
    ROUND(AVG(time_in_hospital), 2) AS avg_days,
    COUNT(*) AS total_patients
FROM diabetic_data
GROUP BY age
ORDER BY age;
/*Emergency vs Elective admissions breakdown Shows how patients are coming in
— are most emergencies or planned admissions?*/
SELECT 
    CASE 
        WHEN admission_type_id = 1 THEN 'Emergency'
        WHEN admission_type_id = 2 THEN 'Urgent'
        WHEN admission_type_id = 3 THEN 'Elective'
        ELSE 'Other'
    END AS admission_type,
    COUNT(*) AS total_patients,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM diabetic_data
GROUP BY admission_type_id
ORDER BY total_patients DESC;
/* Gender Breakdown*/
SELECT 
    gender,
    COUNT(*) AS total_patients,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage,
    ROUND(AVG(time_in_hospital), 2) AS avg_days_in_hospital
FROM diabetic_data
GROUP BY gender
ORDER BY total_patients DESC;
/* Race Breakdown*/
SELECT 
    COALESCE(race, 'Unknown') AS race,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmitted_30_days,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2) AS readmission_rate
FROM diabetic_data
GROUP BY race
ORDER BY total_patients DESC;
/*Number of previous inpatient visits vs readmission
Patients who have been admitted before are often at higher risk 
— this tests that theory.*/
SELECT 
    number_inpatient,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmitted_30_days,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2) AS readmission_rate
FROM diabetic_data
WHERE number_inpatient <= 10
GROUP BY number_inpatient
ORDER BY number_inpatient;