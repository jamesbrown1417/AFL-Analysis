##%######################################################%##
#                                                          #
####             Find the best draft picks              ####
#                                                          #
##%######################################################%##

# Libraries and data
library(tidyverse)
`%notin%` <- Negate(`%in%`)
source("Scripts/03-get-top-players.R")
draft_recap <- read_csv("Data/CSV-files/draft_recap_2022.csv")

best_draft_picks <-
  all_player_rankings %>%
  left_join(draft_recap) %>%
  filter(!is.na(pick)) %>%
  mutate(difference = pick - ranking) %>%
  arrange(desc(difference))
