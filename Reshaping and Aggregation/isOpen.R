#load libraries
library(ggplot2)
library(dplyr)
library(reshape2)
library(stringr)
library(lubridate)
library(data.table)

###Goal###
# Work on the total number of business in all cities

#set working directory
setwd("~/Desktop/R_184/Week 3/Yelp-Dataset")

Busn<-fread("yelp_academic_dataset_business.csv")

USstate <- c("AB", "NV", "QC", "AZ", "ON", "OH", "IL", "WI", "PA", "BY", "NYK", "NC", "SC")

US<-Busn[state %in% USstate]

dim(US)

US[,.(open_count=sum(is_open)),by=state]

#dcast offeres a larger set of reshaping options 
open_tab<-dcast(US,state ~ .,sum,value.var= c("is_open"))
#dcast allows you to define multiple groupings
open_tab<-dcast(US,state ~ city,sum,value.var= c("is_open"))

#this is the same information in tidy format
open_tab<-dcast(US,state + city~.,sum,value.var= c("is_open"))

#rename the '.' column
setnames(open_tab,".","num_open")
open_hundred = open_tab[1:100]
fwrite(open_hundred,"num_Open_100.csv")



