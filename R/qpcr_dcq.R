#' Calculate dCq values
#'
#' This function subtracts the housekeeping gene Cq values from the experimental genes Cq values.
#'
#' @param .data
#' @param cq
#' @param primer_pair
#' @param housekeeping
#' @param ...
#'
#' @return A tibble
#' @export
#'
#' @examples
qpcr_dcq <- function(.data, cq, primer_pair, housekeeping, ...){
  # to do: add if statements to check input. no column called cq etc.
  dots <- base::names(rlang::enquos(..., .named = TRUE))

  cq_hk <- .data %>%
    dplyr::filter({{primer_pair}} == housekeeping) %>%
    dplyr::mutate(cq_hk = {{cq}}) %>%
    dplyr::select(..., cq_hk)

  dcq_values <- .data %>%
    dplyr::filter({{primer_pair}} != housekeeping) %>%
    dplyr::inner_join(cq_hk, by = dots) %>%
    dplyr::mutate(dcq = {{cq}} - cq_hk)
  dcq_values
}
