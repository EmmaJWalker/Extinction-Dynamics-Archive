#CREATE LANDSCAPE FUNCTION
#################################################################################################################
#creates a landscape of a specified size with a specified number of patches, with a patch distribution
#of specified level of clustering or uniformity

#n.patches = number of patches in desired landscape
#landscape.limit = size of disired landscape (max possible x and y coordinate of a patch)
#landscape.type = specify whether the desired landscape's patches should be randomly, clustered or more regularly distrbuted
                  #accepts either "clustered", "regular" or "random"
#no.runs = number of iterations for which the clustering algorithm is run for, specifying the level of clustering
#################################################################################
#GENERATE RANDOM LANDSCAPE OF PATCHES
create.landscape<-function(n.patches, landscape.limit, landscape.type, no.runs){
  #n.patches = number of patches
  #landscape.limit = max x and y coordinate
  #landscape.type = categorical variable deteriming whether patches in the 
  #landscape should be "clustered", "random" or "regularly spaced
  #no.runs = number of times clustering/declustering algorithm should be iterated
  #higher the value, the more patches are clustered or regularly spaced
  #if it is a "clustered" landscape versus a "regular" landscape
  
  n.patches<-n.patches
  patch.ID<-c(1:n.patches)
  #assign ID numbers to each patch (This is so that we can track which patches are
  #removed throughout destruction of patches from the landscape)
  A<-rlnorm(n.patches, meanlog = 2, sdlog=1 )
  #patch areas lognormally distributed with a mean of 2 and standard deviation of 1
  radii<-sqrt(A/pi) #calculate radii of hypothetically circular patches
  
  x.coord<-runif(n.patches, min=0, max=landscape.limit) 
  #pick a random number for the x coordinate of each patch between 0 and the extent
  #of the landscape
  y.coord<-runif(n.patches, min=0, max=landscape.limit) 
  #pick a random number for the y coordinate of each patch between 0 and the extent 
  #of the landscape
  coordinates<-data.frame(x.coord,y.coord) 
  #the landscape of patch locations is given by the randomly chosen x and y 
  #coordinates paired together
  
  #CREATE MATRIX OF DISTANCES BETWEEN PATCHES
  d<-dist(coordinates[,1:2], method="euclidean", diag=TRUE, upper=TRUE)
  #calculate distances between patches based on euclidean distances. 
  #obvs dii=0 and dij=dji, which is indicated by diag=TRUE and upper=TRUE
  d<-as.matrix(d) #set d as a matrix
  
  #LOOP TO PREVENT PATCH OVERLAP
  for (i in 1:n.patches){ #for every patch
    for (j in 1:n.patches){ #and every other patch
      while (j!=i & d[i,j] < (radii[i]+radii[j])) { 
        #while the distance between the 2 patches is less than the sum of their radii
        x.coord[i]<-runif(1, min=0, max=landscape.limit) 
        #pick a new x coordinate for that patch
        y.coord[i]<-runif(1, min=0, max=landscape.limit) 
        #pick a new y coordinate for that patch
        coordinates[i,]<-c(x.coord[i], y.coord[i]) #update the coordinates 
        d<-dist(coordinates[,1:2], method="euclidean", diag=TRUE, upper=TRUE) 
        #update the distances
        d<-as.matrix(d) #set d as a matrix
      }}}
  
  if (landscape.type != "random"){ 
    #If we want a non-random landscape (clustered or regular)...
    for (i in 1:no.runs){
      
      #STEP 1: PICK A RANDOM PATCH UP FROM THE LANDSCAPE
      r<-sample(1:n.patches,1, replace=T) #pick a random number between 1 and n.patches
      r.coordinates<-coordinates[-r,] 
      #remove that patch from the landscape (pick it up to be potentially relocated)
      
      #STEP 2: CALCULATE THE DISTANCE AND CONNECTIVITY OF THE PATCH CHOSEN TO OTHER PATCHES
      d.r.to.j<-rep(NA, (n.patches-1))
      connectivity.r.to.j<-rep(NA, (n.patches-1))
      for (j in 1:(n.patches-1)) { #for every patch in the network calculate...
        d.r.to.j[j] <- sqrt((x.coord[r]-r.coordinates[j,1])^2+(y.coord[r]-r.coordinates[j,2])^2) 
        #the distance between point x and all patches
        connectivity.r.to.j[j]<-exp(-d.r.to.j[j])} 
      #the connectivity of point x and all others
      connectivity.r<-sum(connectivity.r.to.j) 
      #the connectivity of point x is the sum of it's connectivity to all patches
      
      #STEP 3: PICK A RANDOM POINT
      p.x.coord<-runif(1, min=0, max=landscape.limit) 
      #pick a random x coordinate for the point between 0 and the landscape extent
      p.y.coord<-runif(1, min=0, max=landscape.limit) 
      #pick a random y coordinate for the point between 0 and the landscape extent
      
      #STEP 4: CALCULATE THE DISTANCE AND CONNECTIVITY OF THE NEW POINT TO OTHER PATCHES
      d.x.to.j<-rep(NA, (n.patches-1))
      connectivity.x.to.j<-rep(NA, (n.patches-1))
      for (j in 1:(n.patches-1)) { #for every patch in the network calculate...
        d.x.to.j[j] <- sqrt((p.x.coord-r.coordinates[j,1])^2+(p.y.coord-r.coordinates[j,2])^2) 
        #the distance between point x and all patches
        connectivity.x.to.j[j]<-exp(-d.x.to.j[j])} 
      #the connectivity of point x and all others
      connectivity.x<-sum(connectivity.x.to.j) 
      #the connectivity of point x is the sum of it's connectivity to all patches
      
      #STEP 5: LOOP TO ENSURE NEW POINT WILL NOT RESULT IN PATCH OVERLAP
      for (g in 1:(n.patches-1)) { #for each patch
        while (g!=r & d.x.to.j[g]<(radii[r]+radii[g])){ 
          #while any patch other than the chosen patch r has a distance between it's 
          #radius and r's radius greater than the distance between that patches center 
          #and the proposed new location for r
          p.x.coord<-runif(1, min=0, max=landscape.limit) 
          #pick a new x coordinate for the new point
          p.y.coord<-runif(1, min=0, max=landscape.limit) 
          #pick a new y coordinate for the new point
          d.x.to.j<-rep(NA, (n.patches-1))
          for (j in 1:(n.patches-1)){ 
            #for every patch in the network update calculations for...
            d.x.to.j[j]<-sqrt((p.x.coord-r.coordinates[j,1])^2+(p.y.coord-r.coordinates[j,2])^2) 
            #the distance between point x and all patches
            connectivity.x.to.j[j]<-exp(-d.x.to.j[j])} 
          #the connectivity of point x and all others
          connectivity.x<-sum(connectivity.x.to.j) 
          #the connectivity of point x is the sum of it's connectivity to all patches
        }}
      
      #STEP 6: COMPARE THE CONNECTIVITY OF THE PATCH AT ITS ORIGINAL LOCATION TO ITS 
      #NEW LOCATION
      #to generate clustered landscape: increase the pr(r relocated) 
      #if connectivity.x > connectivity.r
      if (landscape.type == "clustered"){ #if we wish to create a clustered landscape...
        if (connectivity.x > connectivity.r){ 
          #if the new location has a higher connectivity...
          x.coord[r]<-p.x.coord #set the x coordinate of the patch to be the new location's
          y.coord[r]<-p.y.coord #set the y coordinate of the patch to be the new location's
          coordinates[r,]<-c(x.coord[r],y.coord[r]) 
          #enter the patch's new coordinates into the landscape
        }}
      #to generate regular landscape: decrease the pr(r relocated) 
      #if connectivity.x > connectivity.r
      if (landscape.type == "regular") { #if we wish to create a regular landscape...
        if(connectivity.x < connectivity.r) { 
          #if the new location has a lower connectivity...
          x.coord[r]<-p.x.coord #set the x coordinate of the patch to be the new location's
          y.coord[r]<-p.y.coord #set the y coordinate of the patch to be the new location's
          coordinates[r,]<-c(x.coord[r],y.coord[r]) 
          #enter the patch's new coordinates into the landscape
        }}
    }
  }
  
  #STEP 7: UPDATE MATRIX OF DISTANCES BETWEEN PATCHES
  d<-dist(coordinates[,1:2], method="euclidean", diag=TRUE, upper=TRUE)
  #calculate distances between patches based on euclidean distances. 
  #obvs dii=0 and dij=dji, which is indicated by diag=TRUE and upper=TRUE
  d<-as.matrix(d) #set d as a matrix
  
  landscape<-data.frame(patch.ID, A, coordinates, d)
  return(landscape)}
#END OF CREATE LANDSCAPE FUNCTION
###############################################################################################################