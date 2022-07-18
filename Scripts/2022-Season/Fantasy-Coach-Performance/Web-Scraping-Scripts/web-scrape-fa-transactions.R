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

##%######################################################%##
#                                                          #
####                        Test                        ####
#                                                          #
##%######################################################%##

# Strings
a <- get_transactions("round_01_transactions.html")
a <- str_remove_all(a, "(\n)|(Uncertain)|(the Free Agent:)|(Close Circle Logo)|(Transactions)|(\\.)|(Injured)|(the Restricted Free Agent)")
a <- str_replace_all(a, "(Defender)|(Forward)|(Midfielder)|(Ruck)|(:)", " ")
a <- str_replace_all(a, "(Def)|(Fwd)|(Mid)|(Ruck)|(:)", " ")
a <- str_replace_all(a, "/[ ]{1,}[ ]", "")
a <- str_replace_all(a, "[ ]{2,}", " ")
a

# Dates
dates <- str_extract_all(a, "^.* 2022") %>% str_replace_all(" ", "-")
dates


# Team
team <- str_extract_all(a, "(?<=2022)[A-Za-z ']{5,31}(?= selected| delisted)")

# Player Selected
selected <- str_extract_all(a, "(?<=selected )[A-Za-z '-]{5,30}(?= And | $)")
selected[sapply(selected, is_empty)] <- NA

# Player Delisted
delisted <- str_extract_all(a, "(?<=delisted )[A-Za-z '-]{5,30}(?= $)")
delisted[sapply(delisted, is_empty)] <- NA

# Round 1 tibble
selected <- tibble(date = dates, team = unlist(team), player_name = unlist(selected), type = "selected")
delisted <- tibble(date = dates, team = unlist(team), player_name = unlist(delisted), type = "delisted")
round_1_transactions <- bind_rows(selected, delisted) %>% filter(!is.na(player_name))
round_1_transactions$date <- as.Date(round_1_transactions$date, "%d-%B-%Y")
