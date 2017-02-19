library(leaflet)
library(shiny)



shinyServer(function(input,output){
  
  map=leaflet()%>%
    addProviderTiles("Hydda.Full")%>%
    setView(lng = -73.97, lat = 40.70, zoom = 30)%>%
    addMarkers(data=Deli,
              group="Deli",
               clusterOptions = markerClusterOptions(),
               lng=~LON,lat=~LAT,
               icon=~myIcons$Deli,
               popup=paste("Name:",Deli$NAME,"<br/>",
                           "Tel:",Deli$TEL,"<br/>",
                           "Website:",Deli$URL,"<br/>",
                           "Address:",Deli$ADDRESS))%>%
    addMarkers(data=Theater,
               group="Theater",
               clusterOptions = markerClusterOptions(),
               lng=~LON,lat=~LAT,
               icon=~myIcons$Theater,
               popup=paste("Name:",Theater$NAME,"<br/>",
                           "Tel:",Theater$TEL,"<br/>",
                           "Website:",Theater$URL,"<br/>",
                           "Address:",Theater$ADDRESS))%>%
    addMarkers(data=Library,
               group="Library",
               clusterOptions = markerClusterOptions(),
               lng=~LON,lat=~LAT,
               icon=~myIcons$Library,
               popup=paste("Name:",Library$NAME,"<br/>",
                           "Tel:",Library$TEL,"<br/>",
                           "Website:",Library$URL,"<br/>",
                           "Address:",Library$ADDRESS))%>%
    addMarkers(data=Museum,
               group="Museum",
               clusterOptions = markerClusterOptions(),
               lng=~LON,lat=~LAT,
               icon=~myIcons$Museum,
               popup=paste("Name:",Museum$NAME,"<br/>",
                           "Tel:",Museum$TEL,"<br/>",
                           "Website:",Museum$URL,"<br/>",
                           "Address:",Museum$ADDRESS))%>%
    
    addMarkers(data=Gallery,
               group="Gallery",
               clusterOptions = markerClusterOptions(),
               lng=~LON,lat=~LAT,
               icon=~myIcons$Gallery,
               popup=paste("Name:",Gallery$NAME,"<br/>",
                           "Tel:",Gallery$TEL,"<br/>",
                           "Website:",Gallery$URL,"<br/>",
                           "Address:",Gallery$ADDRESS))%>%
    addMarkers(data=Restaurant,
               group="Restaurant",
               clusterOptions = markerClusterOptions(),
               lng=~LON,lat=~LAT,
               icon=~myIcons$Restaurant,
               popup=paste("Name:",Restaurant$NAME,"<br/>",
                           "Tel:",Restaurant$TEL,"<br/>",
                           "Website:",Restaurant$URL,"<br/>",
                           "Address:",Restaurant$ADDRESS))%>%
  
    hideGroup(c("Deli","Museum","Theater","Gallery","Restaurant","Library"))
  
  output$map=renderLeaflet(map)
  
  
 observeEvent(input$choice1,{
   leafletProxy("map") %>%
     hideGroup(c("Deli","Museum","Theater","Gallery","Restaurant","Library"))%>%
     showGroup(input$choice1)
    
 })    
 
 observeEvent(input$choice2,{
   leafletProxy("map")%>%
     hideGroup(c("Deli","Museum","Theater","Gallery","Restaurant","Library"))%>%
     showGroup(c(input$choice1,input$choice2))
 })
  
 
 
 observeEvent(input$choice3,{
   leafletProxy("map")%>%
     hideGroup(c("Deli","Museum","Theater","Gallery","Restaurant","Library"))%>%
     showGroup(c(input$choice1,input$choice2,input$choice3))
 })
 
  
 observeEvent(input$update,{
   
   output$c1<-renderText("abcsdg")
 })
 
  observeEvent(input$zoom, {
    leafletProxy('map') %>%
      setView(map,lat=data$LAT,lng=data$LON,zoom=520)
  })
  
  
  
})


