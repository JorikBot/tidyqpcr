#' Calculate mean and sd
#'
#' This function calculates the mean and standard deviation.
#'
#' @param data The dataset you want to summarize, a tibble.
#' @param to_summarise The column you want to apply the function to, for example
#'   the fold change values.
#' @param ... The variables you want to group your data by. Mean and SD will be
#'   calculated for every unique combination of these variables.
#'
#' @return A tibble
#' @export
#'
#' @examples
qpcr_summary <- function(data, to_summarise, ...){
  summary <- data %>%
    dplyr::group_by(...) %>%
    dplyr::summarise(sd = stats::sd({{to_summarise}}, na.rm = TRUE),
              mean = base::mean({{to_summarise}}, na.rm = TRUE))
  summary
}
