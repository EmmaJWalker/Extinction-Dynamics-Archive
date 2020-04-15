rm(list=ls()) #clear the workspace

#nearest neighbours function comes from spatstat package which is unavailable for the R studio installed on the server
library("spatstat") #contains nndist function
library("ggplot2") #for plotting
library("boot") #for bootstrapping 95% CI's

setwd("C:/Users/abuga/Desktop/Metapopulation-Simulation-Package-master")#access working directory that all my metapop functions are stored in
source("Create Landscape Function.r") #load create.landscape.function
source("Create Multiple Landscapes Function.r") #load rep.create.landscape.function
source("NNDist Distribution Summary Function.r")#load nndist.summary function
source("Choose Alphas Function meanmins2.r") #load choose alphas function

#GENERATING LANDSCAPE DATA
#############################################################################################################
n.patches=500
landscape.limit=100
no.runs=500
no.replicates=100
directory="C:/Users/abuga/Desktop/Metapopulation-Simulation-Package-master"
landscape.types=c("regular", "random", "clustered")
landscapes.data<-create.multiple.landscapes(n.patches=n.patches, landscape.limit=landscape.limit, no.runs=no.runs, no.replicates=no.replicates, landscape.types=landscape.types, directory=directory)
#############################################################################################################

#SUBSETTING DATA BY LANDSCAPE TYPE
##############################################################################################################
clustered.data<-subset(landscapes.data, landscape.type=="clustered")
head(clustered.data)
random.data<-subset(landscapes.data, landscape.type=="random")
head(random.data)
regular.data<-subset(landscapes.data, landscape.type=="regular")
head(regular.data)
##############################################################################################################


#CALCULATING SUMMARY STATS ON THE DISTRIBUTION OF NEAREST NEIGHBOUR DISTANCES FOR EACH LANDSCAPE TYPE
##############################################################################################################
regular.nndists.dist<-distribution.nndists.function(regular.data, no.replicates, n.patches)
regular.nndists.dist
random.nndists.dist<-distribution.nndists.function(random.data, no.replicates, n.patches)
random.nndists.dist
clustered.nndists.dist<-distribution.nndists.function(clustered.data, no.replicates, n.patches)
#puting it all into one table
all.nndists.dists<-rbind(regular.nndists.dist, random.nndists.dist, clustered.nndists.dist)
all.nndists.dists$landscape.type<-landscape.types
all.nndists.dists
write.csv(all.nndists.dists, "nndists distribution for each landscape type.csv")
##############################################################################################################

#CHOOSING ALPHA VALUES FOR SIMULATION BASED ON EACH LANDSCAPE TYPE'S DISTRIBUTION OF NNDISTS
#thus, levels of alpha represent diff species but of equivalent dispersal ability within the given landscape
#controls for the fact that clustering will have smaller nearest neighbour distances by way of the clustering algorithm, while regular will have larger nndists
#isolates for the effect of regularity in patch spacing
#############################################################################################################
#CHECK
regular.alphas<-choose.alphas(nndists.distribution=regular.nndists.dist, landscape.limit=landscape.limit)
random.alphas<-choose.alphas(nndists.distribution=random.nndists.dist, landscape.limit=landscape.limit)
clustered.alphas<-choose.alphas(nndists.distribution=clustered.nndists.dist, landscape.limit=landscape.limit)
#putting it all into one table
all.alphas<-rbind(regular.alphas, random.alphas, clustered.alphas)
all.alphas$landscape.type<-landscape.types
all.alphas
write.csv(all.alphas, "alphas.csv")
#############################################################################################################
