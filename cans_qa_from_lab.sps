/* April 25, 2014 */
/* This do-file runs QA procedures on the CANS assessment data */

/* The procedures requested were detailed in the QA document */

GET DATA
  /TYPE=XLS
  /FILE='H:\data_cans\cans_db.xls'
  /SHEET=name 'ASMT'
  /CELLRANGE=full
  /READNAMES=on.

GET DATA
  /TYPE=XLS
  /FILE='H:\data_cans\from_db\20140723_cans_data.xls'
  /SHEET=name 'CANS_Screen'
  /CELLRANGE=full
  /READNAMES=on.

GET DATA
  /TYPE=XLS
  /FILE='H:\data_cans\from_db\20141020_cans_data.xls'
  /SHEET=name 'CANS_Screen'
  /CELLRANGE=full
  /READNAMES=on.
  

RENAME VARIABLES (MCI=mci_id).
RENAME VARIABLES (ASMT_DT=asmt_dt).

/* Is MCI included on all entries? */

FREQ VARS=MCI_ID.

/* Which entries are missing MCI's or have other issues */
/* List County, ASMT_ID, ASMT_DT, DOB */

COMPUTE missingMCI=0.
if (len(MCI_ID)=0) missingMCI=1.
if (len(MCI_ID)<9) missingMCI=1.
if (len(MCI_ID)>9) missingMCI=1.
/* is a string and not a number */
if (number(MCI_ID, F8.2)=$sysmis) missingMCI=1.

FREQ VARS=missingMCI.

SORT CASES BY Date COUNTY_ID (A).
TEMPORARY. 
SELECT IF (missingMCI=1).
LIST VARIABLES=MCI_ID COUNTY_ID ASMT_ID ASMT_DT DOB.

CROSSTABS
 /TABLES=COUNTY_ID by missingMCI
 /CELLS=COUNT ROW.

/* FOR THE FAST: */
/* Is Family ID included on all entries? */
/* FAMILY_ID is read as string */
/* so FREQ VARS not allowed */

FREQ VARS=FAMILY_ID.

/* Is Asmt. ID included on all entries? */

FREQ VARS=ASMT_ID.

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
SELECT IF ASMT_STATUS=1.
FREQ VARS=ASMT_DT.

TEMPORARY.
SELECT IF ASMT_STATUS=1.
CROSSTABS
 /TABLES=ASMT_DT BY COUNTY_ID.


/* DATES RUN from July 01, 2013 to March 31, 2014 in status 1 */

/* Does anyone have gender info missing? */
/* equaling (-9) */

FREQ VARS=GENDER_ID.

/* Time between Assessments */
/* for CANS */
/* will want to sort by MCI */
/* (see if that person has multiple assessments) */
/* then check the date */

/* Guideline about Frequency of CANS: */
/* as often as needed */

/* from WAFCA Intro to CANS */
/* WAFCA = Wisc. Ass'n of Fam. & Child. Agenc. */
/* After the initial assessment at the time of enrollment, */
/* an updated assessment is recommended at least every 3 to 6 months. */

SORT CASES BY mci_id asmt_dt.

COMPUTE order_of_asmt=1.
COMPUTE asmt_onsameday=1.

/* same MCI and same asmt. date */
if (mci_id=lag(mci_id) & asmt_dt=lag(asmt_dt)) asmt_onsameday=lag(asmt_onsameday)+1.

if (mci_id=lag(mci_id)) order_of_asmt=lag(order_of_asmt)+1.

/* max num of asmt */
SORT CASES BY mci_id asmt_dt asmt_onsameday (D).

compute maxnumasmt=asmt_onsameday.
if (mci_id=lag(mci_id) & asmt_dt=lag(asmt_dt)) maxnumasmt=lag(maxnumasmt).
if (mci_id="NULL") maxnumasmt=$sysmis.
if (mci_id="Null") maxnumasmt=$sysmis.

/* Run a tab to see how many have more than one asmt. on same day */

FREQ VARS=asmt_onsameday.

/* Run a tab to see how many have more than one asmt. */
FREQ VARS=order_of_asmt.

/* Most num of asmt for each MCI */
FREQ VARS=maxnumasmt.

/* Listing out the records that are repeats */
SORT CASES BY Date maxnumasmt (D) mci_id asmt_dt.
temporary.
select if (maxnumasmt>1).
list variables mci_id maxnumasmt order_of_asmt asmt_dt county_id asmt_id asmt_status.

*list variables mci_id maxnumasmt order_of_asmt asmt_dt county_id asmt_id asmt_status.
*list variables Row county_id Date mci_id asmt_id asmt_dt DoB GenderID asmt_status .


/* are the records completely repeats of each other? */

SORT CASES BY mci_id asmt_dt order_of_asmt.
compute isarepeat=1.
do repeat allvars=mci_id to Q_63.
if (allvars~=lag(allvars)) isaprepeat=0.
end repeat.

FREQ VARS=isaprepeat.

/* those records from the same date same MCI are not repeats */

/* Check lag in dates between the asmts. */

/* convert the asmt_dt variable from a string to a date variable */
COMPUTE datenum=NUMBER(asmt_dt, sdate).
FORMATS datenum (SDATE10).

LIST VARIABLES datenum asmt_dt
 /CASES FROM 1 TO 10.
EXECUTE.

DELETE VARIABLES asmt_dt.
rename variables (datenum=asmt_dt).

SORT CASES BY mci_id asmt_dt order_of_asmt.

if (order_of_asmt>1 & mci_id=lag(mci_id)) gap_bet_asmt=(asmt_dt-lag(asmt_dt))/(60*60*24*30).
if (sysmis(asmt_dt)=1) gap_bet_asmt=$sysmis.
if (mci_id="NULL") gap_bet_asmt=$sysmis.
if (mci_id="Null") gap_bet_asmt=$sysmis.
if (mci_id="-9") gap_bet_asmt=$sysmis.


FREQ VARS=gap_bet_asmt.

temporary.
select if gap_bet_asmt<3.
list variables Date mci_id asmt_dt gap_bet_asmt.

/* Is there data for all questions? */

DESCRIPTIVES 
 VARIABLES=ASMT_TYPE TO GENDER_ID.

DESCRIPTIVES 
 VARIABLES=Q_1 TO Q_63.

/* Any trend in responses to questions? */

/* Check separately by county */

SORT CASES BY COUNTY_ID.
SPLIT FILE BY COUNTY_ID.

DESCRIPTIVES 
 VARIABLES=Q_1 TO Q_63.

SPLIT FILE OFF.