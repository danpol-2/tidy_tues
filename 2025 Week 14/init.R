
# setup -------------------------------------------------------------------

setwd("~/repos/tidy_tues/2025 Week 14")

pacman::p_load(tidyverse, tidytuesdayR)


# data --------------------------------------------------------------------

data_init_list <- tt_load(2025, week = 14)

data_init <- data_init_list$care_state

data_init <- data_init %>%
  filter(!(state %in% c("GU", "MP", "AS", "VI")))

## verify all states have the same reporting periods for each group
data_init %>%
  count(start_date, end_date, condition, measure_id) %>%
  pull(n) %>%
  unique() %>%
  length()
# I bet there's a more robust way to do this

## only keep certain measures (I don't understand all of them)
cats <- data_init %>%
  distinct(condition, measure_id, measure_name)

## measures where lower is better:
# OP_18b
# OP_18c
# OP_22
## taking inverse scores

## NAs
na_df <- data_init %>%
  summarise(na_count = sum(is.na(score)),
            .by = measure_id)

data_cleaned <- data_init %>%
  filter(!str_detect(measure_id, "MIN"),
         !str_detect(measure_id, "6HR"),
         !str_detect(measure_id, "3HR"),
         ## mostly NAs
         !(measure_id == "OP_31")) %>%
  mutate(score = case_when(measure_id == "OP_18b" ~ -1*score,
                           measure_id == "OP_18c" ~ -1*score,
                           measure_id == "OP_22" ~ -1*score,
                           TRUE ~ score)) %>%
  ## more descriptive names
  mutate(measure_desc = case_when(measure_id == "HCP_COVID_19" ~ "HC C'19 Vacc",
                                  measure_id == "IMM_3" ~ "HC Flu Vacc",
                                  measure_id == "OP_18b" ~ "Avg Emer Time",
                                  measure_id == "OP_18c" ~ "Avg Emer Time - Psych",
                                  measure_id == "OP_22" ~ "Left B4 Seen",
                                  measure_id == "OP_23" ~ "Quick Stroke Resp",
                                  measure_id == "OP_29" ~ "App Colon Rec",
                                  measure_id == "SAFE_USE_OF_OPIOIDS" ~ "Safe Op Use",
                                  measure_id == "SEP_1" ~ "App Sep Care"))

## no NA scores
sum(is.na(data_cleaned$score))
         
# EDA ---------------------------------------------------------------------

## what's the distribution of each measure?

measure_list <- unique(data_cleaned$measure_id)

# for (measure in measure_list) {
#   measure_plot <- data_cleaned %>%
#     filter(measure_id == measure) %>%
#     ggplot(data = .,
#            mapping = aes(x = score)) +
#     geom_histogram() +
#     theme_bw() +
#     labs(title = measure)
#   
#   print(measure_plot)
# }

# rankings heat map -------------------------------------------------------

data_heatmap <- data_cleaned %>%
  mutate(score_rank = rank(-score, ties.method = "min"),
         .by = measure_id) %>%
  mutate(state_score = mean(score_rank),
         .by = state) %>%
  select(state, measure_id, measure_desc, score, score_rank, state_score) %>%
  ## factor by state score for heatmap
  mutate(state = fct_reorder(state, state_score))

heatmap <- data_heatmap %>%
  ggplot(data = .,
         mapping = aes(x = measure_desc, y = state, fill = score_rank)) +
  geom_tile() +
  scale_fill_gradient2(low = "red", mid = "white", high = "blue", midpoint = 52/2) +
  theme_minimal()

print(heatmap)
