EListFromLongFormatFile <- function(
  file="report.tsv", path=NULL,
  format=NULL, sep="\t",
  run.column,
  feature.column,
  intensity.column,
  annotation.columns=NULL,
  q.columns=NULL, q.cutoffs=0.01,
  filter.columns=NULL, filter.values=TRUE,
  censor.value=NULL,
  matrix.columns=NULL,
  log=TRUE,
  verbose=TRUE
)
# Read long format file containing feature intensities
# Created 8 Feb 2026. Last modified 17 Apr 2026.
{
  # Check column vectors
  run.column <- as.character(run.column)
  if(!identical(length(run.column),1L)) stop("Exactly 1 run column must be specified")
  feature.column <- as.character(feature.column)
  if(!(length(feature.column))) stop("At least one feature column must be specified")
  intensity.column <- as.character(intensity.column)
  if(!identical(length(intensity.column),1L)) stop("Exactly 1 intensity column must be specified")

  # Combine column-name vectors
  Required.Columns <- unique(c(run.column, feature.column, intensity.column,
    annotation.columns, q.columns, filter.columns, matrix.columns))

  ## Start file import
 
  if(is.data.frame(file)) {
    Report <- file
  } else {

  # Set path for input file
  file <- as.character(file)
  if(!is.null(path)) file <- file.path(path, file)

  # Detect format from file extension
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

  # Read file
  if (format == "tsv") {
    Report <- suppressWarnings(
      fread(file,sep=sep,select=Required.Columns,data.table=FALSE,showProgress=FALSE)
    )
  } else {
    suppressPackageStartupMessages(OK <- requireNamespace("arrow",quietly=TRUE))
    if(!OK) stop("arrow package required but is not installed (or can't be loaded)")
    Report <- suppressWarnings(
      arrow::read_parquet(file,col_select=Required.Columns)
    )
  }

  } ## End import

  # Check essential columns
  if(!hasName(Report,run.column)) stop("run ID column ",run.column," not found.")
  if(!hasName(Report,intensity.column)) stop("intensity column ",intensity.column," not found.")
  for(fc in feature.column) if(!hasName(Report,fc)) stop("feature column ",fc," not found.")

  # Filter NAs
  if(anyNA(Report[[intensity.column]])) {
    Report <- Report[!is.na(Report[[intensity.column]]),]
  }

  # Limit other columns to headers found in file
  if(length(annotation.columns)) {
    i <- hasName(Report,annotation.columns)
    if(!all(i)) {
      message("Annotation columns ",paste(annotation.columns[!i],collapse=",")," not found.")
      annotation.columns <- annotation.columns[i]
    }
  }
  if(length(q.columns)) {
    q.cutoffs <- rep_len(q.cutoffs,length(q.columns))
    i <- hasName(Report,q.columns)
    if(!all(i)) {
      message("Q-value columms ",paste(q.columns[!i],collapse=",")," not found.")
      q.columns <- q.columns[i]
      q.cutoffs <- q.cutoffs[i]
    }
  }
  if(length(filter.columns)) {
    filter.values <- rep_len(filter.values,length(filter.columns))
    i <- hasName(Report,filter.columns)
    if(!all(i)) {
      message("Filter columms ",paste(filter.columns[!i],collapse=",")," not found.")
      filter.columns <- filter.columns[i]
      filter.values <- filter.values[i]
    }
  }
  if(length(matrix.columns)) {
    i <- hasName(Report,matrix.columns)
    if(!all(i)) {
      message("matrix columms ",paste(matrix.columns[!i],collapse=",")," not found.")
      matrix.columns <- matrix.columns[i]
    }
  }

  # Filter by q-values
  if(length(q.columns)) {
    NObs <- nrow(Report)
    Filter <- rep_len(FALSE, NObs)
    for (j in seq_along(q.columns)) {
      i <- which(Report[[q.columns[j]]] > q.cutoffs[j])
      Filter[i] <- TRUE
    }
    i <- which(Filter)
    if(length(i)) {
      Report <- Report[-i,,drop=FALSE]
      if(verbose) message("Filtered ",length(i)," q-values above q.cutoffs.")
    }
  }

  # Filter columns
  if(length(filter.columns)) {
    NObs <- nrow(Report)
    Filter <- rep_len(FALSE,NObs)
    for (j in seq_along(filter.columns)) {
      i <- which(Report[[filter.columns[j]]]==filter.values[j])
      Filter[i] <- TRUE
    }
    i <- which(Filter)
    if(length(i)) {
      Report <- Report[-i,,drop=FALSE]
      if(verbose) message("Filtered ",length(i)," observations based on filter values.")
    }
  }

  # Left censoring
  if(!is.null(censor.value)) {
    if(min(Report[[intensity.column]],na.rm=TRUE) <= censor.value) {
      i <- which(Report[[intensity.column]] <= censor.value)
      Report <- Report[-i,]
      if(verbose) message("Filtered ",length(i)," observations below lower intensity limit.")
    }
  }

  # Composite feature column
  if(length(feature.column) > 1L) {
    Report$Feature <- do.call(paste,c(Report[,feature.column],sep="."))
    feature.column <- "Feature"
  }

  # Convert intensities to wide format
  Samples <- unique(Report[[run.column]])
  Features <- unique(Report[[feature.column]])
  y <- matrix(0, length(Features), length(Samples))
  mSample <- match(Report[[run.column]], Samples)
  mFeature <- match(Report[[feature.column]], Features)
  i <- mFeature + (mSample - 1L) * length(Features)
  y[i] <- Report[[intensity.column]]
  colnames(y) <- Samples
  rownames(y) <- Features

  # Matrix columns
  if(length(matrix.columns)) {
    Other <- list()
    for (a in matrix.columns) {
      x <- y
      x[i] <- Report[[a]]
      Other[[a]] <- x
    }
  } else {
    Other <- NULL
  }

  # Feature annotation in wide format
  if(length(annotation.columns)) {
    d <- duplicated(Report[[feature.column]])
    Genes <- Report[!d, annotation.columns, drop = FALSE]
    colnames(Genes) <- annotation.columns
    row.names(Genes) <- Features
  } else {
    Genes <- NULL
  }

  # Output either unlogged EListRaw (with zeros) or logged Elist (with NAs)
  if(log) {
    y[y < 1e-8] <- NA
    y <- log2(y)
    E <- new("EList", list(E=y))
  } else {
    E <- new("EListRaw", list(E=y))
  }
  E$genes <- Genes
  E$other <- Other
  E
}
