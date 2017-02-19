
library(leaflet)
library(shiny)

Theater<-read.csv("Theater.csv",header=T)
Library<-read.csv("Library.csv",header=T)
Deli<-read.csv("Deli.csv",header=T)
Museum<-read.csv("Museum.csv",header=T)
Restaurant<-read.csv("Restaurant.csv",header=T)
Gallery<-read.csv("Gallery.csv",header=T)
Market<-read.csv("Market.csv",header=T)



shinyServer(function(input,output){
  output$map <- renderLeaflet({
    map <- leaflet() %>%  addTiles(
      urlTemplate = "https://api.mapbox.com/v4/mapbox.streets/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiZnJhcG9sZW9uIiwiYSI6ImNpa3Q0cXB5bTAwMXh2Zm0zczY1YTNkd2IifQ.rjnjTyXhXymaeYG6r2pclQ",
      attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>' )  %>% setView(-73.983,40.7639,zoom = 13)
    
    leafletProxy("map",data=Theater) %>%
      addMarkers(clusterOptions = markerClusterOptions(),
                 lng=~LON,lat=~LAT,
                 icon=list(iconUrl='icon/Theater.png',iconSize=c(20,20)),
                 popup=paste("Name:",~NAME,"<br/>",
                             "Tel:",~TEL,"<br/>",
                             "Zipcode:",~ZIP,"<br/>",
                             "Website:",a(~URL, href = ~URL),"<br/>", # warning appears
                             "Address:",~ADDRESS),
                group="Theater" )
    
    leafletProxy("map",data=Library) %>%
      addMarkers(clusterOptions = markerClusterOptions(),
                 lng=~LON,lat=~LAT,
                 icon=list(iconUrl='icon/Library.png',iconSize=c(20,20)),
                 popup=paste("Name:",~NAME,"<br/>",
                             "Tel:",~TEL,"<br/>",
                             "Zipcode:",~ZIP,"<br/>",
                             "Website:",a(~URL, href = ~URL),"<br/>", # warning appears
                             "Address:",~ADDRESS),
                 group="Library" )
    
    leafletProxy("map",data=Deli) %>%
      addMarkers(clusterOptions = markerClusterOptions(),
                 lng=~LON,lat=~LAT,
                 icon=list(iconUrl='icon/Deli.png',iconSize=c(20,20)),
                 popup=paste("Name:",~NAME,"<br/>",
                             "Tel:",~TEL,"<br/>",
                             "Zipcode:",~ZIP,"<br/>",
                             "Website:",a(~URL, href = ~URL),"<br/>", # warning appears
                             "Address:",~ADDRESS),
                 group="Deli" )
    
    leafletProxy("map",data=Museum) %>%
      addMarkers(clusterOptions = markerClusterOptions(),
                 lng=~LON,lat=~LAT,
                 icon=list(iconUrl='icon/Museum.png',iconSize=c(20,20)),
                 popup=paste("Name:",~NAME,"<br/>",
                             "Tel:",~TEL,"<br/>",
                             "Zipcode:",~ZIP,"<br/>",
                             "Website:",a(~URL, href = ~URL),"<br/>", # warning appears
                             "Address:",~ADDRESS),
                 group="Museum" )
    
    leafletProxy("map",data=Restaurant) %>%
      addMarkers(clusterOptions = markerClusterOptions(),
                 lng=~LON,lat=~LAT,
                 icon=list(iconUrl='icon/Restaurant.png',iconSize=c(20,20)),
                 popup=paste("Name:",~NAME,"<br/>",
                             "District:",~DISTRICT,"<br/>",
                             "Type:",~TYPE,"<br/>",
                             "Address:",~ADDRESS),
                 group="Restaurant" )
    
    leafletProxy("map",data=Gallery) %>%
      addMarkers(clusterOptions = markerClusterOptions(),
                 lng=~LON,lat=~LAT,
                 icon=list(iconUrl='icon/Gallery.png',iconSize=c(20,20)),
                 popup=paste("Name:",~NAME,"<br/>",
                             "Tel:",~TEL,"<br/>",
                             "Zipcode:",~ZIP,"<br/>",
                             "Website:",a(~URL, href = ~URL),"<br/>", # warning appears
                             "Address:",~ADDRESS),
                 group="Gallery" )
    
    leafletProxy("map",data=Market) %>%
      addMarkers(clusterOptions = markerClusterOptions(),
                 lng=~LON,lat=~LAT,
                 icon=list(iconUrl='icon/Market.png',iconSize=c(20,20)),
                 popup=paste("Name:",~NAME,"<br/>",
                             "Tel:",~TEL,"<br/>",
                             "Zipcode:",~ZIP,"<br/>",
                             "Website:",a(~URL, href = ~URL),"<br/>", # warning appears
                             "Address:",~ADDRESS),
                 group="Market" )
    
    
    map%>%hideGroup(c("Deli","Museum","Theater","Gallery","Restaurant","Library","Market"))
  })
  

  observeEvent(input$location,{
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
      hideGroup(c("Deli","Museum","Theater","Gallery","Restaurant","Library","Market"))%>%
      showGroup(input$choice1)
    
  })    
  
  observeEvent(input$choice2,{
    if("NA" == input$choice2){leafletProxy("map")%>%showGroup(input$choice1)}
    else {leafletProxy("map")%>%
        hideGroup(c("Deli","Museum","Theater","Gallery","Restaurant","Library","Market"))%>%
        showGroup(c(input$choice1,input$choice2))}
  })
  
  
  
  observeEvent(input$choice3,{
    if("NA" == input$choice3){leafletProxy("map")%>%showGroup(c(input$choice1,input$choice2))}
    else {leafletProxy("map")%>%
        hideGroup(c("Deli","Museum","Theater","Gallery","Restaurant","Library","Market"))%>%
        showGroup(c(input$choice1,input$choice2,input$choice3))}
  })
  

  observeEvent(input$submit, {
    leafletProxy('map') %>%
    addCircles(lng =Theater$LON,lat=Theater$LAT,radius = 1, group='circles')})
    
  observeEvent(input$clear, {
    leafletProxy('map') %>% clearGroup("circles")
  })

  })
    



