#P* FUNCTION
#################################################################################################################
#calculates the probability individual patches are occupied at equilibrium

#landscape = a dataframe created by the create landscape function which specifies patch locations, areas, 
#and and an interpatch distance matrix
#a = 1/(average dispersal distance) for a species
#delta = the ratio of the extinction to colonization rate of a species
#iterations = the number of iterations for which the iterative function f is iterated, 
              #greater iterations = greater accuracy, less iterations = lower accuracy

#NOTE: delta can be factored out of this calculation by letting delta = 1
#################################################################################################################
pstar.function<-function(landscape, a, delta, iterations){
  
  n.patches<-length(landscape$patch.ID)
  A<-landscape$A
  d<-as.matrix(landscape[,5:(dim(landscape)+4)])
  
  #STEP 1: SET UP OF MATRIX M
  M<-rep(NA, n.patches*n.patches); dim(M)<-c(n.patches,n.patches)
  for (i in 1:n.patches){ #for each row of matrix M
    for (j in 1:n.patches){ #for each column of matrix M
      if (i==j){M[i,j]<-0} #let the connectivity of a patch to itself be 0
      else{M[i,j]<-A[i]*A[j]*exp(-a*d[i,j])} 
      #let the connectivity of other patches to that patch be AiAje^(-adij)Pj
      if(M[i,j]<1*(10^-8)){M[i,j]<-1*(10^-8)}#assume that there is always some very very small
      #probability that a patch may be colonized because there is never 0 chance and because
      #R makes a rounding error making this 0, if this is too close to 0
      
    }}
  
  #ITERATING FUNCTION TO FIND P*
  p<-rep(NA, n.patches*iterations);dim(p)<-c(iterations,n.patches)
  p[1,1:n.patches]<-rep(0.1,n.patches)
  for (t in 1:(iterations-1)){ #iterate the following for a given number of iterations
    P<-p[t,] #use p of previous iteration
    g<-(M%*%P) #SRLM g function from Ovaskainen and Hanski, 2001
    f<-(g/(g+delta)) #SRLM f function from Ovaskainen and Hanski, 2001, 
    #which when iterated many times will give p*
    p[(t+1),]<-t(f)} 
  #set p for the next iteration = to the output value of p for this iteration
  p.star<-p[iterations,] #p* = the final iterations value of p after many iterations
  return(p.star)
}
#END P* FUNCTION
#################################################################################################################