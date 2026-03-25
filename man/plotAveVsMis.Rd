\name{plotAveVsMis}
\alias{plotAveVsMis}
\title{Average Observed Log-intensity Vs Number of Mising Values}

\description{
For rows of a matrix containing log-intensities, plot average observed log-intensity vs number of missing values. 
}

\usage{
plotAveVsMis(y)
}

\arguments{
  \item{y}{matrix or EList containing log-intensities.}
}

\value{
A plot is created on the current graphics device.
}

\examples{
y <- simProteinDataSet(1000)
plotAveVsMis(y)
}

\concept{Plots}
