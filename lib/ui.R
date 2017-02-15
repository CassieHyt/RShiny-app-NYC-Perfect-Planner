library(shiny)
library(shinydashboard)
library(leaflet)
library(shinythemes)
library(XML)

shinyUI(navbarPage(theme = shinytheme("flatly"),
  
  "Trees in New York",id="nav",
  mainPanel(
    tabsetPanel(                  
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
                             actionButton("submit","Mark"),
                             style="opacity:0.65"
                             ))
            
  ),
 tabPanel("Summary", verbatimTextOutput("summary")),
 tabPanel("Table", tableOutput("table"))
    )
  )
  ))


