#' Title
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
  primer_join <- names(enquos(primer_pair, .named = TRUE))

  dcq_ctrl <- .data %>%
    filter({{treatment}} == untreated) %>%
    group_by({{primer_pair}}) %>%
    summarise(dcq_ctrl = mean({{dcq}}, na.rm = TRUE))

  ddcq <- .data %>%
    filter(treatment != untreated) %>%
    inner_join(dcq_ctrl, by = primer_join) %>%
    mutate(ddcq = {{dcq}} - dcq_ctrl,
           fold_change = 2^-ddcq)
  ddcq
}
