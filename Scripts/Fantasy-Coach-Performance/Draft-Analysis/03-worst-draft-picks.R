##%######################################################%##
#                                                          #
####            Find the worst draft picks              ####
#                                                          #
##%######################################################%##

# Libraries and data
library(tidyverse)
`%notin%` <- Negate(`%in%`)
source("Scripts/03-get-top-players.R")
draft_recap <- read_csv("Data/CSV-files/draft_recap_2022.csv")

worst_draft_picks <-
combined_stats_table %>%
  filter(player_name %in% draft_recap$player_name)

##%######################################################%##
#                                                          #
####     Rank players in each position - fantasy        ####
#                                                          #
##%######################################################%##

# Defender
top_defenders <-
  worst_draft_picks %>%
  filter(fantasy_defender_status) %>%
  filter(!fantasy_forward_status) %>%
  filter(TOG > 50) %>%
  group_by(player_name) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE)) %>%
  arrange(desc(avg_score)) %>%
  ungroup() %>%
  mutate(mean_position_score = mean(avg_score),
         z_score = scale(avg_score)[,1])

# Midfield
top_midfielders <-
  worst_draft_picks %>%
  filter(fantasy_midfield_status) %>%
  filter(!fantasy_forward_status) %>%
  filter(!fantasy_defender_status) %>%
  filter(!fantasy_ruck_status) %>%
  filter(TOG > 50) %>%
  group_by(player_name) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE)) %>%
  arrange(desc(avg_score)) %>%
  ungroup() %>%
  mutate(mean_position_score = mean(avg_score),
         z_score = scale(avg_score)[,1])
# Ruck
top_rucks <-
  worst_draft_picks %>%
  filter(fantasy_ruck_status) %>%
  filter(!fantasy_forward_status) %>%
  filter(!fantasy_defender_status) %>%
  filter(TOG > 50) %>%
  group_by(player_name) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE)) %>%
  arrange(desc(avg_score)) %>%
  ungroup() %>%
  mutate(mean_position_score = mean(avg_score),
         z_score = scale(avg_score)[,1])

# Forward
top_forwards <-
  worst_draft_picks %>%
  filter(fantasy_forward_status) %>%
  filter(TOG > 50) %>%
  group_by(player_name) %>%
  summarise(avg_score = mean(fantasy_points, na.rm = TRUE)) %>%
  arrange(desc(avg_score)) %>%
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

# Get actual draft position
worst_draft_picks <-
  all_player_rankings %>%
  left_join(draft_recap) %>%
  mutate(difference = pick - ranking) %>%
  arrange(difference)

