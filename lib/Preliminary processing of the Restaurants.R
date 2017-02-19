library(ggmap)
require(RJSONIO)
###Load the data
##NYC_Resteraunts.csv is the raw data from the website, which we don't include in our data file
Data<-read.csv("../data/Restaurants_Raw.csv.csv",header = T,as.is = T,encoding = "UTF-8")

#############################################################################
#The following code is for re-assigning the resteraunt type
#############################################################################
##Check type of the resteruant
type<-c(as.character(unique(Data$TYPE)))

##Define the new type of the resteraunt:
type_fast<-c(type[c(3,5,10,14,18,24,27,34,37,47,48,59,64,65,78)])
type_Ita<-c(type[c(7,17)])
type_snaces<-c(type[c(1,4,50,56)])
type_America<-c(type[c(2,12,20,71)])
type_Chinese<-c(type[c(11,25,58,67)])
type_Eurpea<-c(type[c(21,23,31,33,36,40,51,52,66,75)])
type_Asian<-c(type[c(8,19,22,26,30,35,43,49,53,74)])
type_Mex<-c(type[c(9,13,45)])
type_French<-c(type[c(32,46)])
type_other<-c(type[c(15,16,28,29,38,39,41,42,44,54,55,57,60,61,62,63,68,69,70,72,73,76,77,79,80,81,82,83)])
type_All<-list(QuickMeal=type_fast,Italian=type_Ita,Dessert=type_snaces,American=type_America,Chinese=type_Chinese,
           European=type_Eurpea,Asian=type_Asian,Mexcian=type_Mex,French=type_French,Other=type_other)


##Re-assigne the type of the resteraunt:
for (i in 1:length(type_All)){
  for(j in 1:nrow(Data)){
  if (Data$TYPE[j] %in% type_All[[i]]){
    Data$TYPE[j]<-names(type_All[i])
  }
  }
}


##Checking the results.
#unique(Data$TYPE)
#sum(is.na(Data$TYPE))

#############################################################################
#The following code is for changing ADDRESS to LAT and LON
#############################################################################
##Create new variable "ADRESS"
Data$ADDRESS<-paste(Data$BUILDING,Data$STREcET,sep =" ")
Data$ADDRESS<-paste(Data$ADDRESS,"New York City",sep=", ")


##Create functions
geocodeAdddress <- function(address) {
  url <- "http://maps.google.com/maps/api/geocode/json?address="
  url <- URLencode(paste(url, address, "&sensor=false", sep = ""))
  x <- fromJSON(url, simplify = FALSE)
  if (x$status == "OK") {
    out <- c(x$results[[1]]$geometry$location$lng,
             x$results[[1]]$geometry$location$lat)
  } else {
    out <- NA
  }
  Sys.sleep(0.2)  # API only allows 5 requests per second
  out
}


##Perform Conversion:
n<-length(Data$ADDRESS)
#Cor<-matrix(NA,nrow = n,ncol = 2)
for (i in 8788:8791){
  Cor[i,]<-geocodeAdddress(Data$ADDRESS[i])
}


##Obtained useful information£»
Cor<-as.data.frame(Cor)
colnames(Cor)<-c("LON","LAT")
Data$LON<-Cori$LON
Data$LAT<-corodi$LAT
Data<-Data[,-c(1,4,5)]
Data<-na.omit(Data)

#write.csv(Data,"../data/Restaurant.csv")
