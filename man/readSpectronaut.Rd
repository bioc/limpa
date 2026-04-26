\encoding{UTF-8}
\name{readSpectronaut}
\alias{readSpectronaut}
\alias{readSpectronautRunInfo}
\title{Read Spectronaut Normal Report File}
\description{
Read a Spectronaut Normal Report file into an EList or EListRaw object.
}

\usage{
readSpectronaut(
  file = "Report.tsv",
  path = NULL,
  sep = "\t",
  run.column = "R.FileName",
  feature.column = c("EG.ModifiedSequence","FG.Charge"),
  intensity.column = "EG.TotalQuantity (Settings)",
  annotation.columns = c("PG.ProteinAccessions","PG.Genes"),
  q.columns = c("EG.Qvalue", "PG.Qvalue"),
  q.cutoffs = 0.01,
  filter.columns = "EG.IsImputed",
  filter.values = TRUE,
  censor.value = 0,
  run.info = TRUE,
  log = TRUE,
  verbose = TRUE,
  \dots
)

readSpectronautRunInfo(
  file="report.tsv",
  path=NULL,
  sep="\t",
  run.column = "R.FileName",
  run.info.columns = c("R.Condition","R.Fraction","R.Label","R.Replicate"),
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
  \item{run.column}{
    name of the column identifying the mass spectrometry runs.
    Usually each run is a distinct protein sample or, if fractioning is used, a fraction of a sample.
  }
  \item{feature.column}{
    name of the column containing feature IDs,
    or a character vector containing the names of columns, which, when pasted together,
    will uniquely identify each feature.
    By default, the features are precursor ions, but other possibilities are fragments, peptides or proteins.
    See details for examples.
    This argument and \code{intensity.column} must correspond to the same feature level.
  }
  \item{intensity.column}{
    name of column containing the feature intensities.
    By default, the precursor ion intensities are read, but see details for other possibilities.
    This argument and \code{feature.column} must correspond to the same feature level.
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
    If any q-value is above the corresponding cutoff, then the intensity will be set to \code{NA}.
  }
  \item{filter.columns}{
    optional columns that will be used to filter observations.
    The columns may indicated observations that were imputed, or values not used for the final intensity estimates at the peptide or protein levels.
  }
  \item{filter.values}{
    values for the \code{filter.columns} indicating that the observation should be filtered.
  }
  \item{censor.value}{
    intensities less than or equal to this value will be replaced by NAs.
    Spectronaut uses precursor intensities of 0 as placeholders to indicate indetermined intensities.
  }
  \item{run.info}{
    should run information columns be read?
    If \code{TRUE}, the run columns on condition and replicate will be read and stored in the \code{targets} data.frame.
  }
  \item{log}{
    logical.
    If \code{TRUE} then intensities will be returned on the log2 scale, otherwise unlogged.
  }
  \item{verbose}{
    logical, whether to send informative progress messages.
    Set this to \code{FALSE} if you want the function to run quietly.
  }
  \item{run.info.columns}{
    names of columns containing run-level information, for example information on the experimental conditions.
    By default, the standard Spectronaut columns are read.
  }
  \item{\dots}{
    other arguments are not currently used.
  }
}

\details{
The "Normal Report" file from Spectronaut (https://biognosys.com/software/spectronaut/) is a long format file, typically called \code{Report.tsv}, which contains normalized intensities for precursor ions, peptides and proteins.
\code{readSpectronaut} reads this file and produces an EList or EListRaw object.

If \code{file} is a Spectronaut v20 report file, then
\code{feature.column="FG.ProteinGroups"} and \code{intensity.column="PG.Quantity"} will read protein-level summary intensities,
\code{feature.column=c("EG.ModifiedSquence,FG.Charge"} and \code{intensity.column="EG.TotalQuantity (Settings)"} will read precursor ion estimated intensities,
while \code{feature.column=c("EG.ModifiedSequence","FG.Charge","F.FrgIon","F.Charge")} and \code{intensity.column="F.PeakArea"} will read fragment peak intensities.
Note that the columns \code{F.FrgIon}, \code{F.Charge} and \code{F.PeakArea} are not included in Spectronaut report files by default, but can be requested when Spectronaut is run.
Including fragment fragment information will make the file considerably larger.
}

\value{
If \code{log=FALSE}, an EListRaw object containing unlogged intensities with precursor and protein annotation.
Unlogged intensities equal to 0 represent non-detected precursors.
If \code{log=TRUE}, an EList object containing log2 intensities with precursor and protein annotation.
Rows are features, usually precursor ions, and columns are runs or samples.
Precursor and protein annotation is stored in the \code{genes} output component.

\code{readSpectronautRunInfo} produces a data.frame with a row for each run (sample) and a column for each run information columns found in the file.
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
