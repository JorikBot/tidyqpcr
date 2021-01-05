#' Calculate dCq values
#'
#' This function subtracts the housekeeping gene Cq values from the experimental
#' genes Cq values.
#'
#' @param .data The name of the dataset containing the average Cq values.
#' @param cq Give the name of the column containing the (averaged) Cq values. If
#'   you used the qpcr_avg_techrep function this column is called 'cq'.
#' @param primer_pair Supplies the name of the column that denotes which gene
#'   was the target of the PCR.
#' @param housekeeping Give the value of your housekeeping gene, in quotes, as
#'   it occurs in your primer_pair column.
#' @param ... All other column names excluding columns for: cq values, technical
#'   replicates and primers used.
#'
#' @return A tibble
#' @export
#'
#' @examples
qpcr_dcq <- function(.data, cq, primer_pair, housekeeping, ...) {
  # to do: add if statements to check input. no column called cq etc.
  dots <- base::names(rlang::enquos(..., .named = TRUE))

  cq_hk <- .data %>%
    dplyr::filter({{ primer_pair }} == housekeeping) %>%
    dplyr::mutate(cq_hk = {{ cq }}) %>%
    dplyr::select(..., cq_hk)

  dcq_values <- .data %>%
    dplyr::filter({{ primer_pair }} != housekeeping) %>%
    dplyr::inner_join(cq_hk, by = dots) %>%
    dplyr::mutate(dcq = {{ cq }} - cq_hk)
  dcq_values
}
