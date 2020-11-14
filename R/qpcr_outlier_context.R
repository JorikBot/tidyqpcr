#' Show outlier context
#'
#' Shows all the technical replicates that contain at least one outlier.
#' This function takes the raw data and the output from qpcr_clean() as input.
#'
#'
#' @param raw_data
#' @param clean_data
#' @param cq_values
#' @param tech_rep
#' @param ...
#'
#' @return A tibble
#' @export
#'
#' @examples
qpcr_outlier_context <- function(raw_data, clean_data, cq_values, tech_rep, ...){
  #turn some values into strings for joining tables
  dots <- base::names(rlang::enquos(..., .named = TRUE))
  string_tech_rep <- base::names(rlang::enquos(tech_rep, .named = TRUE))
  join2 <- base::append(dots, string_tech_rep)

  #first find all the outliers
  outliers <- raw_data %>%
    base::setdiff(clean_data)

  #give outliers extra columns, all TRUE
  extra_col <- outliers %>%
    dplyr::mutate(outlier = TRUE) %>%
    dplyr::select(-{{cq_values}})

  #find all triplets with outliers
  triplets <- outliers %>%
    dplyr::select(-{{cq_values}}) %>%
    dplyr::select(-{{tech_rep}}) %>%
    dplyr::left_join(raw_data, by = dots) %>%
    dplyr::distinct() %>%
    dplyr::left_join(extra_col, by = join2)
  triplets
}
