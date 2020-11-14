qpcr_avg_techrep <- function(.data, cq, ...){
  .data %>%
    group_by(...) %>%
    summarise(cq = mean({{cq}}, na.rm = TRUE)) %>%
    ungroup()
}
