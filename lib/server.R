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
                 lng=Theater$LON,lat=Theater$LAT,
                 icon=list(iconUrl='icon/Theater.png',iconSize=c(20,20)),
                 popup=paste("Name:",Theater$NAME,"<br/>",
                             "Tel:",Theater$TEL,"<br/>",
                             "Zipcode:",Theater$ZIP,"<br/>",
                             "Website:",a(Theater$URL, href = Theater$URL),"<br/>", # warning appears
                             "Address:",Theater$ADDRESS),
                 group="Theater" )
    
    leafletProxy("map",data=Library) %>%
      addMarkers(clusterOptions = markerClusterOptions(),
                 lng=Library$LON,lat=Library$LAT,
                 icon=list(iconUrl='icon/Library.png',iconSize=c(20,20)),
                 popup=paste("Name:",Library$NAME,"<br/>",
                             "Tel:",Library$TEL,"<br/>",
                             "Zipcode:",Library$ZIP,"<br/>",
                             "Website:",a(Library$URL, href = Library$URL),"<br/>", # warning appears
                             "Address:",Library$ADDRESS),
                 group="Library" )
    
    leafletProxy("map",data=Deli) %>%
      addMarkers(clusterOptions = markerClusterOptions(),
                 lng=Deli$LON,lat=Deli$LAT,
                 icon=list(iconUrl='icon/Deli.png',iconSize=c(20,20)),
                 popup=paste("Name:",Deli$NAME,"<br/>",
                             "Tel:",Deli$TEL,"<br/>",
                             "Zipcode:",Deli$ZIP,"<br/>",
                             "Website:",a(Deli$URL, href = Deli$URL),"<br/>", # warning appears
                             "Address:",Deli$ADDRESS),
                 group="Deli" )
    
    leafletProxy("map",data=Museum) %>%
      addMarkers(clusterOptions = markerClusterOptions(),
                 lng=Museum$LON,lat=Museum$LAT,
                 icon=list(iconUrl='icon/Museum.png',iconSize=c(20,20)),
                 popup=paste("Name:",Museum$NAME,"<br/>",
                             "Tel:",Museum$TEL,"<br/>",
                             "Zipcode:",Museum$ZIP,"<br/>",
                             "Website:",a(Museum$URL, href = Museum$URL),"<br/>", # warning appears
                             "Address:",Museum$ADDRESS),
                 group="Museum" )
    
    leafletProxy("map",data=Restaurant) %>%
      addMarkers(clusterOptions = markerClusterOptions(),
                 lng=Restaurant$LON,lat=Restaurant$LAT,
                 icon=list(iconUrl='icon/Restaurant.png',iconSize=c(20,20)),
                 popup=paste("Name:",Restaurant$NAME,"<br/>",
                             "District:",Restaurant$DISTRICT,"<br/>",
                             "Type:",Restaurant$TYPE,"<br/>",
                             "Address:",Restaurant$ADDRESS),
                 group="Restaurant" )
    
    
    leafletProxy("map",data=Gallery) %>%
      addMarkers(clusterOptions = markerClusterOptions(),
                 lng=Gallery$LON,lat=Gallery$LAT,
                 icon=list(iconUrl='icon/Gallery.png',iconSize=c(20,20)),
                 popup=paste("Name:",Gallery$NAME,"<br/>",
                             "Tel:",Gallery$TEL,"<br/>",
                             "Zipcode:",Gallery$ZIP,"<br/>",
                             "Website:",a(Gallery$URL, href = Gallery$URL),"<br/>", # warning appears
                             "Address:",Gallery$ADDRESS),
                 group="Gallery" )
    
    leafletProxy("map",data=Market) %>%
      addMarkers(clusterOptions = markerClusterOptions(),
                 lng=Market$LON,lat=Market$LAT,
                 icon=list(iconUrl='icon/Market.png',iconSize=c(20,20)),
                 popup=paste("Name:",Market$NAME,"<br/>",
                             "Tel:",Market$TEL,"<br/>",
                             "Zipcode:",Market$ZIP,"<br/>",
                             "Website:",a(Market$URL, href = Market$URL),"<br/>", # warning appears
                             "Address:",Market$ADDRESS),
                 group="Market" )
    
    
    map%>%hideGroup(c("Deli","Museum","Theater","Gallery","Restaurant","Library","Market"))
  })
  
  
  observeEvent(input$submit11,{
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
  observeEvent(input$choice1,{
    if("NA"==input$choice1){leafletProxy("map")%>%hideGroup(c("Deli","Museum","Theater","Gallery","Restaurant","Library","Market"))}
  })
  
  observeEvent(input$choice2,{
    leafletProxy("map")%>%
        showGroup(c(input$choice1,input$choice2))
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


