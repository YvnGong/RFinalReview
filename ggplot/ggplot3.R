library(data.table)
library(reshape2)
library(ggplot2)

#set working directory
setwd("~/Desktop/R_184/Week 3/Yelp-Dataset")

#import data sets
User<-fread("yelp_academic_dataset_user.csv")
noText<-fread("yelp_academic_dataset_reviews_no_text.csv")

#melting starts
Comment_DT<-User[,c("user_id", "useful", "funny", "cool")]
m_Type_Comment<-melt(Comment_DT, id="user_id")

#clean up the data
m_Type_Comment<-m_Type_Comment[!is.na(m_Type_Comment$value)]
m_Type_Comment<-m_Type_Comment[value>0]

#get the counts for each type
Type_Comment<-dcast(m_Type_Comment, user_id+variable~., length, value.var=c("value"))
Type_Comment<-data.table(Type_Comment)

#reName it
setnames(Type_Comment, ".", "Type_Count")
setnames(Type_Comment, "variable", "Review_Type")

#get the total number of review for each business
#Total_Review<-User[,c("user_id", "review_count")]
review_user<-noText[,.N,by=user_id]
#user_review_count<-noText[,.N,by=user_id]
#merge the total number of review type to the counts of each type of review
Type_Comment<-merge(Type_Comment,review_user,all.x=T)

#calculate the frequency from counts
Type_Comment$Type_freq<-Type_Comment$Type_Comment/Type_Comment$N
#Type_Comment[, "review_freq"]<-Type_Comment[, "Type_Count"]/Type_Comment[, "review_count"]

#remove review less thann 100
Type_Comment<-Type_Comment[N>100]

#plot all 
ggplot(Type_Comment,aes(x=log(review_count),y=review_freq,col=Review_Type))+geom_point()+facet_grid(.~Review_Type)

#add a title
ggplot(Type_Comment,aes(x=log(review_count),y=review_freq,col=Review_Type))+geom_point()+facet_grid(.~Review_Type)+ggtitle("Review Type frequency found per users")

#adjust title to center
ggplot(Type_Comment,aes(x=log(review_count),y=review_freq,col=Review_Type))+geom_point()+facet_grid(.~Review_Type)+ggtitle("Review Type frequency found per users")+theme(plot.title = element_text(hjust = 0.5))

#change x and y axis names
ggplot(Type_Comment,aes(x=log(review_count),y=review_freq,col=Review_Type))+geom_point()+facet_grid(.~Review_Type)+ggtitle("Review Type frequency found per users")+theme(plot.title = element_text(hjust = 0.5))+xlab("Log Number of Review")+ylab("Frequency of Review Found")




