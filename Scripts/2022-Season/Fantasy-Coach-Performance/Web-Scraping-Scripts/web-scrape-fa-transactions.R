##%######################################################%##
#                                                          #
####        Web scrape FA transactions from HTML        ####
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

transaction_files <- dir("Data/HTML-files/transactions")
transaction_files <- sort(transaction_files)

#===============================================================================
# Create function that reads html and outputs players table
#===============================================================================

get_transactions <- function(html_path) {
  # Read HTML from path
  full_path <- paste("Data/HTML-files/transactions/", html_path, sep = "")
  html_source <- read_html(full_path)
  
  # Create players vector and return
  transactions <-
    html_source %>%
    html_elements(".hJZdqq") %>%
    html_text2()
  
  return(transactions)
}

##%######################################################%##
#                                                          #
####         Get list of scraped text (in form          ####
####       of a character vector) for each round        ####
#                                                          #
##%######################################################%##

transactions_by_round <- map(transaction_files, get_transactions)

##%######################################################%##
#                                                          #
####      Function to extract transaction details       ####
#                                                          #
##%######################################################%##

extract_transaction <- function(transaction_vector) {
  
# Process Strings
transaction_vector <- str_remove_all(transaction_vector, "(\n)|(Uncertain)|(the Free Agent:)|(Close Circle Logo)|(Transactions)|(\\.)|(Injured)|(the Restricted Free Agent)")
transaction_vector <- str_replace_all(transaction_vector, "(Defender)|(Forward)|(Midfielder)|(Ruck)|(:)", " ")
transaction_vector <- str_replace_all(transaction_vector, "(Def)|(Fwd)|(Mid)|(Ruck)|(:)", " ")
transaction_vector <- str_replace_all(transaction_vector, "/[ ]{1,}[ ]", "")
transaction_vector <- str_replace_all(transaction_vector, "[ ]{2,}", " ")
transaction_vector <- transaction_vector[str_detect(transaction_vector, "initiated and traded", negate = TRUE)]

# Extract Dates
dates <- str_extract_all(transaction_vector, "^.* 2022") %>% str_replace_all(" ", "-")

# Extract Team
team <- str_extract_all(transaction_vector, "(?<=2022)[A-Za-z4 ']{5,31}(?= selected| delisted)")

# Get Selected Players
selected <- str_extract_all(transaction_vector, "(?<=selected )[A-Za-z '-]{5,30}(?= And | $)")
selected[sapply(selected, is_empty)] <- NA

# Get Delisted Players
delisted <- str_extract_all(transaction_vector, "(?<=delisted )[A-Za-z '-]{5,30}(?= $)")
delisted[sapply(delisted, is_empty)] <- NA

# Create Output Tibble
selected <- tibble(date = dates, team = unlist(team), player_name = unlist(selected), type = "selected")
delisted <- tibble(date = dates, team = unlist(team), player_name = unlist(delisted), type = "delisted")
transaction_df <- bind_rows(selected, delisted) %>% filter(!is.na(player_name))
transaction_df$date <- as.Date(transaction_df$date, "%d-%B-%Y")

return(transaction_df)

}

##%######################################################%##
#                                                          #
####   Apply function to extract transasction details   ####
####      to list of transaction character vectors      ####
#                                                          #
##%######################################################%##

all_transactions <- map(transactions_by_round, extract_transaction)
all_transactions <- bind_rows(all_transactions)

##%######################################################%##
#                                                          #
####          Add Stats to transactions table           ####
#                                                          #
##%######################################################%##

# Get averages
fantasy_averages <-
combined_stats_table %>%
  filter(round_number < "Round 18") %>%
  filter(TOG > 50) %>%
  summarise(`Avg Points` = mean(fantasy_points), games_played = max(games_played)) %>%
  mutate(player_name = str_replace(player_name, "\\.", "")) %>%
  mutate(player_name = str_replace(player_name, "Paddy McCartin", "Patrick McCartin")) %>%
  mutate(player_name = str_replace(player_name, "Josh Rachele", "Joshua Rachele"))

# Join with main table
all_transactions <-
  all_transactions %>%
  left_join(fantasy_averages)

##%######################################################%##
#                                                          #
####                Analyse Transactions                ####
#                                                          #
##%######################################################%##

# Total Transactions by Team
all_transactions %>%
  filter(type == "selected") %>%
  group_by(team) %>%
  tally() %>%
  arrange(desc(n))

# Total Transactions by player (selected)
all_transactions %>%
  filter(type == "selected") %>%
  group_by(player_name) %>%
  tally() %>%
  arrange(desc(n))

# Total Transactions by player (delisted)
all_transactions %>%
  filter(type == "delisted") %>%
  group_by(player_name) %>%
  tally() %>%
  arrange(desc(n))

# Each team's most selected player
all_transactions %>%
  filter(type == "selected") %>%
  group_by(team, player_name) %>%
  tally() %>%
  group_by(team) %>%
  arrange(desc(n)) %>%
  slice(1)

# Each team's most delisted player
all_transactions %>%
  filter(type == "delisted") %>%
  group_by(team, player_name) %>%
  tally() %>%
  group_by(team) %>%
  arrange(desc(n)) %>%
  slice(1)

# Costly Delistings
all_transactions %>%
  arrange(date) %>%
  group_by(team, player_name) %>%
  filter(row_number() == n()) %>%
  ungroup() %>%
  filter(type == "delisted") %>%
  arrange(desc(`Avg Points`))

# Best Pickups
all_transactions %>%
  arrange(date) %>%
  group_by(team, player_name) %>%
  filter(row_number() == n()) %>%
  ungroup() %>%
  filter(type == "selected") %>%
  arrange(desc(`Avg Points`))
