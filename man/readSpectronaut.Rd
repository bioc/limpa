\encoding{UTF-8}
\name{readSpectronaut}
\alias{readSpectronaut}
\title{Read Spectronaut Normal Report File}
\description{
Read a Spectronaut Normal Report file into an EList or EListRaw object.
}

\usage{
readSpectronaut(
  file = "Report.tsv",
  path = NULL,
  sep = "\t",
  sample.column = "R.FileName",
  precursor.column = c("EG.ModifiedSequence","FG.Charge"),
  intensity.column = "EG.TotalQuantity (Settings)",
  annotation.columns = c("PG.ProteinAccessions","PG.Genes"),
  q.columns = c("EG.Qvalue", "PG.Qvalue"),
  q.cutoffs = 0.01,
  isimputed.column = "EG.IsImputed",
  censor.value = 1,
  log = TRUE,
  verbose = TRUE
)
}

\arguments{
  \item{file}{
    name of the Normal Report file from which the data are to be read.
    Alternatively, \code{file} can be a data.frame, as would arise from reading the report file into R using a function such as \code{read.delim}.
  }
  \item{path}{
    character string giving the directory containing the file.
    Defaults to the current working directory.
  }
  \item{sep}{
    the field separator character.
    Spectronaut normally writes tab-delimited files, but this argument can be used to read comma-separated files if necessary.
  }
  \item{sample.column}{
    name of column containing run (sample) IDs.
  }
  \item{precursor.column}{
    name of column containing precursor IDs.
    Can be character vector of length two containing the names of the peptide sequence and charge columns, which will then be read separately and pasted together to form a precursor ID.
  }
  \item{intensity.column}{
    name of column containing precursor intensities.
  }
  \item{annotation.columns}{
    names of other columns to be read and included in the output \code{genes} data.frame annotating the precursors and proteins.
  }
  \item{q.columns}{
    names of columns containing q-values for peptide or protein identification.
  }
  \item{q.cutoffs}{
    cutoffs to apply to the q-value columns.
    Either a single value or a numeric vector of the same length as \code{q.columns}.
    Only features with all q-values below the corresponding cutoffs will be retained.
  }
  \item{isimputed.column}{
    name of column indicating whether the intensity was imputed.
    The column should contain \code{TRUE/FALSE} values.
    Any \code{TRUE} values will be replaced with NAs.}
  \item{censor.value}{
    any intensities less than or equal to this value will be replaced by NAs.
    Spectronaut uses intensity values of 0 or 1 as placeholders to indicate indetermined intensities.
  }
  \item{log}{
    logical.
    If \code{TRUE} then intensities will be returned on the log2 scale, otherwise unlogged.
  }
  \item{verbose}{
    logical, whether to send informative progress messages.
    Set this to \code{FALSE} if you want the function to run quietly.
  }
}

\details{
The "Normal Report" file from Spectronaut (https://biognosys.com/software/spectronaut/) is a long format file, typically called \code{Report.tsv}, which contains normalized intensities for precursor ions.
\code{readSpectronaut} reads this file and produces an EList or EListRaw object.
}

\value{
If \code{log=FALSE}, an EListRaw object containing precursor-level unlogged intensities with precursor and protein annotation.
Unlogged intensities equal to 0 represent non-detected precursors.
If \code{log=TRUE}, an EList object containing precursor-level log2 intensities with precursor and protein annotation.
Rows are precursor ions and columns are samples.
Precursor and protein annotation is stored in the \code{genes} output component.

If \code{file} is a Spectronaut v20 report file, then
\code{feature.column="FG.ProteinGroups"} and \code{intensity.column="PG.Quantity"} will read protein-level summary intensities,
\code{feature.column=c("EG.ModifiedSquence,FG.Charge"} and \code{intensity.column="EG.TotalQuantity (Settings)"} will read precursor ion estimated intensities,
while \code{feature.column=c("EG.ModifiedSequence","FG.Charge","F.FrgIon","F.Charge")} and \code{intensity.column="F.PeakArea"} will read fragment peak intensities.
Note that fragment intensities are not included in Spectronaut report files by default, but can be requested when Spectronaut is run.
}

\references{
BIOGNOSYS Spectronaut manual
\url{https://biognosys.com/resources/spectronaut-manual/}.

Yu Z, Du A, Xu X, Li Y, Ma X, Zhang W, Zhang Y, Chu IK, Siu KM (2026).
Spectronaut and DIA-NN: a comparison of their performance in the analysis of lung adenocarcinoma biopsies.
\emph{ACS Omega} 11(5) 8080-8093.
\doi{10.1021/acsomega.5c10421}
}

\seealso{
\code{\link[limma]{EList-class}}.
}

\examples{
\dontrun{
y <- readSpectronaut()
dpcest <- dpc(y)
}
}

\concept{Reading data}
