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
plot_ddj_1 <- function(dataframe, ddj, name) {
  
  #input: the dataframe, output from the ddj_model function and name
  #output: First plot shows the nonparametric conditional variance, total variance, diffusion and jump intensity over time
  
  # nonparametric statistics over time
  mypath <- file.path("C:","Users","probs","Desktop", "Sem 6", "Internship", paste(c(name, '_', colnames(dataframe),'_ddj1.png'), collapse = ''))
  png(filename=mypath)
  par(mfrow = c(2, 2), mar = c(3, 3, 2, 2), cex.axis = 1, cex.lab = 1, mgp = c(1.5, 0.5, 0), oma = c(1, 1, 2, 1))
  plot(ddj$Tvec1, ddj$S2.t, type = "l", lwd = 1, col = "black", xlab = "time", ylab = "conditional variance")
  plot(ddj$Tvec1, ddj$TotVar.t, type = "l", lwd = 1, col = "blue", xlab = "time", ylab = "total variance of dx")
  plot(ddj$Tvec1, ddj$Diff2.t, type = "l", lwd = 1, col = "green", xlab = "time", ylab = "diffusion")
  plot(ddj$Tvec1, ddj$Lamda.t, type = "l", lwd = 1, col = "red", xlab = "time", ylab = "jump intensity")
  mtext(paste(c('DDJ nonparametrics of ', colnames(dataframe), ' in ', name,' versus time'),collapse = ''), side = 3, line = 0.1, outer = TRUE)
  dev.off()
}