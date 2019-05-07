library("RHRV")
library(TTR)

# to be changed by Shiny UI
smoothness = 5
filename   = "hr-vik.txt"
path       = "~"
freqRange  = c(0.0,0.5)

hr = CreateHRVData()
hr = SetVerbose(hr, TRUE)
hr = LoadBeatAscii(hr, filename, RecordPath=path, scale=0.001)
hr = BuildNIHR(hr)
hr = FilterNIHR(hr)
hr = InterpolateNIHR (hr, freqhr = 4)
# hr$time = seq(hr$Beat$Time[1],by=1/hr$Freq_HR,len=length(hr$HR))

layout(matrix(c(1,0,2,2,3,3), 3, 2, byrow = TRUE), 
   widths=c(1,1), heights=c(1,1,1))

hr = CreateNonLinearAnalysis(hr)
hr = PoincarePlot(hr,indexNonLinearAnalysis=1,timeLag=1,
                  confidenceEstimation=TRUE, confidence = 0.9, doPlot=TRUE)

PlotNIHR(hr,ylim=c(50,180),main="Heart Rate")
lines(smooth.spline(hr$Beat$Time,hr$Beat$niHR,df=smoothness),col="red")

# This plot has to be last, since it doesn't seem to play nicely with layout                  
PlotSpectrogram(HRVData=hr, size=20, shift=10, sizesp=512, showLegend=FALSE, freqRange=freqRange)
                  