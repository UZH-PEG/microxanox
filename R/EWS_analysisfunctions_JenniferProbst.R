#---
# title: "Analysis functions"
# author: "Jennifer Probst"
# date: "2019 M08 21"
# output: html_document
# Functions used for the analysis of EWS
# ---


#adjust the paths where the graphs should be saved!! (lines 274, 465, 507, 664 and 681)



#imports needed 
require(moments)
require(nonlinearTseries)
require(earlywarnings)

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

#------------------------------------------------------------------------------------#

#Metric based indicators from the earlywarnings package:
#   https://cran.r-project.org/web/packages/earlywarnings/earlywarnings.pdf
# Standart metric diagnostics: autoregressive coefficient, return rate, density ratio, standart deviation, skewness, kurtosis

earlywarnings_plot <- function(dataframe, name, x) {
  
  #input: dataframe with observed univariate time series of parameter to be analysed, name of dataset and moving window size in % of original data
  #output: plots of earlywarningsignals and summary statistics
  
  
  #functions from: https://github.com/earlywarningtoolbox/earlywarnings-R/blob/master/earlywarnings/R/generic_ews.R
  generic_ews <- function(timeseries, winsize, detrending = c("no", "gaussian", 
                          "loess", "linear", "first-diff"), bandwidth = NULL, span = NULL, degree = NULL, 
                          logtransform = FALSE, interpolate = FALSE, AR_n = FALSE, powerspectrum = FALSE) {
    
    timeseries <- as.matrix(timeseries)  #strict data-types the input data as tseries object for use in later steps
    if (dim(timeseries)[2] == 1) {
      Y = timeseries
      timeindex = 1:dim(timeseries)[1]
    } else if (dim(timeseries)[2] == 2) {
      Y <- timeseries[, 2]
      timeindex <- timeseries[, 1]
    } else {
      warning("not right format of timeseries input")
    }
    
    # Interpolation
    if (interpolate) {
      YY <- approx(timeindex, Y, n = length(Y), method = "linear")
      Y <- YY$y
    } else {
      Y <- Y
    }
    
    # Log-transformation
    if (logtransform) {
      Y <- log(Y + 1)
    }
    
    # Detrending
    detrending <- match.arg(detrending)
    if (detrending == "gaussian") {
      if (is.null(bandwidth)) {
        bw <- round(bw.nrd0(timeindex))
      } else {
        bw <- round(length(Y) * bandwidth/100)
      }
      print(bw)
      smYY <- ksmooth(timeindex, Y, kernel = "normal", bandwidth = bw, range.x = range(timeindex), 
                      x.points = timeindex)
      nsmY <- Y - smYY$y
      smY <- smYY$y
    } else if (detrending == "linear") {
      nsmY <- resid(lm(Y ~ timeindex))
      smY <- fitted(lm(Y ~ timeindex))
    } else if (detrending == "loess") {
      if (is.null(span)) {
        span <- 25/100
      } else {
        span <- span/100
      }
      if (is.null(degree)) {
        degree <- 2
      } else {
        degree <- degree
      }
      smYY <- loess(Y ~ timeindex, span = span, degree = degree, normalize = FALSE, 
                    family = "gaussian")
      smY <- predict(smYY, data.frame(x = timeindex), se = FALSE)
      nsmY <- Y - smY
    } else if (detrending == "first-diff") {
      nsmY <- diff(Y)
      timeindexdiff <- timeindex[1:(length(timeindex) - 1)]
    } else if (detrending == "no") {
      smY <- Y
      nsmY <- Y
    }
    
    
    # Rearrange data for indicator calculation
    mw <- round(length(Y) * winsize/100)
    omw <- length(nsmY) - mw + 1  ##number of moving windows
    low <- 2
    high <- mw
    nMR <- matrix(data = NA, nrow = mw, ncol = omw)
    x1 <- 1:mw
    for (i in 1:omw) {
      Ytw <- nsmY[i:(i + mw - 1)]
      nMR[, i] <- Ytw
    }
    
    # Calculate indicators
    nARR <- numeric()
    nSD <- numeric()
    nSK <- numeric()
    nKURT <- numeric()
    nACF <- numeric()
    nDENSITYRATIO <- numeric()
    nSPECT <- matrix(0, nrow = mw, ncol = ncol(nMR))
    nCV <- numeric()
    smARall <- numeric()
    smARmaxeig <- numeric()
    detB <- numeric()
    ARn <- numeric()
    
    nSD <- apply(nMR, 2, sd, na.rm = TRUE)
    for (i in 1:ncol(nMR)) {
      nYR <- ar.ols(nMR[, i], aic = FALSE, order.max = 1, demean = TRUE, intercept = FALSE)
      nARR[i] <- nYR$ar
      nSK[i] <- abs(moments::skewness(nMR[, i], na.rm = TRUE))
      nKURT[i] <- moments::kurtosis(nMR[, i], na.rm = TRUE)
      nCV[i] <- nSD[i]/mean(nMR[, i])
      ACF <- acf(nMR[, i], lag.max = 1, type = c("correlation"), plot = FALSE)
      nACF[i] <- ACF$acf[2]
      spectfft <- spec.ar(nMR[, i], n.freq = mw, plot = FALSE, order = 1)
      nSPECT[, i] <- spectfft$spec
      nDENSITYRATIO[i] <- spectfft$spec[low]/spectfft$spec[high]
      
      if (AR_n) {
        ## RESILIENCE IVES 2003 Indicators based on AR(n)
        ARall <- ar.ols(nMR[, i], aic = TRUE, order.max = 6, demean = F, intercept = F)
        smARall[i] <- ARall$ar[1]
        ARn[i] <- ARall$order
        roots <- Mod(polyroot(c(rev(-ARall$ar), 1)))
        smARmaxeig[i] <- max(roots)
        detB[i] <- (prod(roots))^(2/ARn[i])
      }
    }
    nRETURNRATE = 1/nARR
    
    # Estimate Kendall trend statistic for indicators
    timevec <- seq(1, length(nARR))
    KtAR <- cor.test(timevec, nARR, alternative = c("two.sided"), method = c("kendall"), 
                     conf.level = 0.95)
    KtACF <- cor.test(timevec, nACF, alternative = c("two.sided"), method = c("kendall"), 
                      conf.level = 0.95)
    KtSD <- cor.test(timevec, nSD, alternative = c("two.sided"), method = c("kendall"), 
                     conf.level = 0.95)
    KtSK <- cor.test(timevec, nSK, alternative = c("two.sided"), method = c("kendall"), 
                     conf.level = 0.95)
    KtKU <- cor.test(timevec, nKURT, alternative = c("two.sided"), method = c("kendall"), 
                     conf.level = 0.95)
    KtDENSITYRATIO <- cor.test(timevec, nDENSITYRATIO, alternative = c("two.sided"), 
                               method = c("kendall"), conf.level = 0.95)
    KtRETURNRATE <- cor.test(timevec, nRETURNRATE, alternative = c("two.sided"), 
                             method = c("kendall"), conf.level = 0.95)
    KtCV <- cor.test(timevec, nCV, alternative = c("two.sided"), method = c("kendall"), 
                     conf.level = 0.95)
    
    # Plotting Generic Early-Warnings
    mypath <- file.path("C:","Users","probs","Desktop", "Sem 6", "Internship", paste(c(name, '_', colnames(dataframe),'_genericews.pdf'), collapse = ''))
    pdf(file=mypath)
    
    par(mar = (c(0, 2, 0, 1) + 0), oma = c(7, 2, 3, 1), mfrow = c(5, 2))
    plot(timeindex, Y, type = "l", ylab = "", xlab = "", xaxt = "n", las = 1, xlim = c(timeindex[1], 
                                                                                       timeindex[length(timeindex)]))
    if (detrending == "gaussian") {
      lines(timeindex, smY, type = "l", ylab = "", xlab = "", xaxt = "n", col = 2, 
            las = 1, xlim = c(timeindex[1], timeindex[length(timeindex)]))
      lines(c(0,mw), c(0.5*(max(smY)),0.5*(max(smY))))
      lines(c(mw,mw), c(0.5*(max(smY))+0.1*(max(smY)),0.5*(max(smY))-0.1*(max(smY))))
      lines(c(0,0), c(0.5*(max(smY))+0.1*(max(smY)),0.5*(max(smY))-0.1*(max(smY))))
      abline(v=mw, lty=3)
      text(0.5*mw, 0.5*(max(smY))-0.1*(max(smY)), "rolling window")
    }
    if (detrending == "loess") {
      lines(timeindex, smY, type = "l", ylab = "", xlab = "", xaxt = "n", col = 2, 
            las = 1, xlim = c(timeindex[1], timeindex[length(timeindex)]))
    }
    if (detrending == "no") {
      plot(c(0, 1), c(0, 1), ylab = "", xlab = "", yaxt = "n", xaxt = "n", type = "n", 
           las = 1)
      lines(c(0,mw), c(0.5*(max(smY)),0.5*(max(smY))))
      abline(v=mw, lty=3)
      text(0.5, 0.5, "no residuals - no detrending")
    } else if (detrending == "first-diff") {
      limit <- max(c(max(abs(nsmY))))
      plot(timeindexdiff, nsmY, ylab = "", xlab = "", type = "l", xaxt = "n", las = 1, 
           ylim = c(-limit, limit), xlim = c(timeindexdiff[1], timeindexdiff[length(timeindexdiff)]))
      legend("topleft", "first-differenced", bty = "n")
    } else {
      limit <- max(c(max(abs(nsmY))))
      plot(timeindex, nsmY, ylab = "", xlab = "", type = "h", xaxt = "n", las = 1, 
           ylim = c(-limit, limit), xlim = c(timeindex[1], timeindex[length(timeindex)]))
      legend("topleft", "residuals", bty = "n")
    }
    plot(timeindex[mw:length(nsmY)], nARR, ylab = "", xlab = "", type = "l", xaxt = "n", 
         las = 1, xlim = c(timeindex[1], timeindex[length(timeindex)]))  #3
    abline(v=mw, lty=3)
    legend("bottomleft", paste("Kendall tau=", round(KtAR$estimate, digits = 3)), 
           bty = "n")
    legend("topleft", "ar(1)", bty = "n")
    plot(timeindex[mw:length(nsmY)], nACF, ylab = "", xlab = "", type = "l", xaxt = "n", 
         las = 1, xlim = c(timeindex[1], timeindex[length(timeindex)]))  #4
    abline(v=mw, lty=3)
    legend("bottomleft", paste("Kendall tau=", round(KtACF$estimate, digits = 3)), 
           bty = "n")
    legend("topleft", "acf(1)", bty = "n")
    plot(timeindex[mw:length(nsmY)], nRETURNRATE, ylab = "", xlab = "", type = "l", 
         xaxt = "n", las = 1, xlim = c(timeindex[1], timeindex[length(timeindex)]))
    abline(v=mw, lty=3)
    legend("bottomleft", paste("Kendall tau=", round(KtRETURNRATE$estimate, digits = 3)), 
           bty = "n")
    legend("topleft", "return rate", bty = "n")
    plot(timeindex[mw:length(nsmY)], nDENSITYRATIO, ylab = "", xlab = "", type = "l", 
         xaxt = "n", las = 1, xlim = c(timeindex[1], timeindex[length(timeindex)]))
    abline(v=mw, lty=3)
    legend("bottomleft", paste("Kendall tau=", round(KtDENSITYRATIO$estimate, digits = 3)), 
           bty = "n")
    legend("topleft", "density ratio", bty = "n")
    plot(timeindex[mw:length(nsmY)], nSD, ylab = "", xlab = "", type = "l", xaxt = "n", 
         las = 1, xlim = c(timeindex[1], timeindex[length(timeindex)]))
    abline(v=mw, lty=3)
    legend("bottomleft", paste("Kendall tau=", round(KtSD$estimate, digits = 3)), 
           bty = "n")
    legend("topleft", "standard deviation", bty = "n")
    if (detrending == "no") {
      plot(timeindex[mw:length(nsmY)], nCV, ylab = "", xlab = "", type = "l", xaxt = "n", 
           las = 1, xlim = c(timeindex[1], timeindex[length(timeindex)]))
      abline(v=mw, lty=3)
      legend("bottomleft", paste("Kendall tau=", round(KtCV$estimate, digits = 3)), 
             bty = "n")
      legend("topleft", "coefficient of variation", bty = "n")
    } else {
      plot(0, 0, ylab = "", xlab = "", type = "n", xaxt = "n", yaxt = "n", xlim = c(0, 
                                                                                    1), ylim = c(0, 1))
      text(0.5, 0.5, "no coeff var estimated - data detrended")
    }
    plot(timeindex[mw:length(nsmY)], nSK, type = "l", ylab = "", xlab = "", las = 1, 
         cex.lab = 1, xlim = c(timeindex[1], timeindex[length(timeindex)]))
    abline(v=mw, lty=3)
    legend("topleft", "skewness", bty = "n")
    legend("bottomleft", paste("Kendall tau=", round(KtSK$estimate, digits = 3)), 
           bty = "n")
    mtext("time", side = 1, line = 2, cex = 0.8)
    plot(timeindex[mw:length(nsmY)], nKURT, type = "l", ylab = "", xlab = "", las = 1, 
         cex.lab = 1, xlim = c(timeindex[1], timeindex[length(timeindex)]))
    abline(v=mw, lty=3)
    legend("topleft", "kurtosis", bty = "n")
    legend("bottomleft", paste("Kendall tau=", round(KtKU$estimate, digits = 3)), 
           bty = "n")
    mtext("time", side = 1, line = 2, cex = 0.8)
    mtext(paste(c('Generic Early-Warnings of ', colnames(dataframe), ' in ', name),collapse = ''), side = 3, line = 0.2, outer = TRUE)
    dev.off()
  }
  generic_ews(dataframe,winsize=x,detrending='gaussian') 
}

#------------------------------------------------------------------------------------#

# Conditional Heteroskedasticity 
condhet_analysis <- function(dataframe, name, interpolate=FALSE) {
  
  #input: dataframe with observed univariate time series, name of timeseries and 'TRUE' if data needs to be interpolated
  #output: plot of conditional heteroskedasticity over time
  
  #functions from https://github.com/earlywarningtoolbox/earlywarnings-R/blob/master/earlywarnings/R/ch_ews.R
  ch_ews <- function(timeseries, winsize = 10, alpha = 0.1, optim = TRUE, lags = 4, 
                     logtransform = FALSE, interpolate = FALSE) {
    
    timeseries <- ts(timeseries)  #strict data-types the input data as tseries object for use in later steps
    if (dim(timeseries)[2] == 1) {
      ts.in = timeseries
      timeindex = 1:dim(timeseries)[1]
    } else if (dim(timeseries)[2] == 2) {
      ts.in = timeseries[, 2]
      timeindex = timeseries[, 1]
    } else {
      warning("not right format of timeseries input")
    }
    
    # Interpolation
    if (interpolate) {
      YY <- approx(timeindex, ts.in, n = length(ts.in), method = "linear")
      ts.in <- YY$y
    }
    
    # Log-transformation
    if (logtransform) {
      ts.in <- log(ts.in + 1)
    }
    
    winSize = round(winsize * length(ts.in)/100)
    sto <- matrix(nrow = (length(ts.in) - (winSize - 1)), ncol = 5)  # creates a matrix to store output
    
    count <- 1  #place holder for writing to the matrix
    for (i2 in winSize:length(ts.in)) {
      # loop to iterate through the model values by window lengths of the input value
      
      # the next line applys the autoregressive model optimized using AIC then we omit
      # the first data point(s) which come back as NA and square the residuals
      if (optim == TRUE) {
        arm <- ar(ts.in[(i2 - (winSize - 1)):i2], method = "ols")
      } else {
        arm <- ar(ts.in[(i2 - (winSize - 1)):i2], aic = FALSE, order.max = lags, 
                  method = "ols")
      }
      resid1 <- na.omit(arm$resid)^2
      
      l1 <- length(resid1)  # stores the number of residuals for many uses later
      lm1 <- lm(resid1[2:l1] ~ resid1[1:(l1 - 1)])  #calculates simple OLS model of describing t+1 by t
      
      # calculates the critical value: Chi-squared critical value using desired alpha
      # level and 1 degree of freedom / number of residuals used in regression
      critical <- qchisq((1 - alpha), df = 1)/(length(resid1) - 1)
      
      sto[count, 1] <- timeindex[i2]  # stores a time component
      sto[count, 2] <- summary(lm1)$r.squared  # stores the r.squared for this window
      sto[count, 3] <- critical  # stores the critical value
      
      # the next flow control group stores a simple 1 for significant test or 0 for
      # non-significant test
      if (summary(lm1)$r.squared > critical) {
        sto[count, 4] <- 1
      } else {
        sto[count, 4] <- 0
      }
      sto[count, 5] <- arm$order
      count <- count + 1  # increment the place holder
    }
    
    sto <- data.frame(sto)  # data types the matrix as a data frame
    colnames(sto) <- c("time", "r.squared", "critical.value", "test.result", "ar.fit.order")  # applies column names to the data frame
    
    # This next series of flow control statements will adjust the max and minimum
    # values to yield prettier plots In some circumstances it is possible for all
    # values to be far greater or far less than the critical value; in all cases we
    # want the critical line ploted on the figure
    if (max(sto$r.squared) < critical) {
      maxY <- critical + 0.02
      minY <- critical - 0.02
    } else if (min(sto$r.squared >= critical)) {
      minY <- critical - 0.02
      maxY <- critical + 0.02
    } else {
      maxY <- max(sto$r.squared)
      minY <- min(sto$r.squared)
    }
    
    # this creates a very simple plot that is well fitted to the data. it also plots the critical value line
    
    mypath <- file.path("C:","Users","probs","Desktop", "Sem 6", "Internship", paste(c(name, '_', colnames(dataframe),'_condhet.png'), collapse = ''))
    png(file=mypath)
    par(mar = (c(0, 4, 0, 1) + 0), oma = c(5, 1, 2, 1), mfrow = c(2, 1))
    plot(timeindex, ts.in, type = "l", ylab = "data", xlab = "", cex.axis = 0.8, 
         cex.lab = 0.8, xaxt = "n", las = 1, xlim = c(timeindex[1], timeindex[length(timeindex)]))
    plot(timeindex[winSize:length(timeindex)], sto$r.squared, ylab = expression(paste("R^2")), 
         xlab = "time", type = "b", cex = 0.5, cex.lab = 0.8, cex.axis = 0.8, las = 1, 
         ylim = c(min(sto$r.squared), max(sto$r.squared)), xlim = c(timeindex[1], 
                                                                    timeindex[length(timeindex)]))
    lines(c(0,winSize), c(0.5*(max(sto$r.squared)),0.5*(max(sto$r.squared))))
    lines(c(winSize,winSize), c(0.5*(max(sto$r.squared))+0.1*(max(sto$r.squared)),0.5*(max(sto$r.squared))-0.1*(max(sto$r.squared))))
    lines(c(0,0), c(0.5*(max(sto$r.squared))+0.1*(max(sto$r.squared)),0.5*(max(sto$r.squared))-0.1*(max(sto$r.squared))))
    text(winSize, 0.5*(max(sto$r.squared))-0.2*(max(sto$r.squared)), "rolling window", size=6)
    legend("topleft", "conditional heteroskedasticity", bty = "n")
    abline(h = sto$critical, lwd = 0.5, lty = 2, col = 2)
    mtext("time", side = 1, line = 2, cex = 0.8)  
    mtext(paste(c('Conditional Heteroskedasticity of ', colnames(dataframe), ' in ', name),collapse = ''), side = 3, line = 0.1, outer = TRUE)
    dev.off()
    
    return(sto)
  } 
  
  ch_ews(dataframe, winsize = 10, alpha = 0.1, optim = TRUE, lags = 4)
}

#------------------------------------------------------------------------------------#

# Detrending fluctuation analysis
# https://www.rdocumentation.org/packages/nonlinearTseries/versions/0.2.3/topics/dfa

dfa_analysis <- function(switch, var_col, n, t, name) {
  
  #input: a dataframe with data of respective switch, windowsize n t=totallength-n-1 and the name of timeseries
  #output: plot of dfa over time
  
  dfa_vector <- numeric(t-11)
  for (i in 1:(t-11)) {
    x <- dfa(switch[i:n+i, var_col], window.size.range = c(10, 300), npoints = 100, do.plot = FALSE)
    dfa_vector[i] <- estimate(x, regression.range = NULL, do.plot = FALSE, fit.col = 2, fit.lty = 1, fit.lwd =1)[1]
  } 
  
  #plot
  mypath <- file.path("C:","Users","probs","Desktop", "Sem 6", "Internship", paste(c(name, colnames(switch)[var_col], '_dfa.png'), collapse = ''))
  png(file=mypath)
  plot(dfa_vector[0:(t-100)]~tottime[n:(length(switch[,var_col])-100)], xlab='timestep', ylab='DFA', main=paste(c('Detrended fluctuation analysis of ',colnames(switch)[var_col], ' of ', name), collapse = ''), type='l')
  dev.off()
}

#------------------------------------------------------------------------------------#

# Model based indicators: 
#   Drift Diffusion Jump Nonparametrics Early Warning Signals

ddj_model <- function(dataframe) {
  
  #input: dataframe with observed univariate time series
  #output: data object with various elements, see: ddjnonparam_ews function:  https://cran.r-project.org/web/packages/earlywarnings/earlywarnings.pdf

  #modified functions from the ddjnonparam_ews function:  https://github.com/earlywarningtoolbox/earlywarnings-R/blob/master/earlywarnings/R/ddjnonparam_ews.R
  # Function to compute Bandi, Johannes etc estimators for time series x
  Bandi5 <- function(x0, dx, nx, DT, bw, na, avec) {
    
    # Set up constants and useful preliminaries
    SF <- 1/(bw * sqrt(2 * pi))  # scale factor for kernel calculation
    x02 <- x0 * x0  # second power of x
    dx2 <- dx * dx  # second power of dx
    dx4 <- dx2 * dx2  # fourth power of dx
    dx6 <- dx2 * dx4  # sixth power of dx
    # Compute matrix of kernel values
    Kmat <- matrix(0, nrow = na, ncol = nx)
    for (i in 1:(nx)) {
      # loop over columns (x0 values)
      Kmat[, i] <- SF * exp(-0.5 * (x0[i] - avec) * (x0[i] - avec)/(bw * bw))
    }
    # Compute M1, M2, M4, moment ratio and components of variance for each value of a
    M1.a <- rep(0, na)
    M2.a <- rep(0, na)
    M4.a <- rep(0, na)
    M6M4r <- rep(0, na)  # vector to hold column kernel-weighted moment ratio
    mean.a <- rep(0, na)  # centering of conditional variance
    SS.a <- rep(0, na)  # sum of squares
    for (i in 1:na) {
      # loop over rows (a values)
      Ksum <- sum(Kmat[i, ])  # sum of weights
      M1.a[i] <- (1/DT) * sum(Kmat[i, ] * dx)/Ksum
      M2.a[i] <- (1/DT) * sum(Kmat[i, ] * dx2)/Ksum
      M4.a[i] <- (1/DT) * sum(Kmat[i, ] * dx4)/Ksum
      M6.c <- (1/DT) * sum(Kmat[i, ] * dx6)/Ksum
      M6M4r[i] <- M6.c/M4.a[i]
      mean.a[i] <- sum(Kmat[i, ] * x0[2:(nx + 1)])/Ksum
      SS.a[i] <- sum(Kmat[i, ] * x02[2:(nx + 1)])/Ksum
    }
    # Compute conditional variance
    S2.x <- SS.a - (mean.a * mean.a)  # sum of squares minus squared mean
    # Compute jump frequency, diffusion and drift
    sigma2.Z <- mean(M6M4r)/(5)  # average the column moment ratios
    lamda.Z <- M4.a/(3 * sigma2.Z * sigma2.Z)
    sigma2.dx <- M2.a - (lamda.Z * sigma2.Z)
    # set negative diffusion estimates to zero
    diff.a <- ifelse(sigma2.dx > 0, sigma2.dx, 0)
    sigma2.dx <- M2.a  # total variance of dx
    mu.a <- M1.a
    outlist <- list(mu.a, sigma2.dx, diff.a, sigma2.Z, lamda.Z, S2.x)

    return(outlist)
  }  
  
  # MAIN FUNCTION
  ddjnonparam_ews <- function(timeseries, bandwidth = 0.6, na = 500) {
    timeseries <- ts(timeseries)  #strict data-types the input data as tseries object for use in later steps
    if (dim(timeseries)[2] == 1) {
      Y = timeseries
      timeindex = 1:dim(timeseries)[1]
    } else if (dim(timeseries)[2] == 2) {
      Y <- timeseries[, 2]
      timeindex <- timeseries[, 1]
    } else {
      warning("not right format of timeseries input")
    }
    
    # Preliminaries
    Xvec1 <- Y
    Tvec1 <- timeindex
    dXvec1 <- diff(Y)
    
    DT <- Tvec1[2] - Tvec1[1]
    bw <- bandwidth * sd(as.vector(Xvec1))  # bandwidth 
    alow <- min(Xvec1)
    ahigh <- max(Xvec1)
    na <- na
    avec <- seq(alow, ahigh, length.out = na)
    nx <- length(dXvec1)
    
    # Bandi-type estimates
    ParEst <- Bandi5(Xvec1, dXvec1, nx, DT, bw, na, avec)
    Drift.vec <- ParEst[[1]]
    TotVar.dx.vec <- ParEst[[2]]
    Diff2.vec <- ParEst[[3]]
    Sigma2Z <- ParEst[[4]]
    LamdaZ.vec <- ParEst[[5]]
    S2.vec <- ParEst[[6]]
    
    # Interpolate time courses of indicators
    TotVar.i <- approx(x = avec, y = TotVar.dx.vec, xout = Xvec1)
    TotVar.t <- TotVar.i$y
    Diff2.i <- approx(x = avec, y = Diff2.vec, xout = Xvec1)
    Diff2.t <- Diff2.i$y
    Lamda.i <- approx(x = avec, y = LamdaZ.vec, xout = Xvec1)
    Lamda.t <- Lamda.i$y
    S2.i <- approx(x = avec, y = S2.vec, xout = Xvec1)
    S2.t <- S2.i$y
    
    # Plot the data
    dev.new()
    par(mfrow = c(2, 1), mar = c(3, 3, 2, 2), mgp = c(1.5, 0.5, 0), oma = c(1, 1, 
                                                                            1, 1))
    plot(Tvec1, Xvec1, type = "l", col = "black", lwd = 2, xlab = "", ylab = "original data")
    grid()
    plot(Tvec1[1:length(Tvec1) - 1], dXvec1, type = "l", col = "black", lwd = 2, 
         xlab = "time", ylab = "first-diff data")
    grid()
    
    # Plot indicators versus a
    dev.new()
    par(mfrow = c(2, 2), mar = c(3, 3, 2, 2), cex.axis = 1, cex.lab = 1, mgp = c(2, 
                                                                                 1, 0), oma = c(1, 1, 2, 1))
    plot(avec, S2.vec, type = "l", lwd = 1, col = "black", xlab = "a", ylab = "conditional variance")
    plot(avec, TotVar.dx.vec, type = "l", lwd = 1, col = "blue", xlab = "a", ylab = "total variance of dx")
    plot(avec, Diff2.vec, type = "l", lwd = 1, col = "green", xlab = "a", ylab = "diffusion")
    plot(avec, LamdaZ.vec, type = "l", lwd = 1, col = "red", xlab = "a", ylab = "jump intensity")
    mtext("DDJ nonparametrics versus a", side = 3, line = 0.1, outer = TRUE)
    
    # Plot indicators versus time
    dev.new()
    par(mfrow = c(2, 2), mar = c(3, 3, 2, 2), cex.axis = 1, cex.lab = 1, mgp = c(1.5, 
                                                                                 0.5, 0), oma = c(1, 1, 2, 1))
    plot(Tvec1, S2.t, type = "l", lwd = 1, col = "black", xlab = "time", ylab = "conditional variance")
    plot(Tvec1, TotVar.t, type = "l", lwd = 1, col = "blue", xlab = "time", ylab = "total variance of dx")
    plot(Tvec1, Diff2.t, type = "l", lwd = 1, col = "green", xlab = "time", ylab = "diffusion")
    plot(Tvec1, Lamda.t, type = "l", lwd = 1, col = "red", xlab = "time", ylab = "jump intensity")
    mtext("DDJ nonparametrics versus time", side = 3, line = 0.1, outer = TRUE)
    
    # Output
    nonpar_x <- data.frame(avec, S2.vec, TotVar.dx.vec, Diff2.vec, LamdaZ.vec)
    nonpar_t <- data.frame(Tvec1, S2.t, TotVar.t, Diff2.t, Lamda.t)
    return(c(nonpar_x, nonpar_t))
  } 
 
  return(ddjnonparam_ews(dataframe, bandwidth = 0.6, na = 500))
  graphics.off()
}


plot_ddj_1 <- function(dataframe, ddj, name) {
  
  #input: the dataframe, output from the ddj_model function and name
  #output: First plot shows the nonparametric conditional variance, total variance, diffusion and jump intensity over time
  
  # nonparametric statistics over time
  mypath <- file.path("C:","Users","probs","Desktop", "Sem 6", "Internship", paste(c(name, '_', colnames(dataframe),'_ddj1.png'), collapse = ''))
  png(file=mypath)
  par(mfrow = c(2, 2), mar = c(3, 3, 2, 2), cex.axis = 1, cex.lab = 1, mgp = c(1.5, 0.5, 0), oma = c(1, 1, 2, 1))
  plot(ddj$Tvec1, ddj$S2.t, type = "l", lwd = 1, col = "black", xlab = "time", ylab = "conditional variance")
  plot(ddj$Tvec1, ddj$TotVar.t, type = "l", lwd = 1, col = "blue", xlab = "time", ylab = "total variance of dx")
  plot(ddj$Tvec1, ddj$Diff2.t, type = "l", lwd = 1, col = "green", xlab = "time", ylab = "diffusion")
  plot(ddj$Tvec1, ddj$Lamda.t, type = "l", lwd = 1, col = "red", xlab = "time", ylab = "jump intensity")
  mtext(paste(c('DDJ nonparametrics of ', colnames(dataframe), ' in ', name,' versus time'),collapse = ''), side = 3, line = 0.1, outer = TRUE)
  dev.off()
}

plot_ddj_2 <- function(dataframe, ddj, name) {
  
  #input: the dataframe, output from the ddj_model function and name
  #output: a plot of the nonparametric statistics from plot_ddj_1 over the residuals after first-differencing
  
  # nonparametric statistics over the data
  mypath2 <- file.path("C:","Users","probs","Desktop", "Sem 6", "Internship", paste(c(name, '_', colnames(dataframe), '_ddj2.png'), collapse = ''))
  png(file=mypath2)
  par(mfrow = c(2, 2), mar = c(3, 3, 2, 2), cex.axis = 1, cex.lab = 1, mgp = c(2, 1, 0), oma = c(1, 1, 2, 1))
  plot(ddj$avec, ddj$S2.vec, type = "l", lwd = 1, col = "black", xlab = "data", ylab = "conditional variance")
  plot(ddj$avec, ddj$TotVar.dx.vec, type = "l", lwd = 1, col = "blue", xlab = "data", ylab = "total variance of dx")
  plot(ddj$avec, ddj$Diff2.vec, type = "l", lwd = 1, col = "green", xlab = "data", ylab = "diffusion")
  plot(ddj$avec, ddj$LamdaZ.vec, type = "l", lwd = 1, col = "red", xlab = "data", ylab = "jump intensity")
  mtext(paste(c('DDJ nonparametrics of ', colnames(dataframe), ' in ', name, ' versus the data after first differencing'),collapse = ''), side = 3, line = 0.1, outer = TRUE)
  dev.off()
}

#------------------------------------------------------------------------------------#
