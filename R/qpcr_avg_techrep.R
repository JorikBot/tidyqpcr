#' Average technical replicates
#'
#' This function calculates the average of every technical replicate. na.rm is
#' set at TRUE by default.
#'
#' @param .data A data frame or tibble.
#' @param cq Unquoted expression. The name of the column containing the Cq
#'   values.
#' @param ... Tidy-select. One or more unquoted expressions separated by commas.
#'   All the names of columns that denote your experimental variables (and
#'   biological replicates). The average will be taken for every unique
#'   combination of values in the supplied columns. Be sure to exclude the
#'   columns containing the Cq values or technical replicates.
#'
#' @return A tibble
#' @export
#'
#' @examples
qpcr_avg_techrep <- function(.data, cq, na.rm = TRUE, ...) {
  .data %>%
    dplyr::group_by(...) %>%
    dplyr::summarise(cq = mean({{ cq }}, na.rm)) %>%
    dplyr::ungroup()
}
