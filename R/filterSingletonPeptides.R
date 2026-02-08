filterSingletonPeptides <- function(y, ...)
UseMethod("filterSingletonPeptides")

filterSingletonPeptides.default <- function(y, protein.group, min.n.peptides=2L, ...)
# Remove proteins with too few features from matrix
# Created 10 August 2023. Last modified 7 Feb 2026.
{
# Check input
  if(anyNA(protein.group)) stop("NAs not allowed in protein.group")

# Sort by protein
  o <- order(protein.group,row.names(y))
  y <- y[o,,drop=FALSE]
  protein.group <- protein.group[o]

# Special case of min.n==1
  if(min.n.peptides < 2L) return(y)

# Count peptides
  ProteinStart <- which(!duplicated(protein.group))
  ProteinStart <- c(ProteinStart,nrow(y)+1L)
  NPrec <- ProteinStart[-1L] - ProteinStart[-length(ProteinStart)]
  NPrecLong <- rep(NPrec,NPrec)

# Filter
  y[NPrecLong >= min.n.peptides,,drop=FALSE]
}

filterSingletonPeptides.EList <- filterSingletonPeptides.EListRaw <- function(y, protein.group="Protein.Group", min.n.peptides=2, ...)
# Remove proteins with too few peptides from EList
# Created 10 August 2023. Last modified 27 December 2024.
{
# Get protein.group vector
  protein.group <- as.character(protein.group)
  if(identical(length(protein.group),1L)) {
    ColName <- protein.group
    protein.group <- y$genes[[protein.group]]
    if(is.null(protein.group)) stop("Column \"",ColName,"\" not found in y$genes")
  } else {
    if(!identical(nrow(y),length(protein.group))) stop("length(protein.group) must match nrows(y)")
    if(anyNA(protein.group)) stop("NAs not allowed in protein.group")
    y$genes$Protein.Group <- protein.group
  }

# Sort by protein
  o <- order(protein.group,row.names(y))
  y <- y[o,,drop=FALSE]
  protein.group <- protein.group[o]

# Count peptides
  ProteinStart <- which(!duplicated(protein.group))
  ProteinStart <- c(ProteinStart,nrow(y)+1L)
  NPrec <- ProteinStart[-1L] - ProteinStart[-length(ProteinStart)]
  NPrecLong <- rep(NPrec,NPrec)
  y$genes$NPrec <- NPrecLong

# Filter
  y[NPrecLong >= min.n.peptides,]
}
