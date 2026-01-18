\name{readDIANN}
\alias{readDIANN}
\title{Read Precursor Ion Intensities From DIA-NN Output}
\description{
Read the DIA-NN report file (report.tsv or report.parquet) into an EList object.
}

\usage{
readDIANN(file = "report.parquet", path = NULL, format = NULL, sep = "\t", log = TRUE,
  run.column = "Run",
  precursor.column = "Precursor.Id",
  qty.column = "Precursor.Normalised",
  q.columns = c("Q.Value", "Lib.Q.Value", "Lib.PG.Q.Value"),
  q.cutoffs = c(0.01, 0.01), 
  extra.columns = c("Protein.Group", "Protein.Names", "Genes", "Proteotypic"))
}

\arguments{
  \item{file}{the name of the main report file from DIA-NN. Or can be the data.frame that results from reading the main report file into R using \code{read.table} or equivalent functions. If a data.frame, then will be in long format, where each row is an observation.}
  \item{path}{character string giving the directory containing the file. Defaults to the current working directory.}
  \item{format}{character string giving the format of the file. Possible values are \code{"tsv"} for a tab-delimited text file or \code{"parquet"} for a Parquet format file. By default, the format is detected from the file name extension.}
  \item{sep}{the field separator character. DIA-NN report files are usually tab-delimited.}
  \item{log}{logical. If \code{TRUE} then intensities will be returned on the log2 scale, otherwise unlogged with zeros.}
  \item{run.column}{character string giving the name of the column containing run names.}
  \item{precursor.column}{character string giving the name of the column containing precursor IDs.}
  \item{qty.column}{character string giving the name of the column containing precursor intensities.}
  \item{q.columns}{character vector of column names containing Q-values for precursor identification.}
  \item{q.cutoffs}{numeric vector of same length as \code{q.columns} giving cutoffs to apply to the Q-values. Only precursors with values below the cutoffs will be retained.}
  \item{extra.columns}{other columns to be read and included in the annotation data.frame.}
}

\details{
DIA-NN (Demichev et al 2020) writes a main report file in long (data.frame) format, typically called \code{Report.tsv} or \code{Report.parquet}, containing normalized intensities for precursors ions.
\code{readDIANN} reads this file and produces an EList or EListRaw object.

Version 1 of DIA-NN wrote the report file in tab-delimited format.
Version 2 of DIA-NN writes the report in Apache Parquet format (\url{https://github.com/vdemichev/DiaNN/releases}). 
In any case, \code{readDIANN} can read the report file directly or, alternatively, one can read the file into a data.frame, and use \code{readDIANN} to process the long-format data.frame into a limma EList or EListRaw object. 
}

\value{
If \code{log=FALSE}, an EListRaw object containing precursor unlogged intensities with zeros and protein annotation.
If \code{log=TRUE}, an EList object containing precursor log2 intensities with NAs and protein annotation.
Rows are precursors and columns are samples.
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
