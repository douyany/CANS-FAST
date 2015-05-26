/* This version of the charts allows people to have separate scales for the graphs */


GET DATA 
  /TYPE=XLS 
  /FILE='H:\mbg_db_reporting\from_yb\20150210_CANS-FAST_qtr.xls' 
  /SHEET=name 'CANS' 
  /CELLRANGE=full 
  /READNAMES=on 
  /ASSUMEDSTRWIDTH=32767. 
EXECUTE. 

RENAME VARIABLES (V1=County).

/* remove the observations for the first two quarters of 2014 */
/* for Crawford County */

if County='Crawford' JanMarch2014=$SYSMIS.
if County='Crawford' AprilJune2014=$SYSMIS.

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

/* now that data is long */
/* make data wide */
/* with each county as its own variable */
/* it is like transposing the original data table */

sort cases by QUARTER County.
*split file by County.
CASESTOVARS
 /id=QUARTER
 /INDEX=County.


* Chart Builder. 
*  GUIDE: text.title(label("Number of CANS by County and Quarter")) .
* Chart Builder. 
GGRAPH 
  /GRAPHDATASET NAME="graphdataset" VARIABLES=QUARTER Allegheny  Crawford  Dauphin  Lackawanna     Philadelphia  Venango  
   REPORTMISSING=YES
  /GRAPHSPEC SOURCE=INLINE. 
BEGIN GPL 
  SOURCE: s=userSource(id("graphdataset")) 
  DATA: QUARTER=col(source(s), name("QUARTER"), unit.category()) 
  DATA: Allegheny=col(source(s), name("Allegheny")) 
  DATA: Crawford=col(source(s), name("Crawford")) 
  DATA: Dauphin=col(source(s), name("Dauphin")) 
  DATA: Lackawanna=col(source(s), name("Lackawanna")) 
  DATA: Philadelphia=col(source(s), name("Philadelphia")) 
  DATA: Venango=col(source(s), name("Venango") ) 
	GRAPH: BEGIN(origin(10%, 0%), scale(90%, 15%))
  GUIDE: axis(dim(2), label("Alleg.")) 
    GUIDE: axis(dim(1), ticks(null())) 
  SCALE: linear(dim(2), min(0), origin(0))
  ELEMENT: line(position(QUARTER*Allegheny),missing.wings(), label(Allegheny)) 
	GRAPH: END()
	GRAPH: BEGIN(origin(10%, 16%), scale(90%, 15%))
  SCALE: linear(dim(2), min(0), origin(0))
    GUIDE: axis(dim(2), label("Crawf.")) 
    GUIDE: axis(dim(1), ticks(null())) 
  ELEMENT: line(position(QUARTER*Crawford), missing.wings(), label(Crawford)) 
	GRAPH: END()
	GRAPH: BEGIN(origin(10%, 32%), scale(90%, 15%))
  SCALE: linear(dim(2), min(0), origin(0))
    GUIDE: axis(dim(2), label("Dauphin")) 
    GUIDE: axis(dim(1), ticks(null())) 
  ELEMENT: line(position(QUARTER*Dauphin), missing.wings(), label(Dauphin)) 
	GRAPH: END()
	GRAPH: BEGIN(origin(10%, 48%), scale(90%, 15%))
  SCALE: linear(dim(2), min(0), origin(0))
    GUIDE: axis(dim(2), label("Lacka.")) 
    GUIDE: axis(dim(1), ticks(null())) 
  ELEMENT: line(position(QUARTER*Lackawanna), missing.wings(), label(Lackawanna)) 
	GRAPH: END()
	GRAPH: BEGIN(origin(10%, 64%), scale(90%, 15%))
  SCALE: linear(dim(2), min(0), origin(0))
    GUIDE: axis(dim(2), label("Phila.")) 
    GUIDE: axis(dim(1), ticks(null())) 
  ELEMENT: line(position(QUARTER*Philadelphia), missing.wings(), label(Philadelphia)) 
	GRAPH: END()
	GRAPH: BEGIN(origin(10%, 80%), scale(90%, 15%))
  SCALE: linear(dim(2), min(0), origin(0))
    GUIDE: axis(dim(2), label("Venango")) 
  ELEMENT: line(position(QUARTER*Venango), missing.wings(), label(Venango)) 
	GRAPH: END()

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
