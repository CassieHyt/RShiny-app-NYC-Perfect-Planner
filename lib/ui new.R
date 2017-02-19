

library(shiny)
library(shinydashboard)
library(leaflet)
library(shinythemes)
library(XML)


Selection<-c("NA","Deli","Museum","Theater","Gallery","Restaurant","Library","Market")


shinyUI(navbarPage(theme = shinytheme("flatly"),
                   
                   "Trees in New York",id="nav",
                   
                   tabPanel("New York",
                            div(class="outer",
                                tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
                                leafletOutput("map",width="100%",height = "100%"),
                                absolutePanel(id="control1",fixed = T,draggable = T,class = "panel panel-default",top = 80,
                                              left = 55, right = "auto", bottom = "auto",
                                              width = 280, height = 550,
                                              h3("Trees"),
                                              
                                              helpText("Choose Your Location"),
                                              textInput("location","Your Location:","Columbia University NY"),
                                              actionButton("location","Mark"),style="opacity: 0.5",
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



