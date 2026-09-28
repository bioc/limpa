\name{pztbinomSameSizeLogitPBothTails}
\alias{pztbinomSameSizeLogitPBothTails}

\title{Zero-Truncated Binomial Distribution P-Values}

\description{
Left and right p-values for zero-truncated binomial deviates.
}

\usage{
pztbinomSameSizeLogitPBothTails(q, size, logit.prob)
}

\arguments{
  \item{q}{numeric vector of quantiles.}
  \item{size}{number of trials (one or more). Should be a single value.}
  \item{logit.prob}{numeric vector of success probabilities on logit scale.}
}

\details{
This function returns left and right p-values for zero-truncated binomial deviates.
The \code{size} argument is assumed to be the same for all deviates.
This function is slow but accurate, even for very small or very large success probabilities.
}

\value{
A list with components:
  \item{left.p.value}{left tail p-values.}
  \item{right.p.value}{left tail p-values.}
  \item{total.prob}{
    probability that the untruncated binomial random deviates are greater than zero.
    Serves as the denominator for the zero-truncated probabilities.
  }
All components are numeric vectors of length equal to \code{max(length(q), length(logit.prob))}.
}

\examples{
q <- 1:3
pztbinomSameSizeLogitPBothTails(q, size=3, logit.prob=0)
}

\concept{Zero truncated binomial distribution}
