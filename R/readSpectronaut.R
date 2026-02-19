readSpectronaut <- function(
  file="Report.tsv",
  path=NULL,
  sep="\t",
  sample.column = "R.FileName",
  precursor.column = c("EG.ModifiedSequence","FG.Charge"),
  intensity.column = "EG.TotalQuantity (Settings)",
  annotation.columns = c("PG.ProteinAccessions","PG.Genes"),
  q.columns = c("EG.Qvalue", "PG.Qvalue"),
  q.cutoffs = 0.01,
  isimputed.column = "EG.IsImputed",
  censor.value=1,
  log=TRUE,
  verbose=TRUE
)
# Read normal (wide) report file from Spectronaut.
# Gordon Smyth and Mengbo Li
# Created 18 December 2023. Last modified 15 Feb 2026.
{
  EListFromLongFormatFile(
    file=file,
    path=path,
    format="tsv",
    sep=sep,
    sample.column=sample.column,
    feature.column=precursor.column,
    intensity.column=intensity.column,
    annotation.columns=annotation.columns,
    q.columns=q.columns,
    q.cutoffs=q.cutoffs,
    isimputed.column=isimputed.column,
    censor.value=censor.value,
    log=log,
    verbose=verbose
  )
}
