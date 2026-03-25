\name{limpanews}
\title{limpa News}
\encoding{UTF-8}


\section{Version 1.3.10 (2026-03-25)}{\itemize{
\item
New function plotAveVsMis().

\item
dpcCN() now uses a systematic rather than a random sample of rows.
Amongst other things, this ensures that the result does not change if the rows of `y` are reordered.

\item
Rename argument `sample.column` to `run.column` in EListFromLongFormatFile(), readDIANN() and readSpectronaut().

\item
Use of `base::is.unsorted` for more efficient checking of whether proteins are already sorted in two functions.
}}


\section{Version 1.3.9 (2026-03-08)}{\itemize{
\item
plotPeptides() now allows users to set the x and y axis labels, same as plotProtein().
}}


\section{Version 1.3.8 (2026-03-07)}{\itemize{
\item
EListFromLongFormatFile(), readDIANN(), and readSpectronaut() now allow `feature.column`
to be a vector of arbitrary length, which allows reading of fragment level data and reading
of MSstats format files.

EListFromLongFormatFile(), readDIANN(), and readSpectronaut() now allow `file` to be a 
data.frame.
}}


\section{Version 1.3.7 (2026-02-19)}{\itemize{
\item
New function filterByDetection(), to choose proteins detected in at least a specified number of samples.

\item
New function EListFromLongFormatFile() to read intensities from a long format file.
readDIANN() and readSpectronaut() now call this function.

\item
Argument `run.column` of readDIAN() renamed to `sample.column`.
Argument `extra.columns` of readDIAN() renamed to `annotation.columns`.
readDIANN() now longer accepts a data.frame instead of a file.

\item
Argument `run.column` of readSpectronaut() renamed to `sample.column`.
Argument `extra.columns` of readSpectronaut() renamed to `annotation.columns`.
New arguments `isimputed.column` and `censor.value` for readSpectronaut(), making explicit operations that were already built-into readSpectronaut().

\item
dpcImpute() now gives a deprecation message in favor of dpcQuantByRow().
}}


\section{Version 1.3.6 (2026-02-08)}{\itemize{
\item
Change of terminology from "peptides" to "precursors" for the default unit of input data throughout the package.
More discussion of precursors vs peptides and other levels of data in the vignette.
Further clarification of the different levels of data that limpa can process.

\item
The output column `genes$NPeptides` from dpcQuant() renamed to `genes$NPrec`.

\item
Progress message from dpcQuant() and dpcQuantByRows() now says "Precursors" instead of "Peptides" for the number of rows.
Percentage progress has also been added.

\item
New argument `verbose` for readDIANN(). If `TRUE`, now gives message about number of filtered q-values.

\item
Bug fix to readDIANN() to avoid unnecessary message about `q.cutoffs` not being the correct length, when it is actually of length 1.
Other code streamlining for readDIANN().

\item
Add filtering based on number of detected samples to DIA-NN and Spectronaut HYE case studies (on external website).
}}


\section{Version 1.3.5 (2026-01-31)}{\itemize{
\item
The upper limit of the y-axis in the plot from plotDPC() is now extended slightly to allow for jittering of the detection proportions. Previously some of the jittered proportions above 1 where not shown on the plot.

\item
New argument `show.start` for plotDPC() to control whether the starting curve from dpc() is shown on the plot as well as the final plot.
Default is now `FALSE`, whereas previously the starting curve was always shown.

\item
In dpcCN(), default value for `subset` increased to 2000 and default value for `verbose` reset to `FALSE`.

\item
Axis labels produced by plotProtein() are now user-settable.

\item
Vignette now cites Corso et al (2026) as IP-MS example.

\item
Vignette now has a "Further documentation" section that links out to case studies, FAQ and reference manual.
The case studies are given as one link instead of listing them individually.
}}


\section{Version 1.3.3 (2025-12-30)}{\itemize{
\item
dpcImpute() renamed to dpcQuantByRow() (although old function name will continue to work for backward compatibility).

\item
New case study section in vignette linking out to several external vignettes and to a FAQ.
The DIA-NN case study is also now external, on the limpa GitHub website.

\item
When operating on an EList, dpcQuant() now removes the protein ID
annotation column from the output object so that the 
IDs appear only as row.names.
dpcQuant() also stores the DPC and the hyperparameters in the output EList object.

\item
plotPeptides() now plots sample names, same as plotProtein().

\item
The y-axis from plotPeptides() is now labelled "Log-intensities"
instead of "Log-expression".

\item
New argument `las` for plotProtein() and plotPeptides() to allow vertical orientation of sample names on x-axis.
}}


\section{Version 1.2.1 (2025-11-15)}{\itemize{
\item
readDIANN() now detects format automatically from file extension.
Default file name updated to `"report.parquet"` instead of `"Report.tsv"`.

\item
Update default `q.columns` for readDIANN().

\item
Mention readFragPipe() and readMaxQuant() in vignette.

\item
Add GitHub URL to DESCRIPTION.
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
