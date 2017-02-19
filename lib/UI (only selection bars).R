######################################################Shiny

Res<-read.csv("../Restaurants.csv")
Type<-as.character(unique(Res$TYPE))
Selection=list(Resteraunt=Type,Supermarket=c("Supermarket"),Deli="Deli",library="Library",Theater="Theater",Musemu="Musemu")
##############################################################
ui<-shinyUI(fluidPage(
  
  titlePanel("Choose Your Preference"),
  
  sidebarLayout(
    
    sidebarPanel(
      fluidRow(
        textInput("My_location", label = h3("Enter Your Location"), value = "Enter text..."),
        selectInput('choice1', 'First Preference ^_^:',Selection),
        selectInput('choice2', 'Chioce 2 (Optional):',Selection),
        selectInput('choice3', 'Chioce 3 (Optional):',Selection),
        sliderInput("distance", "Distance From You", min = 0, max = 10, value = 0.1, step= 0.1),
        sliderInput("radius", "Radius of Your Circle", min = 0, max = 10, value = 0.1, step= 0.1),
        actionButton("update", "Change")
      )
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Radar-Plot", plotOutput("RP")), 
        tabPanel("Win-Rate", plotOutput("WR"))
      )
    )
  )
))

