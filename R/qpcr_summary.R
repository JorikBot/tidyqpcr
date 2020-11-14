qpcr_summary <- function(data, to_summarise, ...){
  summary <- data %>%
    group_by(...) %>%
    summarise(sd = sd({{to_summarise}}, na.rm = TRUE),
              mean = mean({{to_summarise}}, na.rm = TRUE))
  summary
}
