#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$plot1 <- renderPlot({
    c_f <- input$file1
    
    if(!is.null(c_f)) {
      tmp <- read.csv(c_f$datapath, header=FALSE, stringsAsFactors=FALSE)
      colnames(tmp) <- c("HR", "Time", "Mode")
      tmp$Time_ms <- tmp$Time / 1000
      tmp <- dplyr::filter(tmp, Mode == "Neut")
      tmp$Time_ms <- tmp$Time_ms - min(tmp$Time_ms)
      
      if(input$raw_smooth == "Smooth") {
        tmp$HR <- smooth(tmp$HR, kind='3RSS')
      }
      
      ylim2 <- input$hr_limits
      
      plot(tmp$Time_ms, tmp$HR, type='b', col='darkorange', xlab='Time (s)',
           ylab='Heart Rate per minute', ylim=ylim2)
      grid()
    } else {
      return(NULL)
    }
    
  })
  
  output$plot2 <- renderPlot({
    c_f <- input$file1
    
    if(!is.null(c_f)) {
      tmp <- read.csv(c_f$datapath, header=FALSE, stringsAsFactors=FALSE)
      colnames(tmp) <- c("HR", "Time", "Mode")
      tmp$Time_ms <- tmp$Time / 1000
      tmp <- dplyr::filter(tmp, Mode == "RelQ")
      tmp$Time_ms <- tmp$Time_ms - min(tmp$Time_ms)
      
      if(input$raw_smooth == "Smooth") {
        tmp$HR <- smooth(tmp$HR, kind='3RSS')
      }
      
      ylim2 <- input$hr_limits
      
      plot(tmp$Time_ms, tmp$HR, type='b', col='darkorange', xlab='Time (s)',
           ylab='Heart Rate per minute', ylim=ylim2)
      grid()
    } else {
      return(NULL)
    }
    
  })
  
  output$plot3 <- renderPlot({
    c_f <- input$file1
    
    if(!is.null(c_f)) {
      tmp <- read.csv(c_f$datapath, header=FALSE, stringsAsFactors=FALSE)
      colnames(tmp) <- c("HR", "Time", "Mode")
      tmp$Time_ms <- tmp$Time / 1000
      tmp <- dplyr::filter(tmp, Mode == "ComQ")
      tmp$Time_ms <- tmp$Time_ms - min(tmp$Time_ms)
      
      if(input$raw_smooth == "Smooth") {
        tmp$HR <- smooth(tmp$HR, kind='3RSS')
      }
      
      ylim2 <- input$hr_limits
      
      plot(tmp$Time_ms, tmp$HR, type='b', col='darkorange', xlab='Time (s)',
           ylab='Heart Rate per minute', ylim=ylim2)
      grid()
    } else {
      return(NULL)
    }
    
  })
  
  output$med1 <- renderText({
    c_f <- input$file1
    
    if(!is.null(c_f)) {
      tmp <- read.csv(c_f$datapath, header=FALSE)
      colnames(tmp) <- c("HR", "Time", "Mode")
      tmp <- dplyr::filter(tmp, Mode == "Neut")
      
      if(input$raw_smooth == "Smooth") {
        tmp$HR <- smooth(tmp$HR, kind='3RSS')
      }
      
      mn1 <- round(median(tmp$HR, na.rm=TRUE))
      paste("Median HR:", mn1)
    } else {
      return(NULL)
    }
  })
  
  output$med2 <- renderText({
    c_f <- input$file1
    
    if(!is.null(c_f)) {
      tmp <- read.csv(c_f$datapath, header=FALSE)
      colnames(tmp) <- c("HR", "Time", "Mode")
      tmp <- dplyr::filter(tmp, Mode == "RelQ")
      
      if(input$raw_smooth == "Smooth") {
        tmp$HR <- smooth(tmp$HR, kind='3RSS')
      }
      
      mn1 <- round(median(tmp$HR, na.rm=TRUE))
      paste("Median HR:", mn1)
    } else {
      return(NULL)
    }
  })
  
  output$med3 <- renderText({
    c_f <- input$file1
    
    if(!is.null(c_f)) {
      tmp <- read.csv(c_f$datapath, header=FALSE)
      colnames(tmp) <- c("HR", "Time", "Mode")
      tmp <- dplyr::filter(tmp, Mode == "ComQ")
      
      if(input$raw_smooth == "Smooth") {
        tmp$HR <- smooth(tmp$HR, kind='3RSS')
      }
      
      mn1 <- round(median(tmp$HR, na.rm=TRUE))
      paste("Median HR:", mn1)
    } else {
      return(NULL)
    }
  })
  
})
