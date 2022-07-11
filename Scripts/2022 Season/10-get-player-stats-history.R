##%######################################################%##
#                                                          #
####     Read in all combined player stats datasets     ####
#                                                          #
##%######################################################%##

# Libraries
library(tidyverse)

# Read data

# Get file names
files_list = list.files("Data/RDS-files")
files_list <- files_list[str_detect(files_list, "stats_table")]
files_list <- str_replace(files_list, ".rds", "")


# Read them in a loop
for (i in 1:length(files_list)){
  assign(files_list[i], read_rds(paste("Data/RDS-files/", files_list[i], ".rds", sep = "")))
}

# Combine into a single df
all_player_stats = bind_rows(mget(files_list))

##%######################################################%##
#                                                          #
####               Create function to get               ####
####            historical data for a player            ####
#                                                          #
##%######################################################%##

get_historical_player_stats <- function(player) {
  return_df <-
    all_player_stats %>%
    filter(player_name == player) %>%
  arrange(Season, round_number)
  return(return_df)
}

##%######################################################%##
#                                                          #
####  Use function to get data for players of interest  ####
#                                                          #
##%######################################################%##

lyons <- get_historical_player_stats(player = "Jarryd Lyons")
