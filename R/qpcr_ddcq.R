#' Calculate ddCq values
#'
#' \code{qpcr_ddcq} subtracts the dCq control from the dCq treatment(s). It also
#' calculates the fold change.
#'
#' @aliases qpcr_ddct qpcr_ddcp
#'
#' @param .data A data frame or tibble. It should already contain the dCq
#'   values.
#' @param dcq Unquoted expression. Give the name of the column containing the
#'   dCq values. If you used the qpcr_dcq function to create the data set this
#'   column is called 'dcq'.
#' @param treatment Unquoted expression. Tells the function the name of the
#'   column containing the treatment information. This function cannot deal with
#'   multiple treatment variables yet, for example if you have different
#'   additives and time points! In this case I would calculate the ddCq for each
#'   additive separately, by separating the data set per additive using dplyr's
#'   \code{filter}.
#' @param untreated Quoted expression. Give the value in the treatment column
#'   that corresponds with you untreated control samples.
#' @param pcr_target Unquoted expression. Give the name of the column
#'   that indicates which genes were targeted for PCR.
#'
#' @return A tibble
#' @export
#'
#' @examples
qpcr_ddcq <- function(.data, dcq = dcq, treatment, untreated, pcr_target) {
  # to do: check inputs. must be dcq values.
  primer_join <- base::names(rlang::enquos(pcr_target, .named = TRUE))

  dcq_ctrl <- .data %>%
    dplyr::filter({{ treatment }} == untreated) %>%
    dplyr::group_by({{ pcr_target }}) %>%
    dplyr::summarise(dcq_ctrl = base::mean({{ dcq }}, na.rm = TRUE))

  ddcq <- .data %>%
    dplyr::filter(treatment != untreated) %>%
    dplyr::inner_join(dcq_ctrl, by = primer_join) %>%
    dplyr::mutate(
      ddcq = {{ dcq }} - dcq_ctrl,
      fold_change = 2^-ddcq
    )
  ddcq
}
