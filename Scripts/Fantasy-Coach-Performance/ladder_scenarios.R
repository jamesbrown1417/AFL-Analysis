##%######################################################%##
#                                                          #
####               Assess different final               ####
####         percentages for various scenarios          ####
#                                                          #
##%######################################################%##

# Libraries
library(tidyverse)

# Brown
scores_df_brown <-
  tibble(
    Coach_1 = "James Brown",
    brown_points_for = 19914,
    brown_points_against = 20411,
    brown_percentage = 100 * (brown_points_for / brown_points_against),
    brown_round_points_for = 1500,
    brown_round_points_against = 1501:1700,
    brown_new_percentage = 100*((brown_points_for + brown_round_points_for) / (brown_points_against + brown_round_points_against)),
    margin = brown_round_points_against - brown_round_points_for
  )

# Bish
scores_df_bish <-
  tibble(
    Coach_2 = "Sam Bishop",
    bish_points_for = 19496,
    bish_points_against = 20310,
    bish_percentage = 100 * (bish_points_for / bish_points_against),
    bish_round_points_for = 1700,
    bish_round_points_against = 1500:1699,
    bish_new_percentage = 100*((bish_points_for + bish_round_points_for) / (bish_points_against + bish_round_points_against)),
    margin = bish_round_points_for - bish_round_points_against
  )

# Comparison
comparison <- left_join(scores_df_brown, scores_df_bish)

# Scenarios when bish wins
comparison <-
comparison %>%
  select(margin, bish_new_percentage, brown_new_percentage) %>% filter(bish_new_percentage > brown_new_percentage) %>%
  arrange(margin)
