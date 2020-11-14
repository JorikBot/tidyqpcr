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
#' @return
#' @export
#'
#' @examples
qpcr_clean <- function(.data, cq, threshold, ...){
  # to do: add if statements for errors. no column called cq etc.
  dots <- names(enquos(..., .named = TRUE))

  median_cq <- .data %>%
    group_by(...) %>%
    summarise(median_cq = median({{cq}}, na.rm = TRUE), #calculate the median cq value
              count = sum(!is.na({{cq}}))) %>% #count the amount of techreps with a cq value
    ungroup()

  dev_test <- .data %>%
    full_join(median_cq, by = dots) %>%
    filter(count > 1) %>% #take out tech reps with only 1 value
    mutate(distance_med = abs({{cq}} - median_cq)) %>%  #calculate deviation from median
    mutate(keep = if_else(count == 2,
                          if_else(distance_med*2 < threshold, TRUE, FALSE),
                          if_else(distance_med   < threshold, TRUE, FALSE)))

  count_true <- dev_test %>%
    group_by(...) %>%
    summarise(count_keep = sum(keep, na.rm = TRUE)) %>%
    ungroup()

  clean_data <- dev_test %>%
    full_join(count_true, by = dots) %>%
    filter(count_keep > 1, #remove samples where all are more than the threshold apart
           keep == TRUE) %>% #remove all other outliers
    select(-(median_cq:count_keep)) #remove the now unnecessary columns
  clean_data
}
