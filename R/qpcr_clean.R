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
