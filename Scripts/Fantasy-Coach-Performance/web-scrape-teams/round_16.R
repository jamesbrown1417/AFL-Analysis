##%######################################################%##
#                                                          #
####          Web scrape teams as of round 16           ####
#                                                          #
##%######################################################%##


# Libraries, functions and data
library(tidyverse)
library(rvest)
combined_stats_table <- read_rds("Data/RDS-files/combined_stats_table_2022.rds")

##%######################################################%##
#                                                          #
####             Read in HTML of team pages             ####
#                                                          #
##%######################################################%##

# Create function that reads html and outputs table
get_ages <- function(html_path) {
  df <- read_html(html_path)
  
  df <-
    df %>%
    html_elements(".full") %>%
    html_text2()
  
  df <- combined_stats_table %>%
    filter(player_name %in% df) %>%
    distinct(player_name, dob) %>%
    mutate(player_age = as.numeric(lubridate::today() - dob) / 365.25)
  
  return(df)
}

#===============================================================================
# Get dataframes
#===============================================================================

brown <- get_ages("Data/j_brown.html")
aoukar <- get_ages("Data/p_aoukar.html")
baron <- get_ages("Data/m_baron.html")
rossi <- get_ages("Data/j_rossi.html")
marateo <- get_ages("Data/a_marateo.html")
pansini <- get_ages("Data/n_pansini.html")
bishop <- get_ages("Data/s_bishop.html")
kirch <- get_ages("Data/n_kirchner.html")

# Add Karl Worner to rossi's team
rossi <- rossi %>% bind_rows(tibble(
  player_name = "Karl Worner",
  dob = as.Date("2002-06-16"),
  player_age = as.numeric(lubridate::today() - as.Date("2002-06-16")) / 365.25
))

# All coaches and player ages
all_ages <-
  bind_rows(brown %>% mutate(coach = "James Brown"),
            aoukar %>% mutate(coach = "Paul Aoukar"),
            baron %>% mutate(coach = "Matt Baron"),
            rossi %>% mutate(coach = "John Rossi"),
            marateo %>% mutate(coach = "Alex Marateo"),
            pansini %>% mutate(coach = "Nic Pansini"),
            bishop %>% mutate(coach = "Sam Bishop"),
            kirch %>% mutate(coach = "Nick Kirchner"))

# Get summary
all_ages_summary <-
all_ages %>%
  group_by(coach) %>%
  summarise(
  average_age = round(mean(player_age), 2),
  oldest_player_age = round(max(player_age), 2),
  youngest_player_age = round(min(player_age), 2)) %>%
  arrange(desc(average_age))

all_ages_summary %>% kableExtra::kbl() %>% kableExtra::kable_styling()



