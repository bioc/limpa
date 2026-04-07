\encoding{UTF-8}
\name{EListFromLongFormatFile}
\alias{EListFromLongFormatFile}

\title{Read Feature Intensities From a Long Format Report File Written By a Mass Spectrometry Quantification Tool}
\description{
Create an EList from a long format report file written by a quantification tool such as Spectronaut or DIA-NN.
}

\usage{
EListFromLongFormatFile(
  file = "report.tsv", path = NULL, 
  format = NULL, sep = "\t",
  run.column,
  feature.column,
  intensity.column,
  annotation.columns = NULL,
  q.columns = NULL, q.cutoffs = 0.01,
  filter.columns = NULL, filter.values = TRUE,
  censor.value = NULL,
  matrix.columns = NULL,
  log = TRUE,
  verbose = TRUE)
}

\arguments{
  \item{file}{
    the name or path of the report file. If a text file, it should not be compressed.
    Alternatively, \code{file} can be a long format data.frame, as would arise from reading the report file into R using a function such as \code{read.delim}.
  }
  \item{path}{
    character string giving the directory containing the file.
    Defaults to the current working directory.
  }
  \item{format}{
    character string giving the format of the file.
    Possible values are \code{"tsv"} for a tab-delimited text file or \code{"parquet"} for a Parquet format file.
    By default, the format is detected from the file name extension.
  }
  \item{sep}{
    the field separator character for delimited text files.
    This argument is usually unnecessary, but it can be used in combination with \code{format="tsv"} to read comma-separated files.
  }
  \item{run.column}{
    name of the column identifying the mass spectrometry runs.
    Usually each run is a distinct protein sample or, if fractioning is used, a fraction of a sample.
  }
  \item{feature.column}{
    name of the column containing feature IDs,
    or a character vector containing the names of columns, which, when pasted together,
    will uniquely identify each feature.
  }
  \item{intensity.column}{
    character string giving the name of the column containing feature intensities.
  }
  \item{annotation.columns}{
    other columns to be read and included in the output \code{genes} data.frame annotating the features and proteins.
  }
  \item{q.columns}{
    character vector of column names containing q-values for feature identification.
  }
  \item{q.cutoffs}{
    cutoffs to apply to the q-values.
    Either a single value or a numeric vector of the same length as \code{q.columns}.
    Only features with all q-values below the corresponding cutoffs will be retained.
  }
  \item{filter.columns}{
    optional columns that will be used to filter observations.
    The columns may indicated observations that were imputed, or values not used for the final intensity estimates.
    Any observation that is flagged by any of these columns will be \code{NA} in the output EList.
  }
  \item{filter.values}{
    values for the \code{filter.columns} indicating that the observation should be filtered.
  }
  \item{censor.value}{
    any intensities less than or equal to this value will be replaced by NAs.
  }
  \item{matrix.columns}{
    character vector of column names containing observation-level covariates.
    Each such variable will be copied into a matrix of the same dimensions as the intensities
    and stored in the \code{other} component of the output object.
  }
  \item{log}{
    logical.
    If \code{TRUE} then intensities will be returned on the log2 scale, otherwise unlogged.
  }
  \item{verbose}{
    logical, whether to send informative progress messages.
  }
}

\details{
This function reads report files written in long format by tools wuch as DIA-NN (Demichev et al 2020), Spectronaut (https://biognosys.com/software/spectronaut/), or MSstats convert functions.
It produces an EList or EListRaw object with features as rows and samples as columns.

This function is most often used to read precursor ion intensities, but can read intensity data at any summarization level if the intensities are provided in the file.
If \code{feature.column} contains protein IDs, then protein-level intensities (such as maxLFQ) summaries will be read.
If \code{feature.column} specifies peptide sequence and charge, then precursor ion intensities will be read.
If \code{feature.column} specifies fragment ion and fragment charge as well as peptide sequence and precursor charge, then fragment peak intensities can be read.

If \code{file} is a Spectronaut v20 report file, then
\code{feature.column="FG.ProteinsGroups"} and \code{intensity.column="PG.Quantity"} will read protein-level summary intensities,
\code{feature.column=c("EG.ModifiedSquence,FG.Charge"} and \code{intensity.column="EG.TotalQuantity (Settings)"} will read precursor ion estimated intensities,
while \code{feature.column=c("EG.ModifiedSequence","FG.Charge","F.FrgIon","F.Charge")} and \code{intensity.column="F.PeakArea"} will read fragment peak intensities.

This function uses \code{data.table::fread} to read text files and \code{nanoparquet::read_parquet} to read Parquet files.
}

\value{
If \code{log=FALSE}, an EListRaw object containing precursor unlogged intensities, and protein and feature annotation.
If \code{log=TRUE}, an EList object containing precursor log2 intensities with NAs, and protein and feature annotation.
Rows correspond to features and columns to samples.
Precursor and protein annotation is stored in the \code{genes} output component.
}

\references{
BIOGNOSYS Spectronaut manual
\url{https://biognosys.com/resources/spectronaut-manual/}.

Demichev V, Messner CB, Vernardis SI, Lilley KS, Ralser M (2020).
DIA-NN: neural networks and interference correction enable deep proteome coverage in high throughput.
\emph{Nature Methods} 17(1), 41-44.

Yu Z, Du A, Xu X, Li Y, Ma X, Zhang W, Zhang Y, Chu IK, Siu KM (2026).
Spectronaut and DIA-NN: a comparison of their performance in the analysis of lung adenocarcinoma biopsies.
\emph{ACS Omega} 11(5) 8080–8093.
\doi{10.1021/acsomega.5c10421}
}

\concept{Reading data}

