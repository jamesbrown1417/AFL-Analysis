##%######################################################%##
#                                                          #
####               Get the performance of               ####
####       different positions vs different teams       ####
#                                                          #
##%######################################################%##


# Libraries and data
library(tidyverse)
combined_stats_table <- read_rds("Data/RDS-files/combined_stats_table_2022.rds")

# Get best overall opponents
combined_stats_table %>%
  group_by(opposition_team) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE)) %>%
  arrange(desc(avg_score))

# Get best grounds
combined_stats_table %>%
  group_by(venue) %>%
  filter(max(row_number()) > 5) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE)) %>%
  arrange(desc(avg_score))

##%######################################################%##
#                                                          #
####       Get best overall opponents by position       ####
#                                                          #
##%######################################################%##

# Get best opposition for top midfielders - based on CBAs
combined_stats_table %>%
  filter(CBA_percentage > 60) %>%
  group_by(opposition_team) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE)) %>%
  arrange(desc(avg_score))

# Best opposition for midfielders
combined_stats_table %>%
  filter(TOG > 70) %>%
  group_by(opposition_team, position) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE)) %>%
  arrange(desc(avg_score)) %>%
  filter(position == "MIDFIELDER")

# Best opposition for midfielder forwards
combined_stats_table %>%
  filter(TOG > 70) %>%
  group_by(opposition_team, position) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE)) %>%
  arrange(desc(avg_score)) %>%
  filter(position == "MIDFIELDER_FORWARD")

# Best opposition for medium forwards
combined_stats_table %>%
  filter(TOG > 70) %>%
  group_by(opposition_team, position) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE)) %>%
  arrange(desc(avg_score)) %>%
  filter(position == "MEDIUM_FORWARD")

# Best opposition for key forwards
combined_stats_table %>%
  filter(TOG > 70) %>%
  group_by(opposition_team, position) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE)) %>%
  arrange(desc(avg_score)) %>%
  filter(position == "KEY_FORWARD")

# Best opposition for medium defenders
combined_stats_table %>%
  filter(TOG > 70) %>%
  group_by(opposition_team, position) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE)) %>%
  arrange(desc(avg_score)) %>%
  filter(position == "MEDIUM_DEFENDER")

# Best opposition for key defenders
combined_stats_table %>%
  filter(TOG > 70) %>%
  group_by(opposition_team, position) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE)) %>%
  arrange(desc(avg_score)) %>%
  filter(position == "KEY_DEFENDER")

# Best opposition for rucks
combined_stats_table %>%
  filter(TOG > 70) %>%
  group_by(opposition_team, position) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE)) %>%
  arrange(desc(avg_score)) %>%
  filter(position == "RUCK")

##%######################################################%##
#                                                          #
####             Get 3 and 5 game averages              ####
#                                                          #
##%######################################################%##

# 3-game average
three_game_average <-
combined_stats_table %>%
  filter(games_played >= 5) %>%
  filter(TOG > 70) %>%
  group_by(player_name) %>%
  filter(row_number() > (max(row_number()) - 3)) %>%
  summarise(avg_score_last_3 = mean(fantasy_points, na.rm = TRUE)) %>%
  ungroup() %>%
  arrange(desc(avg_score_last_3))

# 5-game average
five_game_average <-
  combined_stats_table %>%
  filter(games_played >= 5) %>%
  filter(TOG > 70) %>%
  group_by(player_name) %>%
  filter(row_number() > (max(row_number()) - 5)) %>%
  summarise(avg_score_last_5 = mean(fantasy_points, na.rm = TRUE)) %>%
  ungroup() %>%
  arrange(desc(avg_score_last_5))

  
# overall average
total_average <-
  combined_stats_table %>%
  filter(games_played >= 5) %>%
  filter(TOG > 70) %>%
  group_by(player_name) %>%
  summarise(avg_score_total = mean(fantasy_points, na.rm = TRUE)) %>%
  ungroup() %>%
  arrange(desc(avg_score_total))

##%######################################################%##
#                                                          #
####  Find in-form and out-of-form players by average   ####
#                                                          #
##%######################################################%##

# Find Players who have gained form
all_averages <-
total_average %>%
  left_join(three_game_average) %>%
  left_join(five_game_average) %>%
  mutate(last_3_vs_ave = avg_score_last_3 - avg_score_total,
         last_5_vs_ave = avg_score_last_5 - avg_score_total)

performing_above_avg_3 <-
  all_averages %>%
  select(-avg_score_last_5, -last_5_vs_ave) %>%
  arrange(desc(last_3_vs_ave)) %>%
  head(30)
  
performing_above_avg_5 <-
  all_averages %>%
  select(-avg_score_last_3, -last_3_vs_ave) %>%
  arrange(desc(last_5_vs_ave)) %>%
  head(30)

running_hot_last_3 <-
  all_averages %>%
  transmute(player_name, avg_score_last_3 = round(avg_score_last_3, 2)) %>%
  arrange(desc(avg_score_last_3)) %>%
  filter(avg_score_last_3 > 80)
  
running_hot_last_5 <-
  all_averages %>%
  transmute(player_name, avg_score_last_5 = round(avg_score_last_5, 2)) %>%
  arrange(desc(avg_score_last_5)) %>%
  filter(avg_score_last_5 > 80)

# Find players who have lost form
performing_below_avg_3 <-
  all_averages %>%
  select(-avg_score_last_5, -last_5_vs_ave) %>%
  arrange(last_3_vs_ave) %>%
  filter(avg_score_total >= 70) %>%
  head(30)

performing_below_avg_5 <-
  all_averages %>%
  select(-avg_score_last_3, -last_3_vs_ave) %>%
  arrange(last_5_vs_ave) %>%
  filter(avg_score_total >= 70) %>%
  head(30)

##%######################################################%##
#                                                          #
####              Get 3 and 5 game medians              ####
#                                                          #
##%######################################################%##

# 5-game median
five_game_median <-
  combined_stats_table %>%
  filter(games_played >= 5) %>%
  filter(TOG > 70) %>%
  group_by(player_name) %>%
  filter(row_number() > (max(row_number()) - 5)) %>%
  summarise(median_score_last_5 = median(fantasy_points, na.rm = TRUE)) %>%
  ungroup() %>%
  arrange(desc(median_score_last_5))


# overall median
total_median <-
  combined_stats_table %>%
  filter(games_played >= 5) %>%
  filter(TOG > 70) %>%
  group_by(player_name) %>%
  summarise(median_score_total = median(fantasy_points, na.rm = TRUE)) %>%
  ungroup() %>%
  arrange(desc(median_score_total))

##%######################################################%##
#                                                          #
####   Find in-form and out-of-form players by median   ####
#                                                          #
##%######################################################%##

# Find Players who have gained form
all_medians <-
  total_median %>%
  left_join(five_game_median) %>%
  mutate(last_5_vs_median = median_score_last_5 - median_score_total)

performing_above_median_5 <-
  all_medians %>%
  arrange(desc(last_5_vs_median)) %>%
  head(30)

running_hot_last_5_median <-
  all_medians %>%
  transmute(player_name, median_score_last_5 = round(median_score_last_5, 2)) %>%
  arrange(desc(median_score_last_5)) %>%
  filter(median_score_last_5 > 80)

# Find players who have lost form
performing_below_median_5 <-
  all_medians %>%
  arrange(last_5_vs_median) %>%
  filter(median_score_total >= 70) %>%
  head(30)

##%######################################################%##
#                                                          #
####   Measure player consistency and floor / ceiling   ####
#                                                          #
##%######################################################%##

# Highest floor
highest_floor <-
combined_stats_table %>%
  filter(TOG >= 50) %>%
  group_by(player_name) %>%
  filter(max(row_number()) >= 10) %>%
  summarise(lowest_score = min(fantasy_points, na.rm = TRUE)) %>%
  arrange(desc(lowest_score))

# Highest ceiling
highest_ceiling <-
  combined_stats_table %>%
  filter(TOG >= 50) %>%
  group_by(player_name) %>%
  filter(max(row_number()) >= 10) %>%
  summarise(highest_score = max(fantasy_points, na.rm = TRUE)) %>%
  arrange(desc(highest_score))

# Lowest ceiling for players who average above 80
lowest_ceiling_above_80 <-
  combined_stats_table %>%
  filter(TOG >= 50) %>%
  group_by(player_name) %>%
  filter(max(row_number()) >= 10) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE), highest_score = max(fantasy_points, na.rm = TRUE)) %>%
  filter(avg_score > 80) %>%
  arrange(highest_score) %>%
  head(20)

# Highest ceiling for players who average below 80
highest_ceiling_below_80 <-
  combined_stats_table %>%
  filter(TOG >= 50) %>%
  group_by(player_name) %>%
  filter(max(row_number()) >= 10) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE), highest_score = max(fantasy_points, na.rm = TRUE)) %>%
  filter(avg_score <= 80) %>%
  arrange(desc(highest_score)) %>%
  head(20)

# Get most consistent players who average above 80
most_consistent_above_80 <-
  combined_stats_table %>%
  filter(TOG >= 50) %>%
  group_by(player_name) %>%
  filter(max(row_number()) >= 10) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE), standard_deviation = sd(fantasy_points, na.rm = TRUE)) %>%
  filter(avg_score > 80) %>%
  arrange(standard_deviation)

# Get least consistent players who average above 80
least_consistent_above_80 <-
  combined_stats_table %>%
  filter(TOG >= 50) %>%
  group_by(player_name) %>%
  filter(max(row_number()) >= 10) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE), standard_deviation = sd(fantasy_points, na.rm = TRUE)) %>%
  filter(avg_score > 80) %>%
  arrange(desc(standard_deviation)) %>%
  head(20)
