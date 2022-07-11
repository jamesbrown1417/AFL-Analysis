##%######################################################%##
#                                                          #
####              Find those who had most               ####
####         games missed from top draft picks          ####
#                                                          #
##%######################################################%##

# Libraries and data
library(tidyverse)
`%notin%` <- Negate(`%in%`)
combined_stats_table <- read_rds("Data/RDS-files/combined_stats_table_2022.rds")
draft_recap <- read_csv("Data/CSV-files/draft_recap_2022.csv")

# Exclude bye rounds
bye_rounds <- c("Round 12", "Round 13", "Round 14")

combined_stats_table_no_byes <-
combined_stats_table %>%
  filter(round_number %notin% bye_rounds)

# Get total games missed
games_missed <-
  combined_stats_table_no_byes %>%
  group_by(player_name) %>%
  summarise(games_played = max(row_number())) %>%
  mutate(games_missed = 13 - games_played)

# Get Draft picks and positions
draft_picks_games_missed <-
games_missed %>%
  left_join(draft_recap) %>%
  filter(!is.na(pick)) %>%
  arrange(pick)

# Get total games missed by top draft picks from first 15 rounds
first_15_player_games <-
draft_picks_games_missed %>%
  filter(pick <= 120) %>%
  group_by(team) %>%
  summarise(player_games_missed = sum(games_missed), player_games_played = sum(games_played)) %>%
  mutate(max_games_played = player_games_missed + player_games_played,
         percentage_games_from_picks = round(100*(player_games_played / max_games_played), digits = 2)) %>%
  arrange(percentage_games_from_picks)
