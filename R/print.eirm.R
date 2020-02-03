#' @title Printing Estimated Parameters for Explanatory IRT Models
#' @description
#' This generic function prints estimated parameters from an eirm object returned
#' from the \code{\link{eirm}} function.
#'
#' @param x An object returned from the \code{\link{eirm}} function.
#' @param difficulty Whether difficulty should be used instead of easiness (default: FALSE)
#' @param ... Other print-related arguments.
#'
#' @return Estimated parameters from an eirm object.
#'
#' @examples
#' data("VerbAgg")
#' mod0 <- eirm(formula = "r2 ~ -1 + situ + btype + (1|id)", data = VerbAgg)
#' print(mod0) # or, just mod0
#' print(mod0, difficulty = TRUE)
#' @method print eirm
#' @export

print.eirm <- function(x, difficulty = FALSE, ...){
  if (!inherits(x, "eirm")) stop("Use only with 'eirm' objects.\n")

  if(difficulty) {
    # Multiply item parameters with -1 to get difficulties
    x$parameters[, 1] <- x$parameters[, 1] * -1
    colnames(x$parameters)[1] <- "Difficulty"
    cat("EIRM formula:", deparse(x$eirm_formula, width.cutoff = getOption('width')), "\n")
    cat("\n")
    cat("Number of persons:", as.numeric(summary(x$model)$ngrps), "\n")
    cat("\n")
    cat("Number of observations:", as.numeric(summary(x$model)$devcomp$dims[1]), "\n")
    cat("\n")
    cat("Number of predictors:", as.numeric(summary(x$model)$devcomp$dims[3]), "\n")
    cat("\n")
    cat("Parameter Estimates:\n")
    cat("\n")
    print(x$parameters)
    cat("\n")
    cat("Note: The estimated parameters above represent 'difficulty'.")
    invisible(x)
  } else {
    cat("EIRM formula:", deparse(x$eirm_formula, width.cutoff = getOption('width')), "\n")
    cat("\n")
    cat("Number of persons:", as.numeric(summary(x$model)$ngrps), "\n")
    cat("\n")
    cat("Number of observations:", as.numeric(summary(x$model)$devcomp$dims[1]), "\n")
    cat("\n")
    cat("Number of predictors:", as.numeric(summary(x$model)$devcomp$dims[3]), "\n")
    cat("\n")
    cat("Parameter Estimates:\n")
    cat("\n")
    print(x$parameters)
    cat("\n")
    cat("Note: The estimated parameters above represent 'easiness'.\n")
    cat("Use difficulty = TRUE to get difficulty parameters.")
    invisible(x)
  }
}


