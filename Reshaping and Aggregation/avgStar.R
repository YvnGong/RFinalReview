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

US[,.(Avg_Star_Count=mean(stars)),by=state]

#dcast offeres a larger set of reshaping options 
Avg_Star_tab<-dcast(US,state ~ .,mean,value.var= c("stars"))
#dcast allows you to define multiple groupings
Avg_Star_tab<-dcast(US,state ~ city,mean,value.var= c("stars"))

#this is the same information in tidy format
Avg_Star_tab<-dcast(US,state + city~.,mean,value.var= c("stars"))

#rename the '.' column
setnames(Avg_Star_tab,".","Avg_Stars")
Avg_Star_hundred = Avg_Star_tab[1:100]
fwrite(Avg_Star_hundred,"Avg_Star_100.csv")



