#' @title Reformat polytomous item responses in a long format for explanatory item response modeling
#' @import reshape2
#' @import lme4
#'
#' @description
#' This function prepares the data with polytomous item responses for explanatory item response modeling.
#' If the data is already in a long format (i.e., items by person), it only recodes the polytomous responses
#' and creates a new variable to be used for the estimation. If the data is not in the long format, then both
#' reshaping the data into the long format and recoding items can be done simultaneously.
#'
#' @param data A data frame -- either in a wide format where the rows represent persons and columns represent items
#' explanatory variables or in a long format where there are multiple rows for each person (i.e., nested data)
#' @param id.var The variable that represents examinee IDs.
#' @param long.format Whether the data follow a wide format and thus need to be transformed into a long format (default is FALSE)
#' @param var.name The variable that represents item IDs if the data is already in long format; otherwise this is the
#' of the variable that represents item IDs once the data is transformed into long format.
#' @param val.name The variable that represents item responses if the data is already in long format;
#' otherwise this is the
#' of the variable that represents item responses once the data is transformed into long format.
#' @return Reformatted data for explanatory item response modeling.
#'
#' @examples
#' data("VerbAgg")
#' VerbAgg2 <- polyreformat(data=VerbAgg, id.var = "id", long.format = FALSE,
#' var.name = "item", val.name = "resp")
#' head(VerbAgg2)
#' @export

polyreformat <- function(data, id.var, long.format = FALSE, var.name = "item", val.name = "resp"){

  # Transform the data into long format if long.format=TRUE
  if(long.format) {
    data <- as.data.frame(data)
    dataMat <- melt(data, id = id.var, variable.name = var.name, value.name = val.name)
  }

  else {dataMat <- data}

  dataMat <- dataMat[order(dataMat[,c(var.name)]),]
  dataMat[,c(val.name)] <- as.factor(dataMat[,c(val.name)])

  itemColumn <- var.name
  respColumn <- val.name

  cats <- length( unique(dataMat[,respColumn]))
  PCMMat <- matrix(rep(0, cats*cats), ncol = cats)
  diag(PCMMat) <- 1
  PCMMat[lower.tri(PCMMat)] <- NA
  PCMMat[upper.tri(PCMMat)] <- NA

  for(i in 1:cats) {
    PCMMat[i-1,i] = 0
  }

  PCMMat <- as.data.frame(PCMMat)
  PCMMat <- PCMMat[,-1]
  dataMat2 <- dataMat[c(respColumn)]
  names(dataMat2) = val.name
  names(PCMMat) <- paste(rep('cat',cats-1),levels(as.factor(dataMat2$resp))[2:(cats)],sep='_')
  rm(dataMat2)
  PCMVars <- names(PCMMat)

  TempMat <- with(dataMat,PCMMat[dataMat[,respColumn],])
  TempMat2 <- cbind(dataMat,TempMat)

  longdata <- melt(TempMat2, measure.vars = PCMVars)

  longdata$newitem <- interaction(longdata[,itemColumn], longdata[,"variable"])

  colnames(longdata)[which(colnames(longdata) == 'variable')] <- 'polycategory'
  colnames(longdata)[which(colnames(longdata) == 'value')] <- 'polyresponse'
  colnames(longdata)[which(colnames(longdata) == 'newitem')] <- 'polyitem'

  #class(longdata) <- "polyreformat"
  return(longdata)
}






