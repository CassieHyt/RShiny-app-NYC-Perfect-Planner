library(leaflet)
library(shiny)

source("../lib/global.R")
namedata<-c("Deli","Museum","Theater","Gallery","Library","Market")


shinyServer(function(input,output){
  output$map <- renderLeaflet({
    map <- leaflet() %>%  addTiles(
      urlTemplate = "https://api.mapbox.com/v4/mapbox.streets/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiZnJhcG9sZW9uIiwiYSI6ImNpa3Q0cXB5bTAwMXh2Zm0zczY1YTNkd2IifQ.rjnjTyXhXymaeYG6r2pclQ",
      attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>' )  %>% setView(-73.983,40.7639,zoom = 13)
    
    for (i in 1:length(namedata)){
      leafletProxy("map",data=all_data[[namedata[i]]]) %>%
        addMarkers(clusterOptions = markerClusterOptions(),
                   lng=all_data[[namedata[i]]]$LON,lat=all_data[[namedata[i]]]$LAT,
                   icon=list(iconUrl=paste('icon/',namedata[i],'.png',sep = ""),iconSize=c(20,20)),
                   popup=paste("Name:",all_data[[namedata[i]]]$NAME,"<br/>",
                               "Tel:",all_data[[namedata[i]]]$TEL,"<br/>",
                               "Zipcode:",all_data[[namedata[i]]]$ZIP,"<br/>",
                               "Website:",a(all_data[[namedata[i]]]$URL, href = all_data[[namedata[i]]]$URL),"<br/>", # warning appears
                               "Address:",all_data[[namedata[i]]]$ADDRESS),
                   group=namedata[i] )
    }
    
    Type<-as.character(unique(Restaurant$TYPE))
    Group<-c("Dessert","American","QuickMeal","Seafood","Italian","Asian","Mexcian","Chinese","Other","European","French")
    for (i in 1:11){
      leafletProxy("map",data=Restaurant[Restaurant$TYPE==Type[i],]) %>%
        addMarkers(clusterOptions = markerClusterOptions(),
                   lng=Restaurant[Restaurant$TYPE==Type[i],]$LON,lat=Restaurant[Restaurant$TYPE==Type[i],]$LAT,
                   icon=list(iconUrl='icon/Restaurant.png',iconSize=c(20,20)),
                   popup=paste("Name:",Restaurant[Restaurant$TYPE==Type[i],]$NAME,"<br/>",
                               "District:",Restaurant[Restaurant$TYPE==Type[i],]$DISTRICT,"<br/>",
                               "Type:",Restaurant[Restaurant$TYPE==Type[i],]$TYPE,"<br/>",
                               "Address:",Restaurant[Restaurant$TYPE==Type[i],]$ADDRESS),
                   group=Group[i] )
    }
    map%>%hideGroup(c("Deli","Museum","Gallery","Library","Market","Dessert","American","QuickMeal","Seafood","Italian","Asian","Mexcian","Chinese","Other","European","French"))
    
    
  })
  
  
  observeEvent(input$submit,{
    url = paste0('http://maps.google.com/maps/api/geocode/xml?address=',input$location,'&sensor=false')
    doc = xmlTreeParse(url) 
    root = xmlRoot(doc) 
    lat = as.numeric(xmlValue(root[['result']][['geometry']][['location']][['lat']])) 
    long = as.numeric(xmlValue(root[['result']][['geometry']][['location']][['lng']]))
    
    leafletProxy("map") %>%
      clearMarkers() %>%
      #      addMarkers(data=address(),~longitude,lat=latitude)
      addMarkers(lng=long,lat=lat)
  })
  
  observeEvent(input$choice1,{
    leafletProxy("map") %>%
         showGroup(input$choice1)
    
  })    
  
  observeEvent(input$choice2,{
    if("NA" == input$choice2){leafletProxy("map")%>%showGroup(input$choice1)}
    else {leafletProxy("map")%>%
        hideGroup(c("Deli","Museum","Theater","Gallery","Library","Market","Dessert","American","QuickMeal","Seafood","Italian","Asian","Mexcian","Chinese","Other","European","French"))%>%
        showGroup(c(input$choice1,input$choice2))}
  })
  
  
  
  observeEvent(input$choice3,{
    if("NA" == input$choice3){leafletProxy("map")%>%showGroup(c(input$choice1,input$choice2))}
    else {leafletProxy("map")%>%
        hideGroup(c("Deli","Museum","Theater","Gallery","Library","Market","Dessert","American","QuickMeal","Seafood","Italian","Asian","Mexcian","Chinese","Other","European","French"))%>%
        showGroup(c(input$choice1,input$choice2,input$choice3))}
  })
  
  

  
  observeEvent(input$update,{
    ########Get My Location Value:
    url = paste0('http://maps.google.com/maps/api/geocode/xml?address=',input$location,'&sensor=false')
    doc = xmlTreeParse(url) 
    root = xmlRoot(doc) 
    lat = as.numeric(xmlValue(root[['result']][['geometry']][['location']][['lat']])) 
    long = as.numeric(xmlValue(root[['result']][['geometry']][['location']][['lng']]))
    
    
    #######select cadidates:
    if (input$choice2=="N.A"){
      center_candidate<-get_center(input$choice1,NA,NA,long,lat,input$distance,input$radius)
    }
    
    if(!input$choice2=="N.A" & input$choice3=="N.A"){
      center_candidate<-get_center(input$choice1,input$choice2,NA,long,lat,input$distance,input$radius)
    }
    
    
    if (!input$choice2=="N.A" & !input$choice3=="N.A"){
      
      center_candidate<-get_center(input$choice1,input$choice2,input$choice3,long,lat,input$distance,input$radius)
      
    }
    center_candidate<-na.omit(center_candidate)
    
    if(mode(center_candidate)=="character"){
      output$c1<-renderPrint(center_candidate)
    } else{
      number<-nrow(center_candidate)
      if(number>5){
        ran<-sample(number,5,replace = FALSE)
        center_candidate<-center_candidate[ran,]
        number<-5
      }
      
      color<-c("red","purple","yellow","green","blue")
  
      answer<-as.list(1:number)
      
      for(i in 1:number){
        answer[[i]]<-as.data.frame(t(center_candidate[i,c("NAME","ADDRESS","TEL")]))
        rownames(answer[[i]])<-c("Names","Address","Telephone")
        colnames(answer[[i]])<-NULL
      }
      
      output$c1<-renderPrint(
        for(j in 1:number){
          cat(paste("Option",j,":"))
          print(answer[[j]])
          cat("\n")
        })
      
      LONs<-c(center_candidate[,c("LON")])
      LATs<-c(center_candidate[,c("LAT")])
      
      ce<-input$choice1
      
      leafletProxy('map')%>%
        clearShapes()%>%
        addCircleMarkers(lng = LONs[1:number],lat=LATs[1:number],radius=input$radius*20,col=color[1:number],group="circles")
      
    }
    
    #####Zoom-In
    observeEvent(input$zoom_1, {
      leafletProxy('map') %>%
        setView("map",lat=LATs[1],lng=LONs[1],zoom=520)
    },ignoreInit=T,once = T)
    
    
    observeEvent(input$zoom_2, {
      leafletProxy('map') %>%
        setView("map",lat=LATs[2],lng=LONs[2],zoom=520)
    },ignoreInit=T,once = T)
    
    observeEvent(input$zoom_3, {
      leafletProxy('map') %>%
        setView("map",lat=LATs[3],lng=LONs[3],zoom=520)
    },ignoreInit=T,once = T)
    
    observeEvent(input$zoom_4, {
      leafletProxy('map') %>%
        setView("map",lat=LATs[4],lng=LONs[4],zoom=520)
    },ignoreInit=T,once = T)
    
    observeEvent(input$zoom_5, {
      leafletProxy('map') %>%
        setView("map",lat=LATs[5],lng=LONs[5],zoom=520)
    },ignoreInit=T,once = T)
    
  })
  
  observeEvent(input$submit3,{
    output$plot1<-renderImage({
      filename <- normalizePath(file.path('../app/www/img/dice.gif'))
      # Return a list containing the filename and alt text
      list(src = filename)
    },deleteFile = FALSE)
  })
  
  observeEvent(input$submit4,{
    output$plot1<-renderImage({
      filename <- normalizePath(file.path('../app/www/img/bg2.png'))
      # Return a list containing the filename and alt text
      list(src = filename)
    },deleteFile = FALSE)
    index<-sample(1:7,3,replace=F)
    index1<-sample(1:100,1)/10
    choice<-c("Restaurant","Theater","Deli","Market","Museum","Gallery","Library")
    output$c5<- renderText({choice[index[1]]})
    output$c2<- renderText({choice[index[2]]})
    output$c3<- renderText({choice[index[3]]})
  })
 
  ##Clear
  observeEvent(input$clear, {
    leafletProxy('map') %>% clearGroup("circles")
    leafletProxy("map")%>%hideGroup(c("Deli","Museum","Theater","Gallery","Library","Market","Dessert","American","QuickMeal","Seafood","Italian","Asian","Mexcian","Chinese","Other","European","French"))
    leafletProxy('map')%>% setView(-73.983,40.7639,zoom = 13)
    output$c1<-renderText(" ")
  })
  
})