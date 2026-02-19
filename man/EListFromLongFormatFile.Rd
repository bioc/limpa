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
  sample.column,
  feature.column,
  intensity.column,
  annotation.columns = character(0),
  q.columns = character(0), q.cutoffs = 0.01,
  isimputed.column = NULL,
  censor.value = NULL,
  log = TRUE,
  verbose = TRUE)
}

\arguments{
  \item{file}{
    the name or path of the report file. If a text file, it should not be compressed.
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
  \item{sample.column}{
    character string giving the name of the column identifying the protein samples or DIA-NN runs.
  }
  \item{feature.column}{
    either a character string giving the name of the column containing feature IDs, usually precursor ions,
    or a character vector of length two containing the names of the peptide sequence and charge columns,
    which will then be read separately and pasted together to form a precursor ID.
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
  \item{isimputed.column}{
    optional column name indicating whether the intensity was imputed.
    The column should contain \code{TRUE/FALSE} values.
    Any \code{TRUE} values will be replaced with NAs.
  }
  \item{censor.value}{
    any intensities less than or equal to this value will be replaced by NAs.
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
This function reads report files written by either DIA-NN (Demichev et al 2020) or Spectronaut (https://biognosys.com/software/spectronaut/), and produces an EList or EListRaw object with features as rows and samples as columns.
It is normally used to read precursor ion intensities, but can read intensity data at any summarization level if the intensities are provided in the file.

This function uses \code{data.table::fread} to read text files and \code{nanoparquet::read_parquet} to read Parquet files.
}

\value{
If \code{log=FALSE}, an EListRaw object containing precursor unlogged intensities, and protein and feature annotation.
If \code{log=TRUE}, an EList object containing precursor log2 intensities with NAs, and protein and feature annotation.
Rows correspond to features and columns to samples.
Precursor and protein annotation is stored in the \code{genes} output component.
}

\references{
Demichev V, Messner CB, Vernardis SI, Lilley KS, Ralser M (2020).
DIA-NN: neural networks and interference correction enable deep proteome coverage in high throughput.
\emph{Nature Methods} 17(1), 41-44.

Yu Z, Du A, Xu X, Li Y, Ma X, Zhang W, Zhang Y, Chu IK, Siu KM (2026).
Spectronaut and DIA-NN: a comparison of their performance in the analysis of lung adenocarcinoma biopsies.
\emph{ACS Omega} 11(5) 8080–8093.
\doi{10.1021/acsomega.5c10421}
}

\concept{Reading data}

