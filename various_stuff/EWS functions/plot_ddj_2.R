#---
# title: "Analysis functions"
# author: "Jennifer Probst"
# date: "2019 M08 21"
# output: html_document
# Functions used for the analysis of EWS
# ---
# adjust the paths where the graphs should be saved!! (lines 274, 465, 507, 664 and 681)


#' To Add
#'
#' @param dataframe TODO
#' @param ddj TODO
#' @param name TODO
#'
#' @return TODO
#'  
#' @importFrom graphics lines mtext par
#' @importFrom grDevices png dev.off
#' 
#' @export
#'
#' @examples
plot_ddj_2 <- function(dataframe, ddj, name) {
  
  #input: the dataframe, output from the ddj_model function and name
  #output: a plot of the nonparametric statistics from plot_ddj_1 over the residuals after first-differencing
  
  # nonparametric statistics over the data
  mypath2 <- file.path("C:","Users","probs","Desktop", "Sem 6", "Internship", paste(c(name, '_', colnames(dataframe), '_ddj2.png'), collapse = ''))
  png(filename=mypath2)
  par(mfrow = c(2, 2), mar = c(3, 3, 2, 2), cex.axis = 1, cex.lab = 1, mgp = c(2, 1, 0), oma = c(1, 1, 2, 1))
  plot(ddj$avec, ddj$S2.vec, type = "l", lwd = 1, col = "black", xlab = "data", ylab = "conditional variance")
  plot(ddj$avec, ddj$TotVar.dx.vec, type = "l", lwd = 1, col = "blue", xlab = "data", ylab = "total variance of dx")
  plot(ddj$avec, ddj$Diff2.vec, type = "l", lwd = 1, col = "green", xlab = "data", ylab = "diffusion")
  plot(ddj$avec, ddj$LamdaZ.vec, type = "l", lwd = 1, col = "red", xlab = "data", ylab = "jump intensity")
  mtext(paste(c('DDJ nonparametrics of ', colnames(dataframe), ' in ', name, ' versus the data after first differencing'),collapse = ''), side = 3, line = 0.1, outer = TRUE)
  dev.off()
}

#------------------------------------------------------------------------------------#
