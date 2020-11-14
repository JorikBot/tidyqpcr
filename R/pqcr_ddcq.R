#' Calculate ddCq values
#'
#' This function subtracts the dCq control from the dCq treatments.
#' It also calculates the fold change.
#'
#' @param .data
#' @param dcq
#' @param treatment
#' @param untreated
#' @param primer_pair
#'
#' @return
#' @export
#'
#' @examples
qpcr_ddcq <- function(.data, dcq = dcq, treatment, untreated, primer_pair){
  #to do: check inputs. must be dcq values.
  primer_join <- base::names(rlang::enquos(primer_pair, .named = TRUE))

  dcq_ctrl <- .data %>%
    dplyr::filter({{treatment}} == untreated) %>%
    dplyr::group_by({{primer_pair}}) %>%
    dplyr::summarise(dcq_ctrl = base::mean({{dcq}}, na.rm = TRUE))

  ddcq <- .data %>%
    dplyr::filter(treatment != untreated) %>%
    dplyr::inner_join(dcq_ctrl, by = primer_join) %>%
    dplyr::mutate(ddcq = {{dcq}} - dcq_ctrl,
                         fold_change = 2^-ddcq)
  ddcq
}
