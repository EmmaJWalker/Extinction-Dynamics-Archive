#NNDIST SUMMARY
#################################################################################################################
#calculate the summary stats of the distribution of nearest neighbour distances across multiple created landscapes of a given type/clustering level

#landscape.data = data of multiple created landscapes
#no.replicates = number of landscapes that were created
#n.patches = number of patches within those landscapes created

#NOTE: only enter landscapes of one type/level of clustering
#use output data from eg. create multiple landscapes function selected for one given landscape type
#############################################################################################################
distribution.nndists.function<-function(potatoes, no.replicates, n.patches){
  for (i in 1:no.replicates) { #for each replicate
    one.landscape.data<-subset(potatoes, landscape.no==i) #subset for that replicate's landscape data
    nndists<-nndist(one.landscape.data$x.coord[1:n.patches], one.landscape.data$y.coord[1:n.patches]) 
    #calculate distribution of nndists for that landscape
    max<-max(nndists) #find the max nndist within that landscape
    third<-quantile(nndists, prob = 0.75) #find the 3rd quantile nndist within that landscape
    median<-median(nndists) #find the median nndist within that landscape
    mean<-mean(nndists)#find the mean nndist within that landscape
    first<-quantile(nndists, prob = 0.25) #find the 1st quantile nndist within that landscape
    min<-min(nndists) #find the min nndist within that landscape
    dists.sum<-data.frame(min, first, median, mean, third, max) #create a data frame of all these summary stats
    if (i==1) {dist.data<-dists.sum} 
    else{dist.data<-rbind(dist.data, dists.sum)} 
  }
  dist.data #put these summary stats for all of our landscapes into one data frame
  
  min.min<-min(dist.data$min) #calculate the minimum of the minimum nndists across landscapes
  min<-mean(dist.data$min) #calculate the average minimum nndists across landscapes
  min.se<-sd(dist.data$min/sqrt(no.replicates)) #calculate the standard error of this
  first<-mean(dist.data$first) #calculate the average first quartile nndists across landscapes
  first.se<-sd(dist.data$first/sqrt(no.replicates)) #calculate the standard error of this
  median<-mean(dist.data$median) #calculate the average median nndists across landscapes
  median.se<-sd(dist.data$median/sqrt(no.replicates)) #calculate the standard error of this
  mean<-mean(dist.data$mean) #calculate the average mean nndists across landscapes
  mean.se<-sd(dist.data$mean/sqrt(no.replicates)) #calculate the standard error of this
  third<-mean(dist.data$third) #calculate the average third quartile nndists across landscapes
  third.se<-sd(dist.data$third/sqrt(no.replicates)) #calculate the standard error of this
  max<-mean(dist.data$max) #calculate the average maximum nndists across landscapes
  max.se<-sd(dist.data$max/sqrt(no.replicates)) #calculate the standard error of this
  max.max<-max(dist.data$max) #calculate the maximum maximum nndist across landscapes
  dist.summary<-data.frame(min.min, min, min.se, first, first.se, median, median.se, mean, mean.se, third, third.se, max, max.se, max.max)
  return(dist.summary) #provide this in a summary table
}
#END NNDIST SUMMARY FUNCTION
############################################################################################################
