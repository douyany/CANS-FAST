/* April 25, 2014 */
/* This do-file runs QA procedures on the FAST assessment data */
/* the Child table */

/* The procedures requested were detailed in the QA document */



GET DATA
  /TYPE=XLS
  /FILE='H:\data_FAST\from_db\20140723_fast_data.xls'
  /SHEET=name 'FAST_CHILD_Screen'
  /CELLRANGE=full
  /READNAMES=on
  /ASSUMEDSTRWIDTH=32767.
EXECUTE.
DATASET NAME DataSet1 WINDOW=FRONT.

/* NOT ALL responses for a question are the same ? */
sort cases by county_id.
split file by county_id.
DESCRIPTIVES 
 VARIABLES=Q_25A to Q_35A.
split file off.

/* FOR THE FAST: */
/* Is Family ID included on all entries? */

FREQ VARS=FAMILY_ID.

/* IT'S A string, but descriptives command won't work */
DESCRIPTIVES 
 VARIABLES=FAMILY_ID.

/* Is Asmt. ID included on all entries? */

FREQ VARS=ASMT_ID.

/* How many children are listed */
/* As counting the number of child's MCI's */

/* from http://stackoverflow.com/questions/2884479/how-can-i-loop-through-variables-in-spss-i-want-to-avoid-code-duplication */

DEFINE macdef (!POS !CHAREND('/'))
!DO !i !IN (!1)
frequencies variables = !i.
!DOEND
!ENDDEFINE.

macdef CHILD_A_MCI CHILD_B_MCI CHILD_C_MCI CHILD_D_MCI CHILD_E_MCI CHILD_F_MCI CHILD_G_MCI CHILD_H_MCI CHILD_I_MCI CHILD_J_MCI   /.

/* two records have non-null MCI for Child J */

/* Are there any Child records that do not have any MCI's at all? */
/* We will not be able to link these records to their other assessments */

string anychildMCI (A155).

compute anychildMCI="".

do repeat myvars=CHILD_A_MCI CHILD_B_MCI CHILD_C_MCI CHILD_D_MCI CHILD_E_MCI CHILD_F_MCI CHILD_G_MCI CHILD_H_MCI CHILD_I_MCI CHILD_J_MCI   .
if (len (rtrim(ltrim(myvars)))>0) anychildMCI=concat(anychildMCI, myvars).
end repeat.


/* what is in the data? */
FREQ VARS=anychildMCI.

/* 32 entries with all null */
/* 167 entries with all blank */

/* records without any MCI's for the children */

/* find these records without any MCI's */
compute noMCIs=0.
if (anychildMCI='') noMCIs=1.
if (substring(anychildMCI,1,8)='NULLNULL') noMCIs=1.

freq vars=noMCIs.

sort cases by noMCIs (D) family_id asmt_id.

/* need the info about county for this information to be immediately useful to the county */
/* info about asmt_dt helps too */
/* neither is available from Child table directly */
list variables noMCIs family_id asmt_id.

/* Is there data for all questions? */

DESCRIPTIVES 
 VARIABLES=FAMILY_ID TO ASMT_ID.

DESCRIPTIVES 
 VARIABLES=CHILD_A_GEN TO Q_35J.


/* are there duplicate records? */
/* in data from Febr. 2015, */
/* data is read as numeric, so no need */
/* to convert from string to numeric */
*recode FAMILY_id ('NULL'=SYSMIS) (CONVERT) INTO FAMID_NUM.
*recode ASMT_id (CONVERT) INTO ASMTID_NUM.
*EXECUTE.
*DELETE VARIABLES FAMILY_ID ASMT_ID.
*DELETE VARIABLES FAMILY_ID .
*RENAME VARIABLES (FAMID_NUM=FAMILY_ID) (ASMTID_NUM=ASMT_ID).
*RENAME VARIABLES (FAMID_NUM=FAMILY_ID) .

sort CASES BY county_id FAMILY_ID ASMT_ID.


/* how many records appear for each FAMILY_ID ASMT_ID combo */

COMPUTE numforthiscombo=1.
if (county_ID=lag(county_ID) and FAMILY_ID=lag(FAMILY_ID) & ASMT_ID=lag(ASMT_ID)) numforthiscombo=lag(numforthiscombo)+1.

freq vars=numforthiscombo.

SORT CASES BY county_id family_id asmt_id numforthiscombo (D).

compute maxnumasmt=numforthiscombo.
if (county_ID=lag(county_ID and asmt_id=lag(asmt_id) & family_id=lag(family_id)) maxnumasmt=lag(maxnumasmt).

freq vars=maxnumasmt.

/* 15 pairs in data from late April download of dB */

/* are the records completely repeats of each other? */

SORT CASES BY county_id family_id asmt_id numforthiscombo.
compute isarepeat=1.
do repeat allvars=CHILD_A_MCI to Q_35J.
if (county_ID=lag(county_ID) and asmt_id=lag(asmt_id) & family_id=lag(family_id) and allvars~=lag(allvars)) isarepeat=0.
end repeat.

/* repeat of the prior row (assessment answers) */

FREQ VARS=isarepeat.

/* repeat of the prior row _and_ has same assessment identifying info */

CROSSTABS
 /TABLES=isarepeat by maxnumasmt.

/* 13 out of 15 of the late April download records are repeats of each other */

formats maxnumasmt (f8.0).
formats numforthiscombo (f8.0).
formats isarepeat (f8.0).
formats family_id (f8.0).

SORT CASES BY maxnumasmt (D) family_id (A)  asmt_id (A) numforthiscombo (A).

temporary.
select if isarepeat=1 and maxnumasmt>1.
list variables county_id date maxnumasmt family_id asmt_id numforthiscombo isarepeat.
