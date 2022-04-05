##%######################################################%##
#                                                          #
####              Libraries and functions               ####
#                                                          #
##%######################################################%##

# Libraries
library(tidyverse)
library(fitzRoy)

##%######################################################%##
#                                                          #
####                    Get CBA Data                    ####
#                                                          #
##%######################################################%##

#===============================================================================
# Fetch player stats for each round
#===============================================================================

# Get most recent round number
total_rounds = fetch_results_afl()
total_rounds = max(total_rounds$round.roundNumber, na.rm = TRUE)

for (i in 1:total_rounds){
  assign(paste("player_stats_round_", i, sep = ""), fetch_player_stats_afl(round = i))
}

#===============================================================================
# Tidy up output and names
#===============================================================================

# Create function to tidy output for each round's player stats
clean_player_stats <- function(df){
    clean_df <- df %>%
    transmute(
      player_name = paste(player.givenName,player.surname),
      round_number = round.name,
      fantasy_points = dreamTeamPoints,
      CBAs = extendedStats.centreBounceAttendances,
      kick_ins = extendedStats.kickins,
      team = team.name)
    return(clean_df)}

# Get list of player stats for each round
player_stats_list = ls()
player_stats_list = mget(player_stats_list)
player_stats_list <- player_stats_list[str_detect(names(player_stats_list),"player_stats_round_")]

# Apply clean_player_stats function to each
player_stats_list <- lapply(player_stats_list, clean_player_stats)

# Bind rows together
player_stats_total <- bind_rows(player_stats_list)

#===============================================================================
# Get match results for each round
#===============================================================================

for (i in 1:total_rounds){
  assign(paste("match_results_round_", i, sep = ""), fetch_results_afl(round = i))
}

# Get CBAs and kick in data
# Create function to tidy output for each round's match results
clean_match_results <- function(df){
  clean_df <- df %>%
    transmute(
      round_number = round.name,
      total_CBAs = awayTeamScore.matchScore.goals + homeTeamScore.matchScore.goals + 2,
      hometeam_kick_ins = homeTeamScore.matchScore.behinds,
      awayteam_kick_ins = awayTeamScore.matchScore.behinds,
      home_team = match.homeTeam.name,
      away_team = match.awayTeam.name)
  
  clean_df <-
    bind_rows(
      (clean_df %>%
         select(round_number,
                total_CBAs,
                total_kick_ins = awayteam_kick_ins,
                team = home_team)),
      (clean_df %>%
         select(round_number,
                total_CBAs,
                total_kick_ins = hometeam_kick_ins,
                team = away_team)))
  
  return(clean_df)}

# Get list of match results for each round
match_results_list = ls()
match_results_list = mget(match_results_list)
match_results_list <- match_results_list[str_detect(names(match_results_list),"match_results_round_")]

# Apply clean_match_results function to each
match_results_list <- lapply(match_results_list, clean_match_results)

# Bind rows together
match_results_total <- bind_rows(match_results_list)

##%######################################################%##
#                                                          #
####          Combine CBA data and total CBAs           ####
####            for each match to get totals            ####
#                                                          #
##%######################################################%##

combined_stats_table <-
  player_stats_total %>%
  left_join(match_results_total) %>%
  mutate(CBA_percentage = round(100*(CBAs / total_CBAs), digits = 2),
         kick_in_percentage = round(100*(kick_ins / total_kick_ins), digits = 2)) %>%
  arrange(team, player_name, round_number)

##%######################################################%##
#                                                          #
####              Get mean CBA attendance               ####
#                                                          #
##%######################################################%##

mean_cba_attendance <-
  combined_stats_table %>%
  select(-contains("kick_ins")) %>%
  group_by(player_name, team) %>%
  summarise(mean_CBA_attendance = mean(CBA_percentage)) %>%
  arrange(desc(mean_CBA_attendance))

##%######################################################%##
#                                                          #
####          Get net change in CBA attendance          ####
#                                                          #
##%######################################################%##

CBA_attendance_change <-
  combined_stats_table %>%
  group_by(player_name, team) %>%
  mutate(CBA_net_change = CBA_percentage - lag(CBA_percentage))

CBA_attendance_change %>%
  filter(max(row_number()) == 3) %>%
  summarise(total_CBA_change = sum(CBA_net_change, na.rm = TRUE)) %>%
  arrange(total_CBA_change)


