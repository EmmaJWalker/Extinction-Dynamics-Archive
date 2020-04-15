#Calculating data for plots (binning destruction and calculating median lambda.M for percent loss
#, using median because it reflects that the data distribution is heavily skewed,
#, confidence intervals claculated using bootstrapping)
##############################################################################################################
plotdata.median.Lm<-function(input.data, scaled.lm){
  input.data<-input.data
  input.data$binned.percent.loss <- cut(input.data$percent.habitatloss, c(-Inf,seq(0, 1, 0.05)), labels=seq(0,1,0.05))
  percent.loss<-levels(droplevels(input.data$binned.percent.loss))
  bins<-percent.loss
  destruction.median<-rep(NA, length(bins))
  destruction.upper.CI<-rep(NA, length(bins))
  destruction.lower.CI<-rep(NA, length(bins))
  degradation.lambda.M<-rep(NA, length(bins))
  for (i in 1:length(bins)) {
    x<-subset(input.data, input.data$binned.percent.loss==bins[i])
    destruction.median[i] <- median(x$lambda.M.r)/scaled.lm
    bootobject <- boot(x$lambda.M.r, function(u,j) median(u[j]), R=1000)
    CI<-boot.ci(bootobject, conf=0.95, type="basic")
    if(is.null(CI)==TRUE){destruction.upper.CI[i]<-destruction.median[i]
    destruction.lower.CI[i]<-destruction.median[i]}
    else{
      destruction.upper.CI[i]<-CI$basic[5]/scaled.lm
      destruction.lower.CI[i]<-CI$basic[4]/scaled.lm}
    degradation.lambda.M[i]<-((1-((i-1)*0.05))^2)
    if(destruction.upper.CI[i]>1){destruction.upper.CI[i]<-1}
    if(destruction.lower.CI[i]>1){destruction.lower.CI[i]<-1}
    if(destruction.upper.CI[i]<0){destruction.upper.CI[i]<-0}
    if(destruction.lower.CI[i]<0){destruction.lower.CI[i]<-0}
  }
  plot.data<-data.frame(percent.loss=seq(0,1,0.05), destruction.median, destruction.upper.CI, destruction.lower.CI, degradation.lambda.M)
  return(plot.data)
}
##############################################################################################################a=c(0.067, 0.105, 0.429, 0.571, 0.96, 100)
#CHECK