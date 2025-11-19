--identifying base enrolled population
with pop as (
SELECT
      Year = case when stud.Person_ID_Number like 'C004879137' then '2024' when stud.Person_ID_Number like 'C004884173' then '2024' else SUBSTRING(stud.Term_Identifier,1,4) end,
      Student = stud.Person_ID_Number,
      Gender = CASE when stud.Person_ID_Number like 'C004879137' then 'Female' when stud.Person_ID_Number like 'C004884173' then 'Female' WHEN stud.Gender_Code = 'M' THEN 'Male'
	  	       WHEN stud.Gender_Code = 'F' THEN 'Female'
			   ELSE '?'
			   END,
     Gender_Imputed = CASE when stud.Person_ID_Number like 'C004879137' then 'Female' when stud.Person_ID_Number like 'C004884173' then 'Female' WHEN stud.Gender_Imputed = 'M' THEN 'Male'
	                       WHEN stud.Gender_Imputed = 'F' THEN 'Female'
						   ELSE '?'
						   END,
	  --Ethnicity = CASE WHEN stud.Abstract_Ethnicity IN ('Asian','ASIAN OR PACIFIC ISLANDER') THEN 'Asian'
	  --     WHEN stud.Abstract_Ethnicity IN ('Black','BLACK NON-HISPANIC') THEN 'Black or African American'
		 --  WHEN stud.Abstract_Ethnicity IN ('Hispanic','HISPANIC') THEN 'Hispanic or Latino'
		 --  WHEN stud.Abstract_Ethnicity IN ('Native American','AMERICAN INDIAN/ALASKA NATIVE') THEN 'American Indian or Alaska Native'
		 --  WHEN stud.Abstract_Ethnicity = 'Pacific Islander' THEN 'Native Hawaiian or Other Pacific Islander'
		 --  WHEN stud.Abstract_Ethnicity = 'Two or more races' THEN 'Two or More Races'
		 --  WHEN stud.Abstract_Ethnicity IN ('Unknown','UNKNOWN','OTHER') THEN 'Unknown'
		 --  WHEN stud.Abstract_Ethnicity IN ('White','WHITE NON-HISPANIC') THEN 'White'
		 --  WHEN stud.Abstract_Ethnicity = 'NRA' THEN 'NRA'
		 --  ELSE '?'
		 --  END,
	  --Ethnicity = CASE WHEN stud.Abstract_Ethnicity = '01' THEN 'NRA'
	  --     WHEN stud.Abstract_Ethnicity = '02' THEN 'Unknown'
		 --  WHEN stud.Abstract_Ethnicity = '03' THEN 'Hispanic or Latino'
		 --  WHEN stud.Abstract_Ethnicity = '04' THEN 'American Indian or Alaska Native'
		 --  WHEN stud.Abstract_Ethnicity = '05' THEN 'Asian'
		 --  WHEN stud.Abstract_Ethnicity = '06' THEN 'Black or African American'
		 --  WHEN stud.Abstract_Ethnicity = '07' THEN 'Native Hawaiian or Other Pacific Islander'
		 --  WHEN stud.Abstract_Ethnicity = '08' THEN 'White'
		 --  WHEN stud.Abstract_Ethnicity = '09' THEN 'Two or more races'
		 --  ELSE '?'
		 --  END,
		 Ethnicity = CASE when stud.Person_ID_Number like 'C004879137' then 'Unknown' when stud.Person_ID_Number like 'C004884173' then 'Asian' WHEN stud.Abstract_Ethnicity IN ('Asian','ASIAN OR PACIFIC ISLANDER') THEN 'Asian'
	       WHEN stud.Abstract_Ethnicity IN ('Black','BLACK NON-HISPANIC') THEN 'Black or African American'
		   WHEN stud.Abstract_Ethnicity IN ('Hispanic','HISPANIC') THEN 'Hispanic or Latino'
		   WHEN stud.Abstract_Ethnicity IN ('Native American','AMERICAN INDIAN/ALASKA NATIVE') THEN 'American Indian or Alaska Native'
		   WHEN stud.Abstract_Ethnicity = 'Pacific Islander' THEN 'Native Hawaiian or Other Pacific Islander'
		   WHEN stud.Abstract_Ethnicity = 'Two or more races' THEN 'Two or More Races'
		   WHEN stud.Abstract_Ethnicity IN ('Unknown','UNKNOWN','OTHER') THEN 'Unknown'
		   WHEN stud.Abstract_Ethnicity IN ('White','WHITE NON-HISPANIC') THEN 'White'
		   WHEN stud.Abstract_Ethnicity IN ('NRA','US Nonresident') THEN 'US Nonresident'
		   else stud.Abstract_Ethnicity end,
	   /************************************************************

	   OPIR edit:	Synthesize logic between Q1 and Q2 for consistency of content (ie, words v codes) in PROV_STUDENT.Abstract_Ethnicity.  
					Update code 'NRA' to 'US Nonresident' per IPEDS AY24 reporting standards.
					Older terminology included for backwards compatibility.
	   Ankura Update: above [Ethnicity] CASE WHEN statement commented out and replaced with logic from IPEDS enrollment query

	   ************************************************************/
	  Citizenship_Country_Code = case when stud.Person_ID_Number like 'C004879137' then 'USA' when stud.Person_ID_Number like 'C004884173' then 'USA' else stud.Citizenship_Country_Code end,
	  School = CASE when stud.Person_ID_Number like 'C004879137' then 'Professional Studies' when stud.Person_ID_Number like 'C004884173' then 'Professional Studies' WHEN stud.Reporting_Code IN ('CC','CN') THEN 'Columbia College'
	       WHEN stud.Reporting_Code = 'EN' THEN 'Engineering'
		   WHEN stud.Reporting_Code IN ('GN','GS') THEN 'General Studies'
		   WHEN stud.Reporting_Code = 'AC' THEN 'Architecture, Planning, & Preservation'
		   WHEN stud.Reporting_Code = 'AR' THEN 'Arts'
		   WHEN stud.Reporting_Code = 'BU' THEN 'Business'
		   WHEN stud.Reporting_Code = 'EP' THEN 'Engineering (Graduate)'
		   WHEN stud.Reporting_Code IN ('GF','GG') THEN 'Graduate School of Arts & Sciences'
		   WHEN stud.Reporting_Code = 'IA' THEN 'International & Public Affairs'
		   WHEN stud.Reporting_Code = 'JN' THEN 'Journalism'
		   WHEN stud.Reporting_Code = 'LW' THEN 'Law'
		   WHEN stud.Reporting_Code = 'SW' THEN 'Social Work'
		   WHEN stud.Reporting_Code IN ('GM','MD','OT','PC','PS','PT','GC') THEN 'College of Physicians & Surgeons'
		   WHEN stud.Reporting_Code IN ('DG','DN') THEN 'Dental Medicine'
		   WHEN stud.Reporting_Code IN ('NP','RN','NM') THEN 'Nursing'
		   WHEN stud.Reporting_Code = 'PH' THEN 'Public Health'
		   WHEN stud.Reporting_Code IN ('AL','SP') THEN 'Professional Studies'
		   WHEN stud.Reporting_Code = 'CS' THEN 'Climate'
		   ELSE '?'
	       END,
      Campus = CASE when stud.Person_ID_Number like 'C004879137' then 'MORNINGSIDE GRADUATE & PROFESSIONAL SCHOOLS' when stud.Person_ID_Number like 'C004884173' then 'MORNINGSIDE GRADUATE & PROFESSIONAL SCHOOLS' WHEN stud.Reporting_Code IN ('CC','CN','EN','GN','GS') THEN 'UNDERGRADUATE SCHOOLS'
		   WHEN stud.Reporting_Code IN ('AC','AR','BU','EP','GF','GG','IA','JN','LW','SW','AL','SP','CS') THEN 'MORNINGSIDE GRADUATE & PROFESSIONAL SCHOOLS'
		   WHEN stud.Reporting_Code IN ('GM','MD','OT','PC','PS','PT','DG','DN','NP','RN','NM','PH','GC') THEN 'MEDICAL CENTER GRADUATE SCHOOLS'
		   ELSE '?'
	       END,
	  Degree_Code_NEW = CASE when stud.Person_ID_Number like 'C004879137' then 'NDG' when stud.Person_ID_Number like 'C004884173' then 'NDG' WHEN stud.Degree_Code = 'AM' THEN 'PHD'
	       WHEN stud.Billing_Program_Code like 'ET%' THEN 'PHD'
		   ELSE stud.Degree_Code 
		   END,
	  Degree_Name_NEW = CASE when stud.Person_ID_Number like 'C004879137' then 'NON-DEGREE' when stud.Person_ID_Number like 'C004884173' then 'NON-DEGREE' WHEN stud.Degree_Code = 'AM' THEN 'Doctor of Philosophy'
	       WHEN stud.Billing_Program_Code like 'ET%' THEN 'Doctor of Philosophy'
		   ELSE stud.Degree_Name 
		   END,
	  Status = CASE when stud.Person_ID_Number like 'C004879137' then 'Part-Time' when stud.Person_ID_Number like 'C004884173' then 'Part-Time' WHEN stud.Enrollment_Status_Code = 'FT' THEN 'Full-Time'
	       WHEN stud.Enrollment_Status_Code = 'PT' THEN 'Part-Time'
		   ELSE '?'
		   END,
	  stud.Current_Standing_Year_Code,
	  FT_Flag = CASE when stud.Person_ID_Number like 'C004879137' then 0 when stud.Person_ID_Number like 'C004884173' then 0 WHEN RTRIM(stud.Enrollment_Status_Code) = 'FT' THEN 1 
	       ELSE 0 END,
	  PT_Flag = CASE when stud.Person_ID_Number like 'C004879137' then 1 when stud.Person_ID_Number like 'C004884173' then 1 WHEN RTRIM(stud.Enrollment_Status_Code) = 'PT' THEN 1
	       ELSE 0 END,
	  Reporting_Code = case when stud.Person_ID_Number like 'C004879137' then 'SP' when stud.Person_ID_Number like 'C004884173' then 'SP' else stud.Reporting_Code end,
	  Academic_Department_Code = case when stud.Person_ID_Number like 'C004879137' then 'DVSP' when stud.Person_ID_Number like 'C004884173' then 'DVSP' else stud.Academic_Department_Code end,
	  Billing_Program_Code = case when stud.Person_ID_Number like 'C004879137' then 'SPNDGH' when stud.Person_ID_Number like 'C004884173' then 'SPNDGH' else stud.Billing_Program_Code end,
	  Program_Short_Name = case when stud.Person_ID_Number like 'C004879137' then 'HS Visiting ' when stud.Person_ID_Number like 'C004884173' then 'HS Visiting ' else pgrm.Program_Short_Name end,
	  Program_Description = case when stud.Person_ID_Number like 'C004879137' then 'Visiting -- College Edge' when stud.Person_ID_Number like 'C004884173' then 'Visiting -- College Edge' else pgrm.Program_Description end,
	  Academic_Department_Name = case when stud.Person_ID_Number like 'C004879137' then 'Professional Studies' when stud.Person_ID_Number like 'C004884173' then 'Professional Studies' else dept.Academic_Department_Name end,
	  Credit_Units_Attempted_Count = case when stud.Person_ID_Number like 'C004879137' then '3' when stud.Person_ID_Number like 'C004884173' then '4' else stud.Credit_Units_Attempted_Count end
FROM opir..PROV_STUDENT stud
LEFT JOIN opir..PROV_REF_ACADEMIC_DEPARTMENT dept ON stud.Academic_Department_Code = dept.Academic_Department_Code
LEFT JOIN sis..PGRM_ACADEMIC_PROGRAM pgrm ON stud.Billing_Program_Code = pgrm.Program_Code
WHERE stud.School_Code NOT IN ('SS','SH','AU','BC','TC','GP','TEST')),
--joining financial aid data based on enrolled population
finaid as (
select
CAST(STU_AWARD_YEAR.award_year_token AS VARCHAR(4)) as Award_Year, 
STUDENT.alternate_id AS PID,
fund_type,
fund_long_name,
fund_family,
case when fund_type like 'G' then 0 else actual_amt end as loan_amt,
pell_flag
FROM
 powerfaids..student as STUDENT 
left join powerfaids..stu_award_year as STU_AWARD_YEAR ON STUDENT.student_token = STU_AWARD_YEAR.student_token
left join powerfaids..stu_award as STU_AWARD ON STU_AWARD_YEAR.stu_award_year_token = STU_AWARD.stu_award_year_token
left join powerfaids..funds as FUNDS ON STU_AWARD.fund_ay_token = FUNDS.fund_token
 join pop p on STUDENT.alternate_id = p.Student and p.Year = FUNDS.award_year_token
where STU_AWARD_YEAR.award_year_token >= '2023' and STU_AWARD_YEAR.award_year_token <= '2024' and (fund_type like 'L' or (fund_type like 'G' and fund_family like '8N'))
)
SELECT 
	Award_Year,
	PID,
	sum(loan_amt) as total_loans,
	    CASE 
        WHEN MAX(CASE WHEN pell_flag = 'O' THEN 1 ELSE 0 END) = 1 
            THEN 'Y' 
            ELSE 'N' 
    END AS p_flag
FROM finaid
group by PID, Award_Year
order by PID, Award_Year