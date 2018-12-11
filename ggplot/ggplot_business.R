library(data.table)
library(reshape2)
library(ggplot2)
#set working directory
setwd("~/Desktop/R_184/Week 3/Yelp-Dataset")

#import two data sets
Busn<-fread("yelp_academic_dataset_business.csv")
noText<-fread("yelp_academic_dataset_reviews_no_text.csv")

#melting starts
Type_noText<-noText[,c("business_id", "useful", "funny", "cool")]
m_Type_noText<-melt(Type_noText, id="business_id")

#clean up the data
m_Type_noText<-m_Type_noText[!is.na(m_Type_noText$value)]
m_Type_noText<-m_Type_noText[value>0]

#get the counts for each type
Type_Count<-dcast(m_Type_noText, business_id+variable~., length, value.var=c("value"))
Type_Count<-data.table(Type_Count)

#reName it
setnames(Type_Count, ".", "Type_Count")
setnames(Type_Count, "variable", "Review_Type")

#get the total number of review for each business
buss_review_count<-noText[,.N,by=business_id]
#buss_review_count<-Busn[review_count]

#merge the total number of review type to the counts of each type of review
Type_Count<-merge(Type_Count,buss_review_count,all.x=T)

#calculate the frequency from counts
Type_Count$Type_freq<-Type_Count$Type_Count/Type_Count$N

#remove review less thann 100
Type_Count<-Type_Count[N>100,]

#plot
ggplot(Type_Count[Review_Type=="useful",],aes(x=N,y=Type_freq))+geom_point()

#what is the distribution of total flights per airport
ggplot(Type_Count[Review_Type=="useful",],aes(x=N))+geom_histogram(bins = 50)

#does a log transform help?
ggplot(Type_Count[Review_Type=="useful",],aes(x=log(N)))+geom_histogram(bins = 50)

#log transform the x axis
ggplot(Type_Count[Review_Type=="useful",],aes(x=log(N),y=Type_freq))+geom_point()

#plot all 
ggplot(Type_Count,aes(x=log(N),y=Type_freq,col=Review_Type))+geom_point()+facet_grid(.~Review_Type)

#add a title
ggplot(Type_Count,aes(x=log(N),y=Type_freq,col=Review_Type))+geom_point()+facet_grid(.~Review_Type)+ggtitle("Review Type frequency")

#adjust title to center
ggplot(Type_Count,aes(x=log(N),y=Type_freq,col=Review_Type))+geom_point()+facet_grid(.~Review_Type)+ggtitle("Review Type frequency")+theme(plot.title = element_text(hjust = 0.5))

#change x and y axis names
ggplot(Type_Count,aes(x=log(N),y=Type_freq,col=Review_Type))+geom_point()+facet_grid(.~Review_Type)+ggtitle("Review Type frequency")+theme(plot.title = element_text(hjust = 0.5))+xlab("Log Number of Review")+ylab("Frequency of Type Review")




