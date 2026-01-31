plotProtein <- function(y, protein, col="black", cex=2, lwd=2, las=NULL,
               xlab="", ylab="Estimated log-intensity", ...)
# Plot the sample-wise protein summary with error bars by dpcQuant.
# Created 15 Jan 2025. Last modified 29 Dec 2025.
{
  #	Check input
  if(!is(y,"EList")) stop("y must be an EList produced by dpcQuant()")
  if (!identical(length(protein), 1L)) stop("Input one protein to plot at each time")
  if (is.character(protein)) {
    if (!(protein %in% row.names(y))) stop("Protein ID not found in y, check input")
  }

  # Get protein values and standard errors
  y_protein <- y$E[protein, ]
  se_protein <- y$other$standard.error[protein, ]
  nsamples <- ncol(y)

  # Plot protein values vs sample
  x <- seq_len(nsamples)
  y0 <- y_protein - se_protein
  y1 <- y_protein + se_protein
  ylim <- c(min(y0, y1), max(y0, y1))
  plot(y_protein, pch=16, ylim=ylim, col=col, xaxt="none", 
  cex=cex, xlab=xlab, ylab=ylab, ...)

  # Add sample labels to x-axis
  cn <- colnames(y)
  if(is.null(cn)) cn <- 1:nsamples
  if(is.null(las)) if(nsamples > 6) las <- 2 else las <- 0
  axis(1, at=x, labels=cn, las=las)

  # Add standard error bars
  arrows(x, y0, x, y1, length=0.1, angle=90, code=3, lwd=lwd, col=col)

  invisible(list(y=y_protein, se=se_protein))
}