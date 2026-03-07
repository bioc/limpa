\name{readDIANN}
\alias{readDIANN}
\title{Read Precursor Ion Intensities From DIA-NN Output}
\description{
Read the DIA-NN report file (report.tsv or report.parquet) into an EList object.
}

\usage{
readDIANN(
  file = "report.parquet",
  path = NULL,
  format = "tsv",
  sep = "\t",
  sample.column = "Run",
  precursor.column = "Precursor.Id",
  intensity.column = "Precursor.Normalised",
  annotation.columns = c("Protein.Group", "Protein.Names", "Genes", "Proteotypic"),
  q.columns = c("Q.Value", "Lib.Q.Value", "Lib.PG.Q.Value"),
  q.cutoffs = 0.01,
  log = TRUE,
  verbose = TRUE
)
}

\arguments{
  \item{file}{
    name of the Report file from which the data are to be read.
    The file usually called \code{"report.tsv"} or \code{"report.parquet"} in the DIA-NN output.
    Alternatively, \code{file} can be a data.frame, as would arise from reading the report file into R using a function such as \code{read.delim}.
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
    the field separator character.
    DIA-NN report files are normally tab-delimited, but this argument can be used together with \code{format="tsv"} to read comma-separated files if necessary.
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
DIA-NN (Demichev et al 2020) writes a main report file in long (data.frame) format, typically called \code{report.tsv} or \code{report.parquet}, containing normalized intensities for precursors ions.
\code{readDIANN} reads this file and produces an EList or EListRaw object.

Version 1 of DIA-NN wrote the report file in tab-delimited format.
Version 2 of DIA-NN writes the report in Apache Parquet format (\url{https://github.com/vdemichev/DiaNN/releases}). 
In any case, \code{readDIANN} can read the report file directly.

An example analysis using this function is shown here: \url{https://smythlab.github.io/limpa/HYE100-DIANN.html}.
}

\value{
If \code{log=FALSE}, an EListRaw object containing precursor unlogged intensities, with intensities for non-detected precursors equal to 0.
If \code{log=TRUE}, an EList object containing precursor log2 intensities.
Rows are precursor ions and columns are samples.
Precursor and protein annotation is stored in the \code{genes} output component.
}

\references{
Demichev V, Messner CB, Vernardis SI, Lilley KS, Ralser M (2020).
DIA-NN: neural networks and interference correction enable deep proteome coverage in high throughput.
\emph{Nature Methods} 17(1), 41-44.
}

\examples{
\dontrun{
ypep <- readDIAN()
dpcest <- dpc(ypep)
yprot <- dpcQuant(ypep, dpc=dpcest)
}
}

\concept{Reading data}
