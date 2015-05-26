/* this query counts */
/* number of records */
/* submitted each month */
/* submitted but has no MCI in any child record */
/* submitted but does not meet min std dataset */

/* min std dataset means */
/* FAMILY_ID, asmt_id, asmt_dt, */
/* at least one child MCI */
/* at least one child DOB */

select COUNTY_ID, SubYear, SubMonth, 
	count(DATE) as NumForms, /* count of all asmt */
	count(case when ConcattedMCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
		then 1 else null end) as nonMCI, /* count of asmt without MCI */
		count(case when 
		(
		 (FAMILY_ID is null) 
		or (ASMT_ID is null) 
			or (asmt_dt is null)
		or	(ConcattedMCI not like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%')
		or (ConcattedDOB not like '%[0-9][0-9][0-9][0-9][-][0-9][0-9][-][0-9][0-9]%')
		)
		then 1 else null end) as nonminstd
		/* count of assessments not meeting min std dataset */
		FROM
(		
SELECT tbl_child.[COUNTY_ID], 
	year(cast(tbl_child.[DATE] as datetime)) as SubYear,   
	month(cast(tbl_child.[DATE] as datetime)) as SubMonth,
	/* start of the fields that will be using for counting */
						tbl_child.[DATE],
	tbl_child.FAMILY_ID,
	tbl_child.ASMT_ID,
		tbl_family.asmt_dt,
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
		CAST(CONCAT(ltrim(rtrim([child_a_DOB])), 
				ltrim(rtrim([child_B_DOB])), 
				ltrim(rtrim([child_c_DOB])), 
				ltrim(rtrim([child_D_DOB])), 
				ltrim(rtrim([child_E_DOB])), 
				ltrim(rtrim([child_f_DOB])), 
				ltrim(rtrim([child_G_DOB])), 
				ltrim(rtrim([child_H_DOB])), 
				ltrim(rtrim([child_I_DOB])), 
				ltrim(rtrim([child_J_DOB]))) AS nvarchar(max))
						as ConcattedDOB
						/* pulling in the date from the Family Together table */
						/* uses the submission date, not the assessment date */
		
 from [Demo_Processing].[dbo].[FAST_CHILD_Screen] as tbl_child
  /* the join to the Family Together table */
   LEFT JOIN 
      [Demo_Processing].[dbo].[FAST_Family_Screen] AS tbl_family
  ON tbl_family.[ASMT_ID]=tbl_child.[ASMT_ID] AND
		tbl_family.[FAMILY_ID]=tbl_child.[FAMILY_ID] and 
		tbl_family.[COUNTY_ID]=tbl_child.[COUNTY_ID] and 
		tbl_family.[DATE]=tbl_child.[DATE]
   where 
   year(cast(tbl_child.[DATE] as datetime))>2013
 ) as TableLayer1
/* group by the county code to get a total number for the county */
 group by COUNTY_ID, SubYear, SubMonth
 /* sort by the county code */
 order by COUNTY_ID, SubYear, SubMonth
