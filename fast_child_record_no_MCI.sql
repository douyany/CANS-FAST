/* will want to show the County Number and the number of records for that county */


SELECT CountyNum, count(ConcattedMCI) as CountofRecords 
from
(
/* uses county number and a concatenated MCI number from the Child Functioning table */
SELECT tbl_child.[countyid] as CountyNum, 
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
		month(cast(tbl_family.[dates] as datetime)) as SubmitMo   
 from [Demo_Processing].[dbo].[FAST_CHILD_Screen] as tbl_child
  /* the join to the Family Together table */
   LEFT JOIN 
      [Demo_Processing].[dbo].[FAST_Family_Screen] AS tbl_family
  ON tbl_family.[ASMT_ID]=tbl_child.[ASMT_ID] AND
		tbl_family.[FAMILY_ID]=tbl_child.[FAMILY_ID] and 
		tbl_family.[countyid]=tbl_child.[countyid] and 
		tbl_family.[DATEs]=tbl_child.[DATEs]
 ) as TableLayer1
 where
 /* the concatenated MCI does not have */
 /* a string of at least eight numbers */
 ConcattedMCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
 /* group by the county code to get a total number for the county */
 group by CountyNum
 /* sort by the county code */
 order by CountyNum

 
 