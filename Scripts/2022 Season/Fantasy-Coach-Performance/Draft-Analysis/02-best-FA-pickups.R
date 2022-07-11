##%######################################################%##
#                                                          #
####              Find the best FA pickups              ####
#                                                          #
##%######################################################%##

# Libraries and data
library(tidyverse)
`%notin%` <- Negate(`%in%`)
source("Scripts/03-get-top-players.R")
draft_recap <- read_csv("Data/CSV-files/draft_recap_2022.csv")

best_FA_pickups <- all_player_rankings %>% filter(player_name %notin% draft_recap$player_name)
