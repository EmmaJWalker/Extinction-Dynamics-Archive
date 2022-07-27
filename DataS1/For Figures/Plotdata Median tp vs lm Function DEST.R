#Calculating data for plots (binning destruction and calculating median lamda.M for percent loss
#, using median because it reflects that the data distribution is heavily skewed,
#, confidence intervals claculated using bootstrapping)
##############################################################################################################
plotdata.median.tp.vs.lm.r<-function(input.data){
  input.data<-input.data
  input.data$lambda.M.r<-input.data$lambda.M.r/20
#input.data$binned.lambda.M.r <- cut(input.data$lambda.M.r, c(seq(0, 1, 0.5),Inf), labels=seq(0,1,0.1))
  input.data$lambda.M.r <- input.data$lambda.M.r*2 
  input.data$binned.lambda.M.r <- round(input.data$lambda.M.r, 1)/2 #to get intervals of 0.5
input.data$binned.lambda.M.r<-as.numeric(as.character(input.data$binned.lambda.M.r)) ############**************
  bins<-unique(input.data$binned.lambda.M.r) #################***************
  destruction.median<-rep(NA, length(bins))
  destruction.upper.CI<-rep(NA, length(bins))
  destruction.lower.CI<-rep(NA, length(bins))
  degradation.upper.CI<-rep(NA, length(bins))
  degradation.lower.CI<-rep(NA, length(bins))
  degradation.median<-rep(NA, length(bins))
  for (i in 1:length(bins)) {
    x<-subset(input.data, binned.lambda.M.r==bins[i])
    #destruction
    destruction.median[i] <- median(x$time.to.eq.r)
    bootobject <- boot(x$time.to.eq.r, function(u,j) median(u[j]), R=1000)
    CI<-boot.ci(bootobject, conf=0.95, type="basic")
    if(is.null(CI)==TRUE){destruction.upper.CI[i]<-destruction.median[i]
    destruction.lower.CI[i]<-destruction.median[i]
    }    else{
      destruction.upper.CI[i]<-CI$basic[5]
      destruction.lower.CI[i]<-CI$basic[4]
      }
    #degradation
    degradation.median[i] <- median(x$time.to.eq.e)
    bootobject <- boot(x$time.to.eq.e, function(u,j) median(u[j]), R=1000)
    CI<-boot.ci(bootobject, conf=0.95, type="basic")
  }
  plot.data<-data.frame(Lm=bins, destruction.median, 
                        destruction.upper.CI, destruction.lower.CI, 
                        degradation.median
                        ,degradation.upper.CI, degradation.lower.CI
                        )
  return(plot.data)}
##############################################################################################################a=c(0.067, 0.105, 0.429, 0.571, 0.96, 100)
#CHECK
