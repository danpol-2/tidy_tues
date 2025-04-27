
# setup -------------------------------------------------------------------

setwd("~/repos/tidy_tues/2025 Week 16")

pacman::p_load(tidyverse, tidytuesdayR, gridExtra, zoo, grid)

tuesdata <- tidytuesdayR::tt_load(2025, week = 16)
daily_accidents <- tuesdata$daily_accidents

daily_accidents_cleaned <- daily_accidents %>%
  mutate(date = as.Date(date),
         year = year(date),
         year_abb = substr(year, 3, 4),
         year_abb = fct_reorder(year_abb, year),
         month = month(date),
         month_abb = factor(month, levels = 1:12, labels = month.abb) %>% fct_rev) %>%
  summarise(fatalities_count = sum(fatalities_count),
            .by = c(year, year_abb, month, month_abb))


# init --------------------------------------------------------------------

month_plot <- ggplot(data = daily_accidents_cleaned,
                     aes(x = year_abb, y = month_abb, fill = fatalities_count)) +
  geom_tile() +
  labs(x = NULL,
       y = "Month",
       title = "Monthly Traffic Fatalities",
       fill = "Fatalities") +
  scale_fill_gradient2(low = ("blue"),
                       mid = "white",
                       high = ("red"),
                       midpoint = median(daily_accidents_cleaned$fatalities_count)) +
  theme_minimal() +
  theme(panel.grid = element_blank(),
        ## cream background
        # plot.background = element_rect(fill = "#fafafa", color = NA),
        # panel.background = element_rect(fill = "#fafafa", color = NA),
        ## title
        plot.title = element_text(hjust = 0, face = "bold")
  )


# rolling 12 --------------------------------------------------------------

## get R12 avg
daily_accidents_cleaned$fatalities_count_R12 <- rollmean(daily_accidents_cleaned$fatalities_count,
                                                         k = 12, align = "right", fill = NA)

daily_accidents_long <- daily_accidents_cleaned %>%
  pivot_longer(cols = c(fatalities_count, fatalities_count_R12),
               names_to = "type",
               values_to = "fatalities") %>%
  mutate(date = as.Date(paste(year, month, 1, sep = "-")),
         type = case_when(type == "fatalities_count" ~ "Mo.",
                          type == "fatalities_count_R12" ~ "R12",
                          TRUE ~ "MC"))

time_plot <- ggplot(data = daily_accidents_long,
                    aes(x = date, y = fatalities, color = type)) +
  geom_line(linewidth = .8) +
  labs(title = NULL,
       x = "Year",
       y = "Fatalities",
       color = NULL) +
  scale_x_date(date_breaks = "1 year",
               date_labels = "%y",
               expand = c(0, 0)) +
  theme_minimal() +
  theme(## cream background
    # plot.background = element_rect(fill = "#fafafa", color = NA),
    # panel.background = element_rect(fill = "#fafafa", color = NA)
    )


# output ------------------------------------------------------------------

citation_text <- "Source: Data Science Learning Community (2024). Tidy Tuesday: A weekly social data project. https://tidytues.day"

citation_plot <- textGrob(citation_text, gp = gpar(fontsize = 10), just = "left", x = 0)

output_plot <- grid.arrange(month_plot,
                            time_plot,
                            citation_plot,
                            ncol = 1, heights = c(2, 1.25, .1))

ggsave("final_plot.png",
       plot = output_plot,
       width = 12,
       height = 6,
       units = "in")
