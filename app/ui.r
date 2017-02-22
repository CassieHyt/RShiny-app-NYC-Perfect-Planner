library(shiny)
library(shinydashboard)
library(leaflet)
library(shinythemes)
library(XML)

source("../lib/global.R")

Restaurant<-read.csv("../data/Restaurant.csv",header=T)
Type<-as.character(unique(Restaurant$TYPE))
Selection=list(N.A="N.A",Market="Market",Deli="Deli",Library="Library",Theater="Theater",Museum="Museum",Gallery="Gallery",Restaurant=Type)


shinyUI(navbarPage(theme = "bootstrap.min-copy.css","Perfect Planner",id="nav",
                   
                   tabPanel("Welcome",
                            div(id="canvas"),
                            mainPanel(
                              img(src="img/bgs.png",height=750,width=1450)   )      
                   ),
                   
                   
                   tabPanel("APP",
                            
                            div(class="outer",
                                
                                tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
                                
                                leafletOutput("map",width="100%",height = "100%"),
                                
                                absolutePanel(id="control1",fixed = T,draggable = T,class = "panel panel-default",top = 80,
                                              
                                              left = 55, right = "auto", bottom = "auto",
                                              
                                              width = 280, height = 550,
                                              
                                              textInput("location",label = h3("Enter Your Location"),"Columbia University NY"),
                                              actionButton("submit","Mark Your Location",icon("map-marker")),
                                              selectInput('choice1', 'First Preference ^_^:',Selection,selected = "Theater"),
                                              selectInput('choice2', 'Chioce 2 (Optional):',Selection),
                                              selectInput('choice3', 'Chioce 3 (Optional):',Selection),
                                              sliderInput("distance", "Distance From You (in km)", min = 0, max = 20, value = 1, step= 0.1),
                                              sliderInput("radius", "Radius of Your Circle (in km)", min = 0, max = 10, value = 1, step= 0.1),
                                              actionButton("update", "Search"),
                                              actionButton("clear","Clear"),
                                              ###Testing
                                              textOutput("wei"),
                                              style="opacity:0.8"
                                              
                                )
                                
                            ),
                            
                            
                            mainPanel(
                              absolutePanel(id = "controls", class = "panel panel-default", fixed= TRUE, draggable = TRUE,
                                            top = 220, left = "auto", right = 20, bottom = "auto", width = 550, height = "auto",
                                            h3("Our Recomendation"),verbatimTextOutput("c1"),
                                            actionButton("zoom_1", "Option1",icon("paper-plane"), 
                                                         style="color: #fff; background-color: #f29898"),
                                            actionButton("zoom_2", "Option2",icon("paper-plane"), 
                                                         style="color: #fff; background-color: #cf8cea"),
                                            actionButton("zoom_3", "Option3",icon("paper-plane"), 
                                                         style="color: #fff; background-color: #efe88b"),
                                            actionButton("zoom_4", "Option4",icon("paper-plane"), 
                                                         style="color: #fff; background-color: #8ee886"),
                                            actionButton("zoom_5", "Option5",icon("paper-plane"), 
                                                         style="color: #fff; background-color: #acc6f9")),
                              style="opacity:0.8"
                              
                            )
                            
                            
                            
                            
                            
                   ),
                   
                   tabPanel("Random Choice",div(id="canvas"),
                            mainPanel(
                              actionButton("submit3", label="choose for you",style="opacity:0.5",align="left"),
                              actionButton("submit4", label="finished!",style="opacity:0.5",align="left"),
                              
                              div(
                                h4("Your first choice?"),
                                verbatimTextOutput("c5"),
                                h4("Your second choice?"),
                                verbatimTextOutput("c2"),
                                h4("Your third choice?"),
                                verbatimTextOutput("c3"),
                                align="left"
                              ),
                              imageOutput("plot1")
                   ))
                   
                   
                   
                   
))