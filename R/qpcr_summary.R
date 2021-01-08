#' Calculate mean and standard deviation
#'
#' \code{qpcr_summary} is a helper function used for calculating the mean and
#' standard deviation.These values can then be used for plotting.
#'
#' @param data A data frame or tibble.
#' @param to_summarise Unquoted expression. The column you want to apply the
#'   function to, for example the fold change values.
#' @param ... Tidy-select. One or more unquoted expressions separated by commas.
#'   The variables you want to group your data by. Mean and SD will be
#'   calculated for every unique combination of these variables.
#'
#' @return Returns the same type as the input (e.g. a data frame or tibble).
#'   Returns all columns supplied in ..., column "mean" containing the mean, and
#'   column "sd" containing the standard deviation.
#' @export
#'
#' @examples
#' ex_summary <- qpcr_summary(ex_ddcq,
#'                            to_summarise = fold_change,
#'                            treatment, primer_pair)
qpcr_summary <- function(data, to_summarise, ...) {
  summary <- data %>%
    dplyr::group_by(...) %>%
    dplyr::summarise(
      sd = stats::sd({{ to_summarise }}, na.rm = TRUE),
      mean = base::mean({{ to_summarise }}, na.rm = TRUE)
    )
  summary
}
