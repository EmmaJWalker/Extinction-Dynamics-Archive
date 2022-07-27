
#CREATES HISTOGRAMS OF NEAREST NEIGHBOUR INTERPATCH DISTANCES WITHIN LANDSCAPES OF EACH TYPE

#LOAD DESIRED LANDSCAPE DATA HERE ***you may modify this***
############################################################################################################
############################################################################################################
setwd("C:/Users/abuga/Desktop/Manuscript Supplementary Files/50 patch output files")
landscapes.data<-read.csv("50_p_100landscapes_clevel500.csv")
no.replicates=100
############################################################################################################
############################################################################################################

#LOADING REQUIRED PACKAGES
############################################################################################################
library("spatstat") #nearest neighbours function comes from spatstat package which is unavailable for the R 
#studio installed on the server
library("moments") #provides functions giving the skew and kurtosis of a distribution
############################################################################################################

#SUBSETTING DATA BY LANDSCAPE TYPE
##############################################################################################################
clustered.data<-subset(landscapes.data, landscape.type=="clustered")
random.data<-subset(landscapes.data, landscape.type=="random")
regular.data<-subset(landscapes.data, landscape.type=="regular")
##############################################################################################################

#CREATING THE HISTOGRAMS (also gives skew, kurtosis and the mean minimum nearest neighbour intepatch distance)
##############################################################################################################
plot.nndist<-function(data, title, no.replicates){
  avg.data<-data.frame(seq(1:no.replicates), rep(NA, no.replicates))
  colnames(avg.data)<-c("landscape", "avg.nndist")
  min.data<-data.frame(seq(1:no.replicates), rep(NA, no.replicates))
  colnames(min.data)<-c("landscape", "min.nndist")
  for (i in 1:nrow(avg.data)){
    avg.data[i,2]<-mean(nndist(data[(50*i-49):(50*i),6:55])) #gives mean nndist for each landscape
    min.data[i,2]<-min(nndist(data[(50*i-49):(50*i),6:55]))   #gives minimum nndist for each landscape
  }
  hist(min.data$min.nndist, xlab="Nearest Neighbour Interpatch Distances", ylab="Avg. Frequency Min NNDIST within Landscapes", 
       main = title, xlim=range(1:10)) #hist of minimum nndists within landscapes
  hist(avg.data$avg.nndist, xlab="Nearest Neighbour Interpatch Distances", ylab="Avg. Frequency Avg. NNDist within Landscapes", 
       main = title, xlim=range(1:10)) #historgram of avg nndists within landscapes
  avg.min.nndist<-mean(min.data$min.nndist)
  skewness<-skewness(avg.data$avg.nndist)
  kurtosis<-kurtosis(avg.data$avg.nndist)
  return(c(skewness, kurtosis, avg.min.nndist))
}
###############################################################################################################
#CHECK/GET OUTPUT
plot.nndist(regular.data, "More Uniform Landscapes", no.replicates)
dev.copy(png,'Uniform Avg NNDist Histogram.png')
dev.off()
plot.nndist(random.data, "Random Landscapes", no.replicates)
dev.copy(png,'Random Avg NNDist Histogram.png')
dev.off()
plot.nndist(clustered.data, "More Clustered Landscapes", no.replicates)
dev.copy(png,'Clustered Avg NNDist Histogram.png')
dev.off()
