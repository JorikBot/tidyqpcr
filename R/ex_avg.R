#' Example averaged qPCR data set
#'
#' A fictional data set of randomly generated Cq values. Any outliers have been
#' removed with \code{qpcr_clean}, using a threshold of 1. Technical replicates
#' have been averaged with \code{qpcr_avg}.
#'
#' @format A tibble with 24 rows and 4 variables:
#' \describe{
#'   \item{treatment}{Three fictional treatment conditions, where CTRL is the
#'   negative control}
#'   \item{bio_rep}{Number to denote which biological replicate the value
#'                  belongs to}
#'   \item{primer_pair}{Three fictional genes targeted for qPCR, where gene_hk
#'                      is the housekeeping gene}
#'   \item{cq}{Number of PCR cycles need to cross a fluorescence
#'   threshold}
#'   }
#' @source Fictional data set created in excel
"ex_avg"
