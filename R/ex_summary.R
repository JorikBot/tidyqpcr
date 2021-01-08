#' Example summary data set
#'
#' A fictional data set of randomly generated Cq values. Any outliers have been
#' removed with \code{qpcr_clean}, using a threshold of 1. Technical replicates
#' have been averaged with \code{qpcr_avg}. dCq values have been calculated
#' using \code{qpcr_dcq}. ddCq values have been calculated using \code{qpcr_ddcq}.
#' Mean and standard deviation of the fold change have been calculated with
#' \code{qpcr_summary}
#'
#' @format A tibble with 4 rows and 4 variables:
#' \describe{
#'   \item{treatment}{Three fictional treatment conditions, where CTRL is the
#'   negative control}
#'   \item{primer_pair}{Three fictional genes targeted for qPCR, where gene_hk
#'   is the housekeeping gene}
#'   \item{sd}{Standard deviation of the fold change in gene expression}
#'   \item{mean}{Mean of the fold change in gene expression}
#'   }
#' @source Fictional data set created in excel
"ex_summary"
