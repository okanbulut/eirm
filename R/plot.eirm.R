#' @title Person-Item Map for Explanatory IRT Models
#' @importFrom graphics axis box layout lines mtext par plot points segments
#' @description
#' This function creates a person-item map for an object returned from the \code{\link{eirm}} function.
#' The function was modified from \code{\link[eRm]{plotPImap}} in package \pkg{eRm}.
#'
#' @param x An object returned from the \code{\link{eirm}} function.
#' @param difficulty Whether difficulty should be used instead of easiness (default: FALSE).
#' @param theta A vector of estimated theta values. If NULL, then theta values are obtained from the
#' estimated eirm model. It might be better to save the theta values from a baseline model (e.g., Rasch)
#' and use them when creating a person-item map.
#' @param sorted Whether the parameters should be sorted in the plot (default: TRUE).
#' @param main Main title for the person-item map.
#' @param latdim Label of the x-axis, i.e., the latent dimension.
#' @param pplabel Title for the upper panel displaying the person parameter distribution.
#' @param cex.gen A numerical value giving the amount by which plotting text and symbols should
#' be magnified relative to the default. Here cex.gen applies to all text labels. The default is 0.7.
#' @param  ... Other plot-related arguments.
#'
#' @return A person-item map.
#'
#' @examples
#' data("VerbAgg")
#' mod0 <- eirm(formula = "r2 ~ -1 + situ + btype + (1|id)", data = VerbAgg)
#' plot(mod0)
#' plot(mod0, difficulty = TRUE) # Plot difficulty instead of easiness
#' @method plot eirm
#' @export

plot.eirm <- function(x, difficulty = FALSE, sorted = TRUE, theta = NULL, main = "Person-Item Map",
                      latdim = "Latent Dimension", pplabel = "Person\nParameter\nDistribution",
                      cex.gen = 0.7, ...){
  if (!inherits(x, "eirm")) stop("Use only with 'eirm' objects.\n")

  # Item parameters
  if(difficulty) {
    threshtable <- data.frame(Location = x$parameters[,1]*-1)
  } else {
    threshtable <- data.frame(Location = x$parameters[,1])
  }

  rownames(threshtable) <- row.names(x$parameters)

  if(sorted) {
    tr <- as.matrix(threshtable)
    tr <- tr[order(tr[, 1], decreasing = FALSE), ]
    tr <- as.matrix(tr)
  } else {
    tr <- as.matrix(threshtable)
  }

  loc <- tr

  # Theta values
  if(is.null(theta)) {
    raneff <- as.data.frame(lme4::ranef(x$model)[1])
    colnames(raneff) <- "theta"
    theta <- round(raneff, 2)
    tt <- table(theta)
    ttx <- as.numeric(names(tt))
  } else {
    theta <- as.data.frame(theta)
    colnames(theta) <- "theta"
    theta <- round(theta, 2)
  }

  tt <- table(theta)
  ttx <- as.numeric(names(tt))
  yrange <- c(0, nrow(tr) + 1)
  xrange <- range(c(tr, theta), na.rm = T)

  # Reset par settings once it is done
  old_par <- par(no.readonly = TRUE)
  on.exit(par(old_par))

  # Plot begins here
  def.par <- par(no.readonly = TRUE)
  nf <- layout(matrix(c(2, 1), 2, 1, byrow = TRUE), heights = c(1, 3), T)
  par(mar = c(2.5, 4, 0, 1))
  plot(xrange, yrange, xlim = xrange, ylim = yrange, main = "",
       ylab = "", type = "n", yaxt = "n", xaxt = "n", ...)
  axis(2, at = 1:nrow(tr), labels = rev(rownames(tr)), las = 2,
       cex.axis = cex.gen)
  axis(1, at = seq(floor(xrange[1]), ceiling(xrange[2])), cex.axis = cex.gen,
       padj = -1.5)
  mtext(latdim, 1, 1.2, cex = cex.gen + 0.1)
  y.offset <- nrow(tr) * 0.0275
  tr.rug <- as.numeric(tr)
  segments(tr.rug, rep(yrange[2], length(tr.rug)) + y.offset,
           tr.rug, rep(yrange[2], length(tr.rug)) + 100)
  warn <- rep(" ", nrow(tr))

  for (j in 1:nrow(tr)) {
    i <- nrow(tr) + 1 - j
    assign("trpoints", tr[i, !is.na(tr[i, ])])
    npnts <- length(trpoints)
    ptcol = "black"
    lines(xrange * 1.5, rep(j, 2), lty = "dotted")
    points(loc[i], j, pch = 20, cex = 1.5, col = ptcol)
  }
  axis(4, at = 1:nrow(tr), tick = FALSE, labels = warn, hadj = 2.5, padj = 0.7, las = 2)
  par(mar = c(0, 4, 3, 1))
  plot(ttx, tt, type = "n", main = main, axes = FALSE,
       ylab = "", xlim = xrange, ylim = c(0, max(tt)), ...)
  points(ttx, tt, type = "h", col = "gray", lend = 2,
         lwd = 5)
  mtext(pplabel, 2, 0.5, las = 2, cex = cex.gen)
  box()
  par(def.par)
}

