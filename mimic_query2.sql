select SAMPLE_PATIENTS.*,
	   admission.SUBJECT_ID,
	   admission.hadm_id,     
	   d_icd_diagnoses.long_title,
	   UNPIVOTED_TABLES.CHARTTIME,
	   UNPIVOTED_TABLES.COL_ID,
	   UNPIVOTED_TABLES.TBL_NAME
FROM
    mimiciv_hosp.admissions AS admission
JOIN mimiciv_hosp.diagnoses_icd   AS diag ON diag.hadm_id = admission.hadm_id
JOIN mimiciv_hosp.d_icd_diagnoses AS d_icd_diagnoses ON 
											diag.icd_code = d_icd_diagnoses.icd_code
											AND diag.icd_version = d_icd_diagnoses.icd_version 
JOIN
	(SELECT SUBJECT_ID,
			HADM_ID,
			CHARTTIME,
			ITEMID::TEXT AS COL_ID,
			VALUENUM::TEXT AS COL_VALUE,
			'labevents' AS TBL_NAME
		FROM MIMICIV_HOSP.LABEVENTS AS LABEVENTS_FULL
		UNION ALL SELECT SUBJECT_ID,
			HADM_ID,
			COALESCE(VERIFIEDTIME,

				STARTTIME) AS CHARTTIME,
			MEDICATION AS COL_ID,
			FREQUENCY::TEXT AS COL_VALUE,
			'pharmacy' AS TBL_NAME
		FROM MIMICIV_HOSP.PHARMACY) AS UNPIVOTED_TABLES ON 
		UNPIVOTED_TABLES.SUBJECT_ID = admission.SUBJECT_ID
AND UNPIVOTED_TABLES.HADM_ID = admission.HADM_ID

JOIN	(SELECT * 
		FROM MIMICIV_HOSP.patients
		 order By RANDOM()
		LIMIT 10000) AS SAMPLE_PATIENTS on 
		admission.SUBJECT_ID = SAMPLE_PATIENTS.SUBJECT_ID
where diag.seq_num=1;





