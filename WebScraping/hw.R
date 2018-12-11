library(rvest)
library(data.table)
library(reshape2)

setwd("~/Desktop/R_184/Week 10")

#####Read in url#####
alabama <- "http://www.espn.com/college-football/team/stats/_/id/333"
clemson <- "http://www.espn.com/college-football/team/stats/_/id/228"
notreDame <- "http://www.espn.com/college-football/team/stats/_/id/87"
michigan <- "http://www.espn.com/college-football/team/stats/_/id/130"
georgia <- "http://www.espn.com/college-football/team/stats/_/id/61"

#####alabama#####
#get the tables
alabama_Tables <- alabama %>%
  read_html() %>%
  html_table()

#clean the header  
ala_Rushing<-alabama_Tables[[2]][-1,]
ala_header<-ala_Rushing[1,]
ala_Rushing<-data.table(ala_Rushing[-1,])
setnames(ala_Rushing,names(ala_Rushing),as.character(unlist(ala_header[1,])))
#remove the totals from the bottom
ala_Rushing<-head(ala_Rushing,-1)

#####end alabama#####

#####clemson#####
#get the tables
clemson_Tables <- clemson %>%
  read_html() %>%
  html_table()

#clean the header  
cle_Rushing<-clemson_Tables[[2]][-1,]
cle_header<-cle_Rushing[1,]
cle_Rushing<-data.table(cle_Rushing[-1,])
setnames(cle_Rushing,names(cle_Rushing),as.character(unlist(cle_header[1,])))
#remove the totals from the bottom
cle_Rushing<-head(cle_Rushing,-1)

#####end clemson#####

#####notreDame#####
#get the tables
notreDame_Tables <- notreDame %>%
  read_html() %>%
  html_table()

#clean the header  
notr_Rushing<-notreDame_Tables[[2]][-1,]
notr_header<-notr_Rushing[1,]
notr_Rushing<-data.table(notr_Rushing[-1,])
setnames(notr_Rushing,names(notr_Rushing),as.character(unlist(notr_header[1,])))
#remove the totals from the bottom
notr_Rushing<-head(notr_Rushing,-1)

#####end notreDame#####

#####michigan#####
#get the tables
michigan_Tables <- michigan %>%
  read_html() %>%
  html_table()

#clean the header  
mich_Rushing<-michigan_Tables[[2]][-1,]
mich_header<-mich_Rushing[1,]
mich_Rushing<-data.table(mich_Rushing[-1,])
setnames(mich_Rushing,names(mich_Rushing),as.character(unlist(mich_header[1,])))
#remove the totals from the bottom
mich_Rushing<-head(mich_Rushing,-1)

#####end michigan#####

#####georgia#####
#get the tables
georgia_Tables <- georgia %>%
  read_html() %>%
  html_table()

#clean the header  
geo_Rushing<-georgia_Tables[[2]][-1,]
geo_header<-geo_Rushing[1,]
geo_Rushing<-data.table(geo_Rushing[-1,])
setnames(geo_Rushing,names(geo_Rushing),as.character(unlist(geo_header[1,])))
#remove the totals from the bottom
geo_Rushing<-head(geo_Rushing,-1)

#####end georgia#####

######merging######
topFive <- merge(ala_Rushing, cle_Rushing, all = TRUE)
topFive <- merge(topFive, notr_Rushing, all = TRUE)
topFive <- merge(topFive, mich_Rushing, all = TRUE)
topFive <- merge(topFive, geo_Rushing, all = TRUE)

fwrite(topFive, file = "webWrapingFootball.csv")