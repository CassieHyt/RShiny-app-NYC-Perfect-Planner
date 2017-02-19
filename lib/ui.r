library(leaflet)
library(shiny)


shinyUI(fluidPage(
  
  titlePanel("Choose Your Preference"),
  
  sidebarLayout(
    
    sidebarPanel(
      fluidRow(
        textInput("My_location", label = h3("Enter Your Location"), value = "Enter text..."),
        selectInput('choice1', label = 'Chioce 1:',choices=Selection),
        selectInput('choice2', label = 'Chioce 2:',choices=Selection),
        selectInput('choice3', 'Chioce 3:',Selection),
        sliderInput("radius", "Radius", min = 0, max = 10, value = 0.1, step= 0.1),
        actionButton("update", "Submit")
      )
    ),
    
    mainPanel(
      tabsetPanel(leafletOutput('map')),
      
      absolutePanel(id = "controls", class = "panel panel-default", fixed= TRUE, draggable = TRUE,
                    top = 120, left = "auto", right = 20, bottom = "auto", width = 320, height = "auto",
                    h4("choice1"),p(textOutput("c1")),actionButton("zoom", "zoom"),
                    h4("choice2"),p(textOutput("c2")),actionButton("zoom", "zoom"))
    )
  )
  
))