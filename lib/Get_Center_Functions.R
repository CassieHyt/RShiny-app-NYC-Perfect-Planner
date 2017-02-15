##Load Testing
#Deli<-read.csv("../data/Deli.csv")
#Supermarket<-read.csv("../data/Market.csv")
#colnames(Deli)[c(14,15)]<-c("LON","LAT")
#colnames(Supermarket)[c(14,15)]<-c("LON","LAT")



Selection<-c("Deli","Supermarket","Library","Theater","Resteranut","Musemu") 

get_Ind<-function(data,Lon0,Lat0,r){
  dis<-(data$LON-Lon0)^2+(data$LAT-Lat0)^2
  Ind<-dis<r^2
  return(list(dis=dis,Ind=Ind))
}

get_candidate<-function(data,Lon0,Lat0,r){
  Ind<-(data$LON-Lon0)^2+(data$LAT-Lat0)^2<r^2
  return(data[Ind,])
}

all_data<-list(Deli=Deli,Supermarket=Supermarket)


get_center<-function(choice1,choice2,choice3,Lon0,Lat0,distance,radius){
  
  ##Get candidates accoriding to distance
  data_candidate<-all_data[c(choice1,choice2,choice3)]
  data_select<-lapply(data_candidate,get_candidate,Lon0=Lon0,Lat0=Lat0,r=distance)
  
  ##Get candidates according to the radius:
  D1<-data_select[[choice1]]
  D2<-data_select[[choice2]]
  D3<-data_select[[choice3]]
  I<-nrow(D1)
  Ans1<-NULL
  #Ans2<-NULL
  #Ans3<-NULL
  #r<-NULL
  IN1<-NULL
  IN2<-NULL
  
  ##Check
  null2<-is.na(choice2)
  null3<-is.na(choice3)
  
  ##If the user only select "Choice1" 
  if (null2 & null3){
    output_data<-D1
  }
  
  
  ##If the user only select "Choice1" and "Choice2"
  if (!null2 & null3){
    for(i in 1:I){
      with2<-get_Ind(D2,D1[i,"LON"],D1[i,"LAT"],r=radius)
      IN2<-with2$Ind
      if (sum(IN2,na.rm=T)!=0){
        Ans1<-c(Ans1,i)
        #Ans2<-rbind(Ans2,IN2)
        #Ans3<-rbind(Ans2,IN2)
      }
    }
    output_data<-D1[Ans1,]
  } 
  if(!null2 & !null3){
    for(i in 1:I){
      with2<-get_Ind(D2,D1[i,"LON"],D1[i,"LAT"],r=radius)
      with3<-get_Ind(D3,D1[i,"LON"],D1[i,"LAT"],r=radius)
      IN2<-with2$Ind
      IN3<-with3$Ind
      if (sum(IN2,na.rm=T)!=0 & sum(IN3,na.rm=T)!=0){
        Ans1<-c(Ans1,i)
        #Ans2<-rbind(Ans2,IN2)
        #Ans3<-rbind(Ans2,IN2)
      }
    }
    output_data<-D1[Ans1,]
  }
  return(output_data) 
}


###Testing
#data<-get_center("Deli","Supermarket",NA,-73.68,40.67,0.1,0.01)
#choice1<-"Deli"
#choice2<-"Supermarket"
#choice3<-NA
#Lon0<--73.68
#Lat0<-40.67
#distance<-0.03
#radius<-0.01
