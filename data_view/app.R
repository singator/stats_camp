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

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("View/Delete Data"),
   
   hr(),
   
   fluidRow(
     column(width=6, 
            numericInput("height", "Height (m)", 
                         value=0, min=0, max=2,step=0.01)),
     column(width=6,
            numericInput("weight", "Weight (kg)", min=0, max=150,
                         value=0, step=0.1))
   ),
   fluidRow(
     column(width=4,
            checkboxGroupInput("gender", "Gender", choices=c("Female", "Male"),
                               inline = TRUE))
   ),
   hr(),
   fluidRow(
     column(width=6, textInput("person_id", "Name", value="")),
     column(width=6, textInput("dev_id", "Device ID", value=""))
   ),
   hr(),
   fluidRow(
     column(width=6, selectInput("treatment", "Treatment",
                                 choices=c("", "baseline", "after_execise",
                                           "watching_sports", 
                                           "listening_music", "doing_math")))
   ),
   hr(),
   fluidRow(
     column(width=6, actionButton("view", "View")),
     column(width=6, actionButton("delete", "Delete"))
   ),
   fluidRow(
     column(width=8,  tableOutput('text1')),
     column(width=8,  tableOutput('text2'))
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   observeEvent(input$view, {
     mm <- readRDS("../data_upload/master_data.rds")
     if(as.numeric(input$height) !=  0) {
       mm <- dplyr::filter(mm, ht == as.numeric(input$height))
     }
     if(as.numeric(input$weight) !=  0) {
       mm <- dplyr::filter(mm, wt == as.numeric(input$weight))
     }
     if(input$person_id !=  "") {
       mm <- dplyr::filter(mm, pid == input$person_id)
     }
     if(input$dev_id !=  "") {
       mm <- dplyr::filter(mm, pid == input$dev_id)
     }
     if(input$treatment !=  "") {
       mm <- dplyr::filter(mm, pid == input$treatment)
     }
     if(!is.null(input$gender)) {
       mm <- dplyr::filter(mm, gender %in% input$gender)
     }
     output$text1 <- renderTable({
       dplyr::select(mm , -1)
     })
   })
  
   observeEvent(input$delete, {
     mm <- readRDS("../data_upload/master_data.rds")
     mm2 <- readRDS("../data_upload/master_data.rds")
     if(as.numeric(input$height) !=  0) {
       mm <- dplyr::filter(mm, ht == as.numeric(input$height))
     }
     if(as.numeric(input$weight) !=  0) {
       mm <- dplyr::filter(mm, wt == as.numeric(input$weight))
     }
     if(input$person_id !=  "") {
       mm <- dplyr::filter(mm, pid == input$person_id)
     }
     if(input$dev_id !=  "") {
       mm <- dplyr::filter(mm, pid == input$dev_id)
     }
     if(input$treatment !=  "") {
       mm <- dplyr::filter(mm, pid == input$treatment)
     }
     if(!is.null(input$gender)) {
       mm <- dplyr::filter(mm, gender %in% input$gender)
     }
     mm <- anti_join(mm2, mm, by=c("gender", "ht", "wt", "pid", "did", "trt"))
     nrows_del <- nrow(mm)
     time_now <- as.character(Sys.time())
     log_string <- paste(time_now, "DELETING",
                         input$height, 
                         input$weight, input$gender,
                         input$person_id, 
                         input$dev_id, 
                         input$treatment, sep=",")
     log_string <- paste0(log_string, "\n")
     cat(log_string, file="../data_upload/camp.log", append = TRUE)
     saveRDS(mm, "../data_upload/master_data.rds")
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

