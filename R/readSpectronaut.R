readSpectronaut <- function(
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
  verbose = TRUE
)
# Read normal (wide) report file from Spectronaut.
# Gordon Smyth and Mengbo Li
# Created 18 December 2023. Last modified 6 Apr 2026.
{
  x <- EListFromLongFormatFile(
    file=file,
    path=path,
    format="tsv",
    sep=sep,
    run.column=run.column,
    feature.column=feature.column,
    intensity.column=intensity.column,
    annotation.columns=annotation.columns,
    q.columns=q.columns,
    q.cutoffs=q.cutoffs,
    filter.columns=filter.columns,
    filter.values=filter.values,
    censor.value=censor.value,
    log=log,
    verbose=verbose
  )
  if(run.info) x$targets <- readSpectronautRunInfo(
    file=file,
    path=path,
    sep=sep,
    run.column=run.column,
    verbose=verbose
  )
  x
}
