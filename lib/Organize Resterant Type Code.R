Data<-read.csv("../data/NYC_Resteraunts.csv",header = T,as.is = T,encoding = "UTF-8")
##Change type of the resteruant
type<-c(as.character(unique(Data$CUISINE.DESCRIPTION)))

##Define the new type of the resteraunt:
type_fast<-c(type[c(3,5,10,14,18,24,27,34,37,47,48,59,64,65,78)])
type_Ita<-c(type[c(7,17)])
type_snaces<-c(type[c(1,4,50,56)])
type_America<-c(type[c(2,12,20,71)])
type_Chinese<-c(type[c(11,25,58,67)])
type_Eurpea<-c(type[c(21,23,31,33,36,40,51,52,66,75)])
type_Asian<-c(type[c(8,19,22,26,30,35,warnin43,49,53,74)])
type_Mex<-c(type[c(9,13,45)])
type_French<-c(type[c(32,46)])
type_other<-c(type[c(15,16,28,29,38,39,41,42,44,54,55,57,60,61,62,63,68,69,70,72,73,76,77,79,80,81,82,83)])
type_All<-list(QuickMeal=type_fast,Italian=type_Ita,Dessert=type_snaces,American=type_America,Chinese=type_Chinese,
           European=type_Eurpea,Asian=type_Asian,Mexcian=type_Mex,French=type_French,Other=type_other)


##Re-assigne the type of the resteraunt:
for (i in 1:length(type_All)){
  for(j in 1:nrow(Data)){
  if (Data$CUISINE.DESCRIPTION[j] %in% type_All[[i]]){
    Data$CUISINE.DESCRIPTION[j]<-names(type_All[i])
  }
  }
}


##Checking the results.
#unique(Data$CUISINE.DESCRIPTION)
#sum(is.na(Data$CUISINE.DESCRIPTION))

#write.csv(Data$CUISINE.DESCRIPTION,"../data/Resteraunts_type.csv")

