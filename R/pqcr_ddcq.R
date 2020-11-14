#' Calculate ddCq values
#'
#' This function subtracts the dCq control from the dCq treatments. It also
#' calculates the fold change.
#'
#' @param .data The dataset containing the dCq values.
#' @param dcq Give the name of the column containing the dCq values. If you used
#'   the qpcr_dcq function to create the dataset you don't need to use this
#'   argument.
#' @param treatment Tells the function the name of the column containing the
#'   treatment information. This function cannot deal with multiple treatment
#'   variables yet, for example if you have different additives and timepoints!
#'   In this case I would calculate the ddCq for each additive separately, by
#'   separating the dataset per additive using dplyr::filter.
#' @param untreated Give the value in the treatment column that corresponds with
#'   you untreated control samples.
#' @param primer_pair Give the column name of the column that indicates which
#'   genes were targeted for PCR.
#'
#' @return A tibble
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
