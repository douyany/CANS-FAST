# in addition to counting the number of forms each month,
# this graph also displays the forms where the minimum standard dataset 
# is not available 

# read in the data
mdata <- read.table("h://mbg_db_reporting//reports//20150316_fast_counts_by_sub_month_nonnineMCI_nonstddataset.csv",
  header=TRUE, sep=",")

## finding max value within a county for how many forms
## within the time window

### find the result using tapply
maxofrows<-tapply(mdata$NumForms, mdata$COUNTY_ID, max)

### put result into data frame
### with first column as county id
maxofrows2<-data.frame("COUNTY_ID"=names(maxofrows), maxofrows)

library(psych)
describe(maxofrows2)

# create a vector for the values of the labels
# will omit the value, if the value is zero
# will omit the value, if the value is the same as the value in 
mdata$nonMCI[mdata$nonMCI==0] <-NA
mdata$nonminstd[mdata$nonminstd==0] <-NA
head(mdata)

### merge info about max per county 
### back with the rest of the dataset
mdata2<-merge(mdata, maxofrows2, by="COUNTY_ID")

## look over some rows
head(mdata2)

# if value is the same between the number of non-nine-digit MCI
# and the number of non-min-standard-dataset forms
# it doesn't need to be printed twice
mdata2$sameMCInonstd <-mdata2$nonMCI==mdata2$nonminstd
head(mdata2$sameMCInonstd)
tail(mdata2$sameMCInonstd)

# describe the dataset
library(psych)
describe(mdata2)
# all vars are being stored as numbers

# trying to get the graph using reshape . melt
## max of rows will be same within a county 
## should not add any rows to the table
library(reshape2)
mydata<- melt(mdata2, id=c("COUNTY_ID", "SubYear", "SubMonth", 
	"maxofrows", "sameMCInonstd"))
head(mydata)
tail(mydata)


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

# have labels for Number of Forms be above the point
# have labels for Number of Problematic Forms be below the point
# create a vector 
mydata$pos_vector <- vector()
##mydata$pos_vector <- rep(NA, length(mydata$yearmon))
mydata$pos_vector[mydata$variable=="NumForms"] <- 3

# change value to "below point" for problematic forms
mydata$pos_vector[mydata$variable %in% c("nonminstd", "nonMCI")] <- 1

mydata$pos_vector
#### if there are values for the num of records that are non-min-std,
#### put the y-value of those records' label at -(max)
#### helps stretch out the range of the data,
#### so that the lines will not overlap each other





# create a vector for the values of the labels
# will put the value at -.5(max) on the y-axis, if the value is for non-nine digit MCI 
# will put the value at -(max) on the y-axis,  for non-min std dataset values
# will omit the value, if the value is the same as the value in 
mydata$ylabel_vector <- mydata$value
mydata$ylabel_vector[mydata$variable=="nonMCI"] <- (-.5)*mydata$maxofrows

mydata$ylabel_vector[mydata$variable=="nonminstd"] <- (-1)*mydata$maxofrows

# version of command
# if value for number of records of that type is NA
# will also set location to NA
mydata <-within(mydata, 
	ylabel_vector <-ifelse(is.na(mydata$value), NA, ylabel_vector)
		)

## change value to "=" if nonMCI is same as nonminstd
mydata$value[mydata$sameMCInonstd & mydata$variable =="nonMCI"]<-"="


describe(mydata$ylabel_vector)
head(mydata$ylabel_vector)
tail(mydata$ylabel_vector, n=20)


# set colors for points
## have the number of forms written out in different colors
mydata$pointcolor <- rep(1, length(mydata$yearmon))
mydata$pointcolor[mydata$variable =="NumForms"] <-"black"
mydata$pointcolor[mydata$variable =="nonminstd"] <-"red"
mydata$pointcolor[mydata$variable =="nonMCI"] <-"mediumpurple3"
head(mydata$pointcolor)
tail(mydata$pointcolor)
####c("black", "red", "green3")


# setup for no margins on the legend
# bottom margin is the first number in the sequence
# top margin is the third number in the sequence
par(mar=c(5.1, 0, 4.1, 0))

 
####
####
####Various iterations of the graph
#### towards the final version of the graph
####
####
# with all the counties on same graph
xyplot(mydata$value ~ mydata$yrmo)
# each county on own graph
xyplot(mydata$value ~ mydata$yrmo |factor(mydata$COUNTY_ID) )

# allow each county to have own scale 
xyplot(mydata$value ~ mydata$yrmo |factor(mydata$COUNTY_ID),scales=list(relation="free"))

# connect the points of each line 
xyplot(mydata$value ~ mydata$yrmo |factor(mydata$COUNTY_ID),scales=list(relation="free"), 
 type="b")

# in a column of six graphs
xyplot(mydata$value ~ mydata$yrmo |factor(mydata$COUNTY_ID),scales=list(relation="free"), 
 type="b",  layout = c(1,6))
 
# label x-axis and y-axis
xyplot(mydata$value ~ mydata$yrmo |factor(mydata$COUNTY_ID),scales=list(relation="free"), 
 type="b",  layout = c(1,6), xlab="Month", ylab="Num. of Forms")
 
# label x-axis and y-axis, with order of counties in alphabetical order
xyplot(mydata$value ~ mydata$yrmo |factor(mydata$COUNTY_ID),scales=list(relation="free"), 
 type="b",  layout = c(1,6), xlab="Month", ylab="Num. of Forms", index.cond=list(c(6, 5, 4, 3, 2, 1)))

 # break data into groups within the panels 
 # the new part #
xyplot(mydata$value ~ mydata$yrmo |factor(mydata$COUNTY_ID),
	groups=factor(mydata$variable), 
	scales=list(relation="free"), 
 type="l",   xlab="Month", ylab="Num. of Forms")


 ##saves file as pdf
pdf(file="h://mbg_db_reporting//reports//20150325_FASTbymo_with_issue_records.pdf", paper="letter", height = 10) 
# with the x-axis now uniform across the counties			
# removed the symbols for each point
# do not draw y-axis ticks



xyplot(mydata$ylabel_vector ~ mydata$timelabels |factor(mydata$COUNTY_ID),
	groups=factor(mydata$variable), 
   prepanel = function(x, y, subscripts) { 
         list(ylim=extendrange(mydata$ylabel_vector[subscripts], f=.25)) 

       }, 
	   
	   		 labels=mydata$value,
			 key=list( title="Number of", x = .7, y =1, corner = c(0, 0),
			 				text=list(labels=c("FAST Child", "No MCI for Any Child", "Non-Min. Std. Dataset")),
			lines=list(col=c("black", "mediumpurple3", "red"),
				type=c("p", "p", "p")
				),
			border=TRUE,
			 cex=0.5
			 ),
scales=list(
            y=list(relation="free", draw=FALSE )), 
 type="l",  layout = c(1,6), xlab="Month", 
	ylab="Number of FAST Child Forms Submitted That Month",
 pch=NA_integer_,
 lty=c(1, 0, 0), 
 main="Number of FAST Child Submissions \nby County and Month",
 index.cond=list(c(6, 5, 4, 3, 2, 1)),
 panel= panel.superpose,
  panel.groups=function(x, y, ..., subscripts) {
               panel.xyplot(x, y, ..., subscripts=subscripts );
               panel.text(mydata$timelabels[subscripts], mydata$ylabel_vector[subscripts], labels=mydata$value[subscripts],  cex=0.8, 
			   offset=1, 
			   	col=mydata$pointcolor[subscripts],
			   position=mydata$pos_vector[subscripts])
			    panel.axis("left", ticks=FALSE, labels=FALSE)
				
            })

## y-value for problematic forms is not getting extended far enough
## for the latter counties


dev.off()
			


 			
			
# trying to draw using plot			
plot(mydata$value , mydata$yrmo 			, type="l")

plot( mydata$yrmo, mydata$value 			, type="l")

# trying to draw using ggplot
library(ggplot2)
p=ggplot( mydata, aes(x=yrmo, y=value)) + geom_line() +
    ggtitle("Growth curve for individual chicks")

	

library(xts) # Will also load zoo
mydata$datxts <- xts(mydata[-1], 
               order.by = as.yearmon(paste(mydata$SubYear, mydata$SubMonth, sep="-")) 
			   

			   
			   
			   
