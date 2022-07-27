rm(list=ls()) #clear workspace

setwd("C:/Users/Administrator/Desktop/Metapopulation-Simulation-Package-master") #access working directory that all my metapop functions are stored in
source("Create Landscape Function.r") #load create.landscape.function
source("Lambda M Function.r") #load the calculate lamda.M.function
source("Pstar Function.r") #load the persistence.function
source("time to eq3.r") #load the SRLM.sim function
source("Destroy and Degrade a Landscape Function2 (P and LM and SimEq)500 saving landscape data.r") #destroy.vs.degrade.function only calculating Pstar and Lambda.M 
source("Degrade and Destroy Multiple Landscapes Function.r") #replicates landscape creation and destroy vs. degrade specified metapop parameters a specified number of times
source("Vary Alpha Destroy and Degrade Function for parallel.r") #provides replicates for a range of alphas across a landscape type

getwd()
setwd("C:/Users/Administrator/Desktop/Metapopulation Manuscript Output") 
getwd() #make sure output will go in the correct directory

# process in parallel
library("doParallel") 
cl <- makeCluster(detectCores(), type='PSOCK')
registerDoParallel(cl)


#parallel alphas
##############################################################################
parallel.alphas<-function(j, n.reps, k){
  alpha.data<-read.csv("C:/Users/Administrator/Desktop/Metapopulation-Simulation-Package-master/alphas500.csv")
  alpha.data<-alpha.data[,c(1,4,5,7,9)] #run for only 1/4x, 1x, 4x, Global, 10 gives the landscape.type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
  clustered.data<-vary.alpha.in.parallel(alphas=alpha.data[3,j+1],landscape.type="clustered", n.landscapes=n.reps, k=k, n.patches=500, landscape.limit=100, no.runs=500, scaled.lm=20)
  rbind(clustered.data)
}
its.of.10=5
output<- foreach (k=1:10, .combine=rbind)  %:%
 foreach(i=((k*4)-3):(k*4), .combine=rbind) %dopar% parallel.alphas(j=i-((k-1)*4), n.reps=its.of.10, k=k)
write.csv(output, "100_150reps_PnLMnSimEq_3_500pnew2.csv")


# turn parallel processing off and run sequentially again:
registerDoSEQ()

stopCluster(cl)

stopImplicitCluster(cl)







