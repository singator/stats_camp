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
                                 choices=c("baseline", "after_exercise",
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
     column(width=6, plotOutput('plot2'))
   ),
   fluidRow(
     column(width=8,  textOutput('text1'))
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
  
   # output$plot1 <- renderPlot({
   #   input$upload
   #   isolate(
   #   if(is.null(rhrv_obj())) {
   #     return(NULL)
   #   } else {
   #     PlotNIHR(rhrv_obj())
   #   })
   # })
   
   observeEvent(input$upload, {
     # check for log file
     time_now <- as.character(Sys.time())
     log_string <- paste(time_now, "Uploading",
                         input$height, 
                         input$weight, input$gender,
                         input$person_id, 
                         input$dev_id, 
                         input$treatment, sep=",")
     
     # update master data file.
     tmp_data <- tribble( 
       ~rhrv, ~gender, ~ht, ~wt, ~pid,  ~did, ~trt, 
       rhrv_obj(), input$gender, as.numeric(input$height), 
       as.numeric(input$weight), input$person_id, input$dev_id, 
       input$treatment)
     data_exists <- file.exists("master_data.rds")
     if(data_exists) {
       master_data <- readRDS("master_data.rds")
       tmp_j <- semi_join(master_data, tmp_data, 
                          by=c("gender", "ht", "wt", "pid", "did", "trt"))
       if(nrow(tmp_j) != 0) {
         master_data <- anti_join(master_data, tmp_data, 
                          by=c("gender", "ht", "wt", "pid", "did", "trt"))
         log_string <- paste0(log_string, "(overwrite) \n")
       } else {
         log_string <- paste0(log_string, "\n")
       }
     } else {
       master_data <- NULL
       log_string <- paste0(log_string, "\n")
     }
     
     master_data <- rbind(master_data, tmp_data)
     saveRDS(master_data, "master_data.rds")
     cat(log_string, file="camp.log", append=TRUE)
     
     if(input$treatment == "baseline") {
       rhrv_f <- FilterNIHR(rhrv_obj())
       rhrv_i <- InterpolateNIHR(rhrv_f)
       mm <- mean(rhrv_i$HR)
       UL <- mm + 1.96*sd(rhrv_i$HR)
       LL <- mm - 1.96*sd(rhrv_i$HR)
       output$plot1 <- renderPlot({
         isolate({
           PlotNIHR(rhrv_obj(), main="Raw")
         })
       })
       output$plot2 <- renderPlot({
         PlotHR(rhrv_i, main="Processed")
         abline(h=c(UL, mm, LL), col=c("red", "blue", "red"), lty=2)
       })
       log_string <- paste(log_string, 
                            "mean: ", as.integer(mm),
                            ",UL: ", as.integer(UL), 
                            ",LL: ", as.integer(LL), sep=",")
     } else {
       rhrv_f <- FilterNIHR(rhrv_obj())
       rhrv_i <- InterpolateNIHR(rhrv_f)
       output$plot1 <- renderPlot({
         isolate({
           PlotNIHR(rhrv_obj(), main="Raw")
         })
       })
       
       tmp <- dplyr::filter(master_data, gender==input$gender,
                    ht == as.numeric(input$height), 
                    wt  == as.numeric(input$weight), 
                    pid == input$person_id, did == input$dev_id,
                    trt == "baseline")
       output$plot2 <- renderPlot({
         PlotHR(rhrv_i, main="Processed", col="red")
         if(nrow(tmp) != 0){
           tmp2 <- FilterNIHR(tmp$rhrv[[1]])
           lines(tmp2$Beat$Time, tmp2$Beat$niHR, col="gray")
         }
       })
       
     }
     
     output$text1 <- renderText({ log_string })
   })

}

# Run the application 
shinyApp(ui = ui, server = server)

