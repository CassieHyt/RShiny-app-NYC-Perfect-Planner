
library(leaflet)
library(shiny)

Theater<-read.csv("Theater.csv",header=T)
Library<-read.csv("Library.csv",header=T)


shinyServer(function(input,output){
  output$map <- renderLeaflet({
    map <- leaflet() %>%  addTiles(
      urlTemplate = "https://api.mapbox.com/v4/mapbox.streets/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiZnJhcG9sZW9uIiwiYSI6ImNpa3Q0cXB5bTAwMXh2Zm0zczY1YTNkd2IifQ.rjnjTyXhXymaeYG6r2pclQ",
      attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>' )  %>% setView(-73.983,40.7639,zoom = 13)
    
    leafletProxy("map",data=Theater[1:20,]) %>%
      addMarkers(clusterOptions = markerClusterOptions(),
                 lng=~LON,lat=~LAT,
                 icon=list(iconUrl='icon/Theater.png',iconSize=c(20,20)),
                 popup=paste("Name:",~NAME,"<br/>",
                             "Tel:",~TEL,"<br/>",
                             "Zipcode:",~ZIP,"<br/>",
                             "Website:",a(~URL, href = ~URL),"<br/>", # warning appears
                             "Address:",~ADDRESS),
                group="markers_Theater" )
    
    leafletProxy("map") %>%
      addMarkers(data=Lirary,
                 clusterOptions = markerClusterOptions(),
                 lng=Library$Longitude,lat=Library$Latitude,
                 icon=list(iconUrl='icon/Library.png',iconSize=c(25,25)),
                 popup=paste("Name:",Library$Name,"<br/>",
                             "Zipcode:",Library$Zip,"<br/>",
                             "Website:",a(Library$Url, href = Library$Url),"<br/>", # warning appears
                             "Address:",Library$Adress),
                 group="markers_Library" )
    map
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
  
  observeEvent(input$submit, {
    if("Theater" %in% c(input$choice1,input$choice2,input$choice3) ) leafletProxy("map") %>% showGroup("markers_Theater")
    else{leafletProxy("map") %>% hideGroup("markers_Theater")}
    if("Library" %in% c(input$choice1,input$choice2,input$choice3)) leafletProxy("map") %>% showGroup("markers_Library")
    else{leafletProxy("map") %>% hideGroup("markers_Library")}
  },ignoreNULL = FALSE)
  

  observeEvent(input$submit, {
    leafletProxy('map') %>%
    addCircles(lng =Theater$LON,lat=Theater$LAT,radius = 1, group='circles')})
    
  observeEvent(input$clear, {
    leafletProxy('map') %>% clearGroup("circles")
  })

  })
    



