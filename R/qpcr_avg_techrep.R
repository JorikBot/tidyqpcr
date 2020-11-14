#' Average technical replicates
#'
#' This function calculates the average of every technical replicate.
#' na.rm is set at TRUE by default.
#'
#' To do: control na.rm from funcion.
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