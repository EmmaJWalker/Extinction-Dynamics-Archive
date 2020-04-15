rm(list=ls()) #clear workspace

setwd("C:/Users/Administrator/Desktop/Metapopulation-Simulation-Package-master") #access working directory that all my metapop functions are stored in
source("Create Landscape Function.r") #load create.landscape.function
source("Lambda M Function.r") #load the calculate lamda.M.function
source("Pstar Function.r") #load the persistence.function
source("time to eq3.r") #load the SRLM.sim function
source("Destroy and Degrade a Landscape Function2 (P and LM and SimEq)500.r") #destroy.vs.degrade.function only calculating Pstar and Lambda.M 
source("Degrade and Destroy Multiple Landscapes Function.r") #replicates landscape creation and destroy vs. degrade specified metapop parameters a specified number of times
source("Vary Alpha Destroy and Degrade Function for parallel.r") #provides replicates for a range of alphas across a landscape type
library("ggplot2")
#devtools::install_github("collectivemedia/tictoc")
library("tictoc")




setwd("C:/Users/Administrator/Desktop/Metapopulation-Simulation-Package-master") #access working directory that all my metapop functions are stored in
source("Create Landscape Function.r") #load create.landscape.function
source("Lambda M Function.r") #load the calculate lamda.M.function
source("Pstar Function.r") #load the persistence.function
source("time to eq3.r") #load the SRLM.sim function
source("Destroy and Degrade a Landscape Function2 (P and LM and SimEq)500 saving landscape data.r") #destroy.vs.degrade.function only calculating Pstar and Lambda.M 
source("Degrade and Destroy Multiple Landscapes Function.r") #replicates landscape creation and destroy vs. degrade specified metapop parameters a specified number of times
source("Vary Alpha Destroy and Degrade Function for parallel.r") #provides replicates for a range of alphas across a landscape type



#CHECK landscape creation function
landscape<-create.landscape(n.patches=500, landscape.limit=100, landscape.type="clustered", no.runs=500)
head(landscape)
print(ggplot(landscape, aes(y.coord,x.coord)) + geom_point(aes(size = A)))

#CHECK lambda.M function
lambda.M<-lambda.M.function(landscape=landscape, a=0.1, delta=1)
lambda.M

#CHECK scaling of lambda.M
delta<-(lambda.M=lambda.M.function(landscape=landscape, a=0.1, delta=1))/20
delta
lambda.M.function(landscape=landscape, a=0.1, delta=delta)

#CHECK pstar function
p.star<-pstar.function(landscape=landscape, a=0.1, delta=delta, iterations=1000)
p.star

#CHECK SRLM function
data<-SRLM.sim(landscape=landscape, a=100, delta=delta, timesteps=1000, p.initial=p.star, avg.p=sum(p.star)/50)
data

tic("one rep")
#CHECK destroy.vs.degrade.p.n.Lm function
clustered.landscape<-create.landscape(n.patches=500, landscape.limit=100, landscape.type="clustered", no.runs=500)
#scaling delta starting with initial lamda.M of 20
delta<-20/(lambda.M=lambda.M.function(landscape=clustered.landscape, a=100, delta=1))
clustered.output<-destroy.vs.degrade(landscape=clustered.landscape, a=100, delta=delta, landscape.type="clustered")
toc()

landscape.type<-rep("clustered", 2)
clustered.output<-data.frame(landscape.type, clustered.output)
head(clustered.output)
plot(clustered.output$percent.habitatloss, clustered.output$lambda.M.e)
plot(clustered.output$percent.habitatloss, clustered.output$lambda.M.r)
clustered.output

#Check the create multiple landscapes function
gen.destroy.and.degrade.landscapes(n.patches=500, landscape.limit=100, 
                                   landscape.type="clustered", no.runs=500, a=100, 
                                   n.landscapes=2, scaled.lm=20)


  
