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
    sidebarPanel(fileInput("file1", "Choose CSV File",
                           accept = c("text/csv",
                             "text/comma-separated-values,text/plain",
                             ".csv") ),
                 sliderInput("xlims", "Start / End Time", min=0, 
                             max=600, value=c(0, 600)),
                 sliderInput("ylims", "HR Limits", min=0, max=250,
                             value=c(50, 150)),
                 htmlOutput("text1")),
    mainPanel( plotOutput("plot1") )
    )))
