
# setup -------------------------------------------------------------------

setwd("~/repos/tidy_tues/2025 Week 14")

pacman::p_load(tidyverse, tidytuesdayR)


# data --------------------------------------------------------------------

data_init_list <- tt_load(2025, week = 14)

data_init <- data_init_list$care_state

data_init <- data_init %>%
  filter(!(state %in% c("GU", "MP", "AS", "VI")))

## verify all states have the same reporting periods
data_init %>%
  count(start_date, end_date, condition, measure_id) %>%
  pull(n) %>%
  unique() %>%
  length()



