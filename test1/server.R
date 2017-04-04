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
shinyServer(function(input, output, clientData, session) {
  
  observe({
    c_f <- input$file1
    
    if(!is.null(c_f)) {
      tmp <- read.csv(c_f$datapath, header=TRUE)
      min.T <- round(min(tmp$Time.ms, na.rm=TRUE)/1000)
      max.T <- round(max(tmp$Time.ms, na.rm=TRUE)/1000)
      updateSliderInput(session, 'start_end_time', val=c(min.T, max.T), 
                        min=min.T,  max=max.T)
      
      min.hr <- round(min(tmp$HR, na.rm=TRUE))
      max.hr <- round(max(tmp$HR, na.rm=TRUE))
      updateSliderInput(session, 'hr_limits', val=c(min.hr, max.hr), 
                        min=round(0.8*min.hr),  max=round(1.2*max.hr))
    }
  }
  )
  
  output$mean1 <- renderText({
    c_f <- input$file1
    xlim2 <- input$start_end_time
    
    if(!is.null(c_f)) {
      tmp <- read.csv(c_f$datapath, header=TRUE)
      tmp <- subset(tmp, tmp$Time.ms/1000 < xlim2[2] &
                         tmp$Time.ms/1000 > xlim2[1])
      mn1 <- round(mean(tmp$HR, na.rm=TRUE))
      paste("Mean HR:", mn1)
    } else {
      return(NULL)
    }
  }  )
  
  output$med1 <- renderText({
    c_f <- input$file1
    xlim2 <- input$start_end_time
    
    if(!is.null(c_f)) {
      tmp <- read.csv(c_f$datapath, header=TRUE)
      tmp <- subset(tmp, tmp$Time.ms/1000 < xlim2[2] &
                         tmp$Time.ms/1000 > xlim2[1])
      mn1 <- round(median(tmp$HR, na.rm=TRUE))
      paste("Median HR:", mn1)
    } else {
      return(NULL)
    }
  }  )
  
  output$nobs <- renderText({
    c_f <- input$file1
    xlim2 <- input$start_end_time
    
    if(!is.null(c_f)) {
      tmp <- read.csv(c_f$datapath, header=TRUE)
      tmp <- subset(tmp, tmp$Time.ms/1000 < xlim2[2] &
                         tmp$Time.ms/1000 > xlim2[1])
      paste("No. of obs:", nrow(tmp))
    } else {
      return(NULL)
    }
  }  )
  
  output$plot1 <- renderPlot({
    c_f <- input$file1
    
    if(!is.null(c_f)) {
      tmp <- read.csv(c_f$datapath, header=TRUE)
      xvals <- tmp$Time.ms/1000
      yvals <- tmp$HR
      
      xlim2 <- input$start_end_time
      ylim2 <- input$hr_limits
      
      plot(xvals, yvals, type='b', col='darkorange', xlab='Time (s)',
           ylab='Heart Rate per minute', xlim=xlim2, ylim=ylim2)
      grid()
    } else {
      return(NULL)
    }
    
  }
    
  )
  }
)
