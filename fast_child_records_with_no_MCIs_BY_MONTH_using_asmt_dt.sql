/* will want to show the County Number and the number of records for that county */

/* THIS REPORT IS SPECIFIC TO THE THREE-MONTH PROGRESS REPORT */
/* AND ONLY IS RUN FOR THE PRIOR MONTHS */
/* (THIS RESTRICTION IS SET MANUALLY */

/* this one uses the assessment date */
/* not submission date */
/* to determine the assignment for the month */

SELECT CountyNum, AsmtMo, count(ConcattedMCI) as CountofRecords 
from
(
/* uses county number and a concatenated MCI number from the Child Functioning table */
SELECT tbl_child.[COUNTY_ID] as CountyNum, 
		CAST(CONCAT(ltrim(rtrim([child_a_mci])), 
				ltrim(rtrim([child_B_mci])), 
				ltrim(rtrim([child_c_mci])), 
				ltrim(rtrim([child_D_mci])), 
				ltrim(rtrim([child_E_mci])), 
				ltrim(rtrim([child_f_mci])), 
				ltrim(rtrim([child_G_mci])), 
				ltrim(rtrim([child_H_mci])), 
				ltrim(rtrim([child_I_mci])), 
				ltrim(rtrim([child_J_mci]))) AS nvarchar(max))
						as ConcattedMCI,
						/* pulling in the date from the Family Together table */
						/* uses the submission date, not the assessment date */
		month(cast(tbl_family.[ASMT_DT] as datetime)) as AsmtMo   
 from [Demo_Processing].[dbo].[FAST_CHILD_Screen] as tbl_child
  /* the join to the Family Together table */
   LEFT JOIN 
      [Demo_Processing].[dbo].[FAST_Family_Screen] AS tbl_family
  ON tbl_family.[ASMT_ID]=tbl_child.[ASMT_ID] AND
		tbl_family.[FAMILY_ID]=tbl_child.[FAMILY_ID] and 
		tbl_family.[COUNTY_ID]=tbl_child.[COUNTY_ID] and 
		tbl_family.[DATE]=tbl_child.[DATE]
   where 
/* limits the time window to (July 2013 to end of October 2014) */
   (cast([ASMT_DT] as datetime)>='2013/07/01' 
 AND 
 cast([ASMT_DT] as datetime)<='2014/10/31 23:59:59.999')
 /* restriction for latest months */
  and
 month(cast(tbl_family.[ASMT_DT] as datetime))>7
 and 
 /* from the most recent year */
 year(cast(tbl_family.[ASMT_DT] as datetime))=2014
 ) as TableLayer1
 where
 /* the concatenated MCI does not have */
 /* a string of at least eight numbers */
 ConcattedMCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
 /* group by the county code to get a total number for the county */
 group by CountyNum, AsmtMo
 /* sort by the county code */
 order by CountyNum, AsmtMo