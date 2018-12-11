#load libraries
library(data.table)
library(reshape2)
library(ggplot2)
#set working directory
setwd("~/Desktop/R_184/Week 3/Yelp-Dataset")
#read in 
Busn<-fread("yelp_academic_dataset_business.csv")
noText<-fread("yelp_academic_dataset_reviews_no_text.csv")
Comb<-fread("business_review_Melting_ALL.csv")

Star_DT<-Comb[,c("business_id", "Five_Star_count", "One_Star_count")]

#melt into a long format
m_Star_Count<-melt(Star_DT,id="business_id")

#clean the NAs and low star times
m_Star_Count<-m_Star_Count[!is.na(m_Star_Count$value)]
m_Star_Count<-m_Star_Count[value>0]
Star_Count<-data.table(m_Star_Count)

#rename
setnames(Star_Count, "variable", "Star_Type")
setnames(Star_Count, "value", "Star_Count")

#get the total number of review for each business
buss_review_count<-noText[,.N,by=business_id]

#total together
Star_Count<-merge(Star_Count,buss_review_count,all.x=T)

#calculate the frequency from counts
Star_Count$Star_freq<-Star_Count$Star_Count/Star_Count$N

#remove the less than 100
Star_Count<-Star_Count[N>100,]

#plot all the delay types in facets
ggplot(Star_Count,aes(x=log(N),y=Star_freq,col=Star_Type))+geom_point()+facet_grid(.~Star_Type)

#add a title
ggplot(Star_Count,aes(x=log(N),y=Star_freq,col=Star_Type))+geom_point()+facet_grid(.~Star_Type)+ggtitle("Five and One Star frequency in business")

#adjust title to center
ggplot(Star_Count,aes(x=log(N),y=Star_freq,col=Star_Type))+geom_point()+facet_grid(.~Star_Type)+ggtitle("Five and One Star frequency in business")+theme(plot.title = element_text(hjust = 0.5))

#change x and y axis names
ggplot(Star_Count,aes(x=log(N),y=Star_freq,col=Star_Type))+geom_point()+facet_grid(.~Star_Type)+ggtitle("Five and One Star frequency per business")+theme(plot.title = element_text(hjust = 0.5))+xlab("Log Number of Star")+ylab("Frequency of Extreme Rating")
