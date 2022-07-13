##%######################################################%##
#                                                          #
####            Web scrape results from HTML            ####
####      files returned by selenium python script      ####
#                                                          #
##%######################################################%##

# Libraries, functions and data
library(tidyverse)
library(rvest)
combined_stats_table <- read_rds("Data/RDS-files/combined_stats_table_2022.rds")
player_details <- read_rds("Data/RDS-files/player_details.rds")
draft_recap <- read_csv("Data/CSV-files/draft_recap_2022.csv")
`%notin%` <- Negate(`%in%`)

##%######################################################%##
#                                                          #
####             Read in HTML of team pages             ####
#                                                          #
##%######################################################%##

#===============================================================================
# Get list of files in Data/HTML-files folder
#===============================================================================

team_files <- dir("Data/HTML-files/teams")
team_files <- sort(team_files)

#===============================================================================
# Create function that reads html and outputs players table
#===============================================================================

get_players <- function(html_path) {
  # Read HTML from path
  full_path <- paste("Data/HTML-files/teams/", html_path, sep = "")
  html_source <- read_html(full_path)
  
  # Create players vector and return
  players <-
    html_source %>%
    html_elements(".jfnohy") %>%
    html_text2()
  
  return(players)
}

#===============================================================================
# Create function that reads html and outputs teams table
#===============================================================================

get_teams <- function(html_path) {
  # Read HTML from path
  full_path <- paste("Data/HTML-files/teams/", html_path, sep = "")
  html_source <- read_html(full_path)
  
  # Create teams vector and return
  teams <-
    html_source %>%
    html_elements(".jfIbnL") %>%
    html_text2()
  
  return(teams)
}

#===============================================================================
# Map functions to list to get coaches and their players each round
#===============================================================================

all_players <- map(team_files, get_players)
all_teams <- map(team_files, get_teams)

# Get teams list in order they appear
all_teams_list <- all_teams[[1]]

# Get list of rounds
rounds <-
  c(
    "Round 1",
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
    "Round 15",
    "Round 16",
    "Round 17"
  )

##%######################################################%##
#                                                          #
####          Create function to extract each           ####
####          coaches fielded team each round           ####
#                                                          #
##%######################################################%##

# Create empty list of teams
all_fielded_teams <- list()

#===============================================================================
# Loop through and populate list of teams for each round
#===============================================================================

for (i in 1:length(rounds)){
  
  # Get tibble with player name
  fielded_team <- tibble(player_name = all_players[[i]], round_number = rounds[i])
  
  # Add team names
  fielded_team <-
    fielded_team %>%
    mutate(fantasy_team =
             case_when(
               row_number() <= 22 ~ all_teams_list[1],
               between(row_number(), 23, 44) ~ all_teams_list[2],
               between(row_number(), 45, 66) ~ all_teams_list[3],
               between(row_number(), 67, 88) ~ all_teams_list[4],
               between(row_number(), 89, 110) ~ all_teams_list[5],
               between(row_number(), 111, 132) ~ all_teams_list[6],
               between(row_number(), 133, 154) ~ all_teams_list[7],
               between(row_number(), 155, 176) ~ all_teams_list[8]
               )
           )
  
  # Remove positions and new line from player_name variable
  fielded_team$player_name <- str_remove_all(fielded_team$player_name, "\\n.*$")
  
  # Created fielded position variable
  fielded_team <-
    fielded_team %>%
    group_by(fantasy_team) %>%
    mutate(
      fielded_position =
        case_when(
          row_number() <= 5 ~ "Defender",
          between(row_number(), 6, 12) ~ "Midfielder",
          row_number() == 13 ~ "Ruck",
          between(row_number(), 14, 18) ~ "Forward",
          between(row_number(), 19, 22) ~ "Interchange"
        )
    )
  
  # Push to list
  all_fielded_teams[[i]] <- fielded_team
}

#===============================================================================
# Collapse list into a single dataframe for analysis
#===============================================================================

all_fielded_teams <- bind_rows(all_fielded_teams)

##%######################################################%##
#                                                          #
####   Combine fielded teams list with combined stats   ####
####          table to get scores and TOG data          ####
#                                                          #
##%######################################################%##

#===============================================================================
# Get filtered combined stats data
#===============================================================================
combined_stats_table_filtered <-
  combined_stats_table %>%
  mutate(
    player_first_initial = str_extract(player_name, "^[A-Z]"),
    player_middle_initial = str_extract(player_name, " [A-Z]\\. "),
    player_last_name = str_extract(player_name, "([A-Za-z-']*$)|(De Goey)")
  ) %>%
  mutate(player_middle_initial = ifelse(is.na(player_middle_initial), "", player_middle_initial)) %>%
  mutate(player_middle_initial = str_remove_all(player_middle_initial, " ")) %>%
  mutate(
    player_name_initials = paste(
      player_first_initial,
      ". ",
      player_last_name,
      sep = ""
    )
  ) %>%
  transmute(
    player_name,
    player_name_initials,
    club = team,
    round_number = as.character(round_number),
    fantasy_points,
    TOG,
    dob,
    start_time,
    height,
    weight
  )

#===============================================================================
# Fix names for players that share first initial 
# and last name with others in competition
#===============================================================================

duplicate_names <- combined_stats_table_filtered %>%
  ungroup() %>%
  distinct(player_name_initials, club) %>%
  group_by(player_name_initials) %>%
  filter(max(row_number()) > 1) %>%
  arrange(player_name_initials) %>%
  filter(player_name_initials %in% all_fielded_teams$player_name)

#===============================================================================
# For both the all_fielded_teams and combined_stats_filtered_tables,
# if a player is a duplicate player, use their full name instead
#===============================================================================

# Get players fielded that have a duplicate
all_fielded_teams_duplicate_names <-
  all_fielded_teams %>%
  filter(player_name %in% duplicate_names$player_name_initials) %>%
  distinct(player_name, fantasy_team)

# Manually fix these in fielded teams table
all_fielded_teams <- 
  all_fielded_teams %>%
  ungroup() %>%
  mutate(player_name_2 =
           case_when(
             player_name == "J. Kelly" ~ "Josh Kelly",
             player_name == "B. Smith" & fantasy_team == "The Big 4 Bull" ~ "Bailey Smith",
             player_name == "B. Hill" ~ "Bradley Hill",
             player_name == "B. Smith" & fantasy_team == "BuIIs on parade" ~ "Brodie Smith",
             player_name == "A. Brayshaw" & fantasy_team == "Welcome To The Pig Sty" ~ "Andrew Brayshaw",
             player_name == "L. Ryan" ~ "Luke Ryan",
             player_name == "L. McDonald" ~ "Luke McDonald",
             player_name == "D. Moore" ~ "Dylan Moore",
             player_name == "B. Ainsworth" ~ "Ben Ainsworth",
             player_name == "J. Kennedy" & fantasy_team == "BuIIs on parade" ~ "Josh P. Kennedy",
             player_name == "J. Kennedy" & fantasy_team == "The Big 4 Bull" ~ "Josh J. Kennedy",
             player_name == "A. Brayshaw" & fantasy_team == "DoYouLikeThat" ~ "Angus Brayshaw",
             player_name == "L. Young" ~ "Lachie Young"
           )
         ) %>%
  mutate(player_name = ifelse(!is.na(player_name_2), player_name_2, player_name)) %>%
  select(-player_name_2)

# Manually fix these in combined stats table
combined_stats_table_filtered <- 
  combined_stats_table_filtered %>%
  ungroup() %>%
  mutate(player_name_2 =
           case_when(
             player_name_initials == "J. Kelly" & club == "GWS Giants" ~ "Josh Kelly",
             player_name_initials == "B. Smith" & club == "Western Bulldogs" ~ "Bailey Smith",
             player_name_initials == "B. Hill" & club == "St Kilda" ~ "Bradley Hill",
             player_name_initials == "B. Smith" & club == "Adelaide Crows" ~ "Brodie Smith",
             player_name_initials == "A. Brayshaw" & club == "Fremantle" ~ "Andrew Brayshaw",
             player_name_initials == "L. Ryan" & club == "Fremantle" ~ "Luke Ryan",
             player_name_initials == "L. McDonald" & club == "North Melbourne" ~ "Luke McDonald",
             player_name_initials == "D. Moore" & club == "Hawthorn" ~ "Dylan Moore",
             player_name_initials == "B. Ainsworth" & club == "Gold Coast Suns" ~ "Ben Ainsworth",
             player_name_initials == "J. Kennedy" & club == "Sydney Swans" ~ "Josh P. Kennedy",
             player_name_initials == "J. Kennedy" & club == "West Coast Eagles" ~ "Josh J. Kennedy",
             player_name_initials == "A. Brayshaw" & club == "Melbourne" ~ "Angus Brayshaw",
             player_name_initials == "L. Young" & club == "North Melbourne" ~ "Lachie Young")) %>%
  mutate(player_name_initials = ifelse(!is.na(player_name_2), player_name_2, player_name_initials)) %>%
  select(-player_name_2) %>%
  rename(player_name_full = player_name)

#===============================================================================
# Join tables together
#===============================================================================

all_fielded_teams_full <-
  all_fielded_teams %>%
  left_join(combined_stats_table_filtered, by = c("player_name" = "player_name_initials", "round_number")) %>%
  group_by(player_name) %>%
  fill(player_name_full, club, height, weight, dob, .direction = "downup") %>%
  rename(round_start_date = start_time) %>%
  group_by(round_number) %>%
  mutate(round_start_date = as.Date(min(round_start_date, na.rm = TRUE))) %>%
  ungroup() %>%
  mutate(player_age_at_round_start = round(as.numeric((round_start_date - dob) / 365.25), digits = 2))

#===============================================================================
# Add Emergency Status to get loopholed players / injury replacements
#===============================================================================

all_fielded_teams_full <-
  all_fielded_teams_full %>%
  mutate(fielded_position_2 =
           case_when(
             player_name_full == "Nick Daicos" & round_number == "Round 1" ~ "Emergency Midfielder",
             player_name_full == "Daniel Rioli" & round_number == "Round 1" ~ "Emergency Forward",
             player_name_full == "Kyle Langford" & round_number == "Round 1" ~ "Emergency Midfielder",
             player_name_full == "Nick Blakey" & round_number == "Round 1" ~ "Emergency Defender",
             player_name_full == "Dylan Shiel" & round_number == "Round 1" ~ "Emergency Midfielder",
             player_name_full == "Josh Battle" & round_number == "Round 1" ~ "Emergency Forward",
             
             player_name_full == "Brayden Fiorini" & round_number == "Round 2" ~ "Emergency Midfielder",
             player_name_full == "Jeremy Cameron" & round_number == "Round 2" ~ "Emergency Forward",
             player_name_full == "Hayden Crozier" & round_number == "Round 2" ~ "Emergency Defender",
             player_name_full == "Dayne Zorko" & round_number == "Round 2" ~ "Emergency Midfielder",
             player_name_full == "Aaron Naughton" & round_number == "Round 2" ~ "Emergency Forward",
             
             player_name_full == "Chad Warner" & round_number == "Round 3" ~ "Emergency Midfielder",
             player_name_full == "Dayne Zorko" & round_number == "Round 3" ~ "Emergency Midfielder",
             player_name_full == "Dylan Shiel" & round_number == "Round 3" ~ "Emergency Midfielder",
             player_name_full == "Lachie Hunter" & round_number == "Round 3" ~ "Emergency Midfielder",
             
             player_name_full == "Brad Close" & round_number == "Round 4" ~ "Emergency Forward",
             player_name_full == "Brayden Maynard" & round_number == "Round 4" ~ "Emergency Defender",
             player_name_full == "Charlie Cameron" & round_number == "Round 4" ~ "Emergency Forward",
             player_name_full == "Angus Brayshaw" & round_number == "Round 4" ~ "Emergency Midfielder",
             player_name_full == "Riley Bonner" & round_number == "Round 4" ~ "Emergency Defender",
             player_name_full == "Oliver Florent" & round_number == "Round 4" ~ "Emergency Midfielder",
             player_name_full == "Steven May" & round_number == "Round 4" ~ "Emergency Defender",
             player_name_full == "Callum Wilkie" & round_number == "Round 4" ~ "Emergency Defender",
             player_name_full == "David Mundy" & round_number == "Round 4" ~ "Emergency Midfielder",
             
             player_name_full == "Tim Membrey" & round_number == "Round 5" ~ "Emergency Forward",
             player_name_full == "Brandon Ellis" & round_number == "Round 5" ~ "Emergency Midfielder",
             player_name_full == "Taylor Walker" & round_number == "Round 5" ~ "Emergency Forward",
             player_name_full == "Charlie Cameron" & round_number == "Round 5" ~ "Emergency Forward",
             
             player_name_full == "Sebastian Ross" & round_number == "Round 6" ~ "Emergency Midfielder",
             player_name_full == "Steele Sidebottom" & round_number == "Round 6" ~ "Emergency Midfielder",
             player_name_full == "Josh Battle" & round_number == "Round 6" ~ "Emergency Forward",
             player_name_full == "Kane Farrell" & round_number == "Round 6" ~ "Emergency Forward",
             
             player_name_full == "Kane Lambert" & round_number == "Round 7" ~ "Emergency Forward",
             player_name_full == "Stefan Martin" & round_number == "Round 7" ~ "Emergency Ruck",
             player_name_full == "Jack Redden" & round_number == "Round 7" ~ "Emergency Midfielder",
             player_name_full == "Jeremy Cameron" & round_number == "Round 7" ~ "Emergency Forward",
             player_name_full == "Charlie Curnow" & round_number == "Round 7" ~ "Emergency Forward",
             
             player_name_full == "David Mundy" & round_number == "Round 8" ~ "Emergency Midfielder",
             player_name_full == "Jye Caldwell" & round_number == "Round 8" ~ "Emergency Midfielder",
             player_name_full == "Jordan Clark" & round_number == "Round 8" ~ "Emergency Midfielder",
             player_name_full == "Brayden Maynard" & round_number == "Round 8" ~ "Emergency Defender",
             player_name_full == "Will Day" & round_number == "Round 8" ~ "Emergency Defender",
             player_name_full == "Luke McDonald" & round_number == "Round 8" ~ "Emergency Defender",
             player_name_full == "Tarryn Thomas" & round_number == "Round 8" ~ "Emergency Forward",
             player_name_full == "Chad Warner" & round_number == "Round 8" ~ "Emergency Midfielder",
             player_name_full == "Darcy Cameron" & round_number == "Round 8" ~ "Emergency Forward",
             player_name_full == "Mason Redman" & round_number == "Round 8" ~ "Emergency Defender",
             
             player_name_full == "Tom J. Lynch" & round_number == "Round 9" ~ "Emergency Forward",
             player_name_full == "Jeremy Howe" & round_number == "Round 9" ~ "Emergency Defender",
             player_name_full == "Zach Tuohy" & round_number == "Round 9" ~ "Emergency Midfielder",
             player_name_full == "Rhys Stanley" & round_number == "Round 9" ~ "Emergency Ruck",
             player_name_full == "Jarman Impey" & round_number == "Round 9" ~ "Emergency Defender",
             
             player_name_full == "Luke McDonald" & round_number == "Round 10" ~ "Emergency Defender",
             player_name_full == "Jeremy Cameron" & round_number == "Round 10" ~ "Emergency Forward",
             player_name_full == "Mason Redman" & round_number == "Round 10" ~ "Emergency Defender",
             player_name_full == "Nic Newman" & round_number == "Round 10" ~ "Emergency Defender",
             player_name_full == "Jackson Hately" & round_number == "Round 10" ~ "Emergency Midfielder",
             player_name_full == "Jai Newcombe" & round_number == "Round 10" ~ "Emergency Midfielder",
             player_name_full == "Tom Atkins" & round_number == "Round 10" ~ "Emergency Defender",
             
             player_name_full == "Bradley Hill" & round_number == "Round 11" ~ "Emergency Defender",
             player_name_full == "Jack Graham" & round_number == "Round 11" ~ "Emergency Forward",
             player_name_full == "Tom Hawkins" & round_number == "Round 11" ~ "Emergency Forward",
             player_name_full == "Chad Warner" & round_number == "Round 11" ~ "Emergency Midfielder",
             player_name_full == "Tarryn Thomas" & round_number == "Round 11" ~ "Emergency Midfielder",
             player_name_full == "Nathan Broad" & round_number == "Round 11" ~ "Emergency Defender",
             
             player_name_full == "Nick Hind" & round_number == "Round 15" ~ "Emergency Defender",
             player_name_full == "Jack Newnes" & round_number == "Round 15" ~ "Emergency Midfielder",
             player_name_full == "Liam Duggan" & round_number == "Round 15" ~ "Emergency Defender",
             player_name_full == "Sam Powell-Pepper" & round_number == "Round 15" ~ "Emergency Midfielder",
             player_name_full == "Mitch Lewis" & round_number == "Round 15" ~ "Emergency Forward",
             
             player_name_full == "Bradley Hill" & round_number == "Round 16" ~ "Emergency Defender",
             player_name_full == "Jaeger O'Meara" & round_number == "Round 16" ~ "Emergency Midfielder",
             player_name_full == "Rowan Marshall" & round_number == "Round 16" ~ "Emergency Ruck",
             player_name_full == "David Swallow" & round_number == "Round 16" ~ "Emergency Defender",
             player_name_full == "Nic Martin" & round_number == "Round 16" ~ "Emergency Forward",
             player_name_full == "Jackson Hately" & round_number == "Round 16" ~ "Emergency Midfielder",
             player_name_full == "Tom Hickey" & round_number == "Round 16" ~ "Emergency Ruck",
             player_name_full == "Keidean Coleman" & round_number == "Round 16" ~ "Emergency Forward",
             player_name_full == "Mason Redman" & round_number == "Round 16" ~ "Emergency Defender",
             player_name_full == "Justin McInerney" & round_number == "Round 16" ~ "Emergency Defender",
             player_name_full == "Jack Bowes" & round_number == "Round 16" ~ "Emergency Defender",
             player_name_full == "David Mundy" & round_number == "Round 16" ~ "Emergency Midfielder",
             
             player_name_full == "Lance Franklin" & round_number == "Round 17" ~ "Emergency Forward",
             player_name_full == "Josh Daicos" & round_number == "Round 17" ~ "Emergency Midfielder",
             player_name_full == "Sam Powell-Pepper" & round_number == "Round 17" ~ "Emergency Midfielder"
           )
         )

all_fielded_teams_full <-
  all_fielded_teams_full %>%
  mutate(fielded_position = ifelse(!is.na(fielded_position_2), fielded_position_2, fielded_position)) %>%
  select(-fielded_position_2)

#===============================================================================
# Get details for players who didn't play any games from player data table
#===============================================================================

names_to_join <-
  player_details %>%
  filter(player_name %notin% all_fielded_teams_full$player_name_full) %>%
  select(player_name, club = team, height, weight, dob) %>%
  mutate(
    player_first_initial = str_extract(player_name, "^[A-Z]"),
    player_last_name = str_extract(player_name, "[A-Za-z-']*$"),
    player_name_initials = paste(player_first_initial,
                                 ". ",
                                 player_last_name,
                                 sep = "")) %>%
  select(-player_first_initial, -player_last_name) %>%
  filter(player_name_initials %in% all_fielded_teams_full$player_name) %>%
  filter(player_name_initials %notin% c("T. Lynch", "C. Warner", "C. Brown", "S. Darcy", "Z. Williams")) # Manually filter out duplicate players who didn't get picked for whole year


