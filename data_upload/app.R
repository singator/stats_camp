#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(RHRV)
library(tidyverse)

# Creates rhrv object, without removing outliers, before interpolation
create_nihr <- function(fname) {
  obj <- CreateHRVData()
  vec1 <- read.table(fname)[,1]
  vec1 <- vec1 - vec1[1]
  obj <- LoadBeatVector(obj, vec1, scale = 0.001)
  obj <- BuildNIHR(obj)
  obj <- SetVerbose(obj, TRUE)
  obj
}

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
                         step=0.1))
   ),
   fluidRow(
     column(width=4,
            radioButtons("gender", "Gender", choices=c("Female", "Male"),
                         inline = TRUE))
   ),
   hr(),
   fluidRow(
     column(width=6, textInput("person_id", "Name", value="")),
     column(width=6, textInput("dev_id", "Device ID", value=""))
   ),
   hr(),
   fluidRow(
     column(width=6,  fileInput("file1", "Text file")),
     column(width=6, selectInput("treatment", "Treatment",
                                 choices=c("baseline", "after_stairs",
                                           "watching_sports", 
                                           "listening_music", "doing_math")))
   ),
   hr(),
   fluidRow(
     column(width=6, actionButton("upload", "Upload"))
   ),
   hr(),
   fluidRow(
     column(width=6, plotOutput('plot1')),
     column(width=6, textOutput('text1'))
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  rhrv_obj <- reactive({
    in_file <- input$file1
    if(is.null(in_file))
      return(NULL)
    rhrv_obj <- create_nihr(in_file$datapath)
    rhrv_obj
  })
  
   output$plot1 <- renderPlot({
     input$upload
     isolate(
     if(is.null(rhrv_obj())) {
       #dist <- rnorm(100)
       #hist(dist)
       return(NULL)
     } else {
       PlotNIHR(rhrv_obj())
     })
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

