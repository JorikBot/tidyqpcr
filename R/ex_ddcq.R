#' Example ddCq values data set
#'
#' A fictional data set of randomly generated Cq values. Any outliers have been
#' removed with \code{qpcr_clean}, using a threshold of 1. Technical replicates
#' have been averaged with \code{qpcr_avg}. dCq values have been calculated
#' using \code{qpcr_dcq}. ddCq values have been calculated using \code{qpcr_ddcq}
#'
#' @format A tibble with 10 rows and 9 variables:
#' \describe{
#'   \item{treatment}{Three fictional treatment conditions, where CTRL is the
#'   negative control}
#'   \item{bio_rep}{Number to denote which biological replicate the value
#'                  belongs to}
#'   \item{primer_pair}{Three fictional genes targeted for qPCR, where gene_hk
#'                      is the housekeeping gene}
#'   \item{cq}{Number of PCR cycles need to cross a fluorescence
#'   threshold}
#'   \item{cq_hk}{Cq values of housekeeping control}
#'   \item{dcq}{Cq value gene of interest - Cq value housekeeping gene}
#'   \item{dcq_ctrl}{dCq values of the negative control samples}
#'   \item{ddcq}{dCq treated - dCq control}
#'   \item{fold_change}{Estimated fold change in gene expression. 2^-ddcq}
#'   }
#' @source Fictional data set created in excel
"ex_ddcq"
