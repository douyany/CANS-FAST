/* April 25, 2014 */
/* This do-file runs QA procedures on the FAST assessment data */
/* the Family Together table */

/* The procedures requested were detailed in the QA document */

/* FOR THE FAST: */


GET DATA
  /TYPE=XLS
  /FILE='H:\data_fast\from_db\20140723_fast_data.xls'
  /SHEET=name 'FAST_Family_Screen'
  /CELLRANGE=full
  /READNAMES=on.


COMPUTE asmtdatenum=NUMBER(ASMT_DT, sdate).
FORMATS asmtdatenum (SDATE10).

LIST VARIABLES asmt_dt asmtdatenum
 /CASES FROM 1 TO 10.

EXECUTE.
DELETE VARIABLES asmt_dt.

rename variables (asmtdatenum=ASMT_DT).

/* as all dates are yyyy-mm-dd in file */
/* don't need to do date conversion this piecemeal way */

/* CREATE Date variable */

string m1 (a2).
string d1 (a2).
string y1 (a4).
exe.

/* what is length of string variable? */
/* mm-dd-yyyy means 10 */
/* mm-d-yyyy means 9 */
/* m-dd-yyyy means 9 */
/* m-d-yyyy means 8 */
/* some have time " 0:00" */
/* 13 means 8 */
/* 14 means 9 */
/* 15 means 10 */
/* 23 means yyyy-mm-dd 00:00:00.000 */
compute lendate=len(ltrim(rtrim(asmt_dt))).
freq vars=lendate.

if (lendate=13) lendate=8.
if (lendate=14) lendate=9.
if (lendate=15) lendate=10.

if (substring(asmt_dt,3,1)="/") slashat3=1.
if (substring(asmt_dt,3,1)~="/") slashat3=0.

freq vars=slashat3.

DEFINE fillindates (thelendate=!TOKENS(1) 
 / yesslash=!TOKENS(1) 
 / mplace=!TOKENS(1) 
 / mlength=!TOKENS(1) 
 / dplace=!TOKENS(1) 
 / dlength=!TOKENS(1)
 / yplace=!TOKENS(1))

if (lendate=!thelendate & slashat3=!yesslash) m1=substring(asmt_dt, !mplace, !mlength).
if (lendate=!thelendate & slashat3=!yesslash) d1=substring(asmt_dt, !dplace, !dlength).
if (lendate=!thelendate & slashat3=!yesslash) y1=substring(asmt_dt, !yplace, 4).
!enddefine.


fillindates thelendate=10 yesslash=1 mplace=1 mlength=2 dplace=4 dlength=2 yplace=7.
fillindates thelendate=9 yesslash=1 mplace=1 mlength=2 dplace=4 dlength=1 yplace=6.
fillindates thelendate=9 yesslash=0 mplace=1 mlength=1 dplace=3 dlength=2 yplace=6.
fillindates thelendate=8 yesslash=0 mplace=1 mlength=1 dplace=3 dlength=1 yplace=5.
fillindates thelendate=23 yesslash=0 mplace=6 mlength=2 dplace=9 dlength=2 yplace=1.

freq vars=m1.
freq vars=d1.
freq vars=y1.


/* is month two digits? */
* compute m1 = substr(asmt_dt, 1, 2).
* if (index(m1, "/")>0) onedigmo=1.
* if (index(m1, "/")=0) onedigmo=0.
* if (index(m1, "/")>0) m1=substr(asmt_dt, 1, 1).

/* taking into account number of digits in month */
* if (onedigmo=0) compute d1 = substr(asmt_dt, 4, 2).
/* that one has a slash in it? */
* if (onedigmo=0 & index(d1, "/")>0) onedigdy=1.
* if (onedigmo=0 & index(d1, "/")=0) onedigdy=0.
* if (onedigmo=0 & index(d1, "/")>0) compute d1 = substr(asmt_dt, 4, 1).



* compute y1 = substr(asmt_dt, 7, 4).

compute mn = numeric(m1, f4.0).
compute dn = numeric(d1, f4.0).
compute yn = numeric(y1, f4.0).

compute new_date = date.dmy(dn, mn, yn).

format new_date (adate).

execute.
delete variables asmt_dt.
execute.
rename variables (new_date=asmt_dt).

formats asmt_dt (adate).








/* FOR THE FAST: */
/* Is Family ID included on all entries? */

/* for when FAMILY_ID is formatted as a string */

FREQ VARS=FAMILY_ID.

/* for when family_id is formatted as a number */

descriptives variables=FAMILY_ID.



/* Is Asmt. ID included on all entries? */

/* for when ASMT_ID is formatted as a string */

FREQ VARS=ASMT_ID.

/* for when ASMT_ID is formatted as a number */
descriptives variables=ASMT_ID.


/* What type of ASMT? */

FREQ VARS=ASMT_TYPE.
CROSSTABS
 /TABLES=COUNTY_ID BY ASMT_TYPE.

 /* Are all the assessments of "completed" or "closed" STATUS? */
/* COMPLETE STATUS=2 */
/* closed STATUS=3 */

FREQ VARS=ASMT_STATUS.

CROSSTABS
 /TABLES=COUNTY_ID BY ASMT_STATUS.


TEMPORARY.
SELECT IF ASMT_STATUS='1'.
FREQ VARS=ASMT_DT.

TEMPORARY.
SELECT IF ASMT_STATUS='1'.
CROSSTABS
 /TABLES=ASMT_DT by COUNTY_ID.


 /* Time between Assessments */
/* for FAST */
/* will want to sort by county and Family ID */
/* (see if that family has multiple assessments */
/* then check the date */

/* Guideline about Frequency of FAST: */
/* does not seem to be listed online */


SORT CASES BY county_id family_id asmt_dt.

COMPUTE order_of_asmt=1.
COMPUTE asmt_onsameday=1.

if (county_id=lag(county_id) & family_id=lag(family_id)) order_of_asmt=lag(order_of_asmt)+1.

/* same MCI and same asmt. date */
if (county_id=lag(county_id) & family_id=lag(family_id) & asmt_dt=lag(asmt_dt)) asmt_onsameday=lag(asmt_onsameday)+1.

SORT CASES BY county_id family_id asmt_dt asmt_onsameday (D).

compute maxnumasmt=asmt_onsameday.
if (county_id=lag(county_id) & family_id=lag(family_id) & asmt_dt=lag(asmt_dt)) maxnumasmt=lag(maxnumasmt).

SORT CASES BY date maxnumasmt (D) county_id family_id asmt_dt.
temporary.
select if maxnumasmt>1.
list variables date family_id maxnumasmt order_of_asmt asmt_dt county_id asmt_id asmt_status.

/* are the records completely repeats of each other? */

SORT CASES BY county_id family_id asmt_dt.
compute isarepeat=1.
do repeat allvars=family_id to FT_Q_11.
if (allvars~=lag(allvars)) isarepeat=0.
end repeat.

FREQ VARS=isarepeat.

crosstabs 
/tables=county_id by isarepeat.

temporary.
select if (isarepeat=1).
FREQ VARS=family_id.

COMPUTE subdatenum=NUMBER(date, sdate).
FORMATS subdatenum (SDATE10).


EXECUTE.
DELETE VARIABLES date.
rename variables (subdatenum=date).




SORT CASES BY date maxnumasmt (D) county_id family_id asmt_dt.
temporary.
select if (isarepeat=1).
list variables date family_id maxnumasmt order_of_asmt asmt_dt county_id asmt_id asmt_status isarepeat.


/* Run a tab to see how many have more than one asmt. */

FREQ VARS=order_of_asmt.
FREQ VARS=asmt_onsameday.
FREQ VARS=maxnumasmt.

crosstabs 
/tables=asmt_onsameday by maxnumasmt.

/* Check lag in dates between the asmts. */

SORT CASES BY county_id family_id asmt_dt.


SORT CASES BY county_id family_id asmt_dt.

/* elapsed time in months (roughly) */
if (county_id=lag(county_id) & family_id=lag(family_id)) gap_bet_asmt=(asmt_dt-lag(asmt_dt))/(60*60*24 * 30.4375).

FREQ VARS=gap_bet_asmt.

/* Is there data for all questions? */

DESCRIPTIVES 
 VARIABLES=FAMILY_ID TO COUNTY_ID.

DESCRIPTIVES 
 VARIABLES=FT_Q_1 TO FT_Q_11.

do repeat famtogqs=FT_Q_1 TO FT_Q_11 / newqs=NEWFT1 to NEWFT11.
recode famtogqs (convert) into newqs.
end repeat.

DESCRIPTIVES 
 VARIABLES=NEWFT1 to NEWFT11.

sort cases by COUNTY_id.
split file by COUNTY_id. 
DESCRIPTIVES 
 VARIABLES=NEWFT1 to NEWFT11.
split file off.

sort cases by COUNTY_id.
split file by COUNTY_id. 
DESCRIPTIVES 
 VARIABLES=FT_Q_1 TO FT_Q_11.
split file off.
