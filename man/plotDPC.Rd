\name{plotDPC}
\alias{plotDPC}
\title{Plot the Detection Probability Curve}

\description{
Plot the detection probability curve using output from the \code{dpc} function.
}

\usage{
plotDPC(dpcfit, add.jitter = TRUE, point.cex = 0.2, lwd = 2, ylim = c(0, 1),
        main = "Detection probability curve", show.start = FALSE, \dots)
}

\arguments{
  \item{dpcfit}{object produced by \code{dpc()}.}
  \item{add.jitter}{logical, whether to add jitter to the detected proportions.}
  \item{point.cex}{relative size of points.}
  \item{lwd}{relative line width.}
  \item{ylim}{limits of the y-axis.}
  \item{main}{main title of plot.}
  \item{show.start}{logical, whether to show starting as well as final estimate of curve.}
  \item{\dots}{other arguments are passed to \code{plot}.}
}

\value{
A plot is produced on the current device.
A list with components \code{x} and \code{y} is also invisibly returned.
}

\examples{
y <- simProteinDataSet(n.peptides=100, n.groups=1)
dpcfit <- dpc(y)
plotDPC(dpcfit)
}

\concept{Detection probability curve}
