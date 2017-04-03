#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Analysing Polygraph Data"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "Choose CSV File",
                accept = c("text/csv", 
                           "text/comma-separated-values,text/plain", ".csv")
      ),
      sliderInput('start_end_time', 'Start / End Times', value=c(10, 590), min =0, max=600),
      sliderInput('hr_limits', 'HR Limits', value=c(60, 80), min =30, max=120),
      textOutput('mean1'),
      textOutput('med1'),
      textOutput('nobs')
    ),
    mainPanel(
      plotOutput('plot1')
    )
  )
))
  
