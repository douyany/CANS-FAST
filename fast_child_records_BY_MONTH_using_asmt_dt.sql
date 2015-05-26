/* uses county number and a concatenated MCI number from the Child Functioning table */
SELECT tbl_child.[COUNTY_ID] as CountyNum, 
						/* pulling in the date from the Family Together table */
						/* uses the submission date, not the assessment date */
		month(cast(tbl_family.[ASMT_DT] as datetime)) as AsmtMo,
		count(tbl_child.Row) as CountofRecords
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
  /* group by the county code to get a total number for the county */
 group by tbl_child.[COUNTY_ID], month(cast(tbl_family.[ASMT_DT] as datetime))
 /* sort by the county code */
 order by tbl_child.[COUNTY_ID], month(cast(tbl_family.[ASMT_DT] as datetime))