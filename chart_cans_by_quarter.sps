GET DATA 
  /TYPE=XLS 
  /FILE='H:\mbg_db_reporting\from_yb\20150210_CANS-FAST_qtr.xls' 
  /SHEET=name 'CANS' 
  /CELLRANGE=full 
  /READNAMES=on 
  /ASSUMEDSTRWIDTH=32767. 
EXECUTE. 

RENAME VARIABLES (V1=County).

RENAME VARIABLES (JanMarch2014=Q1)
 (AprilJune2014=Q2)
 (JulySept2014=Q3)
 (OctDec2014=Q4).

VARSTOCASES
 /MAKE Submissions FROM Q1 to Q4
 /INDEX=QUARTER.

VARIABLE LABELS QUARTER 'Submission Qtr.'.
VARIABLE LABELS Submissions 'Num. of CANS'.

VALUE LABELS QUARTER 1 'Jan-March 2014'	
 2 'April-June 2014'
 3 'July-Sept 2014'
 4	'Oct-Dec 2014'.

COMPUTE keepvalue=1.
if (County='Total') keepvalue=0.

select if (keepvalue=1).

execute.
delete variables keepvalue.



* Chart Builder. 
GGRAPH 
  /GRAPHDATASET NAME="graphdataset" VARIABLES=QUARTER Submissions County MISSING=LISTWISE REPORTMISSING=NO 
  /GRAPHSPEC SOURCE=INLINE. 
BEGIN GPL 
  SOURCE: s=userSource(id("graphdataset")) 
  DATA: QUARTER=col(source(s), name("QUARTER"), unit.category()) 
  DATA: Submissions=col(source(s), name("Submissions"), unit.category()) 
  DATA: County=col(source(s), name("County"), unit.category()) 
  GUIDE: axis(dim(1), label("Submission Qtr.")) 
  GUIDE: axis(dim(2), label("Num. of CANS")) 
  GUIDE: legend(aesthetic(aesthetic.shape.interior), label("County")) 
  GUIDE: text.title(label("Number of CANS by County and Quarter")) 
  SCALE: cat(dim(1), include("1", "2", "3", "4")) 
  ELEMENT: line(position(QUARTER*Submissions), shape.interior(County), missing.wings(), label(County)) 
END GPL.

/* Counties on Separate Panels */
* Chart Builder. 
GGRAPH 
  /GRAPHDATASET NAME="graphdataset" VARIABLES=QUARTER Submissions County MISSING=LISTWISE REPORTMISSING=NO 
  /GRAPHSPEC SOURCE=INLINE. 
BEGIN GPL 
  SOURCE: s=userSource(id("graphdataset")) 
  DATA: QUARTER=col(source(s), name("QUARTER"), unit.category()) 
  DATA: Submissions=col(source(s), name("Submissions"), unit.category()) 
  DATA: County=col(source(s), name("County"), unit.category()) 
  GUIDE: axis(dim(1), label("Submission Qtr.")) 
  GUIDE: axis(dim(2), label("Num. of CANS")) 
  GUIDE: axis(dim(4), label("County"), opposite()) 
  SCALE: cat(dim(1), include("1", "2", "3", "4")) 
  GUIDE: text.title(label("Number of CANS by County and Quarter"))
  ELEMENT: line(position(QUARTER*Submissions*1*County), missing.wings()) 
END GPL.


/* Counties on Separate Panels with labels for num of submissions */
* Chart Builder. 
GGRAPH 
  /GRAPHDATASET NAME="graphdataset" VARIABLES=QUARTER Submissions County MISSING=LISTWISE REPORTMISSING=NO 
  /GRAPHSPEC SOURCE=INLINE. 
BEGIN GPL 
  SOURCE: s=userSource(id("graphdataset")) 
  DATA: QUARTER=col(source(s), name("QUARTER"), unit.category()) 
  DATA: Submissions=col(source(s), name("Submissions"), unit.category()) 
  DATA: County=col(source(s), name("County"), unit.category()) 
  GUIDE: axis(dim(1), label("Submission Qtr.")) 
  GUIDE: axis(dim(2), label("Num. of CANS")) 
  GUIDE: axis(dim(4), label("County"), opposite()) 
  SCALE: cat(dim(1), include("1", "2", "3", "4")) 
  GUIDE: text.title(label("Number of CANS by County and Quarter"))
  ELEMENT: line(position(QUARTER*Submissions*1*County), missing.wings(), label(Submissions)) 
END GPL.
