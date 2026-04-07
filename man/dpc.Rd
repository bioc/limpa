\name{dpc}
\alias{dpc}
\title{Detection Probability Curve}

\description{
Detection probability curve for label-free shotgun proteomics data.
}

\usage{
dpc(
  y, model="cn",
  dpc.start = NULL, dpc.slope.start = 0.7, 
  iterations = 2, subset = 2000, robust = TRUE, verbose = FALSE
)
}

\arguments{
  \item{y}{
    numeric matrix of log2-intensities.
    Rows correspond to features (usually precursor ions) and columns to runs or samples.
  }
  \item{model}{
    which model to use.
    Possibilities are \code{"cn"} for the complete-normal model or \code{"on"} for the observed-normal model.
  }
  \item{dpc.start}{numeric vector of length 2 giving starting values for the DPC intercept and slope.}
  \item{dpc.slope.start}{starting value for the DPC slope. Only used if \code{dpc.start} is NULL.}
  \item{iterations}{number of outer iterations. Only used if \code{model="cn"}.}
  \item{subset}{maximum number of rows of \code{y} to use in the calculation. A systematic sample is taken stratified by number of missing values and average observed log2-intensity. Only used if \code{model="cn"}.}
  \item{robust}{if \code{TRUE}, outlier rows will be downweighted to produce a robust DPC estimate. Only used if \code{model="on"}.}
  \item{verbose}{if \code{TRUE}, then progress information will be printed from each iteration.}
}

\details{
Estimate the detection probability curve (DPC) for label-free shotgun proteomics data
using either the "complete normal" or the "observed normal" models.
The function returns results from either \code{dpcCON()} or \code{dpcON()}, depending on whether \code{model} is equal to \code{"cn"} or \code{"on"}.

Li, Cobbold & Smyth (2025) show that the complete normal and observed normal models, although theoretically different, give similar results in practice.
}

\value{
A list with components
  \item{dpc}{numeric vector of length 2 giving the estimated DPC intercept and slope.}
  \item{model}{equal to either \code{"CN"} or \code{"ON"}.}

For other components of the output list, see the help pages for \code{\link{dpcCN}} or \code{\link{dpcON}}.
}

\references{
Li M, Cobbold SA, Smyth GK (2025).
Quantification and differential analysis of mass spectrometry proteomics data with probabilistic recovery of information from missing values.
\emph{bioRxiv} 2025/651125.
\doi{10.1101/2025.04.28.651125}
}

\seealso{
\code{\link{dpc}}.
}

\examples{
y <- simProteinDataSet(n.peptides=100, n.groups=1)
dpcest <- dpc(y)
dpcest$dpc
}

\concept{Detection probability curve}
