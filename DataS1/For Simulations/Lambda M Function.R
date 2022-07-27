#CALCULATES lambda.M
#################################################################################################################
#calculates lambda.M for a given landscape (landscape), species specific average dispersal distance (a), 
#and species specific ratio of extinction to colonization rate (delta)

#landscape = a dataframe created by the create landscape function which specifies patch locations, areas, 
            #and and an interpatch distance matrix
#a = 1/(average dispersal distance) for a species
#delta = the ratio of the extinction to colonization rate of a species

#NOTE: delta can be factored out of this calculation by letting delta = 1
##################################################################################################################
#F2: DETERMINE lambda.M FUNCTION ***With delta (otherwise exactly the same)
##################################################################################################################
lambda.M.function<-function(landscape, a, delta){
  n.patches<-length(landscape$patch.ID)
  A<-landscape$A
  d<-as.matrix(landscape[,5:(n.patches+4)]) #selects data from column 5 onwards
  #STEP 1: SET UP OF MATRIX M
  M<-rep(NA, n.patches*n.patches); dim(M)<-c(n.patches,n.patches)
  for (i in 1:n.patches){ #for each row of matrix M
    for (j in 1:n.patches){ #for each column of matrix M
      if (i==j){M[i,j]<-0} #let the connectivity of a patch to itself be 0
      else{M[i,j]<-A[i]*A[j]*exp(-a*d[i,j])
      if(M[i,j]<1*(10^-8)){M[i,j]<-1*(10^-8)} #assume that there is always some very very small
      #probability that a patch may be colonized because there is never 0 chance and because
      #R makes a rounding error making this 0, if this is too close to 0
      } 
      #let the connectivity of other patches to that patch be AiAje^(-adij)
    }}
  #FIND lambda M (The Metapop persistence capacity)
  eigen.M<-eigen(M) #determine eigenvalues and eigenvectors for matrix M
  lambda.M<-eigen.M$values[1] 
  #lambda.M is the leading eigenvalue of matrix M which is given as the first output value
  lambda.M<-lambda.M #add a negligible # onto lambda.M so that it never = 0
  #I did this because if lambda.M is ever 0, delta will become infinity if we try to scale it
  #we don't want to start with a lambda.M<1 ever anyways ***
  lambda.M<-lambda.M/delta
  return(lambda.M)
}
#END lambda.M FUNCTION
#################################################################################################################################
#CHECK
#delta<-20/(lambda.M=lambda.M.function(landscape=landscape, a=100, delta=1))
#delta
#lambda.M.function(landscape=landscape, a=100, delta=delta)