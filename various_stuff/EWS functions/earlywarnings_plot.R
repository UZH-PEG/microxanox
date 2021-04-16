#---
# title: "Analysis functions"
# author: "Jennifer Probst"
# date: "2019 M08 21"
# output: html_document
# Functions used for the analysis of EWS
# ---
# adjust the paths where the graphs should be saved!! (lines 274, 465, 507, 664 and 681)


#------------------------------------------------------------------------------------#

#Metric based indicators from the earlywarnings package:
#   https://cran.r-project.org/web/packages/earlywarnings/earlywarnings.pdf
# Standart metric diagnostics: autoregressive coefficient, return rate, density ratio, standart deviation, skewness, kurtosis

#' To Add
#'
#' @param dataframe TODO
#' @param name TODO
#' @param x TODO
#'
#' @return TODO
#' 
#' @importFrom graphics abline legend lines mtext par text
#' @importFrom grDevices pdf dev.off
#' @importFrom stats acf approx ar.ols bw.nrd0 cor.test fitted ksmooth lm loess predict resid spec.ar
#' 
#' @export
#'
#' @examples
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
