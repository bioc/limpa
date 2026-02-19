readDIANN <- function(
  file="report.parquet",
  path=NULL,
  format="tsv",
  sep="\t",
  sample.column="Run",
  precursor.column="Precursor.Id",
  intensity.column="Precursor.Normalised",
  annotation.columns=c("Protein.Group", "Protein.Names", "Genes", "Proteotypic"),
  q.columns=c("Q.Value", "Lib.Q.Value", "Lib.PG.Q.Value"),
  q.cutoffs=0.01,
  log=TRUE,
  verbose=TRUE
)
# Read Report file from DIA-NN
# Gordon Smyth and Mengbo Li
# Created 3 July 2023. Last modified 15 Feb 2026.
{
  EListFromLongFormatFile(
    file=file,
    path=path,
    format=format,
    sep=sep,
    sample.column=sample.column,
    feature.column=precursor.column,
    intensity.column=intensity.column,
    annotation.columns=annotation.columns,
    q.columns=q.columns,
    q.cutoffs=q.cutoffs,
    isimputed.column=NULL,
    censor.value=NULL,
    log=log,
    verbose=verbose
  )
}
