#' Calculate mean and sd
#'
#' This function calculates the mean and standard deviation.
#'
#' @param data
#' @param to_summarise
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
qpcr_summary <- function(data, to_summarise, ...){
  summary <- data %>%
    group_by(...) %>%
    summarise(sd = sd({{to_summarise}}, na.rm = TRUE),
              mean = mean({{to_summarise}}, na.rm = TRUE))
  summary
}