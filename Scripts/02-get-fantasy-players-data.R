##%######################################################%##
#                                                          #
####              Libraries and functions               ####
#                                                          #
##%######################################################%##

# Libraries
library(tidyverse)
library(fitzRoy)

# Set Season of interest
season = 2022

##%######################################################%##
#                                                          #
####                      Get data                      ####
#                                                          #
##%######################################################%##

main <- function(season = 2022){

#===============================================================================
# Fetch player stats for each round
#===============================================================================

# Get most recent round number
total_rounds = fetch_results_afl(season = season)
total_rounds = max(total_rounds$round.roundNumber, na.rm = TRUE)

# If total rounds greater than 23, make it just 23 (to exclude finals)
total_rounds <- ifelse(total_rounds > 23, 23L, total_rounds)

for (i in 1:total_rounds){
  assign(paste("player_stats_round_", i, sep = ""), fetch_player_stats_afl(season = season,round = i))
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
      TOG = timeOnGroundPercentage,
      kick_ins = extendedStats.kickins,
      kicks,
      handballs,
      disposals,
      marks,
      tackles,
      contestedMarks,
      uncontestedMarks = marks - contestedMarks,
      goals,
      behinds,
      hitouts,
      contestedPossessions,
      uncontestedPossessions,
      freesFor,
      freesAgainst,
      clangers,
      turnovers,
      disposalEfficiency,
      kick_efficiency = extendedStats.kickEfficiency,
      ruck_contests_attended = extendedStats.ruckContests,
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
  assign(paste("match_results_round_", i, sep = ""), fetch_results_afl(season = season,round = i))
}

# Get CBAs and kick in data
# Create function to tidy output for each round's match results
clean_match_results <- function(df){
  clean_df <- df %>%
    transmute(
      round_number = round.name,
      total_CBAs = awayTeamScore.matchScore.goals + homeTeamScore.matchScore.goals + 4,
      hometeam_kick_ins = homeTeamScore.matchScore.behinds,
      awayteam_kick_ins = awayTeamScore.matchScore.behinds,
      home_team = match.homeTeam.name,
      away_team = match.awayTeam.name,
      venue = venue.name,
      start_time = match.venueLocalStartTime,
      temperature = weather.tempInCelsius,
      conditions = weather.weatherType)
  
  clean_df <-
    bind_rows(
      (clean_df %>%
         select(round_number,
                total_CBAs,
                total_kick_ins = awayteam_kick_ins,
                team = home_team,
                opposition_team = away_team,
                venue,
                start_time,
                temperature,
                conditions)),
      (clean_df %>%
         select(round_number,
                total_CBAs,
                total_kick_ins = hometeam_kick_ins,
                team = away_team,
                opposition_team = home_team,
                venue,
                start_time,
                temperature,
                conditions)))
  
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
####    Add footywire AFL Fantasy positions to table    ####
####     and get total games played for each player     ####
#                                                          #
##%######################################################%##

player_details <- readRDS("Data/RDS-files/player_details.RDS")

combined_stats_table <-
  combined_stats_table %>%
  left_join(player_details) %>%
  group_by(player_name) %>%
  mutate(games_played = max(row_number(), na.rm = TRUE))

##%######################################################%##
#                                                          #
####        Make round number an ordered factor         ####
#                                                          #
##%######################################################%##

combined_stats_table$round_number <-
  factor(combined_stats_table$round_number,
         levels = c("Round 1",
                    "Round 2",
                    "Round 3",
                    "Round 4",
                    "Round 5",
                    "Round 6",
                    "Round 7",
                    "Round 8",
                    "Round 9",
                    "Round 10",
                    "Round 11",
                    "Round 12",
                    "Round 13",
                    "Round 14",
                    "Round 15",
                    "Round 16",
                    "Round 17",
                    "Round 18",
                    "Round 19",
                    "Round 20",
                    "Round 21",
                    "Round 22",
                    "Round 23"),
         ordered = TRUE)

combined_stats_table <-
  combined_stats_table %>%
  arrange(player_name, round_number) %>%
  mutate(Season = season) %>%
  relocate(total_CBAs, CBA_percentage, .after = CBAs) %>%
  relocate(Season, .after = player_name)

##%######################################################%##
#                                                          #
####              Write out to Data folder              ####
#                                                          #
##%######################################################%##

filename_csv = paste("Data/CSV-files/combined_stats_table_", season, ".csv", sep = "")
filename_rds = paste("Data/RDS-files/combined_stats_table_", season, ".rds", sep = "")

write_csv(combined_stats_table, filename_csv)
write_rds(combined_stats_table, filename_rds)}

# Run function for various years
main(season = 2022)
#main(season = 2021)
# main(season = 2020)
# main(season = 2019)
# main(season = 2018)
