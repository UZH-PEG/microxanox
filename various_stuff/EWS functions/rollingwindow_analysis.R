#---
# title: "Analysis functions"
# author: "Jennifer Probst"
# date: "2019 M08 21"
# output: html_document
# Functions used for the analysis of EWS
# ---
# adjust the paths where the graphs should be saved!! (lines 274, 465, 507, 664 and 681)


#------------------------------------------------------------------------------------#

#Rolling window analysis for variance, skewness, kurtosis & autokorrelation from hand: 

rollingwindow_analysis <- function(switch, var_col, n, t, name) {
  
  #input: a dataframe with data of respective switch, column of dataframe that should be analysed, 
          #windowsize n, t=totallength-n-1 and the name of the timeseries
  #output: vectors with variance, skewness, kurtosis and autocorrelation calculated in rolling window sizes of     
          #50% of the dataframe; also plots of rolling window analysis
  
  sdvector <- numeric(t)
  skewnessvector <- numeric(t)
  kurtosisvector <- numeric(t)
  acfvector <- numeric(t) #estimate first value of acf
  acvector <- numeric(t) #fit autoregressive model of order 1 and take autoregressive coefficient (AR(1))
  
  for (i in 1:t) {
    sdvector[i] <- sd(switch[i:n+i, var_col])
    skewnessvector[i] <- abs(skewness(switch[i:n+i, var_col]))
    kurtosisvector[i] <- kurtosis(switch[i:n+i, var_col])
    if (i<t-2){
      acvector[i] <- ar.ols(switch[i:n+i, var_col], aic = FALSE, order.max = 1, demean = TRUE, intercept = FALSE)$ar
      acfvector[i] <- acf(switch[i:n+i, var_col], type=c('correlation'), plot = FALSE)$acf[2]
    }
  }
  
  #Kendall's Taus:
  time <- seq(1, length(sdvector), by=1)
  Kt_ac <- cor.test(time[1:length(time)], acvector, alternative = c("two.sided"), method = c("kendall"), conf.level = 0.95)$estimate
  Kt_acf <- cor.test(time[1:length(time)], acfvector, alternative = c("two.sided"), method = c("kendall"), conf.level = 0.95)$estimate
  Kt_sd <- cor.test(time, sdvector, alternative = c("two.sided"), method = c("kendall"),conf.level = 0.95)$estimate
  Kt_sk <- cor.test(time, skewnessvector, alternative = c("two.sided"), method = c("kendall"),conf.level = 0.95)$estimate
  Kt_ku <- cor.test(time, kurtosisvector, alternative = c("two.sided"), method = c("kendall"),conf.level = 0.95)$estimate
  
  
  #plotting functions:
  tottime <- seq(1, length(switch[,var_col]), by=1)
  
  a <- ggplot(switch, aes(x=tottime, y=switch[,var_col]))+ 
    ggtitle(paste(c('Original time series of ', colnames(switch)[var_col], ' of ', name),collapse = '')) + 
    xlab("timestep") + 
    ylab(paste(c('Original time series of ', colnames(switch)[var_col]),collapse = '')) + 
    geom_line()
  plot(a)
  ggsave(paste(c(name,'_', colnames(switch)[var_col], '_original.jpg'),collapse = ''))
  
  b <- ggplot() +
    geom_line(aes(x=tottime[n:length(switch[,var_col])], y=acvector))+
    # xlim(0, length(tottime))+
    ggtitle(paste(c('AR(1) of ', colnames(switch)[var_col], ' of ', name),collapse = ''))+
    xlab("timestep") +
    ylab("Autocorrelation at-lag-1 (AR(1))") +
    annotate("text", x = (tottime[length(switch[,var_col])/2]+500), y = max(acvector, na.rm=TRUE), label = sprintf("Kendall's Tau: =\"%0.4f\"\n", Kt_ac))
  plot(b)
  ggsave(paste(c(name,'_', colnames(switch)[var_col],'_ac.jpg'),collapse = ''))
  
  
  c <- ggplot() +
    geom_line(aes(x=tottime[n:length(switch[,var_col])], y=acfvector))+
    #xlim(0, length(tottime))+
    ggtitle(paste(c('Acf(1) of ', colnames(switch)[var_col], ' of ', name),collapse = ''))+
    xlab("timestep") +
    ylab("Autocorrelation function (Acf(1))") +
    annotate("text", x = (tottime[length(switch[,var_col])/2]+500), y = max(acfvector, na.rm=TRUE), label = sprintf("Kendall's Tau: =\"%0.4f\"\n", Kt_acf))  
  plot(c)
  ggsave(paste(c(name,'_', colnames(switch)[var_col],'_acf.jpg'),collapse = ''))
  
  d <- ggplot() +
    geom_line(aes(x=tottime[n:length(switch[,var_col])], y=sdvector))+
    #xlim(0, length(tottime))+
    ggtitle(paste(c('Standarddeviation of ', colnames(switch)[var_col], ' of ', name),collapse = ''))+
    xlab("timestep") +
    ylab("standard deviation") +
    annotate("text", x = (tottime[length(switch[,var_col])/2]+500), y = max(sdvector, na.rm=TRUE), label = sprintf("Kendall's Tau: =\"%0.4f\"\n", Kt_sd))  
  plot(d)
  ggsave(paste(c(name,'_', colnames(switch)[var_col],'_sd.jpg'),collapse = ''))
  
  e <- ggplot() +
    geom_line(aes(x=tottime[n:length(switch[,var_col])], y=skewnessvector))+
    #xlim(0, length(tottime))+
    ggtitle(paste(c('Skewness of ', colnames(switch)[var_col], ' of ', name),collapse = ''))+
    xlab("timestep") +
    ylab("skewness") +
    annotate("text", x = (tottime[length(switch[,var_col])/2]+500), y = max(skewnessvector, na.rm=TRUE), label = sprintf("Kendall's Tau: =\"%0.4f\"\n", Kt_ku))
  plot(e)
  ggsave(paste(c(name,'_', colnames(switch)[var_col],'_ske.jpg'),collapse = ''))
  
  f <- ggplot() +
    geom_line(aes(x=tottime[n:length(switch[,var_col])], y=kurtosisvector))+
    #xlim(0, length(tottime))+
    ggtitle(paste(c('Kurtosis of ', colnames(switch)[var_col], ' of ', name),collapse = ''))+
    xlab("timestep") +
    ylab("kurtosis") +
    annotate("text", x = (tottime[length(switch[,var_col])/2]+500), y = max(kurtosisvector, na.rm=TRUE), label = sprintf("Kendall's Tau: =\"%0.4f\"\n", Kt_ku))
  plot(f)
  ggsave(paste(c(name,'_', colnames(switch)[var_col],'_kurt.jpg'),collapse = ''))
  
  #these different values can be returned if wished:
  #return(list(sdvector, skewnessvector, kurtosisvector, acvector, acfvector, c(Kt_ac, Kt_acf, Kt_sd, Kt_sk, Kt_ku)))
  
}