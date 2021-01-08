#' Remove outliers
#'
#' \code{qpcr_clean} removes outliers from technical qPCR replicates. These
#' outliers can occur because of inaccurate pipetting, pipetting in the wrong
#' well, seal detachment, etc. The function removes them based on the deviation
#' from the median Cq value. See details for exact rules of outlier removal.
#'
#' The rules for what is an outlier and what is not are as follows:
#' \enumerate{
#'   \item If only one Cq value is present (i.e. the other replicates failed to
#' produce a Cq value), it will be removed.
#'   \item If only two Cq values are present, they need to be less than the
#'         threshold apart.
#'   \item For three or more technical replicates:
#'     \itemize{
#'         \item If the absolute distance between a Cq value and the median Cq
#'               is greater than the set threshold, than this value will be
#'               removed.
#'         \item If all Cq values within a technical replicate are more than
#'               the threshold apart, they will all be removed. } }
#'
#' @param .data A data frame or tibble.
#' @param cq Unquoted expression. The name of the column containing the Cq
#'   values.
#' @param threshold A numeric. The maximum allowed deviation from the median.
#' @param ... Tidy-select. One or more unquoted expressions separated by commas.
#'   These are the names of all other columns that are not the Cq values or
#'   denote technical replicates. They will be used to make groups, so
#'   calculations will be made for each unique combination of variables.
#'
#' @return Returns the same type as the input (e.g. a data frame or tibble).
#'   Rows that are deemed outliers are removed from the output. If you want to
#'   inspect these rows see \code{\link{qpcr_outlier_context}}.
#' @export
#'
#' @examples
#' clean_data <- qpcr_clean(ex_data,
#'                          cq = cq_values,
#'                          threshold = 1,
#'                          treatment, primer_pair, bio_rep)
qpcr_clean <- function(.data, cq, threshold, ...) {
  # to resolve note
  count <- distance_med <- keep <- count_keep <- NULL

  # to do: add if statements for errors. no column called cq etc.
  dots <- base::names(rlang::enquos(..., .named = TRUE))

  median_cq <- .data %>%
    dplyr::group_by(...) %>%
    dplyr::summarise(
      median_cq = stats::median({{ cq }}, na.rm = TRUE), # calculate the median cq value
      count = base::sum(!is.na({{ cq }}))
    ) %>% # count the amount of techreps with a cq value
    dplyr::ungroup()

  dev_test <- .data %>%
    dplyr::full_join(median_cq, by = dots) %>%
    dplyr::filter(count > 1) %>% # take out tech reps with only 1 value
    dplyr::mutate(distance_med = base::abs({{ cq }} - median_cq)) %>% # calculate deviation from median
    dplyr::mutate(keep = dplyr::if_else(
      count == 2,
      dplyr::if_else(distance_med * 2 < threshold, TRUE, FALSE),
      dplyr::if_else(distance_med < threshold, TRUE, FALSE)
    ))

  count_true <- dev_test %>%
    dplyr::group_by(...) %>%
    dplyr::summarise(count_keep = base::sum(keep, na.rm = TRUE)) %>%
    dplyr::ungroup()

  clean_data <- dev_test %>%
    dplyr::full_join(count_true, by = dots) %>%
    dplyr::filter(
      count_keep > 1, # remove samples where all are more than the threshold apart
      keep == TRUE
    ) %>% # remove all other outliers
    dplyr::select(-(median_cq:count_keep)) # remove the now unnecessary columns
  clean_data
}
