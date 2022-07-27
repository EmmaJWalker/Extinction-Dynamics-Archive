rm(list=ls()) #clear the workspace

#nearest neighbours function comes from spatstat package which is unavailable for the R studio installed on the server
library("spatstat")
library("ggplot2")
library("ggthemes")
library("plotly")
library("RColorBrewer")
library("colorspace")
library("wesanderson") #SUPER NICE COLOUR SCHEMES!
library("ggthemes")
pal <- choose_palette()
pal(4)


percent.loss<-seq(1,100,1)
degradation<-(1-(percent.loss/100))^2
uniform.destruction<-(1-(percent.loss/100))
clustered.destruction<-c(rep(1, 15), rep(NA, 70), rep(0, 15))
plot.data<-data.frame(percent.loss, degradation, clustered.destruction, uniform.destruction)

plot.hypothesis<-function(plot.data){
  print(
    ggplot(data=plot.data)  + theme_classic()
    + geom_line(aes(x = percent.loss, y = uniform.destruction), color="#C9C7BA", size=1) 
    + geom_line(aes(x = percent.loss, y = clustered.destruction), color="#2D3184", size=1)
    + geom_ribbon(aes(x=percent.loss, ymin= c(rep(NA, 15), rep(0, 70), rep(NA, 15)), ymax=c(rep(NA, 15), rep(1, 70), rep(NA, 15))), fill="#2D3184", alpha=0.3)
    + geom_line(aes(x = percent.loss, y = degradation), size=1,  color="red", linetype="dashed") 
    + geom_hline(aes(yintercept=1/100), color="black", size=1) 
    + labs(x = "Percent Habitat Reduction", y = "Persistence Capacity Final/Intial", 
           title = "Hypothesis")
    + theme(text = element_text(size=15))
  )
}

plot1<-plot.hypothesis(plot.data)
dev.copy(png,'Hypothesis.png')
dev.off()
