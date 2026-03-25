EListFromLongFormatFile <- function(
  file="report.tsv", path=NULL,
  format=NULL, sep="\t",
  run.column,
  feature.column,
  intensity.column,
  annotation.columns=character(0),
  q.columns=character(0), q.cutoffs=0.01,
  isimputed.column=NULL,
  censor.value=NULL,
  log=TRUE,
  verbose=TRUE
)
# Read long format file containing feature intensities
# Created 8 Feb 2026. Last modified 24 Mar 2026.
{
  # Check column vectors
  run.column <- as.character(run.column)
  if(!identical(length(run.column),1L)) stop("Exactly 1 sample column must be specified")
  feature.column <- as.character(feature.column)
  if(!(length(feature.column))) stop("At least one feature column must be specified")
  intensity.column <- as.character(intensity.column)
  if(!identical(length(intensity.column),1L)) stop("Exactly 1 intensity column must be specified")
  if(length(isimputed.column) > 1L) stop("Only one imputation column allowed.")

  # Combine column-name vectors
  Required.Columns <- unique(c(run.column, feature.column, intensity.column,
    annotation.columns, q.columns, isimputed.column))

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
    suppressPackageStartupMessages(OK <- requireNamespace("nanoparquet",quietly=TRUE))
    if(!OK) stop("nanoparquet package required but is not installed (or can't be loaded)")
    Report <- suppressWarnings(
      nanoparquet::read_parquet(file,col_select=Required.Columns)
    )
  }

  } ## End import

  # Check essential columns
  if(!hasName(Report,run.column)) stop("sample column ",run.column," not found.")
  if(!hasName(Report,intensity.column)) stop("intensity column ",intensity.column," not found.")
  for(fc in feature.column) if(!hasName(Report,fc)) stop("feature column ",fc," not found.")

  # Filter NAs
  if(anyNA(Report[[intensity.column]])) {
    Report <- Report[!is.na(Report[[intensity.column]]),]
  }

  # Limit other columns to headers found in file
  i <- hasName(Report,annotation.columns)
  if(!all(i)) {
    message("Annotation columns ",paste(annotation.columns[!i],collapse=",")," not found.")
    annotation.columns <- annotation.columns[i]
  }
  i <- hasName(Report,q.columns)
  if(!all(i)) {
    message("Q-value columms ",paste(q.columns[!i],collapse=",")," not found.")
    q.columns <- q.columns[i]
  }
  if(length(isimputed.column))
    if(!hasName(Report,isimputed.column)) {
      message("Imputation column ",isimputed.column," not found.")
      isimputed.column <- character(0)
    }

  # Filter by q-values
  if(length(q.columns)) {
    q.cutoffs <- rep_len(q.cutoffs,length(q.columns))
    NObs <- nrow(Report)
    keep <- rep_len(TRUE, NObs)
    for (j in seq_along(q.columns)) {
      keep[ Report[[ q.columns[j] ]] > q.cutoffs[j] ] <- FALSE
    }
    Report <- Report[keep,]
    if(verbose && nrow(Report) < NObs) message("Filtered ",NObs-nrow(Report)," q-values above q.cutoffs.")
  }
   
  # Filter imputed values
  if(length(isimputed.column)) {
    if(is.logical(Report[[isimputed.column]])) {
      if(any(Report[[isimputed.column]])) {
        NObs <- nrow(Report)
        Report <- Report[!Report[[isimputed.column]],]
        if(verbose) message("Filtered ",NObs-nrow(Report)," imputed values.")
      }
    } else {
      warning("isimputed column",isimputed.column,"doesn't contain TRUE/FALSE values.")
    }
  }

  # Left censoring
  if(!is.null(censor.value)) {
    if(min(Report[[intensity.column]],na.rm=TRUE) <= censor.value) {
      i <- which(Report[[intensity.column]] <= censor.value)
      Report <- Report[-i,]
      if(verbose) message("Filtered ",length(i)," values below lower intensity limit.")
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
    new("EList", list(E = y, genes = Genes))
  } else {
    new("EListRaw", list(E = y, genes = Genes))
  }
}
