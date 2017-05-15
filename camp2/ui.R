#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Who's Lying?"),
  hr(),
  
  fluidRow(
    column(4, 
      fileInput("file1", "Data Input",
                accept = c("text/csv",  
                           "text/comma-separated-values,text/plain", ".csv"))
    ), 
    
    column(4,  sliderInput('hr_limits', 'HR Limits', value=c(60, 80), 
                           min =30, max=120)
    ),
    
    
    column(4, 
           selectInput('raw_smooth', 'Raw or smoothed data:', 
                       c('Raw', "Smooth"))
    )
  ),
  
  br(),
  
  fluidRow(
    column(4, "Neutral Questions",
           plotOutput("plot1"),
           textOutput("med1")),
    
    column(4, "Relevant Questions",
           plotOutput("plot2"),
           textOutput("med2")),
    column(4, "Comparison Questions",
           plotOutput("plot3"),
           textOutput("med3"))
  )
  
  # Sidebar with a slider input for number of bins 
))
