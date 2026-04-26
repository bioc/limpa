readDIANN <- function(
  file="report.parquet",
  path=NULL,
  format=NULL,
  sep="\t",
  run.column="Run",
  feature.column="Precursor.Id",
  intensity.column="Precursor.Normalised",
  annotation.columns=c("Protein.Group", "Protein.Names", "Genes", "Proteotypic"),
  q.columns=c("Q.Value", "Lib.Q.Value", "Lib.PG.Q.Value"),
  q.cutoffs=0.01,
  log=TRUE,
  verbose=TRUE,
  ...
)
# Read Report file from DIA-NN
# Gordon Smyth and Mengbo Li
# Created 3 July 2023. Last modified 26 Apr 2026.
{
# Check for deprecated arguments
  dots <- list(...)
  if(hasName(dots,"precursor.column")) {
    feature.column <- dots$precursor.column
    message("`precursor.column` is deprecated, please use `feature.column` instead.")
  }
  if(hasName(dots,"qty.column")) {
    intensity.column <- dots$qty.column
    message("`qty.column` is deprecated, please use `intensity.column` instead.")
  }
  if(hasName(dots,"extra.columns")) {
    annotation.columns <- dots$extra.columns
    message("`extra.columns` is deprecated, please use `annotation.columns` instead.")
  }

  EListFromLongFormatFile(
    file=file,
    path=path,
    format=format,
    sep=sep,
    run.column=run.column,
    feature.column=feature.column,
    intensity.column=intensity.column,
    annotation.columns=annotation.columns,
    q.columns=q.columns,
    q.cutoffs=q.cutoffs,
    censor.value=NULL,
    log=log,
    verbose=verbose
  )
}
