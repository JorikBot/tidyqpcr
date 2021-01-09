#' Example small qPCR data set
#'
#' A fictional data set of randomly generated Cq values. Contains all possible
#' outlier cases that qpcr_clean removes.
#'
#' @format A tibble with 81 rows and 4 variables:
#' \describe{
#'   \item{treatment}{Three fictional treatment conditions, where CTRL is the
#'   negative control}
#'   \item{bio_rep}{Number to denote which biological replicate the value
#'                  belongs to}
#'   \item{primer_pair}{Three fictional genes targeted for qPCR, where gene_hk
#'                      is the housekeeping gene}
#'   \item{cq_values}{Number of PCR cycles need to cross a fluorescence
#'   threshold}
#'   }
#' @source Fictional data set created in excel
"ex_data"

