##%######################################################%##
#                                                          #
####              Libraries and functions               ####
#                                                          #
##%######################################################%##

# Libraries
library(tidyverse)
library(fitzRoy)

# Get Unique team names dataframe
# Get unique teams that footywire uses
unique_teams_footywire = c(
  "Adelaide",
  "Brisbane Lions",
  "Carlton",
  "Collingwood",
  "Essendon",
  "Fremantle",
  "GWS",
  "Geelong",
  "Gold Coast",
  "Hawthorn",
  "Melbourne",
  "Kangaroos",
  "Port Adelaide",
  "Richmond",
  "St Kilda",
  "Sydney",
  "West Coast",
  "Western Bulldogs"
)

# Get unique teams that AFL uses
unique_teams_afl = c(
  "Adelaide Crows",
  "Brisbane Lions",
  "Carlton",
  "Collingwood",
  "Essendon",
  "Fremantle",
  "GWS Giants",
  "Geelong Cats",
  "Gold Coast Suns",
  "Hawthorn",
  "Melbourne",
  "North Melbourne",
  "Port Adelaide",
  "Richmond",
  "St Kilda",
  "Sydney Swans",
  "West Coast Eagles",
  "Western Bulldogs"
)

unique_teams_df <- bind_cols(footywire_names = unique_teams_footywire, AFL_names = unique_teams_afl)

##%######################################################%##
#                                                          #
####             Get AFL Fantasy positions              ####
#                                                          #
##%######################################################%##

# Create empty list of DFs to add to
team_list = list(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA)

# Assign a df for the players in each time
for (i in 1:18) {
  team_list[[i]] <- fetch_player_details_footywire(team = unique_teams_df[i,1])
  team_list[[i]] <- team_list[[i]] %>% mutate(team = unique_teams_df[[i,2]])
}
  
# Combine into one DF
fantasy_positions = bind_rows(team_list)
fantasy_positions <- fantasy_positions %>% transmute(jumperNumber = as.integer(No), Position_1, Position_2, team)

# Get AFL official player details
AFL_player_details = fetch_player_details_afl(season = 2022)

# Add positions data to official AFL player details
player_details <-
  AFL_player_details %>% 
  left_join(fantasy_positions) %>%
  transmute(
    player_name = paste(firstName, surname),
    team,
    position,
    dob = as.Date(dateOfBirth),
    height = heightInCm,
    weight = weightInKg,
    fantasy_defender_status = ifelse(Position_1 == "Defender" | Position_2 == "Defender", TRUE, FALSE),
    fantasy_midfield_status = ifelse(Position_1 == "Midfield" | Position_2 == "Midfield", TRUE, FALSE),
    fantasy_ruck_status = ifelse(Position_1 == "Ruck" | Position_2 == "Ruck", TRUE, FALSE),
    fantasy_forward_status = ifelse(Position_1 == "Forward" | Position_2 == "Forward", TRUE, FALSE)) %>%
  mutate(fantasy_defender_status = ifelse(is.na(fantasy_defender_status), FALSE, fantasy_defender_status),
         fantasy_midfield_status = ifelse(is.na(fantasy_midfield_status), FALSE, fantasy_midfield_status),
         fantasy_ruck_status = ifelse(is.na(fantasy_ruck_status), FALSE, fantasy_ruck_status),
         fantasy_forward_status = ifelse(is.na(fantasy_forward_status), FALSE, fantasy_forward_status))

# Write out to data folder as CSV and Rdata files
write_csv(player_details, "Data/CSV-files/player_details.csv")
write_rds(player_details, "Data/RDS-files/player_details.RDS")
