#Creation of multiple landscapes of a given type and save data on each landscape generated in an output file
#################################################################################################################
#creates a multiple landscapes of all three possible landscape types of a specified size with a specified number 
#of patches, with a patch distribution of specified level of clustering or uniformity

#n.patches = number of patches in desired landscape
#landscape.limit = size of desired landscape (max possible x and y coordinate of a patch)
#landscape.types = may be a list of landscape types to be created eg. "clustered", "random", "regular"
#no.runs = number of iterations for which the clustering algorithm is run for, specifying the level of clustering
#no replicates = number of landscapes of each type to create
#directory = where output data should be saved
###############################################################################################################
create.multiple.landscapes<-function(n.patches, landscape.limit, no.runs, no.replicates, landscape.types, directory){
  setwd(directory)
  for (j in 1:length(landscape.types)){
    for (i in 1:no.replicates){
      landscape.i.data<-create.landscape(n.patches=n.patches,
                                         landscape.limit=landscape.limit,
                                         no.runs=no.runs,
                                         landscape.type = landscape.types[j])
      landscape.i.data$landscape.no<-i #add a column indicating the individual landscape's number
      #stitching all the individual landscapes into one data frame
      if (i==1){type.j.data<-landscape.i.data} 
      else {type.j.data<-rbind(type.j.data, landscape.i.data)}
    }
    type.j.data$landscape.type<-landscape.types[j] #add a column indicating the type of landscape's generated
    #stitching the data on all landscapes of each type together
    if (j==1){data<-type.j.data} 
    else {data<-rbind(data, type.j.data)}
  }
  #output file to be written with all the landscape's data and metadata
  file.name<-paste0(n.patches, "_p_", no.replicates, "landscapes", "_clevel", no.runs, ".csv")
  write.csv(data, file=file.name)
  return(data)
}
#END OF REPLICATE CREATE LANDSCAPE FUNCTION
################################################################################################################
