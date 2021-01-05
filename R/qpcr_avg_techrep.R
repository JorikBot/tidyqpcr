#' Average technical replicates
#'
#' This function calculates the average of every technical replicate. na.rm is
#' set at TRUE by default.
#'
#' To do: control na.rm from funcion.
#'
#' @param .data The name of your (cleaned) dataset.
#' @param cq The name of the column containing the Cq values.
#' @param ... All other column names, excluding the columns containing the Cq
#'   values or technical replicates. Give them unquoted and separated by a
#'   comma.
#'
#' @return A tibble
#' @export
#'
#' @examples
qpcr_avg_techrep <- function(.data, cq, ...) {
  .data %>%
    dplyr::group_by(...) %>%
    dplyr::summarise(cq = mean({{ cq }}, na.rm = TRUE)) %>%
    dplyr::ungroup()
}
