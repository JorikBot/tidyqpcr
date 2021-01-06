#' tidyqpcr: A package for tidy qpcr data analysis.
#'
#' The tidyqpcr package provides functions for finding and removing outliers,
#' averaging technical replicates, calculating dCq values and calculating ddCq
#' values.
#'
#' @section Package functions:
#' \itemize{
#'   \item \code{\link{qpcr_clean}} is used to remove
#'   outliers based on a given maximum deviation from the median Cq value.
#'   \item \code{\link{qpcr_outlier_context}} can be used to find all the technical
#'   replicate groups that contain at least one outlier.
#'   \item \code{\link{qpcr_avg_techrep}} averages technical replicates.
#'   \item \code{\link{qpcr_dcq}} calculates the dCq values.
#'   \item \code{\link{qpcr_ddcq}} calculates the ddCq values.
#'   \item \code{\link{qpcr_summary}} is used to quickly calculate the mean
#'   and standard deviation for a given column.
#' }
#'
#' @docType package
#' @name tidyqpcr
NULL
#> NULL
