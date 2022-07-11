##%######################################################%##
#                                                          #
####              Get top fantasy players               ####
####           for each position and overall            ####
#                                                          #
##%######################################################%##

# Libraries and data
library(tidyverse)
combined_stats_table <- read_rds("Data/RDS-files/combined_stats_table_2021.rds")

##%######################################################%##
#                                                          #
####       Top players in each position - fantasy       ####
#                                                          #
##%######################################################%##

# Defender
top_defenders <-
  combined_stats_table %>%
  filter(fantasy_defender_status) %>%
  filter(!fantasy_forward_status) %>%
  filter(TOG > 50) %>%
  filter(games_played >= 5) %>%
  group_by(player_name) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE), games_played = max(games_played)) %>%
  arrange(desc(avg_score)) %>%
  head(48) %>%
  ungroup() %>%
  mutate(mean_position_score = mean(avg_score),
         z_score = scale(avg_score)[,1])

# Midfield
top_midfielders <-
  combined_stats_table %>%
  filter(fantasy_midfield_status) %>%
  filter(!fantasy_forward_status) %>%
  filter(!fantasy_defender_status) %>%
  filter(!fantasy_ruck_status) %>%
  filter(TOG > 50) %>%
  filter(games_played >= 5) %>%
  group_by(player_name) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE), games_played = max(games_played)) %>%
  arrange(desc(avg_score)) %>%
  head(64) %>%
  ungroup() %>%
  mutate(mean_position_score = mean(avg_score),
         z_score = scale(avg_score)[,1])
# Ruck
top_rucks <-
  combined_stats_table %>%
  filter(fantasy_ruck_status) %>%
  filter(!fantasy_forward_status) %>%
  filter(!fantasy_defender_status) %>%
  filter(TOG > 50) %>%
  filter(games_played >= 5) %>%
  group_by(player_name) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE), games_played = max(games_played)) %>%
  arrange(desc(avg_score)) %>%
  head(16) %>%
  ungroup() %>%
  mutate(mean_position_score = mean(avg_score),
         z_score = scale(avg_score)[,1])

# Forward
top_forwards <-
  combined_stats_table %>%
  filter(fantasy_forward_status) %>%
  filter(TOG > 50) %>%
  filter(games_played >= 5) %>%
  group_by(player_name) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE), games_played = max(games_played)) %>%
  arrange(desc(avg_score)) %>%
  head(48) %>%
  ungroup() %>%
  mutate(mean_position_score = mean(avg_score),
         z_score = scale(avg_score)[,1])

# Combine into 1 to get redraft ranking
all_player_rankings <-
  bind_rows(top_defenders, top_midfielders, top_rucks, top_forwards) %>%
  group_by(player_name) %>%
  filter(z_score == max(z_score)) %>%
  ungroup() %>%
  arrange(desc(z_score)) %>%
  mutate(ranking = row_number())
