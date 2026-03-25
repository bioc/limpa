plotAveVsMis <- function(y)
# Plot average log-intensity vs number of missing values.
# Created 25 Mar 2026.
{
  y <- as.matrix(y)
  NMis <- rowSums(is.na(y))
  Ave <- rowMeans(y,na.rm=TRUE)
  boxplot(Ave~NMis,range=0,xlab="Number of missing values",ylab="Average Observed Log-Intensity")
}

