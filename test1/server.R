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
                        min=min.hr,  max=max.hr)
    }
  }
  )
  
  output$mean1 <- renderText({
    c_f <- input$file1
    
    if(!is.null(c_f)) {
      tmp <- read.csv(c_f$datapath, header=TRUE)
      mn1 <- round(mean(tmp$HR, na.rm=TRUE))
      paste("Mean HR:", mn1)
    } else {
      return(NULL)
    }
  }  )
  
  output$med1 <- renderText({
    c_f <- input$file1
    
    if(!is.null(c_f)) {
      tmp <- read.csv(c_f$datapath, header=TRUE)
      mn1 <- round(median(tmp$HR, na.rm=TRUE))
      paste("Median HR:", mn1)
    } else {
      return(NULL)
    }
  }  )
  
  output$nobs <- renderText({
    c_f <- input$file1
    
    if(!is.null(c_f)) {
      tmp <- read.csv(c_f$datapath, header=TRUE)
      paste("No. of obs:", nrow(tmp))
    } else {
      return(NULL)
    }
  }  )
  
  }
)
