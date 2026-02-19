filterByDetection <- function(y, n.samples=3, n.detections=1)
# Given limpa EList, choose proteins that are detected in at least a specified number of samples
# Created 14 Feb 2026.
{
  if(is.null(y$other$n.observations)) stop("n.observations not found.")
  rowSums(y$other$n.observations > (n.detections-0.25)) > (n.samples-0.25)
}
