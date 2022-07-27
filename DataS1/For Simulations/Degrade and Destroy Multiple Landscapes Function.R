#running replicates of the degradation and destruction scenarios of landscapes for a given set of parameters

#n.patches = number of patches desired in landscapes
#landscape limit = size of landscapes (max x and y coord of patches)
#landscape.type = specifiy whether landscapes should be "clustered", "random" or "regular" in patch distribution
#no.runs = level of clustering (number of times the clustering algorithm is iterated for)
#a = 1/average dispersal distance of the species
#n.landscapes = number of landscapes put through the degradation and destruction scenarios
#scaled.lm = value you would like to scale lambda.M to initially
############################################################################################
gen.destroy.and.degrade.landscapes<-function(n.patches, landscape.limit, landscape.type, no.runs, a, n.landscapes, scaled.lm){
  for (i in 1:n.landscapes){
    landscape<-create.landscape(n.patches=n.patches, landscape.limit=landscape.limit, landscape.type=landscape.type, no.runs=no.runs)
    #scaling delta starting with initial lambda.M of 20
    delta<-(lambda.M=lambda.M.function(landscape=landscape, a=a, delta=1))/scaled.lm
    output<-destroy.vs.degrade(landscape=landscape, a=a, delta=delta, landscape.type)
    output<-data.frame(landscape.type, output)
    #shift % loss column, (fix this in the destroy vs degrade function then remove this here)
    output["percent.habitatloss"]<-c(0, head(output["percent.habitatloss"], dim(output)[1]-1)[[1]])
    output$landscape.type<-landscape.type
    output$alpha<-a
    output$rep.no<-i
    #write.csv(output, paste0(i," ", no.runs,"run", a, "a", n.patches, "p ", landscape.type, " output.csv"))
    if(i==1){data<-output}
    else{data<-rbind(data, output)}
  }
  return(data)
}
############################################################################################
