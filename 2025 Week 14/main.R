
# setup -------------------------------------------------------------------

setwd("~/repos/tidy_tues/2025 Week 14")

pacman::p_load(tidyverse, tidytuesdayR, scales)


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
  ## more descriptive names & score weights
  mutate(measure_desc = case_when(measure_id == "HCP_COVID_19" ~ "HC C'19 Vacc",
                                  measure_id == "IMM_3" ~ "HC Flu Vacc",
                                  measure_id == "OP_18b" ~ "Avg Wait Time",
                                  measure_id == "OP_18c" ~ "Avg Wait Time - Psych",
                                  measure_id == "OP_22" ~ "Left B4 Seen",
                                  measure_id == "OP_23" ~ "Quick Stroke Resp",
                                  measure_id == "OP_29" ~ "App Colon Rec",
                                  measure_id == "SAFE_USE_OF_OPIOIDS" ~ "Safe Op Use",
                                  measure_id == "SEP_1" ~ "App Sep Care"),
         measure_weight = case_when(measure_id == "HCP_COVID_19" ~ 1,
                                    measure_id == "IMM_3" ~ 2,
                                    measure_id == "OP_18b" ~ 9,
                                    measure_id == "OP_18c" ~ 8,
                                    measure_id == "OP_22" ~ 7,
                                    measure_id == "OP_23" ~ 6,
                                    measure_id == "OP_29" ~ 5,
                                    measure_id == "SAFE_USE_OF_OPIOIDS" ~ 3,
                                    measure_id == "SEP_1" ~ 2))

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

## get state scores by measure
data_scored <- data_cleaned %>%
  mutate(score_rank = rank(-score, ties.method = "min"),
         .by = measure_id) 

## get overall state performance
state_scores <- data_scored %>%
  summarise(state_score = sum(score_rank * measure_weight) / sum(measure_weight),
            .by = state) %>%
  mutate(state_overall_rank = rank(state_score, ties.method = "first"))

## create rows for overall state performance
state_perf_df <- state_scores %>%
  mutate(measure_desc = "Overall") %>%
  select(state, measure_desc, score_rank = state_score, state_overall_rank)

## create spacer rows
spacer_df <- data.frame(state = rep(state_scores$state, each = 1),
                        measure_desc = " ",
                        score_rank = NA,
                        state_overall_rank = NA)

## heatmap data
data_heatmap <- data_scored %>%
  merge(state_scores,
        all.x = TRUE,
        by = c("state")) %>%
  select(state, measure_desc, score_rank, state_overall_rank) %>%
  bind_rows(spacer_df, state_perf_df) %>%
  ## factor orders
  mutate(state = fct_reorder(state, -state_overall_rank, .na_rm = TRUE),
         measure_desc = factor(measure_desc, levels = c("Avg Wait Time",
                                                        "Avg Wait Time - Psych",
                                                        "Left B4 Seen",
                                                        "Quick Stroke Resp",
                                                        "App Colon Rec",
                                                        "App Sep Care",
                                                        "Safe Op Use",
                                                        "HC Flu Vacc",
                                                        "HC C'19 Vacc",
                                                        " ",
                                                        "Overall")))

plot_heatmap <- data_heatmap %>%
  ggplot(data = .,
         mapping = aes(x = measure_desc, y = state, fill = score_rank)) +
  geom_tile() +
  scale_fill_gradient2(low = muted("blue"),
                       mid = "white",
                       high = muted("red"),
                       na.value = "#fafafa",
                       midpoint = 52/2,
                       labels = c("", "Better", "", "", "", "Worse"),
                       name = "State Rank") +
  coord_fixed(ratio = .3) +
  labs(title = "US Healthcare Performances",
       x = NULL,
       y = NULL) +
  theme_minimal() +
  guides(fill = guide_legend(position = "top",
                             title.position = "top",
                             title.hjust = .5,
                             labels = c("lower ranked", "higher ranked"),
                             label.position = "bottom",
                             label.hjust = 0.5,
                             reverse = TRUE)) +
        ## no grid lines
  theme(panel.grid = element_blank(),
        ## legend
        legend.margin = margin(0, 0, 0, 0),
        legend.justification.top = "center",
        legend.location = "panel",
        ## title
        plot.title = element_text(hjust = 0.5, face = "bold"),
        ## rotate axis labels
        axis.text.x = element_text(angle = 45, hjust = 1),
        ## cream background
        plot.background = element_rect(fill = "#fafafa", color = NA),
        panel.background = element_rect(fill = "#fafafa", color = NA))

print(plot_heatmap)

## output dims: 665 1133
ggsave("heatmap_plot.png",
       plot = plot_heatmap,
       width = 665 / 100,
       height = 1133 / 100,
       units = "in")
