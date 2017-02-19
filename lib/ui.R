

library(shiny)
library(shinydashboard)
library(leaflet)
library(shinythemes)
library(XML)

Type<-as.character(unique(Restaurant$TYPE))
Selection=list(Market="Market",Deli="Deli",Library="Library",Theater="Theater",Museum="Museum",Gallery="Gallery",Restaurant=Type)


shinyUI(navbarPage(theme = shinytheme("flatly"),
                   
                   "Planner NYC",id="nav",
                   
                   tabPanel("New York",
                            div(class="outer",
                                tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
                                leafletOutput("map",width="100%",height = "100%"),
                                absolutePanel(id="control1",fixed = T,draggable = T,class = "panel panel-default",top = 80,
                                              left = 55, right = "auto", bottom = "auto",
                                              width = 280, height = 550,
                                              h3("Map"),
                                              
                                              helpText("Choose Your Location"),
                                              textInput("location","Your Location:","Columbia University, NY"),
                                              actionButton("submit11","Mark"),style="opacity: 0.8",
                                              textOutput("lo"),
                                              selectInput('choice1', 'Chioce 1:',Selection),
                                              selectInput('choice2', 'Chioce 2:',Selection),
                                              selectInput('choice3', 'Chioce 3:',Selection),
                                              sliderInput("radius", "Radius", min = 0, max = 10, value = 0.1, step= 0.1),
                                              actionButton("submit", "Submit"),
                                              actionButton("clear","Clear")
                                              
                                              
                                )
                                
                                
                            )
                   ),
                   
                   tabPanel("New York"
                   ),
                   tabPanel("New York"
                   )
                   
                   
))