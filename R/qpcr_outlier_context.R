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
#'@param cq_values Unquoted expression. Give name of the column containing the
#'  cq values.
#'@param tech_rep Unquoted expression. Give the name of the column containing
#'  the technical replicate information.
#'@param ... Tidy-select. One or more unquoted expressions separated by commas.
#'  All other column names, excluding the columns containing the Cq values or
#'  technical replicates.
#'
#'@return Returns the same type as the input (e.g. a data frame or tibble). Only
#'  the rows of technical replicate group containing at least one outlier are
#'  returned. The values that are deemed outliers are marked with TRUE in the
#'  column "outlier".
#'@export
#'
#' @examples
qpcr_outlier_context <- function(raw_data, clean_data, cq_values, tech_rep, ...) {
  # turn some values into strings for joining tables
  dots <- base::names(rlang::enquos(..., .named = TRUE))
  string_tech_rep <- base::names(rlang::enquos(tech_rep, .named = TRUE))
  join2 <- base::append(dots, string_tech_rep)

  # first find all the outliers
  outliers <- raw_data %>%
    base::setdiff(clean_data)

  # give outliers extra columns, all TRUE
  extra_col <- outliers %>%
    dplyr::mutate(outlier = TRUE) %>%
    dplyr::select(-{{ cq_values }})

  # find all triplets with outliers
  triplets <- outliers %>%
    dplyr::select(-{{ cq_values }}) %>%
    dplyr::select(-{{ tech_rep }}) %>%
    dplyr::left_join(raw_data, by = dots) %>%
    dplyr::distinct() %>%
    dplyr::left_join(extra_col, by = join2)
  triplets
}
