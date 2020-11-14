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
#' @return
#' @export
#'
#' @examples
qpcr_dcq <- function(.data, cq, primer_pair, housekeeping, ...){
  # to do: add if statements to check input. no column called cq etc.
  dots <- names(enquos(..., .named = TRUE))

  cq_hk <- .data %>%
    filter({{primer_pair}} == housekeeping) %>%
    mutate(cq_hk = {{cq}}) %>%
    select(..., cq_hk)

  dcq_values <- .data %>%
    filter({{primer_pair}} != housekeeping) %>%
    inner_join(cq_hk, by = dots) %>%
    mutate(dcq = {{cq}} - cq_hk)
  dcq_values
}