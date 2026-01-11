plotPeptides <- function(y, ...)
  UseMethod("plotPeptides")

plotPeptides.default <- function(y, cex=1.5, lwd=1.5, col="blue", las=NULL, step.down=0.5, ...)
# Plot peptide log-intensities for one protein.
# Created 20 May 2025. Last modified 29 Dec 2025.
{
# Check y
  y <- as.matrix(y)
  IsNA <- is.na(y)
  if(all(IsNA)) stop("y is all missing")

# Simple imputation
  rmin <- apply(y,1,min,na.rm=TRUE)
  rmin[is.na(rmin)] <- min(y,na.rm=TRUE)
  rmin <- rmin - step.down
  yimp <- y
  yimp[IsNA] <- matrix(rmin,nrow(y),ncol(y))[IsNA]

# Setup plotting character, open for missing, closed for observed
  pch <- matrix(16,nrow(y),ncol(y))
  pch[IsNA] <- 1

# Plot log-expression vs sample
  Sample <- col(y)
  plot(Sample,yimp,pch=pch,xlab="Sample",ylab="Log-intensity",cex=cex,xaxt="none",...)

# Add sample names to x-axis
  x <- seq_len(ncol(y))
  cn <- colnames(y)
  if(is.null(cn)) cn <- 1:ncol(y)
  if(is.null(las)) if(ncol(y) > 6) las <- 2 else las <- 0
  axis(1, at=x, labels=cn, las=las)

# Connect points for same peptide
  for (i in 1:nrow(y)) {
    lines(1:ncol(y),yimp[i,],lwd=lwd,col=col) 
  }

# Return the simple imputed matrix invisibly
  invisible(yimp)
}

plotPeptides.EList <- function(y, index, cex=1.5, lwd=1.5, col="blue", las=NULL, step.down=0.5, ...)
# Plot peptide log-intensities for one protein. Method for EList.
# Created 22 Jun 2025. Last modified 22 Jun 2025.
{
  plotPeptides(y$E[index,],cex=cex,lwd=lwd,col=col,las=las,step.down=step.down,...)
}
