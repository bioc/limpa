readDIANN <- function(
  file="report.parquet", path=NULL, 
  format = NULL, 
  sep="\t", log=TRUE, 
  run.column = "Run",
  precursor.column = "Precursor.Id",
  qty.column = "Precursor.Normalised",
  q.columns = c("Q.Value", "Lib.Q.Value", "Lib.PG.Q.Value"), q.cutoffs = 0.01, 
  extra.columns = c("Protein.Group", "Protein.Names", "Genes", "Proteotypic")
  )
# Read Report.tsv from DIA-NN output
# Gordon Smyth and Mengbo Li
# Created 3 July 2023. Last modified 31 Jan 2026.
{
  # Optionally add path to filename
  file <- as.character(file)
  if (!is.null(path)) file <- file.path(path, file)

  # Combine column-name vectors
  Select <- c(run.column, precursor.column, qty.column, q.columns, extra.columns)

  # Detect format
  if(is.null(format)) {
    n <- nchar(file)
    if(n > 3L && substring(file,n-3L,n)==".tsv") {
      format <- "tsv"
    } else {
      if(n > 7L && substring(file,n-7L,n)==".parquet") {
        format <- "parquet"
      } else {
        stop("file doesn't have 'tsv' or 'parquet' extension. Please specify format explicitly.")
      }
    }
  } else {
    format <- match.arg(format, choices = c("tsv", "parquet"))
  }

  # Read DIA-NN report file
  if (format == "tsv") {
    Report <- suppressWarnings(fread(file, sep = sep, select = Select, 
    data.table = FALSE, showProgress = FALSE))
  } else {
    # Use arrow package to read Parquet format file
    suppressPackageStartupMessages(OK <- requireNamespace("arrow",quietly = TRUE))
    if(!OK) stop("arrow package required but is not installed (or can't be loaded)")
    Report <- suppressWarnings(arrow::read_parquet(file))
    Report <- as.data.frame(Report[, Select])
  }

  all.columns <- colnames(Report)
  if (any(!(Select %in% all.columns))) {
    no.in.Select <- setdiff(Select, all.columns)
    message(paste("Columns", paste(no.in.Select, collapse = ","), "not found in file.", sep = " "))
    message("Reading other columns.")
  }
  Select <- intersect(Select, all.columns)
  extra.columns <- intersect(extra.columns, all.columns)
  colnames(Report)[which(colnames(Report) == run.column)] <- "Run"
  colnames(Report)[which(colnames(Report) == precursor.column)] <- "Precursor.Id"
  colnames(Report)[which(colnames(Report) == qty.column)] <- "Intensity"
  
  # Filter by q-values
  if (length(q.columns) > 0L) {
    if (!identical(length(q.cutoffs), length(q.columns))) {
      q.cutoffs <- rep_len(q.cutoffs[1], length(q.columns))
      if(length(q.cutoffs) > 0L) message("Length of q.cutoffs doesn't that of q.columns. Using q.cutoffs[1] for all columns.")
    }
    kp <- rep_len(TRUE, nrow(Report))
    for (qcol in seq_along(q.columns)) {
      kp[ Report[[ q.columns[qcol] ]] > q.cutoffs[qcol] ] <- FALSE
    }
    Report <- Report[kp, ]
  }
  
  # Convert intensities to wide format
  Samples <- unique(Report$Run)
  Precursors <- unique(Report$Precursor.Id)
  y <- matrix(0, length(Precursors), length(Samples))
  mSample <- match(Report$Run, Samples)
  mPrecursor <- match(Report$Precursor.Id, Precursors)
  i <- mPrecursor + (mSample - 1L) * length(Precursors)
  y[i] <- Report$Intensity
  colnames(y) <- Samples
  rownames(y) <- Precursors
  
  # Precursor annotation in wide format
  d <- duplicated(Report$Precursor.Id)
  Genes <- Report[!d, extra.columns, drop = FALSE]
  colnames(Genes) <- extra.columns
  row.names(Genes) <- Precursors
  
  # Output either unlogged EListRaw (with zeros) or logged Elist (with NAs)
  if (log) {
    y[y < 1e-8] <- NA
    y <- log2(y)
    new("EList", list(E = y, genes = Genes))
  } else {
    new("EListRaw", list(E = y, genes = Genes))
  }
}
