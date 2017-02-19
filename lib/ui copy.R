
library(leaflet)
library(shiny)

Selection<-c("Deli","Supermarket","Library","Theater","Restaurant","Museum")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  titlePanel("Choose Your Preference"),
  
  sidebarLayout(
    
    sidebarPanel(
      fluidRow(
        textInput("My_location", label = h3("Enter Your Location"), value = "Enter text..."),
        selectInput('choice1', 'Chioce 1:',Selection),
        selectInput('choice2', 'Chioce 2:',Selection),
        selectInput('choice3', 'Chioce 3:',Selection),
        sliderInput("radius", "Radius", min = 0, max = 10, value = 0.1, step= 0.1),
        actionButton("submit", "Submit"),
        actionButton("clear","Clear")
      )
    ),
    
    mainPanel(
      tabsetPanel(leafletOutput('map'))
    )
  )
  
))
