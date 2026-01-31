plotDPC <- function(dpcfit,
                    add.jitter = TRUE,
                    point.cex = 0.2,
                    lwd = 2,
                    ylim = c(0, 1), 
                    main = "Detection probability curve",
                    show.start = FALSE,
                    ...)
# Plot detection probability curve (DPC) produced by dpc().
# Mengbo Li
# Created 16 May 2022 as part of protDP package.
# Migrated to limpa 11 Sept 2024. Last modified 28 Jan 2026.
{
  if ("dpc.start" %in% names(dpcfit)) {
    # ON by exponential tilting
    x <- (dpcfit$mu.obs + dpcfit$mu.mis)/2
    y <- dpcfit$n.detected / dpcfit$nsamples
    if (add.jitter) {
      y <- jitter(y, amount = 1/dpcfit$nsamples/2)
      ylim[2] <- ylim[2] + 1/dpcfit$nsamples/2
    }
    
    plot(x = x, y = y, pch = 16, cex = point.cex, ylim = ylim,
    xlab = "Log-intensity", ylab = "Detection probability", main = main, ...)
    
    x <- x[order(x)]
    lines(x = x, y = plogis(dpcfit$dpc["beta0"] + dpcfit$dpc["beta1"]*x), col = "blue", lwd = lwd)
    if(show.start) {
      lines(x = x, y = plogis(dpcfit$dpc.start["beta0"] + dpcfit$dpc.start["beta1"]*x), lty = "dashed", lwd = lwd)
      legend("bottomright", legend = c("Start", "Final"), col = c("black", "blue"), lty = c(2, 1), lwd = lwd, cex = 0.8)
    }
  } else {
    # CN by maximum likelihood1
    x <- dpcfit$mu
    y <- dpcfit$n.detected / dpcfit$nsamples
    if (add.jitter) {
      y <- jitter(y, amount = 1/dpcfit$nsamples/2)
      ylim[2] <- ylim[2] + 1/dpcfit$nsamples/2
    }

    plot(x = x, y = y, pch = 16, cex = point.cex, ylim = ylim,
    xlab = "Average log-intensity", ylab = "Detection probability", main = main, ...)

    x <- x[order(x)]
    lines(x = x, y = plogis(dpcfit$dpc["beta0"] + dpcfit$dpc["beta1"]*x), col = "blue", lwd = lwd)
  }


  invisible(list(x=x,y=y))
}