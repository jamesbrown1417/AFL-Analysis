##%######################################################%##
#                                                          #
####    Get change in CBA attendance for last round     ####
#                                                          #
##%######################################################%##


# Libraries and data
library(tidyverse)
combined_stats_table <- read_rds("Data/RDS-files/combined_stats_table_2022.rds")

# Get last and second last row for each group
CBA_changes_1 <-
  combined_stats_table %>%
  filter(TOG > 50) %>%
  group_by(player_name) %>%
  slice(n() - 1) %>%
  ungroup() %>%
  select(player_name,
         second_last_round = round_number,
         second_last_CBAs = CBAs,
         second_last_total_CBAs = total_CBAs,
         second_last_CBA_percentage = CBA_percentage)

CBA_changes_2 <-
combined_stats_table %>%
  filter(TOG > 50) %>%
  group_by(player_name) %>%
  slice(n()) %>%
  ungroup() %>%
  select(player_name,
         last_round = round_number,
         last_CBAs = CBAs,
         last_total_CBAs = total_CBAs,
         last_CBA_percentage = CBA_percentage) %>%
  filter(last_round == max(combined_stats_table$round_number))

# Get total change in CBA attendance from last round and whatever previously played game was
CBA_change <-
  left_join(CBA_changes_2, CBA_changes_1) %>%
  transmute(player_name,
         second_last_round,
         last_round,
         second_last_CBAs,
         second_last_total_CBAs,
         last_CBAs,
         last_total_CBAs,
         second_last_CBA_percentage,
         last_CBA_percentage,
         diff = last_CBA_percentage - second_last_CBA_percentage)

# Get top 10 increases and decreases in CBA percentage
increased_CBAs <-
  CBA_change %>%
  arrange(desc(diff)) %>%
  head(10)

decreased_CBAs <-
  CBA_change %>%
  arrange(diff) %>%
  head(10)
