#perform replicate runs for multiple different alpha values

#alphas = vector of alpha values
#n.patches = number of patches desired in landscapes
#landscape limit = size of landscapes (max x and y coord of patches)
#landscape.type = specifiy whether landscapes should be "clustered", "random" or "regular" in patch distribution
#no.runs = level of clustering (number of times the clustering algorithm is iterated for)
#n.landscapes = number of landscapes put through the degradation and destruction scenarios
#scaled.lm = desired lambda.M of pristine landscapes

##########################################################################################################################################
vary.alpha<-function(alphas, n.landscapes, landscape.type, n.patches, landscape.limit, no.runs, scaled.lm){
  for (i in 1:length(alphas)) {
    output<-gen.destroy.and.degrade.landscapes(n.patches=n.patches, landscape.limit=landscape.limit, landscape.type=landscape.type, a=alphas[i], no.runs=no.runs, n.landscapes=n.landscapes, scaled.lm=scaled.lm)
    output$alpha<-alphas[i]
    #put all data for all diff alpha values in one file
    if(i==1){data<-output}
    else{data<-rbind(data, output)}
  }
  file.name<-paste0(n.landscapes,"reps_", landscape.type, n.patches,"p", "_desvsdeg_PnLM.csv")
  write.csv(data, file=file.name)
  return(data)
}
##############################################################################################################################