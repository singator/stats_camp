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
  
      inFile <- input$file1
      if(is.null(inFile))
        return(NULL)
      dat1 <- read.csv(inFile$datapath, header=TRUE)
    
      # plot time series
      xvals <- dat1[,2]/1000
      yvals <- dat1[,1]
      xlims = input$xlims
      ylims= input$ylims
      
      # make plot
      plot(xvals, yvals, type='b', col='darkorange2',
           xlim=xlims, ylim=ylims, pch=20,
           xlab='Time (s)', ylab='Heart Rate')
      grid()
      
    })
    
      output$text1 <-  renderUI( { 
        inFile <- input$file1
        
        if(!is.null(input$file1)) {
          dat1 <- read.csv(inFile$datapath, header=TRUE)
          xlims = input$xlims
          ylims= input$ylims
          
          str1 <- paste('Length of recording: ', round(dat1[nrow(dat1),2]/1000),
                  'seconds')
          str2 <- paste('Max. HR: ', round(max(dat1[,1])))
          
          id <- which(dat1$Time.ms./1000 < xlims[2] & 
                      dat1$Time.ms./1000 > xlims[1])
          tmp1 <- mean(dat1$HR[id], na.rm=TRUE)
          str3 <- paste('Mean. HR: ', round(tmp1))
          
          tmp2 <- median(dat1$HR[id], na.rm=TRUE)
          str4 <- paste('Median. HR: ', round(tmp2))
          
          tmp3 <- length(id)
          str5 <- paste('No. of points: ', tmp3)
          HTML(paste(str1, str2, str3, str4, str5, sep='<br/>'))
        } else {
          paste('Choose a file')
        }
        
        } )
  }  

)
