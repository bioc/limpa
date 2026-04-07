readSpectronautRunInfo <- function(
  file="report.tsv",
  path=NULL,
  sep="\t",
  run.column = "R.FileName",
  run.info.columns = c("R.Condition","R.Fraction","R.Label","R.Replicate"),
  verbose = TRUE
)
# Read run (sample) information from Spectronaut output file
# Created 6 Apr 2026. Last modified 6 Apr 2026.
{
  # Combine column-name vectors
  Required.Columns <- unique(c(run.column, run.info.columns))

  # Set path for input file
  file <- as.character(file)
  if(!is.null(path)) file <- file.path(path, file)

  # Read file
  Report <- suppressWarnings(
    fread(file,sep=sep,select=Required.Columns,data.table=FALSE,showProgress=FALSE)
  )

  # Check for run (essential) column
  if(!hasName(Report,run.column)) stop("run ID column ",run.column," not found.")

  # Limit other columns to headers found in file
  if(length(run.info.columns)) {
    i <- hasName(Report,run.info.columns)
    if(any(i)) {
      run.info.columns <- run.info.columns[i]
      if(verbose) message("Read run info columns ",paste(run.info.columns,collapse=","),".")
    }
  }

  # Return run info data.frame
  d <- which(!duplicated(Report[[run.column]]))
  Report <- Report[d,,drop=FALSE]
  if(length(run.info.columns)) {
    row.names(Report) <- Report[[1]]
    Report[[1]] <- NULL
  }
  Report
}
