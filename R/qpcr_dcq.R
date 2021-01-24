#' Calculate dCq values
#'
#' \code{qpcr_dcq} subtracts the housekeeping gene Cq values from the
#' experimental genes Cq values.
#'
#' @aliases qpcr_dct qpcr_dcp
#'
#' @param .data A data frame or tibble.
#' @param cq Unquoted expression. Give the name of the column containing the
#'   (averaged) Cq values. If you used the qpcr_avg_techrep function this column
#'   is called 'cq'.
#' @param pcr_target Unquoted expression. Supply the name of the column that
#'   denotes which gene was the target of the qPCR.
#' @param housekeeping Quoted expression. Give the value of your housekeeping
#'   gene as it occurs in your pcr_target column.
#'
#' @return Returns the same type as the input (e.g. a data frame or tibble).
#'   Creates 2 new columns. "cq_hk" moves the housekeeping Cq values into its
#'   own column. "dcq" contains the calculated dCq values.
#' @export
#'
#' @examples
#' dcq_values <- qpcr_dcq(ex_avg,
#'                        cq = cq,
#'                        pcr_target = primer_pair,
#'                        housekeeping = "gene_hk")
qpcr_dcq <- function(.data, cq, pcr_target, housekeeping) {
  # to do: add if statements to check input. no column called cq etc.

  #find columns for the join
  data_colnames <- base::colnames(.data)
  notuse_join <- base::names(rlang::enquos(cq, pcr_target, .named = TRUE))
  use_join <- dplyr::setdiff(data_colnames, notuse_join)

  cq_hk <- .data %>%
    dplyr::filter({{ pcr_target }} == housekeeping) %>%
    dplyr::rename(cq_hk = {{ cq }}) %>%
    dplyr::select(! {{ pcr_target }})

  dcq_values <- .data %>%
    dplyr::filter({{ pcr_target }} != housekeeping) %>%
    dplyr::inner_join(cq_hk, by = use_join) %>%
    dplyr::mutate(dcq = {{ cq }} - cq_hk)
  dcq_values
}
