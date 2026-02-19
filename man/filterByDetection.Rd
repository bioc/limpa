\name{filterByDetection}
\alias{filterByDetection}

\title{Filter Proteins By Detection}

\description{
Keep proteins that are detected at least a specified number of times in at least a specified number of samples.
}

\usage{
filterByDetection(y, n.samples = 3, n.detections = 1)
}

\arguments{ 
\item{y}{\code{EList} object produced by \code{dpcQuant()}.}
\item{n.samples}{minimum number of samples that protein must be detected in.}
\item{n.detections}{number of detections (number of non-missing precursors) required for each sample.}
}

\details{
This function is used for filtering of proteins after \code{dpcQuant} but before normalization or \code{dpeDE}.
The number of samples required should be chosen to retain proteins that are biological meaningful.
For a small experiment, \code{n.samples} might be set to the smallest group size.
For a large dataset, \code{n.samples} would be chosen to keep proteins that are expressed in a sufficiently large subset of samples to be scientifically meaningful in a list of differentially expressed proteins.
}

\value{
Logical vector of length \code{nrow(y)} indicating which rows of \code{y} to keep in the analysis.
}

\examples{\dontrun{
y <- dpcQuant(y.prec, ProteinID)
keep <- filterByDetection(y)
yfilt <- y[keep,]
}}

\concept{Quantification}
