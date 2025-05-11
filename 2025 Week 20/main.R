
# setup -------------------------------------------------------------------

setwd("~/repos/tidy_tues/2025 Week 20")

pacman::p_load(tidyverse, tidytuesdayR, gridExtra)

tuesdata <- tidytuesdayR::tt_load(2025, week = 20)

water_quality <- tuesdata$water_quality
weather <- tuesdata$weather
