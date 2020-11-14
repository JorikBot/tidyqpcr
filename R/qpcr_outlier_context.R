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
#' @return
#' @export
#'
#' @examples
qpcr_outlier_context <- function(raw_data, clean_data, cq_values, tech_rep, ...){
  #turn some values into strings for joining tables
  dots <- names(enquos(..., .named = TRUE))
  string_tech_rep <- names(enquos(tech_rep, .named = TRUE))
  join2 <- append(dots, string_tech_rep)

  #first find all the outliers
  outliers <- raw_data %>%
    setdiff(clean_data)

  #give outliers extra columns, all TRUE
  extra_col <- outliers %>%
    mutate(outlier = TRUE) %>%
    select(-{{cq_values}})

  #find all triplets with outliers
  triplets <- outliers %>%
    select(-{{cq_values}}) %>%
    select(-{{tech_rep}}) %>%
    left_join(raw_data, by = dots) %>%
    distinct() %>%
    left_join(extra_col, by = join2)
  triplets
}
