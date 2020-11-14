#' Remove outliers
#'
#' This function removes outliers from technical qPCR replicates.
#' These outliers can occur thru inaccurate pipetting, pipetting in the wrong well, seal detachment, etc.
#' The function removes them based on the deviation from the median value, using the following rules:
#'
#' 1. If only one Cq value is present (i.e. the other replicates failed to produce a Cq value), it will be removed.
#' 2. If only two Cq values are present, they need to be less than a threshold apart.
#' 3. For three or more technical replicates:
#'    a. If the absolute distance between a Cq value and the median Cq is greater than a set threshold, than this value will be removed.
#'    b. If all Cq values within a technical replicate are more than a threshold apart, they will all be removed.
#'
#' @param .data
#' @param cq
#' @param threshold
#' @param ...
#'
#' @return A tibble
#' @export
#'
#' @examples
qpcr_clean <- function(.data, cq, threshold, ...){
  #to resolve note
  count <- distance_med <- keep <- count_keep <- NULL

  # to do: add if statements for errors. no column called cq etc.
  dots <- base::names(rlang::enquos(..., .named = TRUE))

  median_cq <- .data %>%
    dplyr::group_by(...) %>%
    dplyr::summarise(median_cq = stats::median({{cq}}, na.rm = TRUE), #calculate the median cq value
                     count = base::sum(!is.na({{cq}}))) %>% #count the amount of techreps with a cq value
    dplyr::ungroup()

  dev_test <- .data %>%
    dplyr::full_join(median_cq, by = dots) %>%
    dplyr::filter(count > 1) %>% #take out tech reps with only 1 value
    dplyr::mutate(distance_med = base::abs({{cq}} - median_cq)) %>%  #calculate deviation from median
    dplyr::mutate(keep = dplyr::if_else(count == 2,
                                        dplyr::if_else(distance_med*2 < threshold, TRUE, FALSE),
                                        dplyr::if_else(distance_med   < threshold, TRUE, FALSE)))

  count_true <- dev_test %>%
    dplyr::group_by(...) %>%
    dplyr::summarise(count_keep = base::sum(keep, na.rm = TRUE)) %>%
    dplyr::ungroup()

  clean_data <- dev_test %>%
    dplyr::full_join(count_true, by = dots) %>%
    dplyr::filter(count_keep > 1, #remove samples where all are more than the threshold apart
           keep == TRUE) %>% #remove all other outliers
    dplyr::select(-(median_cq:count_keep)) #remove the now unnecessary columns
  clean_data
}
