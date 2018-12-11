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
#this is the same information in tidy format
Avg_Review_tab<-dcast(Busn,state + city~.,mean,value.var= c("review_count"))

#rename the '.' column
setnames(Avg_Review_tab,".","Average_Review_Count")

Avg_Review_tab_hundred = Avg_Review_tab[1:100]

fwrite(Avg_Review_tab_hundred, "Avg_Review_Count_2000000000.csv")



