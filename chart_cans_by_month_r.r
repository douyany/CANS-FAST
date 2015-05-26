# read in the data
mydata <- read.table("h://mbg_db_reporting//reports//20150310_cans_counts_by_submission_month_csv.csv",
  header=TRUE, sep=",")

# describe the dataset
library(psych)
describe(mydata)
# all vars are being stored as numbers

# load lattice library 
library(lattice)

  
#use zoo package to convert year and month into a date 
#load(zoo)
library(zoo)
mydata$yrmo <- as.yearmon(paste(mydata$SubYear, mydata$SubMonth, sep="-")) 

# add factors for county names
mydata$COUNTY_ID<-factor(mydata$COUNTY_ID,
 levels = c(2, 20, 22, 35, 51, 61),
 labels = c("Allegheny","Crawford","Dauphin","Lackawanna","Philadelphia","Venango"))

 # create a date that is in word rather than in decimal format
mydata$timelabels<-as.Date(mydata$yrmo)
mydata$timelabels
 
####
####
####Various iterations of the graph
#### towards the final version of the graph
####
####
# with all the counties on same graph
xyplot(mydata$NumForms ~ mydata$yrmo)
# each county on own graph
xyplot(mydata$NumForms ~ mydata$yrmo |factor(mydata$COUNTY_ID) )

# allow each county to have own scale 
xyplot(mydata$NumForms ~ mydata$yrmo |factor(mydata$COUNTY_ID),scales=list(relation="free"))

# connect the points of each line 
xyplot(mydata$NumForms ~ mydata$yrmo |factor(mydata$COUNTY_ID),scales=list(relation="free"), 
 type="b")

# in a column of six graphs
xyplot(mydata$NumForms ~ mydata$yrmo |factor(mydata$COUNTY_ID),scales=list(relation="free"), 
 type="b",  layout = c(1,6))
 
# label x-axis and y-axis
xyplot(mydata$NumForms ~ mydata$yrmo |factor(mydata$COUNTY_ID),scales=list(relation="free"), 
 type="b",  layout = c(1,6), xlab="Month", ylab="Num. of Forms")
 
# label x-axis and y-axis, with order of counties in alphabetical order
xyplot(mydata$NumForms ~ mydata$yrmo |factor(mydata$COUNTY_ID),scales=list(relation="free"), 
 type="b",  layout = c(1,6), xlab="Month", ylab="Num. of Forms", index.cond=list(c(6, 5, 4, 3, 2, 1)))



 ##saves file as pdf
pdf(file="h://mbg_db_reporting//reports//20150312_CANSbymo.pdf", paper="letter") 
# with the x-axis now uniform across the counties			
# removed the symbols for each point
# do not draw y-axis ticks

xyplot(mydata$NumForms ~ mydata$timelabels |factor(mydata$COUNTY_ID),
groups=factor(mydata$COUNTY_ID),
   prepanel = function(x, y, subscripts) { 
         list(ylim=extendrange(mydata$NumForms[subscripts], f=.25)) 
       }, 
scales=list(
            y=list(relation="free", draw=FALSE )), 
 type="b",  layout = c(1,6), xlab="Month", ylab="Num. of CANS",
 pch=NA_integer_,
 main="CANS Submissions by County and Month",
 index.cond=list(c(6, 5, 4, 3, 2, 1)),
 panel= panel.superpose,
  panel.groups=function(x, y, ..., subscripts) {
               panel.xyplot(x, y, ..., subscripts=subscripts );
               panel.text(mydata$timelabels[subscripts], mydata$NumForms[subscripts], labels=mydata$NumForms[subscripts],  cex=0.8, offset=1)
			    panel.axis("left", ticks=FALSE, labels=FALSE)
				
            })



dev.off()
			


 			
			
# trying to draw using plot			
plot(mydata$NumForms , mydata$yrmo 			, type="l")

plot( mydata$yrmo, mydata$NumForms 			, type="l")

# trying to draw using ggplot
library(ggplot2)
p=ggplot( mydata, aes(x=yrmo, y=NumForms)) + geom_line() +
    ggtitle("Growth curve for individual chicks")

	
	# trying to get the graph using reshape . melt
library(reshape2)
valuelabels<- dcast(mydata, yrmo~COUNTY_ID, value.var=NumForms)	
valuelabels<- dcast(mydata, yrmo~COUNTY_ID, value.var="NumForms")	
mytext<- c(valuelabels$2)

library(xts) # Will also load zoo
mydata$datxts <- xts(mydata[-1], 
               order.by = as.yearmon(paste(mydata$SubYear, mydata$SubMonth, sep="-")) 
			   

			   
			   
			   
