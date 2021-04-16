#---
# title: "Analysis functions"
# author: "Jennifer Probst"
# date: "2019 M08 21"
# output: html_document
# Functions used for the analysis of EWS
# ---
# adjust the paths where the graphs should be saved!! (lines 274, 465, 507, 664 and 681)

#------------------------------------------------------------------------------------#

# Detrending fluctuation analysis
# https://www.rdocumentation.org/packages/nonlinearTseries/versions/0.2.3/topics/dfa

#' To Add
#'
#' @param switch TODO
#' @param var_col TODO
#' @param n TODO
#' @param t TODO
#' @param name TODO
#'
#' @return TODO
#' 
#' @importFrom graphics lines
#' @importFrom grDevices png dev.off
#' 
#' @export
#'
#' @examples
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
  png(filename=mypath)
  plot(dfa_vector[0:(t-100)]~tottime[n:(length(switch[,var_col])-100)], xlab='timestep', ylab='DFA', main=paste(c('Detrended fluctuation analysis of ',colnames(switch)[var_col], ' of ', name), collapse = ''), type='l')
  dev.off()
}