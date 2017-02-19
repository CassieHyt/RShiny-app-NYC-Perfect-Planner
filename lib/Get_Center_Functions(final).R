##Load Testing
##Selection<-c("Deli","Supermarket","Library","Theater","Resteranut","Musemu") 
##Deli<-read.csv("./Deli.csv")
##Supermarket<-read.csv("./Market.csv")


library(geosphere)

##Get Index for candidates
get_Ind<-function(data,Lon0,Lat0,r){
  coords<-cbind(data$LON,data$LAT)
  dis<-distm(coords,c(Lon0,Lat0), fun = distHaversine)
  Ind<-dis<r
  return(list(dis=dis,Ind=Ind))
}

##Get data:
get_candidate<-function(data,Lon0,Lat0,r){
  coords<-cbind(data$LON,data$LAT)
  dis<-distm(coords,c(Lon0,Lat0), fun = distHaversine)
  Ind<-dis<r
  return(data[Ind,])
}


##########Give centers based on the selection
########Output is dataframe. if no data satisfying the conditions, error messages will appear
get_center<-function(choice1,choice2,choice3,Lon0,Lat0,distance,radius){
  ##Check how many choices are made
  null2<-is.na(choice2)
  null3<-is.na(choice3)
  
  ##If the user only select "Choice1" 
  if (null2 & null3){
    data_candidate<-all_data[[choice1]]
    ##Get candidates according to the radius:
    output_data<-get_candidate(data_candidate,Lon0=Lon0,Lat0=Lat0,r=distance)
    return(output_data)
  }

  ##If the user only select "Choice1" and "Choice 2"
  if (!null2 & null3){
    data_candidate<-all_data[c(choice1,choice2)]
    data_candidate<-na.omit(data_candidate)
    ##Get candidates according to the radius:
    data_select<-lapply(data_candidate,get_candidate,Lon0=Lon0,Lat0=Lat0,r=distance)
    D1<-na.omit(data_select[[choice1]])
    D2<-na.omit(data_select[[choice2]])
    
    if ((dim(D1)[1]==0)|((dim(D2)[1]==0))){
      mess<-"Sorry,No place found! Please try Longer Distance"
      return(mess)
      } else {
        coords1<-D1[,c("LON","LAT")]
        coords2<-D2[,c("LON","LAT")]
        ##Culculate distance between choices and selected the centers
        Dis2<-distm(coords1,coords2, fun = distHaversine)
        Inx2<-Dis2<radius
        output_data<-D1[!(colSums(Inx2)==0),]
        return(output_data)
      }
  }
  
  ##If the user selecte all choices
  if (!null2 & !null3){
    data_candidate<-all_data[c(choice1,choice2,choice3)]
    
    ##Get candidates according to the radius:
    data_select<-lapply(data_candidate,get_candidate,Lon0=Lon0,Lat0=Lat0,r=distance)
    D1<-na.omit(data_select[[choice1]])
    D2<-na.omit(data_select[[choice2]])
    D3<-na.omit(data_select[[choice3]])
    
    if ((dim(D1)[1]==0)|((dim(D2)[1]==0))|((dim(D3)[1]==0))){
      mess<-"Sorry,No place found! Please try Longer Distance"
      return(mess)
    } else {
    coords1<-D1[,c("LON","LAT")]
    coords2<-D2[,c("LON","LAT")]
    coords3<-D3[,c("LON","LAT")]
    
    ##Culculate distance between choices
    Dis2<-distm(coords1,coords2, fun = distHaversine)
    Dis3<-distm(coords1,coords3, fun = distHaversine)
    Inx2<-Dis2<radius
    Inx3<-Dis3<radius
    output_data<-D1[(!(colSums(Inx2)==0))&(!(colSums(Inx3)==0)),]
    return(output_data)
  }
  }
}

##output is dataframe : either center or "Error Message"


###Testing
#data1<-get_center("Deli","Supermarket",NA,-73.68,40.67,1000,9000)


#choice1<-"Deli"
#choice2<-"Supermarket"
#choice3<-NA
#Lon0<--73.68
#Lat0<-40.67
#distance<-13000
#radius<-10000
#distm(c(-73.70,40.8),c(Lon0,Lat0), fun = distHaversine)
