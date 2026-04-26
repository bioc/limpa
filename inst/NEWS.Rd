\name{limpanews}
\title{limpa News}
\encoding{UTF-8}


\section{Version 1.4.0 (2026-04-29)}{\itemize{
\item
A limpa documentation page has been created at https://github.com/SmythLab/limpa/
containing a number of case study analyses of real datasets.
This URL has been addded to the package DESCRIPTION file
and the package vignette now has a "Further documentation" section that links out to this site.

\item
Change of terminology from "peptides" to "precursors" as the default unit of input data throughout the package.
More discussion of precursors vs peptides and other levels of data in the vignette.

\item
Further clarification in the vignette that limpa can process any level of data for which intensities are available,
including fragments, precursors, peptides, proteins, or PTMs.
limpa can summarize precursors to either peptides or proteins
and can conduct differential analyses at any level.
The vignette now cites the Corso et al (2026) preprint as an IP-MS example.
limpa can also explore isoform-specific expression by
conducting differential usage analyses of peptides or PTMs within proteins,
and there is a case study of such an analysis at https://github.com/SmythLab/limpa/.

\item
As part of the above change, the output column `genes$NPeptides` from dpcQuant() nas been renamed to `genes$NPrec`,
and the progress message from dpcQuant() and dpcQuantByRows()
now says "Precursors" instead of "Peptides" for the number of rows.
(The column name and message are generic:
the column name will still be `NPrec` and the message will still say "Precursors" even if
fragments are being processed instead of precursors.)
Percentage progress has also been added to the progress message.

\item
A new function EListFromLongFormatFile() has been added to read intensities from any long format file,
and readDIANN() and readSpectronaut() now call this function instead of handling their own read code.
The input file can be either an uncompressed delimited text file or a Parquet file,
and the file type is detected automatically from the file name.
The new function uses the nanoparquet package to read Parquet
files whereas readDIANN() previously used arrow.
The new function adds a number of new arguments and changes the names of some existing arguments.
It allows filtering by any number of columns and allows reading of observation-level covariates.
All three functions now allow `feature.column` to be a vector of arbitrary length,
which allows columns to be combined to created a unique precursor or fragment ID.
Amongst other things, this functionality facilitates reading of fragment level data
and reading of MSstats format files.
All three functions have a new argument `verbose` to optionally output
progress information and the number of intensity values that have been filtered.

\item
readDIAN() has a new argument list to match EListFromLongFormatFile().
The old argument `precursor.column` is renamed to `feature.column`,
`qty.column` to `intensity.column`, and `extra.columns` to `annotation.columns`.
Default setting for `q.columns` is updated.

\item
readSpectronaut() has a new argument list to match EListFromLongFormatFile().
The old argument `precursor.column` is renamed to `feature.column`, `qty.column` to `intensity.column`, and `extra.columns` to `annotation.columns`.
New arguments `filter.columns` and `censor.value` give more flexibility over filtering.

\item
New function readSpectronautRunInfo(), which is called by readSpectronaut()
to include run (sample) information in the `targets` component of the output.

\item
New function plotAveVsMis() to plot average observed log-intensity per row vs the number of missing values.

\item
dpc() has been replaced by a new function that combines the functionalities of
dpcON() and dpcCN(), with the CN method as the default.
The original dpc() function has been renamed to dpcLegacy().

\item
dpcCN() now uses a systematic rather than a random sample of rows.
Amongst other things, this ensures that the result does not change if the rows of `y` are reordered.
The default value for `subset` is increased to 2000 and the default value for `verbose` is now `FALSE`.

\item
The upper limit of the y-axis in the plot from plotDPC() is now extended slightly to allow for jittering of the detection proportions. Previously some of the jittered proportions above 1 were not shown on the plot.

\item
New argument `show.start` for plotDPC() to control whether the starting curve from dpc() is shown on the plot as well as the final plot.
Default is now `FALSE`, whereas previously the starting curve was always shown.

\item
dpcImpute() renamed to dpcQuantByRow() (although old function name will continue to work for backward compatibility).

\item
When operating on an EList, dpcQuant() now removes the protein ID
annotation column from the output object so that the 
IDs appear only as row.names.
dpcQuant() also stores the DPC and the hyperparameters in the output EList object.

\item
New function filterByDetection(), to choose proteins detected in at least a specified number of samples.

\item
Axis labels produced by plotPeptides() and plotProtein() are now user-settable.
plotPeptides() now plots sample names, in the same style as plotProtein(),
and the y-axis is now labelled "Log-intensities" instead of "Log-expression".

\item
New argument `las` for plotProtein() and plotPeptides() to allow vertical orientation of sample names on x-axis.

\item
readFragPipe() and readMaxQuant() are now mentioned in the vignette.

\item
Acknowledgement section added to vignette.

\item
A number of programming efficiencies have been introduced to various functions.
}}


\section{Version 1.2.0 (2025-10-28)}{\itemize{
\item
New function readFragPipe() to read FragPipe output.

\item
New function readMaxQuant() to read MaxQuant output.

\item
readDIANN() now allows user-specified input column names and "parquet" is now the default format.

\item
Bug fixes to readSpectronaut() when `sep` is other than a tab or 
when there is only one peptide annotation column.

\item
Revisions to all the read functions.
readDIANN(), readFragPipe(), readMaxQuant(), and readSpectronaut() all use `fread()` with `data.table=FALSE` now to read ascii delimited files.

\item
New argument `logit.p` for dztbinom(), which allows the function to avoid subtractive cancellation for success probabilities close to 1.
dpc() now uses the new argument when calling dztbinom().

\item
New function dpcON() to estimate the DPC assuming the oberved-normal model.
Should give same output as dpc() but is somewhat faster.
dpcON() calls a new function, pztbinomSameSizeLogitPBothTails(), which computes left and right tail p-values for 
zero-truncated binomial quantiles.

\item
Revisions to dpcCN() to improve convergence.
To improve speed, the function now randomly selects a subset of rows of data to process, with the number of rows given by the new argument `subset`.
The default number of outer iterations is decreased to 2.

\item
dpcImpute() now sets row.names.
Sections on dpcImpute() and imputeByExpTilt() have been added to the package vignette.

\item
dpcQuant() now calls dpcImpute() automatically when all proteins have just one peptide.

\item
New function plotPeptides() to plot the peptide-level log-intensities for one protein.

\item
Fix simProteinDataSet() processing of `prop.missing` argument.

\item
Cite the limpa bioRxiv preprint (Li et al, bioRxiv 2025) in the vignette and help pages.

\item
Expand Quantification section in the vignette to give more math details.
}}


\section{Version 1.0.0 (2025-04-16)}{\itemize{
\item
dpcQuant() and peptides2Proteins() now return essentially equal values if there are 
multiple entirely imputed values for the same protein.

\item
Update readSpectronaut() to allow more flexibility regarding which columns are read.

\item
Remove reference to DIA in vignette, because limpa works for both DIA and DDA.

\item
New function plotMDSUsingSEs(), which accounts for standard errors when computing between-sample distances for the plot.

\item
New argument `chunk` for dpcQuant() and dpcImpute().

\item
dpcImpute() now passes the `verbose` argument to peptides2Proteins().

\item
Add more background information to the vignette, including references for DIA-NN, Spectronaut and MaxQuant.
Add mention of voomaLmFitWithImputation().

\item
Bug fix to starting values in peptides2Proteins() for single-peptide proteins.

\item
expTiltByColumns() is now more robust for datasets with very few rows, especially when the column variance is exactly zero by chance.
It originally assumed that the number of rows would always be large.
This also improves the robustness of imputeByExpTilt().

\item
peptides2Proteins() now runs imputeByExpTilt() on the whole dataset in order to get starting values for each protein.
This improves speed slightly and makes the starting values more robust for large datasets with many NAs.

\item
readDIANN() now supports DIA-NN output in either tsv or Parquet formats.

\item
New functions dpcImpute() and dpcImputeHyperparam() to facilitate imputation and differential expression analysis at the peptide level.
This may be needed for phosphoproteomics and analogous applications.

\item
Package title changed to "Quantification and Differential Analysis of Proteomics Data", and package description expanded.

\item
New function plotProtein(), to plot the quantifications for a given protein with error bars.

\item
Cleanup annotation output from dpcQuant() to remove peptide-level annotation columns

\item
dpc() now outputs `n.detected` for each peptide.

\item
dpc() now checks for peptides that are entirely missing.

\item
plotDPC() now accepts input from either dpc() or dpcCN().
It now estimates the jittering amount automatically.

\item
Add readDIANN() code to vignette.

\item
Add peptide filtering to vignette.

\item
New function voomaLmFitWithImputation(), which is the same as limma::voomaLmFit() except that it allows for loss of degrees of freedom when all the values for a particular protein in a particular group are imputed.
dpcDE() now calls this new function instead of limma::voomaLmFit(), making the differential expression analysis more robust to high rates of missing values.

\item
Fix dpcQuant() `genes` output when the input `y` is a plain matrix instead of an `EList` object.

\item
New argument `dpc.slope` for dpcQuant(), to allow the use of a preset DPC slope.

\item
estimateDPCIntercept() now allows `dpc.slope=0`, corresponding to the case that missing values are uninformative.
}}


\section{Version 0.99.0 (2025-01-03)}{\itemize{
\item
Initial public release of the limpa package ("Linear Models for Proteomics Data")
at \url{https://github.com/SmythLab/limpa} with the following exported functions:
completeMomentsON, dpc, dpcCN, dpcDE, dpcQuant, dpcQuant.default,
dpcQuant.EList, dpcQuantHyperparam, dztbinom, estimateDPCIntercept, expTiltByColumns,
expTiltByRows, filterCompoundProteins, filterCompoundProteins.default,
filterCompoundProteins.EList, filterCompoundProteins.EListRaw,
filterNonProteotypicPeptides, filterNonProteotypicPeptides.default,
filterNonProteotypicPeptides.EList, filterNonProteotypicPeptides.EListRaw,
filterSingletonPeptides, filterSingletonPeptides.default,
filterSingletonPeptides.EList, filterSingletonPeptides.EListRaw,
fitZTLogit, imputeByExpTilt, imputeByExpTilt.default,
imputeByExpTilt.EList, imputeByExpTilt.EListRaw, observedMomentsCN,
peptides2ProteinBFGS, peptides2ProteinNewton, peptides2Proteins,
peptides2ProteinWithoutNAs, plotDPC, proteinResVarFromCompletePeptideData,
pztbinom, readDIANN, readSpectronaut, removeNARows, removeNARows.default,
removeNARows.EList, simCompleteDataCN, simCompleteDataON, simProteinDataSet.
}}
