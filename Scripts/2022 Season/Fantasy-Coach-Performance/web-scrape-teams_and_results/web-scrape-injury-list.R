##%######################################################%##
#                                                          #
####         Take the AFL official injury list          ####
####        tables and scrape into a usable form        ####
#                                                          #
##%######################################################%##


# Libraries, functions and data
library(tidyverse)
library(rvest)
combined_stats_table <- read_rds("Data/RDS-files/combined_stats_table_2022.rds")

# Get teams DF in alphabetical order
teams_list <- combined_stats_table %>% ungroup() %>% distinct(team) %>% arrange(team)

# Get URL of injury list page
injury_list_url <- "https://www.afl.com.au/matches/injury-list"

# Read HTML of injury list
injury_list_html <- read_html(injury_list_url)

# Get tables from website
all_injury_tables <-
  injury_list_html %>%
  html_elements("table")

# Get function to give each column of each table the same name
fix_names <- function(df) {
  names(df) <- c("player_name", "injury_type", "estimated_return")
  return(df)
}

# Get list of tables for each team and give them consistent names
afl_injury_list <-
  map(all_injury_tables, html_table) %>%
  map(.f = fix_names)

# Add team variable
for (i in 1:length(afl_injury_list)) {
afl_injury_list[[i]]$team <- teams_list[[1]][i]  
}

# Get into a single tibble
full_afl_injury_list <- bind_rows(afl_injury_list)

# Get last updated as a variable
full_afl_injury_list <-
  full_afl_injury_list %>%
  group_by(team) %>%
  mutate(last_updated = last(player_name)) %>%
  ungroup() %>%
  filter(str_detect(player_name, "Updated:", negate = TRUE))
