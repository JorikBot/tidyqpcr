#' Title
#'
#' @param .data
#' @param cq
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
qpcr_avg_techrep <- function(.data, cq, ...){
  .data %>%
    group_by(...) %>%
    summarise(cq = mean({{cq}}, na.rm = TRUE)) %>%
    ungroup()
}
