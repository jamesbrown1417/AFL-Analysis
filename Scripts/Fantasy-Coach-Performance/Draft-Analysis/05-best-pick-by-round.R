##%######################################################%##
#                                                          #
####        Best and worst draft picks by round         ####
#                                                          #
##%######################################################%##

# Libraries and data
library(tidyverse)
`%notin%` <- Negate(`%in%`)
source("Scripts/03-get-top-players.R")
draft_recap <- read_csv("Data/CSV-files/draft_recap_2022.csv")

# Create draft round variable
rounds <-
  c(
    rep(1, 8),
    rep(2, 8),
    rep(3, 8),
    rep(4, 8),
    rep(5, 8),
    rep(6, 8),
    rep(7, 8),
    rep(8, 8),
    rep(9, 8),
    rep(10, 8),
    rep(11, 8),
    rep(12, 8),
    rep(13, 8),
    rep(14, 8),
    rep(15, 8),
    rep(16, 8),
    rep(17, 8),
    rep(18, 8),
    rep(19, 8),
    rep(20, 8),
    rep(21, 8),
    rep(22, 8)
  )

draft_recap <-
  draft_recap %>%
  mutate(round = rounds)

# Get best draft pick by round
best_pick_by_round <-
  draft_recap %>%
  left_join(all_player_rankings %>% select(player_name, ranking)) %>%
  group_by(round) %>%
  filter(ranking == min(ranking, na.rm = TRUE))

# Get worst draft pick by round
worst_pick_by_round <-
  draft_recap %>%
  left_join(all_player_rankings %>% select(player_name, ranking)) %>%
  group_by(round) %>%
  filter(ranking == max(ranking, na.rm = TRUE))

# Count number of times a particular coach has the best or worst pick of the round
best_pick_by_round %>%
  group_by(team) %>%
  summarise(count = max(row_number())) %>%
  arrange(desc(count))

worst_pick_by_round %>%
  group_by(team) %>%
  summarise(count = max(row_number())) %>%
  arrange(desc(count))
