#load libraries
library(data.table)
library(reshape2)
#set working directory
setwd("~/Desktop/R_184/Week 3/Yelp-Dataset")

Busn<-fread("yelp_academic_dataset_business.csv")
#review<-fread("yelp_academic_dataset_review.csv")
noText<-fread("yelp_academic_dataset_reviews_no_text.csv")

#user<-fread("yelp_academic_dataset_user.csv", nrows = 100)
#calculate some aggregate stats 

Avg_Star_review<-dcast(noText,business_id ~ .,mean,value.var= c("stars"))
Avg_Useful_review<-dcast(noText,business_id~.,mean,na.rm=T,value.var=c("useful"))
Tot_Useful_count<-dcast(noText,business_id~.,sum,na.rm=T,value.var=c("useful"))
Five_Star_subset<-noText[stars==5,]
Five_Star_count<-dcast(Five_Star_subset,business_id~.,length,value.var=c("business_id"))
One_Star_subset<-noText[stars==1,]
One_Star_count<-dcast(One_Star_subset,business_id~.,length,value.var=c("business_id"))

#rename the new values
setnames(Avg_Star_review,".","Avg_Star")
setnames(Avg_Useful_review,".","Avg_Useful_Review")
setnames(Tot_Useful_count,".","Tot_Useful_Review")
setnames(Five_Star_count,".","Five_Star_count")
setnames(One_Star_count,".","One_Star_count")

#write out .csv to upload to canvas
#fwrite(Avg_Star_review[1:100,],"Avg_Star.csv")
#fwrite(Five_Star_count[1:100,],"five_star.csv")

#make sure the objects are data.tables
Avg_Star_review<-data.table(Avg_Star_review)
Avg_Useful_review<-data.table(Avg_Useful_review)
Tot_Useful_count<-data.table(Tot_Useful_count)
Five_Star_count<-data.table(Five_Star_count)
One_Star_count<-data.table(One_Star_count)

#merging with keys
#first set some keys
setkey(noText, business_id)
setkey(Avg_Star_review, business_id)
setkey(Avg_Useful_review, business_id)
setkey(Tot_Useful_count, business_id)
setkey(Five_Star_count, business_id)
setkey(One_Star_count, business_id)

#do the merging

review_stats<-merge(Busn,Busn,all.x=T)
review_stats<-merge(review_stats,Avg_Star_review,all.x=T)
review_stats<-merge(review_stats,Avg_Useful_review,all.x=T)
review_stats<-merge(review_stats,Tot_Useful_count,all.x=T)
review_stats<-merge(review_stats,Five_Star_count,all.x=T)
review_stats<-merge(review_stats,One_Star_count,all.x=T)

fwrite(review_stats[1:100,],"business_reviewStats.csv")