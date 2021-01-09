#'Show replicates that contain outliers
#'
#'\code{qpcr_outlier_context} shows all the technical replicates that contain at
#'least one outlier. This function takes the raw data and the output from
#'\code{qpcr_clean} as input.
#'
#'To Do: ... can be removed. What happens when no tech rep column?
#'
#'@param raw_data A data frame or tibble. Here you supply the raw unfiltered
#'  data.
#'@param clean_data A data frame or tibble. Here you supply the cleaned data
#'  from the qpcr_clean function.
#'@param ... Tidy-select. One or more unquoted expressions separated by commas.
#'  All other column names, excluding the column containing the Cq values.
#'
#'@return Returns the same type as the input (e.g. a data frame or tibble). Only
#'  the rows of technical replicate group containing at least one outlier are
#'  returned. The values that are deemed outliers are marked with TRUE in the
#'  column "outlier".
#'@export
#'
#' @examples
#' outlier_triplets <- qpcr_outlier_context(raw_data = ex_data,
#'                                          clean_data = ex_clean,
#'                                          treatment, bio_rep, primer_pair)
qpcr_outlier_context <- function(raw_data, clean_data, ...) {
  # first find all the outliers
  outliers <- dplyr::setdiff(raw_data, clean_data)

  # give outliers extra columns, all TRUE
  outlier_col <- outliers %>%
    dplyr::mutate(outlier = TRUE)

  triplets <- raw_data %>%
    # mark all removed values in full data set
    dplyr::left_join(outlier_col) %>%
    # find technical reps with >= 1 outlier
    dplyr::group_by(...) %>%
    dplyr::filter(sum(outlier, na.rm = TRUE) > 0) %>%
    #replace NA with FALSE in outlier column
    dplyr::ungroup() %>%
    dplyr::mutate(outlier = dplyr::if_else(is.na(outlier) == TRUE, FALSE, TRUE))
  triplets
}

