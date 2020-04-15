#CHOOSING ALPHA VALUES 
#################################################################################################################
#choose alpha values for simulation based on each landscape type's distribution of nndists
#thus, levels of alpha represent diff species but of equivalent dispersal ability within the given landscape
#controls for the fact that clustering will have smaller nearest neighbour distances by way of the clustering algorithm, while regular will have larger nndists
#isolates for the effect of regularity in patch spacing

#nndists.distribution = data.frame of summary stats of nndists for all three landscape types 
#(aka output from NNDISTS Distribution Summary function)
#landscape.limit = size of landscape (max x and y coordinate that was possible in landscape generation)

#############################################################################################################
choose.alphas<-function(nndists.distribution, landscape.limit){
  a.16min<-nndists.distribution[2]/16 #average dispersal distance 16x smaller than mean(min) nndist
  a.8min<-nndists.distribution[2]/8 #average dispersal distance 8x smaller than mean(min) nndist 
  a.4min<-nndists.distribution[2]/4 #average dispersal distance 4x smaller than mean(min) nndist
  a.2min<-nndists.distribution[2] #average dispersal distance = mean(min) nndist
  a4.min<-nndists.distribution[2]*2 #average dispersal distance = mean(min) nndist x4
  a8.min<-nndists.distribution[2]*4 #average dispersal distance = mean(min) nndist
  a16.min<-nndists.distribution[2]*8 #average dispersal distance 16x smaller than mean(min) nndist
  a.limit<-landscape.limit #average dispersal distance = landscape limit (global dispersal)
  alphas<-data.frame(a.16min, a.8min, a.4min, a.2min, a4.min, a8.min, a16.min, a.limit)
  alphas<-1/alphas
  return(alphas)
}
###########################################################################################################
#CHECK
#alphas<-choose.alphas(nndists.distribution=clustered.nndists.dist, landscape.limit=100)
#alphas