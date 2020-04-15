rm(list=ls()) #clear the workspace

library("gridExtra")
library("grid")
library("lattice")
library("cowplot")

#nearest neighbours function comes from spatstat package which is unavailable for the R studio installed on the server
library("spatstat")
library("ggplot2")
#library("rcompanion")
#library("fitdistrplus")
library("boot")
library("ggthemes")
library("plotly")

setwd("C:/Users/abuga/Desktop/Metapopulation-Simulation-Package-master")#access working directory that all my metapop functions are stored in
source("Plotdata Median Lm Function.r")
source("Plotdata Median P Function.r")
source("Plotdata Median P1000 Function.r")
#source("Plotdata Median t extinct Function.r")
#source("Plotdata Total extinct Function.r")
#source("Plotdata Median t to P Function.r")
#source("Plotdata Median t to P by lm Function.r")
#source("Plotdata Median t to P binning lm Function.r")
#source("Plotdata Median tex Function.r")
source("Plotdata Median tex vs lm Function DEST.r")
source("Plotdata Median tex vs lm Function DEG.r")
source("Plotdata Median tp vs lm Function DEST.r")
source("Plotdata Median tp vs lm Function DEG.r")

library("RColorBrewer")
library("colorspace")
library("wesanderson") #SUPER NICE COLOUR SCHEMES!
library("ggthemes")

#READING IN DATA
################################################################################################################
data.set1<-read.csv("C:/Users/abuga/Desktop/Manuscript Supplementary Files/500 patch output files/10reps_PnLMnSimEq_3_500pnew2.csv")
data.set2<-read.csv("C:/Users/abuga/Desktop/Manuscript Supplementary Files/500 patch output files/10_40reps_PnLMnSimEq_3_500pnew2.csv")
data.set3<-read.csv("C:/Users/abuga/Desktop/Manuscript Supplementary Files/500 patch output files/40_70reps_PnLMnSimEq_3_500pnew2.csv")
data.set4<-read.csv("C:/Users/abuga/Desktop/Manuscript Supplementary Files/500 patch output files/70_100reps_PnLMnSimEq_3_500pnew2.csv")
data.set<-rbind(data.set1, data.set2, data.set3, data.set4)
unique(data.set$alpha) ###duplicates = weird!!!! why? I dunno...
unique(data.set$time.to.eq.e)
length(data.set$time.to.eq.e)
length(!data.set$time.to.eq.r==1000 & !is.na(data.set$time.to.eq.r))
################################################################################################################


#ADD IN A SCALED TIME TO EQ COLUMN
#######################################################################################################
#data.set$t.to.eq.by.lm.r<-data.set$time.to.eq.r/data.set$lambda.M.r
#data.set$t.to.eq.by.lm.e<-data.set$time.to.eq.e/data.set$lambda.M.e
data.set$time.to.eq.r[is.na(data.set$time.to.eq.r)]<-1000 #if it never reached eq say it took 1000 timesteps
data.set$time.to.eq.e[is.na(data.set$time.to.eq.e)]<-1000 #if it never reached eq say it took 1000 timesteps
#######################################################################################################

#SUBSETTING THE DATA FOR A GIVEN LANDSCAPE TYPE
################################################################################################################
subset.landscape<-function(data, landscape.type){
  data<-data[data$landscape.type==landscape.type,]
  return(data)}
###########################################################################################################
#CHECK data<-subset.landscape(data.set, landscape.type)

#GET UNIQUE ALPHAS
##########################################################################################################
get.a<-function(data){
  a<-unique(data$alpha)
  return(a)}
################################################################################################################
#CHECK a<-get.a(data)


#CLEANING DATA ***UPDATED
################################################################################################################
clean.data<-function(a, data){
  data<-data[data$delta>1/100000,] #removing landscape data in which the only reason the species is persisting is because of the base colinization probablity
  data<-data[complete.cases(data[ , 8]),]  #getting rid of rows with NA's in all but the time extinct column (based on values in column 8)
  #exclude any data for which there are less than 20 replicates
  df2<-NULL
  for (i in 1:length(a)){
    input.data<-data[data$alpha==a[i],]
    df<-input.data[length(unique(input.data$rep.no[input.data$alpha==a[i]]))>20]
    df2<-rbind(df2, df)}
  data<-df2}
################################################################################################################
#CHECK data<-clean.data(a, data)

#GET DISTRIBUTION OF DELTAS
###########################################################################################################
get.deltas<-function(a, data, landscape.type){
  deltas<-rep(NA, 6*length(a)); dim(deltas)<-c(length(a),6)
  for (i in 1:length(a)){
    a.group<-data[data$alpha==a[i],]
    deltas[i,]<-(summary(a.group$delta))
  }
  deltas<-as.data.frame(deltas)
  deltas$a<-a
  deltas$avg.disp<-c("1/8x Avg Min Nearest Neighbour Distance","1/4x Avg Min Nearest Neighbour Distance", "1/2x Avg Min Nearest Neighbour Distance", "1x Avg Min Nearest Neighbour Distance", "2x Avg Min Nearest Neighbour Distance", "4x Avg Min Nearest Neighbour Distance", "8x Avg Min Nearest Neighbour Distance", "Global Dispersal")
  colnames(deltas)<-c("Min", "1st.Q", "Med", "Mean", "3rd.Q", "Max", "a", "avg.disp")
  deltas
  setwd("C:/Users/abuga/Desktop/Metapopulation Manuscript Output")
  write.csv(deltas, file = paste0(landscape.type, "50p deltas sim.csv"))
  return(deltas)
}
########################################################################################################################################
#CHECK deltas<-get.deltas(a, data, landscape.type)

#DEST ONLY GRAPHS
pal <- choose_palette()
#####################################################################################################
#LM GRAPH
LMplot.data<-function(deltas, data){
  deltas<-na.omit(deltas)
  plot.data<-NULL
  for (i in 1:length(deltas$a)){
    df3<-plotdata.median.Lm(data[data$alpha==deltas$a[i], ], scaled.lm=20)
    df3<-data.frame(a=rep(deltas$a[i], nrow(df3)), avg.disp=rep(deltas$avg.disp[i], nrow(df3)), df3)
    plot.data<-rbind(plot.data, df3)
  }
  return(plot.data)
}
#CHECK plot.data<-LMplot.data(deltas, data)
plot.LM<-function(plot.data, landscape.type, a, title){
  print(
    ggplot(data=plot.data)  + theme_classic()
        + geom_ribbon(aes(x=percent.loss, ymin= destruction.lower.CI, ymax=destruction.upper.CI, group=log(1/a), fill=factor(log(1/a))), alpha=0.3)
        + geom_line(aes(x = percent.loss, y = destruction.median, group=log(1/a), colour=factor(log(1/a))), size=1) 
        + geom_line(aes(x = percent.loss, y = degradation.lambda.M, colour="Degradation"), size=1,  color="red", linetype="dashed") 
        + geom_hline(aes(yintercept=0.05), color="black", size=1) 
        + labs(x = "Percent Habitat Reduction", y = "Persistence Capacity Final/Intial", 
               title = paste0(title, " Landscapes"))
        + scale_colour_manual("Dispersal Ability", values = pal(8), 
                                labels = rev(c("1/8x", "1/4x", "Avg Min N.N.", "4x", "Global Dispersal")),
                                guide="legend") #
        + scale_fill_manual(values=pal(8), guide="none")
        + theme(text = element_text(size=15))
        + theme(legend.text=element_text(size=12))
        + theme(legend.key.size = unit(1.5, "cm"))
        + theme(legend.title = element_text(size=17, vjust=1))
        #+ theme(legend.position="none") #to remove legend
        + theme(legend.position = c(0.9, 0.9))
        + guides(color=guide_legend(keywidth=0.1, keyheight=0.2, default.unit="inch", override.aes = list(size = 4)))
    )
}
plot.LM2<-function(plot.data, landscape.type, a, title){
  print(
    ggplot(data=plot.data)
    + geom_ribbon(aes(x=percent.loss, ymin= destruction.lower.CI, ymax=destruction.upper.CI, group=log(1/a), fill=factor(log(1/a))), alpha=0.3)
    + geom_line(aes(x = percent.loss, y = destruction.median, group=log(1/a), colour=factor(log(1/a))), size=0.5) 
    + geom_line(aes(x = percent.loss, y = degradation.lambda.M, colour="Degradation"),  color="red", linetype="dashed", size=0.5) 
    + geom_hline(aes(yintercept=0.05), color="black", size=0.5) 
    + labs(x = "Percent Habitat Reduction", y = "Persistence Capacity Final/Intial", 
           title = paste0(title, " Landscapes"))
    + scale_colour_manual("Dispersal Ability", values = pal(8), 
                            labels = rev(c("1/8x", "1/4x", "Avg Min Nearest Neighbour", "4x", "Global Dispersal")),
                            guide="none") #
    + scale_fill_manual(values=pal(8), guide="none")
    )
} #plotly version

#CHECK plot.LM(plot.data, landscape.type)
graph.LM<-function(data.set, landscape.type, title){
  data<-subset.landscape(data.set, landscape.type)
  a<-get.a(data)
  data<-clean.data(a, data)
  deltas<-get.deltas(a, data, landscape.type)
  plot.data<-LMplot.data(deltas, data)
  plot.data<-subset(plot.data, 
                    avg.disp=="1/8x Avg Min Nearest Neighbour Distance" | 
                      avg.disp=="1/4x Avg Min Nearest Neighbour Distance" |
                      avg.disp=="1x Avg Min Nearest Neighbour Distance" |
                      avg.disp=="4x Avg Min Nearest Neighbour Distance" |
                      avg.disp=="Global Dispersal" )
  plot.LM(plot.data, landscape.type, a, title)
}

plot1<-graph.LM(data.set, "regular", "More Uniform")
#p<-ggplotly(plot1)
#plotly_IMAGE(p, format = "png", out_file = "uniform-LM-plotly.png")
dev.copy(png,'Uniform LM 5 vals.png')
dev.off()
plot2<-graph.LM(data.set, "random", "Random")
#p<-ggplotly(plot2)
#plotly_IMAGE(p, format = "png", out_file = "random-LM-plotly.png")
dev.copy(png,'Random LM 5 vals.png')
dev.off()
plot3<-graph.LM(data.set, "clustered", "More Clustered")
ggplotly(plot3)
#plotly_IMAGE(p, format = "png", out_file = "clustered-Lm-plotly.png")
dev.copy(png,'Clustered LM 5 vals red.png')
dev.off()

#generating all required initial persistence plots for every alpha value and landscape type
##############################################################################################################a=c(0.067, 0.105, 0.429, 0.571, 0.96, 100)
plot.Pi<-function(plot.data, landscape.type, title){
  plot.data$degradation.p.initial<-(1-plot.data$degradation.lambda.M)
  plot.data$destruction.p.initial<-(1-plot.data$destruction.median)
  print(ggplot(data=plot.data) + theme_classic() +
          geom_line(aes(x = percent.loss, y = degradation.p.initial, colour="Degradation"), size=1,  color="red", linetype="dashed") +
          #geom_ribbon(aes(x=percent.loss, ymin=0, ymax=degradation.p.initial, group=1, fill="Degradation"), alpha=0.3) +
          geom_ribbon(aes(x=percent.loss, ymin=0, ymax=destruction.p.initial, group=log(1/a), fill=factor(log(1/a))), alpha=0.3) +
          labs(x = "Percent Habitat Reduction", y = "Porportion of initial habitat occupied to persist", 
               title = paste0(title, " Landscapes"))
        + scale_fill_manual("Dispersal Ability",values = pal(8), 
                              labels = rev(c("1/16x", "1/8x", "1/4x", "Avg Min Nearest Neighbour", "2x", "4x", "8x", "Global Dispersal"))) #
        + theme(text = element_text(size=15))
        + theme(legend.text=element_text(size=12))
        + theme(legend.key.size = unit(1.5, "cm"))
        + theme(legend.title = element_text(size=17, vjust=20))
        + theme(legend.position="none") #to remove legend
  )
}
plot.Pi2<-function(plot.data, landscape.type, title){
  plot.data$degradation.p.initial<-(1-plot.data$degradation.lambda.M)
  plot.data$destruction.p.initial<-(1-plot.data$destruction.median)
  print(ggplot(data=plot.data) + theme_classic() +
          geom_line(aes(x = percent.loss, y = degradation.p.initial, colour="Degradation"), size=0.5,  color="red", linetype="dashed") +
          #geom_ribbon(aes(x=percent.loss, ymin=0, ymax=degradation.p.initial, group=1, fill="Degradation"), alpha=0.3) +
          geom_ribbon(aes(x=percent.loss, ymin=0, ymax=destruction.p.initial, group=(1/a), fill=factor(1/a)), alpha=0.3) +
          labs(x = "Percent Habitat Reduction", y = "Porportion of initial habitat occupied to persist", 
               title = paste0(title, " Landscapes"))
        + scale_fill_manual("Dispersal Ability", values = pal(8), 
                              breaks = c(100, 8, 4, 2, 1, 0.25, 0.125, 0.0625), 
                              labels = rev(c("1/16x", "1/8x", "1/4x", "Avg Min Nearest Neighbour", "2x", "4x", "8x", "Global Dispersal"))) #
        + theme(legend.position="none") #to remove legend
  )
} #plotly version

graph.Pi<-function(data.set, landscape.type, title){
  data<-subset.landscape(data.set, landscape.type)
  a<-get.a(data)
  data<-clean.data(a, data)
  deltas<-get.deltas(a, data, landscape.type)
  plot.data<-LMplot.data(deltas, data)
  plot.data<-subset(plot.data, 
                    avg.disp=="1/8x Avg Min Nearest Neighbour Distance" | 
                      avg.disp=="1/4x Avg Min Nearest Neighbour Distance" |
                      avg.disp=="1x Avg Min Nearest Neighbour Distance" |
                      avg.disp=="4x Avg Min Nearest Neighbour Distance" |
                      avg.disp=="Global Dispersal" )
  plot<-plot.Pi(plot.data, landscape.type, title)
  return(plot)
}

plot1<-graph.Pi(data.set, "regular", "More Uniform")
#ggplotly(plot1)
dev.copy(png,'Uniform Pi 5 vals.png')
dev.off()
plot2<-graph.Pi(data.set, "random", "Random")
#ggplotly(plot2)
dev.copy(png,'Random Pi 5 vals.png')
dev.off()
plot3<-graph.Pi(data.set, "clustered", "More Clustered")
ggplotly(plot3)
dev.copy(png,'Clustered Pi 5 vals.png')
dev.off()

#P* GRAPH
#########################################################################################################
Pplot.data<-function(deltas, data){
  deltas<-na.omit(deltas)
  plot.data<-NULL
  for (i in 1:length(deltas$a)){
    df3<-plotdata.median.p(data[data$alpha==deltas$a[i], ])
    df3<-data.frame(a=rep(deltas$a[i], nrow(df3)), avg.disp=rep(deltas$avg.disp[i], nrow(df3)), df3)
    plot.data<-rbind(plot.data, df3)
  }
  return(plot.data)
}
#CHECK plot.data<-Pplot.data(deltas, data)

plot.P<-function(plot.data, landscape.type, a, title){
  print(ggplot(data=plot.data) + theme_classic()
        + geom_ribbon(aes(x=percent.loss, ymin= destruction.lower.CI, ymax=destruction.upper.CI, group=log(1/a), fill=factor(log(1/a))), alpha=0.3)
        + geom_line(aes(x = percent.loss, y = destruction.median, group=log(1/a), colour=factor(log(1/a))), size=1, linetype="dashed") 
        #+ geom_ribbon(aes(x=percent.loss, ymin= degradation.lower.CI, ymax=degradation.upper.CI, group=(1/a), fill=factor(1/a)), alpha=0.3)
        #+ geom_line(aes(x = percent.loss, y = degradation.median, group=(1/a), colour=1/(a)), size=1, linetype="dashed") 
        + labs(x = "Percent Habitat Reduction", y = "Avg. Expected Patch Occupancy at Equilibrium (P*)", 
               title = paste0(title, " Landscapes"))
        + scale_colour_manual("Dispersal Ability",values = pal(8), 
                                labels = rev(c("1/16x", "1/8x", "1/4x", "Avg Min Nearest Neighbour", "2x", "4x", "8x", "Global Dispersal"))) #
        + scale_fill_manual(values=pal(8), guide="none")
        + theme(text = element_text(size=15))
        + theme(legend.text=element_text(size=12))
        + theme(legend.key.size = unit(1.5, "cm"))
        + theme(legend.title = element_text(size=17, vjust=20))
        + theme(legend.position="none") #to remove legend
        + ylim(0,1) + xlim(0,1)
  )
}
#CHECK plot.P(plot.data, landscape.type, a, title)
plot.P2<-function(plot.data, landscape.type, a, title){
  print(ggplot(data=plot.data) + theme_classic()
        + geom_ribbon(aes(x=percent.loss, ymin= destruction.lower.CI, ymax=destruction.upper.CI, group=log(1/a), fill=factor(log(1/a))), alpha=0.3)
        + geom_line(aes(x = percent.loss, y = destruction.median, group=log(1/a), colour=factor(log(1/a))), size=0.5, linetype="dashed") 
        #+ geom_ribbon(aes(x=percent.loss, ymin= degradation.lower.CI, ymax=degradation.upper.CI, group=(1/a), fill=factor(1/a)), alpha=0.3)
        #+ geom_line(aes(x = percent.loss, y = degradation.median, group=(1/a), colour=1/(a)), size=0.5, linetype="dashed") 
        + labs(x = "Percent Habitat Reduction", y = "Avg. Expected Patch Occupancy at Equilibrium (P*)", 
               title = "Destruction in Clustered Landscapes")
        + scale_colour_manual("Dispersal Ability",values = pal(8), 
                                labels = rev(c("1/16x", "1/8x", "1/4x", "Avg Min Nearest Neighbour", "2x", "4x", "8x", "Global Dispersal"))) #
        + scale_fill_manual(values=pal(8), guide="none")
        + theme(legend.position="none") #to remove legend
        #+ ylim(0,1) + xlim(0,1)
  )
}

graph.P<-function(data.set, landscape.type, title){
  data<-subset.landscape(data.set, landscape.type)
  a<-get.a(data)
  data<-clean.data(a, data)
  deltas<-get.deltas(a, data, landscape.type)
  plot.data<-Pplot.data(deltas, data)
  plot.data<-subset(plot.data, 
                    avg.disp=="1/8x Avg Min Nearest Neighbour Distance" | 
                      avg.disp=="1/4x Avg Min Nearest Neighbour Distance" |
                      avg.disp=="1x Avg Min Nearest Neighbour Distance" |
                      avg.disp=="4x Avg Min Nearest Neighbour Distance" |
                      avg.disp=="Global Dispersal" )
  plot<-plot.P(plot.data, landscape.type, a, title)
  return(plot)
}

plot1<-graph.P(data.set, "regular", "More Uniform")
dev.copy(png,'Dest Uniform Pstar 5 vals.png')
dev.off()
plot2<-graph.P(data.set, "random", "Random")
dev.copy(png,'Dest Random Pstar 5 vals.png')
dev.off()
plot3<-graph.P(data.set, "clustered", "More Clustered")
ggplotly(plot3)
dev.copy(png,'Dest Clustered Pstar 5 vals.png')
dev.off()

###################################################################################################
#P1000
simplot.data<-function(deltas, data){
  deltas<-na.omit(deltas)
  plot.data<-NULL
  for (i in 1:length(deltas$a)){
    df3<-plotdata.median.p1000(data[data$alpha==deltas$a[i], ])
    df3<-data.frame(a=rep(deltas$a[i], nrow(df3)), avg.disp=rep(deltas$avg.disp[i], nrow(df3)), df3)
    plot.data<-rbind(plot.data, df3)
  }
  return(plot.data)
}
#CHECK plot.data<-Pplot.data(deltas, data)

plot.sim<-function(plot.data, landscape.type, a, title){
  print(ggplot(data=plot.data) + theme_classic()
        + geom_ribbon(aes(x=percent.loss, ymin= destruction.lower.CI, ymax=destruction.upper.CI, group=log(1/a), fill=factor(log(1/a))), alpha=0.3)
        + geom_line(aes(x = percent.loss, y = destruction.median, group=log(1/a), colour=factor(log(1/a))), size=1) 
        #+ geom_ribbon(aes(x=percent.loss, ymin= degradation.lower.CI, ymax=degradation.upper.CI, group=(1/a), fill=factor(1/a)), alpha=0.3)
        #+ geom_line(aes(x = percent.loss, y = degradation.median, group=(1/a), colour=1/(a)), size=1) 
        + labs(x = "Percent Habitat Reduction", y = "Avg. Patch Occupancy", 
               title = paste0(title, " Landscapes"))
        + scale_colour_manual("Dispersal Ability",values = pal(8),
                              labels = rev(c("1/8x", "1/4x", "1/2x", "Avg Min Nearest Neighbour", "2x", "4x", "8x", "Global Dispersal"))) #
        + scale_fill_manual(values=pal(8), guide="none")
        + theme(text = element_text(size=15))
        + theme(legend.text=element_text(size=12))
        + theme(legend.key.size = unit(1.5, "cm"))
        + theme(legend.title = element_text(size=17, vjust=20))
        + xlim(0,1) + ylim(0,1)
        + theme(legend.position="none") #to remove legend
  )
}
#CHECK plot.P(plot.data, landscape.type, a, title)
plot.sim2<-function(plot.data, landscape.type, a, title){
  print(ggplot(data=plot.data) + theme_classic()
        + geom_ribbon(aes(x=percent.loss, ymin= destruction.lower.CI, ymax=destruction.upper.CI, group=log(1/a), fill=factor(log(1/a))), alpha=0.3)
        + geom_line(aes(x = percent.loss, y = destruction.median, group=log(1/a), colour=factor(log(1/a))), size=0.5) 
        #+ geom_ribbon(aes(x=percent.loss, ymin= degradation.lower.CI, ymax=degradation.upper.CI, group=(1/a), fill=factor(1/a)), alpha=0.3)
        #+ geom_line(aes(x = percent.loss, y = degradation.median, group=(1/a), colour=1/(a)), size=1) 
        + labs(x = "Percent Habitat Reduction", y = "Avg. Patch Occupancy", 
               title = "Destruction in Clustered Landscapes")
        + scale_colour_manual("Dispersal Ability",values = pal(8), 
                                labels = rev(c("1/8x", "1/4x", "1/2x", "Avg Min Nearest Neighbour", "2x", "4x", "8x", "Global Dispersal"))) #
        + scale_fill_manual(values=pal(8), guide="none")
        + theme(legend.position="none") #to remove legend
  )
}

graph.sim<-function(data.set, landscape.type, title){
  data<-subset.landscape(data.set, landscape.type)
  a<-get.a(data)
  data<-clean.data(a, data)
  deltas<-get.deltas(a, data, landscape.type)
  plot.data<-simplot.data(deltas, data)
  plot.data<-subset(plot.data, 
                    avg.disp=="1/8x Avg Min Nearest Neighbour Distance" | 
                      avg.disp=="1/4x Avg Min Nearest Neighbour Distance" |
                      avg.disp=="1x Avg Min Nearest Neighbour Distance" |
                      avg.disp=="4x Avg Min Nearest Neighbour Distance" |
                      avg.disp=="Global Dispersal" )
  plot.sim2(plot.data, landscape.type, a, title)
}

plot1<-graph.sim(data.set, "regular", "More Uniform")
dev.copy(png,'Dest Uniform P1000 5 vals.png')
dev.off()
plot2<-graph.sim(data.set, "random", "Random")
dev.copy(png,'Dest Random P1000 5 vals.png')
dev.off()
plot3<-graph.sim(data.set, "clustered", "More Clustered")
ggplotly(plot3)
dev.copy(png,'Dest Clustered P1000 5 vals.png')
dev.off()
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
#DEG ONLY GRAPHS
pal <- choose_palette()
#####################################################################################################
Pplot.data<-function(deltas, data){
  deltas<-na.omit(deltas)
  plot.data<-NULL
  for (i in 1:length(deltas$a)){
    df3<-plotdata.median.p(data[data$alpha==deltas$a[i], ])
    df3<-data.frame(a=rep(deltas$a[i], nrow(df3)), avg.disp=rep(deltas$avg.disp[i], nrow(df3)), df3)
    plot.data<-rbind(plot.data, df3)
  }
  return(plot.data)
}
#CHECK plot.data<-Pplot.data(deltas, data)

plot.P<-function(plot.data, landscape.type, a, title){
  print(ggplot(data=plot.data) + theme_classic()
        #+ geom_ribbon(aes(x=percent.loss, ymin= destruction.lower.CI, ymax=destruction.upper.CI, group=(1/a), fill=factor(1/a)), alpha=0.3)
        #+ geom_line(aes(x = percent.loss, y = destruction.median, group=(1/a), colour=1/(a)), size=1, linetype="dashed") 
        + geom_ribbon(aes(x=percent.loss, ymin= degradation.lower.CI, ymax=degradation.upper.CI, group=log(1/a), fill=factor(log(1/a))), alpha=0.3)
        + geom_line(aes(x = percent.loss, y = degradation.median, group=log(1/a), colour=factor(log(1/a))), size=1, linetype="dashed") 
        + labs(x = "Percent Habitat Reduction", y = "Avg. Expected Patch Occupancy at Equilibrium (P*)", 
               title = paste0(title, " Landscapes"))
        + scale_colour_manual("Dispersal Ability", values = pal(8),
                                labels = rev(c("1/16x", "1/8x", "1/4x", "Avg Min Nearest Neighbour", "2x", "4x", "8x", "Global Dispersal"))) #
        + scale_fill_manual(values=pal(8), guide="none")
        + theme(text = element_text(size=15))
        + theme(legend.text=element_text(size=12))
        + theme(legend.key.size = unit(1.5, "cm"))
        + theme(legend.title = element_text(size=17, vjust=20))
        + theme(legend.position="none") #to remove legend
        + ylim(0,1) + xlim(0,1)
  )
}
#CHECK plot.P(plot.data, landscape.type, a, title)
plot.P2<-function(plot.data, landscape.type, a, title){
  print(ggplot(data=plot.data) + theme_classic()
        #+ geom_ribbon(aes(x=percent.loss, ymin= destruction.lower.CI, ymax=destruction.upper.CI, group=(1/a), fill=factor(1/a)), alpha=0.3)
        #+ geom_line(aes(x = percent.loss, y = destruction.median, group=(1/a), colour=1/(a)), size=1, linetype="dashed") 
        + geom_ribbon(aes(x=percent.loss, ymin= degradation.lower.CI, ymax=degradation.upper.CI, group=log(1/a), fill=factor(log(1/a))), alpha=0.3)
        + geom_line(aes(x = percent.loss, y = degradation.median, group=log(1/a), colour=factor(log(1/a))), size=0.5, linetype="dashed") 
        + labs(x = "Percent Habitat Reduction", y = "Avg. Expected Patch Occupancy at Equilibrium (P*)", 
               title = "Degradation in Clustered Landscapes")
        + scale_colour_gradient("Dispersal Ability",values = pal(8), 
                                labels = rev(c("1/16x", "1/8x", "1/4x", "Avg Min Nearest Neighbour", "2x", "4x", "8x", "Global Dispersal"))) #
        + scale_fill_manual(values=pal(8), guide="none")
        + theme(legend.position="none") #to remove legend
        #+ ylim(0,1) + xlim(0,1)
  )
}

graph.P<-function(data.set, landscape.type, title){
  data<-subset.landscape(data.set, landscape.type)
  a<-get.a(data)
  data<-clean.data(a, data)
  deltas<-get.deltas(a, data, landscape.type)
  plot.data<-Pplot.data(deltas, data)
  plot.data<-subset(plot.data, 
                    avg.disp=="1/8x Avg Min Nearest Neighbour Distance" | 
                      avg.disp=="1/4x Avg Min Nearest Neighbour Distance" |
                      avg.disp=="1x Avg Min Nearest Neighbour Distance" |
                      avg.disp=="4x Avg Min Nearest Neighbour Distance" |
                      avg.disp=="Global Dispersal" )
  plot<-plot.P2(plot.data, landscape.type, a, title)
  return(plot)
}

plot1<-graph.P(data.set, "regular", "More Uniform")
dev.copy(png,'Deg Uniform Pstar 5 vals.png')
dev.off()
plot2<-graph.P(data.set, "random", "Random")
dev.copy(png,'Deg Random Pstar 5 vals.png')
dev.off()
plot3<-graph.P(data.set, "clustered", "More Clustered")
ggplotly(plot)
dev.copy(png,'Deg Clustered Pstar 5 vals.png')
dev.off()

#P1000 Deg #########################################################################################
simplot.data<-function(deltas, data){
  deltas<-na.omit(deltas)
  plot.data<-NULL
  for (i in 1:length(deltas$a)){
    df3<-plotdata.median.p1000(data[data$alpha==deltas$a[i], ])
    df3<-data.frame(a=rep(deltas$a[i], nrow(df3)), avg.disp=rep(deltas$avg.disp[i], nrow(df3)), df3)
    plot.data<-rbind(plot.data, df3)
  }
  return(plot.data)
}
#CHECK plot.data<-Pplot.data(deltas, data)

plot.sim<-function(plot.data, landscape.type, a, title){
  print(ggplot(data=plot.data) + theme_classic()
        #+ geom_ribbon(aes(x=percent.loss, ymin= destruction.lower.CI, ymax=destruction.upper.CI, group=(1/a), fill=factor(1/a)), alpha=0.3)
        #+ geom_line(aes(x = percent.loss, y = destruction.median, group=(1/a), colour=1/(a)), size=1) 
        + geom_ribbon(aes(x=percent.loss, ymin= degradation.lower.CI, ymax=degradation.upper.CI, group=log(1/a), fill=factor(log(1/a))), alpha=0.3)
        + geom_line(aes(x = percent.loss, y = degradation.median, group=log(1/a), colour=factor(log(1/a))), size=1) 
        + labs(x = "Percent Habitat Loss", y = "Avg. Patch Occupancy", 
               title = paste0(title, " Landscapes"))
        + scale_colour_manual("Dispersal Ability", values = pal(8), 
                              labels = rev(c("1/8x", "1/4x", "1/2x", "Avg Min Nearest Neighbour", "2x", "4x", "8x", "Global Dispersal"))) #
        + scale_fill_manual(values=pal(8), guide="none")
        + theme(text = element_text(size=15))
        + theme(legend.text=element_text(size=12))
        + theme(legend.key.size = unit(1.5, "cm"))
        + theme(legend.title = element_text(size=17, vjust=20))
        + xlim(0,1) + ylim(0,1)
        + theme(legend.position="none") #to remove legend
  )
}
#CHECK plot.P(plot.data, landscape.type, a, title)
plot.sim2<-function(plot.data, landscape.type, a, title){
  print(ggplot(data=plot.data) + theme_classic()
        #+ geom_ribbon(aes(x=percent.loss, ymin= destruction.lower.CI, ymax=destruction.upper.CI, group=(1/a), fill=factor(1/a)), alpha=0.3)
        #+ geom_line(aes(x = percent.loss, y = destruction.median, group=(1/a), colour=1/(a)), size=1) 
        + geom_ribbon(aes(x=percent.loss, ymin= degradation.lower.CI, ymax=degradation.upper.CI, group=log(1/a), fill=factor(log(1/a))), alpha=0.3)
        + geom_line(aes(x = percent.loss, y = degradation.median, group=log(1/a), colour=factor(log(1/a))), size=0.5) 
        + labs(x = "Percent Habitat Loss", y = "Avg. Patch Occupancy", 
               title = "Degradation in Clustered Landscapes")
        + scale_colour_manual("Dispersal Ability",values = pal(8), 
                              labels = rev(c("1/8x", "1/4x", "1/2x", "Avg Min Nearest Neighbour", "2x", "4x", "8x", "Global Dispersal"))) #
        + scale_fill_manual(values=pal(8), guide="none")
        + xlim(0,1) + ylim(0,1)
        + theme(legend.position="none") #to remove legend
  )
}


graph.sim<-function(data.set, landscape.type, title){
  data<-subset.landscape(data.set, landscape.type)
  a<-get.a(data)
  data<-clean.data(a, data)
  deltas<-get.deltas(a, data, landscape.type)
  plot.data<-simplot.data(deltas, data)
  plot.data<-subset(plot.data, 
                    avg.disp=="1/8x Avg Min Nearest Neighbour Distance" | 
                      avg.disp=="1/4x Avg Min Nearest Neighbour Distance" |
                      avg.disp=="1x Avg Min Nearest Neighbour Distance" |
                      avg.disp=="4x Avg Min Nearest Neighbour Distance" |
                      avg.disp=="Global Dispersal" )
  plot<-plot.sim2(plot.data, landscape.type, a, title)
  return(plot)
}

plot1<-graph.sim(data.set, "regular", "More Uniform")
dev.copy(png,'Deg Uniform P1000 5 vals.png')
dev.off()
plot2<-graph.sim(data.set, "random", "Random")
dev.copy(png,'Deg Random P1000 5 vals.png')
dev.off()
plot3<-graph.sim(data.set, "clustered", "More Clustered")
ggplotly(plot) #doesn't work out of the function but just run it's insides manually and it works
dev.copy(png,'Deg Clustered P1000 5 vals.png')
dev.off()
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
#HEAT MAPS for time to equilibrium
pal <- choose_palette()
library("akima")
library("plotly")
tp.vs.lm.plot.data<-function(deltas, data){
  deltas<-na.omit(deltas)
  plot.data<-NULL
  for (i in 1:length(deltas$a)){
    df3<-plotdata.median.tp.vs.lm.r(data[data$alpha==deltas$a[i], ])
    df3<-data.frame(a=rep(deltas$a[i], nrow(df3)), avg.disp=rep(deltas$avg.disp[i], nrow(df3)), df3)
    plot.data<-rbind(plot.data, df3)
  }
  return(plot.data)
}
#CHECK plot.data<-texplot.data(deltas, data)
####################################################################################################
#manually update these and print plots
landscape.type="clustered"
title="More Clustered"
####################################################################################################
data<-subset.landscape(data.set, landscape.type)
a<-get.a(data)
data<-clean.data(a, data)
deltas<-get.deltas(a, data, landscape.type)
plot.data<-tp.vs.lm.plot.data(deltas, data)
plot.data<-subset(plot.data, 
                  #avg.disp=="1/8x Avg Min Nearest Neighbour Distance" | 
                    avg.disp=="1/4x Avg Min Nearest Neighbour Distance" |
                    avg.disp=="1x Avg Min Nearest Neighbour Distance" |
                    avg.disp=="4x Avg Min Nearest Neighbour Distance" |
                    avg.disp=="Global Dispersal" )

data <- data.frame(x=1-plot.data$Lm,
                   y=1/plot.data$a,
                   distance=plot.data$destruction.median)
resolution <- 0.01 # you can increase the resolution by decreasing this number (warning: the resulting dataframe size increase very quickly)
interpolated.data <- interp(x=data$x, y=data$y, z=data$distance, 
            xo=seq(min(data$x),max(data$x),by=resolution), 
            yo=seq(min(data$y),max(data$y),by=resolution), duplicate="mean")
interpolated.data$z<-t(interpolated.data$z)
#summary(interpolated.data$z)
#summary(plot.data$destruction.median)

b <- list(title = "Change in Persistence Capacity (Initial-Final)/Initial")
c <- list(title = "Log(Avg. Dispersal)")
legendtitle <- list(yref='paper',xref="paper",y=1.05,x=1.4, text="Time to Equilibrium",showarrow=F)
plot_ly(x=interpolated.data$x, y=log10(interpolated.data$y), z=log(interpolated.data$z), type = "heatmap", colors=pal(8)) %>%
  layout(xaxis = b, yaxis = c, title = "Time to Equilibrium")
tp.vs.lm.plot.data<-function(deltas, data){
  deltas<-na.omit(deltas)
  plot.data<-NULL
  for (i in 1:length(deltas$a)){
    df3<-plotdata.median.tp.vs.lm.r(data[data$alpha==deltas$a[i], ])
    df3<-data.frame(a=rep(deltas$a[i], nrow(df3)), avg.disp=rep(deltas$avg.disp[i], nrow(df3)), df3)
    plot.data<-rbind(plot.data, df3)
  }
  return(plot.data)
}
#CHECK plot.data<-texplot.data(deltas, data)


#########################DEG
tp.vs.lm.plot.data<-function(deltas, data){
  deltas<-na.omit(deltas)
  plot.data<-NULL
  for (i in 1:length(deltas$a)){
    df3<-plotdata.median.tp.vs.lm.e(data[data$alpha==deltas$a[i], ])
    df3<-data.frame(a=rep(deltas$a[i], nrow(df3)), avg.disp=rep(deltas$avg.disp[i], nrow(df3)), df3)
    plot.data<-rbind(plot.data, df3)
  }
  return(plot.data)
}
#CHECK plot.data<-texplot.data(deltas, data)
####################################################################################################
#manually update these and print plots
landscape.type="clustered"
title="More Clustered"
####################################################################################################
data<-subset.landscape(data.set, landscape.type)
a<-get.a(data)
data<-clean.data(a, data)
deltas<-get.deltas(a, data, landscape.type)
plot.data<-tp.vs.lm.plot.data(deltas, data)
plot.data<-subset(plot.data, 
                  avg.disp=="1/8x Avg Min Nearest Neighbour Distance" | 
                    avg.disp=="1/4x Avg Min Nearest Neighbour Distance" |
                    avg.disp=="1x Avg Min Nearest Neighbour Distance" |
                    avg.disp=="4x Avg Min Nearest Neighbour Distance" |
                    avg.disp=="Global Dispersal" )

data <- data.frame(x=1-plot.data$Lm,
                   y=1/plot.data$a,
                   distance=plot.data$degradation.median)
resolution <- 0.01 # you can increase the resolution by decreasing this number (warning: the resulting dataframe size increase very quickly)
interpolated.data <- interp(x=data$x, y=data$y, z=data$distance, 
                            xo=seq(min(data$x),max(data$x),by=resolution), 
                            yo=seq(min(data$y),max(data$y),by=resolution), duplicate="mean")
interpolated.data$z<-t(interpolated.data$z)
#summary(interpolated.data$z)
#summary(plot.data$destruction.median)

b <- list(title = "Change in Persistence Capacity (Initial-Final)/Initial")
c <- list(title = "Log(Avg. Dispersal)")
legendtitle <- list(yref='paper',xref="paper",y=1.05,x=1.4, text="Log(Time to Equilibrium)",showarrow=F)
plot_ly(x=interpolated.data$x, y=log10(interpolated.data$y), z=log10(interpolated.data$z), type = "heatmap", colors=pal(8)) %>%
  layout(xaxis = b, yaxis = c, title = "Log(Time to Equilibrium)")

##################################################################################################
####
#time extinct by lm GRAPH ***95% CI's not working but should be able to fix
#you need to update the function below with whether it's e or r you want this for***
tex.vs.lm.plot.data<-function(deltas, data){
  data[data$sim.eq.size.r!=0,]$time.to.p1000.r<-1000 #for the simulations that never went extinct, set the time it took for them to reach their end to be 1000
  #data<-data[data$sim.eq.size.r==0,] #only include extinctions within 1000 years
  data<-data[data$lambda.M.r<=1,] #only include where we were expecting extinction
  deltas<-na.omit(deltas)
  plot.data<-NULL
  for (i in 1:length(deltas$a)){
    df3<-plotdata.median.tex.vs.lm.r(data[data$alpha==deltas$a[i], ])
    df3<-data.frame(a=rep(deltas$a[i], nrow(df3)), avg.disp=rep(deltas$avg.disp[i], nrow(df3)), df3)
    plot.data<-rbind(plot.data, df3)
  }
  return(plot.data)
}
#CHECK plot.data<-texplot.data(deltas, data)

plot.tex.vs.lm<-function(plot.data, landscape.type, a, title){
  print(ggplot(data=plot.data[complete.cases(plot.data[,1:7]),]) + theme_classic()
        #+ geom_ribbon(aes(x=Lm, ymin= destruction.lower.CI, ymax=destruction.upper.CI, group=(1/a), fill=factor(1/a)), alpha=0.3)
        + geom_line(aes(x=Lm, y = log10(destruction.median), group=(1/a), colour=1/(a)), size=1) 
        #+ geom_ribbon(aes(x=Lm, ymin= degradation.lower.CI, ymax=degradation.upper.CI, group=(1/a), fill=factor(1/a)), alpha=0.3)
        #+ geom_line(aes(x = Lm, y = log10(degradation.median), group=(1/a), colour=1/(a)), size=1) 
        + labs(x = "Persitence Capacity", y = "Log Time Extinct", 
               title = paste0(title, " Landscapes"))
        + scale_colour_gradient("Dispersal Ability",low = pal(8),high = "light grey", trans="log", breaks = c(100, 4, 1, 0.25, 0.125), labels = rev(c("1/8x", "1/4x", "Avg Min Nearest Neighbour", "4x", "Global Dispersal"))) #
        + scale_fill_manual(values=pal(8), guide="none")
        + theme(text = element_text(size=15))
        + theme(legend.text=element_text(size=12))
        + theme(legend.key.size = unit(1.5, "cm"))
        + theme(legend.title = element_text(size=17, vjust=20))
        #+ xlim(0,1) 
        + ylim(0,log10(1000))
        + theme(legend.position="none") #to remove legend
  )
}
#CHECK plot.P(plot.data, landscape.type, a, title)

landscape.type="clustered"
title="More Clustered"
data<-subset.landscape(data.set, landscape.type)
a<-get.a(data)
data<-clean.data(a, data)
deltas<-get.deltas(a, data, landscape.type)
plot.data<-tex.vs.lm.plot.data(deltas, data)
plot_ly(
  x = plot.data$Lm, y = plot.data$avg.disp,
  z = plot.data$destruction.median, type = "heatmap")

#heatmap interpolating between points
#############################################
library("akima")
data <- data.frame(x=(1-plot.data$Lm),
                   y=(1/plot.data$a),
                   distance=plot.data$destruction.median)
resolution <- 0.01 # you can increase the resolution by decreasing this number (warning: the resulting dataframe size increase very quickly)
f <- interp(x=data$x, y=data$y, z=data$distance, 
            xo=seq(min(data$x),max(data$x),by=resolution), 
            yo=seq(min(data$y),max(data$y),by=resolution), duplicate="mean")
f$z<-t(f$z)
summary(f$z)


b <- list(title = "Persistence Capacity (Initial-Final)/Initial")
c <- list(title = "Log(Avg. Dispersal)")
legendtitle <- list(yref='paper',xref="paper",y=1.05,x=1.4, text="Log(Time to Extinction)",showarrow=F)
plot_ly(x=f$x, y=log10(f$y), z=log10(f$z), type = "heatmap", colors=pal(8)) %>%
  layout(xaxis = b, yaxis = c, title = "Log(Time to Extinction)"
         #, annotations=legendtitle
  )

####
#time extinct by lm GRAPH ***95% CI's not working but should be able to fix
#you need to update the function below with whether it's e or r you want this for***
tex.vs.lm.plot.data<-function(deltas, data){
  data[data$sim.eq.size.e!=0,]$time.to.p1000.e<-1000 #for the simulations that never went extinct, set the time it took for them to reach their end to be 1000
  #data<-data[data$sim.eq.size.e==0,] #only include extinctions within 1000 years
  data<-data[data$lambda.M.e<=1,] #only include where we were expecting extinction
  deltas<-na.omit(deltas)
  plot.data<-NULL
  for (i in 1:length(deltas$a)){
    df3<-plotdata.median.tex.vs.lm.e(data[data$alpha==deltas$a[i], ])
    df3<-data.frame(a=rep(deltas$a[i], nrow(df3)), avg.disp=rep(deltas$avg.disp[i], nrow(df3)), df3)
    plot.data<-rbind(plot.data, df3)
  }
  return(plot.data)
}
#CHECK plot.data<-texplot.data(deltas, data)

plot.tex.vs.lm<-function(plot.data, landscape.type, a, title){
  print(ggplot(data=plot.data[complete.cases(plot.data[,1:7]),]) + theme_classic()
        #+ geom_ribbon(aes(x=Lm, ymin= destruction.lower.CI, ymax=destruction.upper.CI, group=(1/a), fill=factor(1/a)), alpha=0.3)
        #+ geom_line(aes(x = Lm, y = destruction.median, group=(1/a), colour=1/(a)), size=1) 
        #+ geom_ribbon(aes(x=Lm, ymin= degradation.lower.CI, ymax=degradation.upper.CI, group=(1/a), fill=factor(1/a)), alpha=0.3)
        + geom_line(aes(x = Lm, y = log10(degradation.median), group=(1/a), colour=1/(a)), size=1) 
        + labs(x = "Persitence Capacity", y = "Log Time Extinct", 
               title = paste0(title, " Landscapes"))
        + scale_colour_gradient("Dispersal Ability",low = pal(8),high = "light grey", trans="log", breaks = c(100, 8, 4, 2, 1, 0.5, 0.25, 0.125), labels = rev(c("1/8x", "1/4x", "1/2x", "Avg Min Nearest Neighbour", "2x", "4x", "8x", "Global Dispersal"))) #
        + scale_fill_manual(values=pal(8), guide="none")
        + theme(text = element_text(size=15))
        + theme(legend.text=element_text(size=12))
        + theme(legend.key.size = unit(1.5, "cm"))
        + theme(legend.title = element_text(size=17, vjust=20))
        #+ xlim(0,1) 
        + ylim(0,log10(1000))
        + theme(legend.position="none") #to remove legend
  )
}
#CHECK plot.P(plot.data, landscape.type, a, title)

landscape.type="clustered"
title="More Clustered"
graph.tex.vs.lm<-function(data.set, landscape.type, title){
  data<-subset.landscape(data.set, landscape.type)
  a<-get.a(data)
  data<-clean.data(a, data)
  deltas<-get.deltas(a, data, landscape.type)
  plot.data<-tex.vs.lm.plot.data(deltas, data)
  plot.data<-subset(plot.data, 
                    avg.disp=="1/8x Avg Min Nearest Neighbour Distance" | 
                      avg.disp=="1/4x Avg Min Nearest Neighbour Distance" |
                      avg.disp=="1x Avg Min Nearest Neighbour Distance" |
                      avg.disp=="4x Avg Min Nearest Neighbour Distance" |
                      avg.disp=="Global Dispersal" )
  plot.tex.vs.lm(plot.data, landscape.type, a, title)
}


data<-subset.landscape(data.set, landscape.type)
a<-get.a(data)
data<-clean.data(a, data)
deltas<-get.deltas(a, data, landscape.type)
plot.data<-tex.vs.lm.plot.data(deltas, data)

data <- data.frame(x=1-plot.data$Lm,
                   y=1/plot.data$a,
                   distance=plot.data$degradation.median)
resolution <- 0.01 # you can increase the resolution by decreasing this number (warning: the resulting dataframe size increase very quickly)
a <- interp(x=data$x, y=data$y, z=data$distance, 
            xo=seq(min(data$x),max(data$x),by=resolution), 
            yo=seq(min(data$y),max(data$y),by=resolution), duplicate="mean")
a$z<-t(a$z)
summary(a$z)
summary(plot.data$degradation.median)

b <- list(title = "Persistence Capacity (Initial-Final)/Initial")
c <- list(title = "Log(Avg. Dispersal)")
legendtitle <- list(yref='paper',xref="paper",y=1.05,x=1.4, text="Log(Time to Extinction)",showarrow=F)
plot_ly(x=a$x, y=log10(a$y), z=log10(a$z), type = "heatmap", colors=pal(8)) %>%
  layout(xaxis = b, yaxis = c, title = "Log(Time to Extinction)"
         #, annotations=legendtitle
  )