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

##%######################################################%##
#                                                          #
####             Read in HTML of team pages             ####
#                                                          #
##%######################################################%##

#===============================================================================
# Get list of files in Data/HTML-files folder
#===============================================================================

matchup_files <- dir("Data/HTML-files/matchups")
matchup_files <- sort(matchup_files)

#===============================================================================
# Create function that reads html and outputs table
#===============================================================================

get_matchups <- function(html_path) {
  # Read HTML from path
  full_path <- paste("Data/HTML-files/matchups/", html_path, sep = "")
  html_source <- read_html(full_path)
  
  # Create matchups vector and return
  matchups <-
    html_source %>%
    html_elements(".bmYPWD") %>%
    html_text2()
  
  return(matchups)
}

all_matchups <- map(matchup_files, get_matchups)

#===============================================================================
# Get rid of coach names from matchups list
#===============================================================================

# Function that strips names from string
remove_coach_name <- function(new_string_vec){
  new_string_vec <- str_remove_all(new_string_vec, "Jonathon R.")
  new_string_vec <- str_remove_all(new_string_vec, "James B.")
  new_string_vec <- str_remove_all(new_string_vec, "Sam B.")
  new_string_vec <- str_remove_all(new_string_vec, "Nick K.")
  new_string_vec <- str_remove_all(new_string_vec, "Nicholas P.")
  new_string_vec <- str_remove_all(new_string_vec, "Alex M.")
  new_string_vec <- str_remove_all(new_string_vec, "Matt B.")
  new_string_vec <- str_remove_all(new_string_vec, "Paul A.")
  return(new_string_vec)
}

# Apply to list
all_matchups <- map(all_matchups, remove_coach_name)

#===============================================================================
# Get rid of full time from matchups list
#===============================================================================

# Function that strips names from string
remove_full_time <- function(new_string_vec){
  new_string_vec <- str_remove_all(new_string_vec, "Full time")
  return(new_string_vec)
}

# Apply to list
all_matchups <- map(all_matchups, remove_full_time)

#===============================================================================
# Loop through matchups and extract results, push to a list
#===============================================================================

# Results list
results <- list()

# Loop to add to results list
for (j in 1:length(all_matchups)) {
  # Get round matchups and round number
  matchups <- all_matchups[[j]]
  this_round <- paste("Round", j)
  
  # Round results list
  round_results_list <- list()
  
  for (i in 1:4) {
    # Get results from fixture
    scores <- str_extract_all(matchups[i], "[0-9]{3,4}")[[1]]
    teams <-
      str_extract_all(matchups[i], "\\n[A-Za-z '4]{5,}\\n")[[1]] %>% str_remove_all("\\n")
    
    # Get result tibble
    round_results <-
      bind_rows(
        tibble(
          team = teams[1],
          score = scores[1],
          opposition = teams[2],
          opposition_score = scores[2],
          round_number = this_round
        ),
        tibble(
          team = teams[2],
          score = scores[2],
          opposition = teams[1],
          opposition_score = scores[1],
          round_number = this_round
        )
      )
    
    round_results_list[[i]] <- round_results
  }
  results[[j]] <- bind_rows(round_results_list)
}

# Bind together dataframes to get all results
all_results <- bind_rows(results)

# Fix round numbers 12, 13 and 14
all_results$round_number <- ifelse(all_results$round_number == "Round 12", "Round 15", all_results$round_number)
all_results$round_number <- ifelse(all_results$round_number == "Round 13", "Round 16", all_results$round_number)
all_results$round_number <- ifelse(all_results$round_number == "Round 14", "Round 17", all_results$round_number)

# Make round number an ordered factor
all_results$round_number <-
  factor(
    all_results$round_number,
    levels = c(
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
    ),
    ordered = TRUE
  )

# Make score and opposition score numeric variables
all_results$score <- as.numeric(all_results$score)
all_results$opposition_score <- as.numeric(all_results$opposition_score)

# Add win variable
all_results$result <- ifelse(all_results$score > all_results$opposition_score, "Win", "Loss")
all_results$result <- ifelse(all_results$score == all_results$opposition_score, "Draw", all_results$result)

# Recreate ladder
ladder <-
  all_results %>%
  group_by(team) %>%
  summarise(
    W = sum(result == "Win"),
    L = sum(result == "Loss"),
    D = sum(result == "Draw"),
    PF = sum(as.numeric(score)),
    PA = sum(as.numeric(opposition_score)),
    `%` = round((PF / PA) * 100, digits = 3),
    Points = 4 * W + 2 * D
  ) %>%
  arrange(desc(Points), desc(`%`))

# Lowest winning totals
all_results %>%
  filter(result == "Win") %>%
  arrange(score) %>%
  head(5)

# Highest losing total
all_results %>%
  filter(result == "Loss") %>%
  arrange(desc(score)) %>%
  head(5)

# Highest scores for the season
all_results %>%
  arrange(desc(score)) %>%
  head(10)

# Lowest scores for the season
all_results %>%
  arrange(score) %>%
  head(10)

# Get number of scores over 1600
all_results %>%
  group_by(team) %>%
  summarise(`Number of 1600+ Scores` = sum(as.numeric(score) >= 1600)) %>%
  arrange(desc(`Number of 1600+ Scores`))

# Get number of scores over 1700
all_results %>%
  group_by(team) %>%
  summarise(`Number of 1700+ Scores` = sum(as.numeric(score) >= 1700)) %>%
  arrange(desc(`Number of 1700+ Scores`))

# Get number of scores below 1500
all_results %>%
  group_by(team) %>%
  summarise(`Number of Scores Below 1500` = sum(as.numeric(score) < 1500)) %>%
  arrange(desc(`Number of Scores Below 1500`))

# Get number of scores below 1400
all_results %>%
  group_by(team) %>%
  summarise(`Number of Scores Below 1400` = sum(as.numeric(score) < 1400)) %>%
  arrange(desc(`Number of Scores Below 1400`))

# Get number of scores below 1300
all_results %>%
  group_by(team) %>%
  summarise(`Number of Scores Below 1300` = sum(as.numeric(score) < 1300)) %>%
  arrange(desc(`Number of Scores Below 1300`))

# Biggest margin
all_results %>%
  mutate(margin = as.numeric(score) - as.numeric(opposition_score)) %>%
  arrange(desc(margin)) %>%
  head(10)

# Smallest margin
all_results %>%
  mutate(margin = as.numeric(score) - as.numeric(opposition_score)) %>%
  filter(margin >= 0) %>%
  arrange(margin) %>%
  head(10)

# Season series
all_results %>%
  mutate(margin = as.numeric(score) - as.numeric(opposition_score)) %>%
  group_by(team, opposition) %>%
  summarise(`Season Series Margin` = sum(margin))
