library(data.table)
library(reshape2)
library(ggplot2)
library(geosphere)
library(lubridate)

#download data to your local computer
download.file(url="https://s3.amazonaws.com/stat.184.data/BikeShare/Trips.csv",destfile='Trips.csv', method='curl')
download.file(url="https://s3.amazonaws.com/stat.184.data/BikeShare/DC_Stations.csv",destfile='DC_Stations.csv', method='curl')

#Read in the data
#Stations gives information about each bike share station location
Stations<-fread("DC_Stations.csv")
#Trips gives information about the rental history over the last quarter of 2014
Trips<-fread("Trips.csv")

setnames(Stations, c("name", "lat", "long"), c("sstation", "slat", "slon"))
Trips<-merge(Trips,Stations[,c("sstation", "slat", "slon")],all.x = T)
setnames(Stations, c("sstation", "slat", "slon"), c("estation", "elat", "elon"))
Trips<-merge(Trips,Stations[,c("estation", "elat", "elon")],by="estation",all.x = T)

Trips$distance<-distHaversine(Trips[,c('slon','slat')], Trips[,c('elon','elat')])

Travel<-Trips[! distance == 0]
Travel$time<-duration(Travel[,c(duration)])
Travel<-data.table(Travel)[order(distance)]
#make a density plot with geom_dist for the frequency of trips across every distance observed in the dataset
#ggplot(Travel,aes(x=distance, y=time@.Data))+geom_point()
ggplot(Travel,aes(x=distance, y=time@.Data))+geom_point()+ggtitle("Bikeshare Station Rental Duration by Distance")+theme(plot.title = element_text(hjust = 0.5))+xlab("distance traveled")+ylab("time in seconds")