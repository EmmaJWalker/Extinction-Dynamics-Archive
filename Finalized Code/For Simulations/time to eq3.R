#F4: SIMULATION OF SRLM MODEL FUNCTION (METAPOPULATION SIZE AND TIME TO EXTINCTION)
#########################################################################################
SRLM.sim<-function(landscape, a, delta, timesteps, p.initial, avg.p){
  
  landscape<-landscape
  a=a
  col.rate=1
  ext.rate=delta
  timesteps=timesteps
  avg.p=avg.p
  
  n.patches<-length(landscape$patch.ID)
  A<-landscape$A
  d<-as.matrix(landscape[,5:(dim(landscape)+4)])
  
  initial.occupied<-rbinom(n.patches, size=1, prob=p.initial)
  #draw from the binomial distribution with pr(occupied)=p.star to 
  #determine which patches are occupied initially starting at equilibrium
  
  occupied<-rep(NA, n.patches*timesteps); dim(occupied)<-c(timesteps, n.patches)
  occupied[1,]<-initial.occupied 
  #initially all patches have a probability of 1 they are occupied, 
  #therefore they are all occupied
  for (t in 2:timesteps){ #for all future timesteps in the simulation
    P<-occupied[t-1,] #the probability a patch is occupied is the probability 
    #it was occupied in the previous iteration of the simulation
    connectivity.net<-rep(NA, n.patches*n.patches); dim(connectivity.net)<-c(n.patches,n.patches)
    for (i in 1:n.patches){ #for each row in the matrix
      for (j in 1:n.patches){ #for each column in the matrix
        if (i==j){connectivity.net[i,j]<-0} #let the connectivity of a patch to itself be 0
        else{connectivity.net[i,j]<-A[j]*exp(-a*d[i,j])*P[j]} 
        #let the connectivity of other patches to that patch be Aje^(-adij)Pj
      }
    }
    S<-rowSums(connectivity.net) #The patch connectivity (S) = the sum of a patches 
    #connectivity to all other patches (don't have to exclude itself because it is simply 0)
    C<-rep(NA, n.patches)
    exp.col<-rep(NA,n.patches)
    E<-rep(NA, n.patches)
    exp.ext<-rep(NA, n.patches)
    for (i in 1:n.patches) { #for each patch
      C[i]<-S[i]/(S[i]+(1/col.rate)) #discrete time version of colonization for SRLM
      exp.col[i]<-C[i]*(1-P[i]) #probability we expect a patch will be colonized = 
      #pr(colonization)*pr(unnoccupied (1-P)) (therefore, pr(empty and colonized))
    } 
    real.col<-rbinom(n.patches, size=1, prob=exp.col) 
    #number of patches actually colonized, 
    #drawn from the normal distribution with the expected probability of colonization
    for (i in 1:n.patches) { #for each patch
      E[i]<-ext.rate/A[i]*(1-C[i]) #pr(extinction) is e/Ai*(1-Ci), 
      #rescue effect which is the probability that a pop establishes within the timestep
      exp.ext[i]<-E[i]*P[i] #probability we expect a patch will go extinct = 
      #pr(occupied)*pr(extinction) (therefore, the pr(occupied and goes extinct)
    } 
    exp.ext<-ifelse(exp.ext>1,1,exp.ext) #pr(extinction) is never greater than 1 
    real.ext<-rbinom(n.patches, size=1, prob=exp.ext) 
    #number of patches actually gone extinct, drawn from the normal distribution 
    #with the expected probability of extinction
    occupied[t,]<-P-real.ext+real.col #number of occupied patches = *****
    #print(head(occupied))
  } 
  metapop<-rowSums(occupied) #size of metapop (given by total number of patches occupied)
  #plot(1:timesteps, metapop, type="b") #plotting the size of metapop over time
  end.size<-mean(metapop[(timesteps-50):timesteps]) 
  #finds average metapop size over the last 50 timesteps (assuming that equilibrium is reached by 950 iterations this should = p.star of the current landscape)
  if (any((end.size-1) < metapop & metapop < (end.size+1))) {
    time.to.p1000<-which.max((end.size-1) < metapop & metapop < (end.size+1)) #finds first metapop entry at p.1000
  } else { time.to.p1000<-NA }#time.to.p1000=NA (shouldn't ever happen)
  if (any((metapop/n.patches) <= (avg.p+(sqrt(avg.p*(1-avg.p))/sqrt(n.patches))))) { # plus standard error of a binomial distribution
    time.to.eq<-which.max((metapop/n.patches) <= (avg.p+(sqrt(avg.p*(1-avg.p))/sqrt(n.patches)))) #finds first metapop entry at avg. expected p.star
    } else { time.to.eq<-NA}#time.to.eq=NA if never hits eq
  data<-list(#metapop=metapop, #include metapop to check
    eq.size=end.size, time.to.p1000=time.to.p1000, time.to.eq=time.to.eq)
  return(data) 
  } 
#END SRLM FUNCTION
############################################################################################################################################################################
#setwd("C:/Users/Administrator/Desktop/Manuscript/Functions") #access working directory that all my metapop functions are stored in
#source("Create Landscape Function.r") #load create.landscape.function
#source("Lambda M Function.r") #load the calculate lamda.M.function
#source("Pstar Function.r") #load the persistence.function

#CHECK SRLM function
#data<-SRLM.sim(landscape=landscape, a=1/2, delta=delta, timesteps=1000, p.initial=p.star, p.star=p.star)
#data$metapop
#plot(1:1000,data$metapop)
