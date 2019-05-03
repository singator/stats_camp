#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Upload Data"),
   
   hr(),
   
   fluidRow(
     column(width=6, 
            numericInput("height", "Height (m)", 
                         value=1.0, min=0, max=2,step=0.01)),
     column(width=6,
            numericInput("weight", "Weight (kg)", value=50, min=0, max=150,
                         step=0.1)),
     column(width=4,
            radioButtons("gender", "Gender", choices=c("Female", "Male"),
                         inline = TRUE))
   ),
   hr(),
   fluidRow(
     column(width=4, textInput("person_id", "Person ID", value="")),
     column(width=4, textInput("dev_id", "Device ID", value=""))
   ),
   hr(),
   fluidRow(
     column(width=6,  fileInput("file1", "Text file")),
     column(width=6, selectInput("treatment", "Treatment",
                                 choices=c("baseline", "after_stairs",
                                           "watching_sports", 
                                           "listening_music", "math")))
   ),
   hr(),
   fluidRow(
     column(width=6, actionButton("upload", "Upload"))
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2] 
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

