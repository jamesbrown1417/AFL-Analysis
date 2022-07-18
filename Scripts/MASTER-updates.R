##%######################################################%##
#                                                          #
####                  Setup Functions                   ####
#                                                          #
##%######################################################%##

#===============================================================================
# Update combined stats table and player positions function
#===============================================================================

stats_update <- function() {
  source("Scripts/Update-Data/01-get-fantasy-positions.R")
  source("Scripts/Update-Data/02-get-fantasy-players-data.R")
}

#===============================================================================
# Render Fantasy Weekly Summaries Function
#===============================================================================

fantasy_weekly_reports_update <- function(season = "2022") {
  
  # Get path to scripts
  path_to_scripts <-
    paste("Scripts/",
          season,
          "-Season/Fantasy-Player-Performance/",
          sep = "")
  
  # Get project wd
  project_wd <- getwd()
  
  # Change wd to folder with scripts
  setwd(path_to_scripts)
  
  # Render CBA Change Report
  quarto::quarto_render(
    "02-CBA-change-report.qmd",
    output_format = "html",
    output_file = paste("CBA-Change-Report", ".html", sep = "")
  )
  
  # Render Fantasy Form Report
  quarto::quarto_render(
    "04-fantasy-form-report.qmd",
    output_format = "html",
    output_file = paste("Fantasy-Form-Report", ".html", sep = "")
  )
  
  # Move files to output folder
  current_files <- list.files(pattern = ".html")
  for (i in 1:length(current_files)) {
    file.rename(
      current_files[i],
      paste(
        "../../../Output/Weekly-Reports/",
        season,
        "/",
        current_files[i],
        sep = ""
      )
    )
  }
  
  # Go back to project directory
  setwd(project_wd)
}

#===============================================================================
# Render Fantasy Player Season Summaries Function
#===============================================================================

fantasy_season_player_reports_update <- function(season = "2022") {
  
  # Get path to scripts
  path_to_scripts <-
    paste("Scripts/",
          season,
          "-Season/Fantasy-Player-Performance/",
          sep = "")
  
  # Get project wd
  project_wd <- getwd()
  
  # Change wd to folder with scripts
  setwd(path_to_scripts)
  
  # Render Top Players Report
  quarto::quarto_render(
    "01-top-players-report.qmd",
    output_format = "html",
    output_file = paste("Top-Players-Report", ".html", sep = "")
  )
  
  
  # Render Heatmaps
  quarto::quarto_render(
    "03-heatmaps.qmd",
    output_format = "html",
    output_file = paste("Heatmaps", ".html", sep = "")
  )
  
  # Move files to output folder
  current_files <- list.files(pattern = ".html")
  for (i in 1:length(current_files)) {
    file.rename(
      current_files[i],
      paste(
        "../../../Output/Season-Summaries/",
        season,
        "/",
        current_files[i],
        sep = ""
      )
    )
  }
  
  # Go back to project directory
  setwd(project_wd)
}

#===============================================================================
# Render Fantasy coach Season Summaries Function
#===============================================================================

season_reports_update <- function(season = "2022"){
  # Get path to scripts
  path_to_scripts <-
    paste("Scripts/",
          season,
          "-Season/Fantasy-Coach-Performance/",
          sep = "")
  
  # Get project wd
  project_wd <- getwd()
  
  # Change wd to folder with scripts
  setwd(path_to_scripts)
  
  # Render Draft and FA Report
  quarto::quarto_render(
    "01-draft-and-FA-report.qmd",
    output_format = "html",
    output_file = paste("Draft-and-FA-Report", ".html", sep = "")
  )
  
  # Render Fantasy Draft Season Summary
  quarto::quarto_render(
    "02-season-summary.qmd",
    output_format = "html",
    output_file = paste("Draft-Season-Summary", ".html", sep = "")
  )
  
  # Render Fantasy Draft Player Summary
  quarto::quarto_render(
    "03-season-players-report.qmd",
    output_format = "html",
    output_file = paste("Draft-Player-Summary", ".html", sep = "")
  )
  
  # Move files to output folder
  current_files <- list.files(pattern = ".html")
  for (i in 1:length(current_files)) {
    file.rename(
      current_files[i],
      paste(
        "../../../Output/Season-Summaries/",
        season,
        "/",
        current_files[i],
        sep = ""
      )
    )
  }
  
  # Go back to project directory
  setwd(project_wd)
}

#===============================================================================
# Render Weekly Player Stats Report
#===============================================================================

weekly_player_stats_update <- function(season = "2022") {
  
  # Get path to scripts
  path_to_scripts <-
    paste("Scripts/",
          season,
          "-Season/Player-Stats/",
          sep = "")
  
  # Get project wd
  project_wd <- getwd()
  
  # Change wd to folder with scripts
  setwd(path_to_scripts)
  
  # Render Weekly Player Stats Report
  quarto::quarto_render(
    "01-Weekly-Player-Report.qmd",
    output_format = "html",
    output_file = paste("Weekly-Player-Stats-Report", ".html", sep = "")
  )
  
  # Move files to output folder
  current_files <- list.files(pattern = ".html")
  for (i in 1:length(current_files)) {
    file.rename(
      current_files[i],
      paste(
        "../../../Output/Weekly-Reports/",
        season,
        "/",
        current_files[i],
        sep = ""
      )
    )
  }
  
  # Go back to project directory
  setwd(project_wd)
}

#===============================================================================
# Render Weekly Team Stats Report
#===============================================================================

weekly_team_stats_update <- function(season = "2022") {
  
  # Get path to scripts
  path_to_scripts <-
    paste("Scripts/",
          season,
          "-Season/Team-Stats/",
          sep = "")
  
  # Get project wd
  project_wd <- getwd()
  
  # Change wd to folder with scripts
  setwd(path_to_scripts)
  
  # Render Weekly Player Stats Report
  quarto::quarto_render(
    "01-Team-Stats-Weekly-Report.qmd",
    output_format = "html",
    output_file = paste("Weekly-Team-Stats-Report", ".html", sep = "")
  )
  
  # Move files to output folder
  current_files <- list.files(pattern = ".html")
  for (i in 1:length(current_files)) {
    file.rename(
      current_files[i],
      paste(
        "../../../Output/Weekly-Reports/",
        season,
        "/",
        current_files[i],
        sep = ""
      )
    )
  }
  
  # Go back to project directory
  setwd(project_wd)
}

#===============================================================================
# Render Season Player Stats Report
#===============================================================================

season_player_stats_update <- function(season = "2022") {
  
  # Get path to scripts
  path_to_scripts <-
    paste("Scripts/",
          season,
          "-Season/Player-Stats/",
          sep = "")
  
  # Get project wd
  project_wd <- getwd()
  
  # Change wd to folder with scripts
  setwd(path_to_scripts)
  
  # Render Weekly Player Stats Report
  quarto::quarto_render(
    "02-Season-Player-Summaries.qmd",
    output_format = "html",
    output_file = paste("Season-Player-Stats-Report", ".html", sep = "")
  )
  
  # Move files to output folder
  current_files <- list.files(pattern = ".html")
  for (i in 1:length(current_files)) {
    file.rename(
      current_files[i],
      paste(
        "../../../Output/Season-Summaries/",
        season,
        "/",
        current_files[i],
        sep = ""
      )
    )
  }
  
  # Go back to project directory
  setwd(project_wd)
}

#===============================================================================
# Render Season Team Stats Report
#===============================================================================

season_team_stats_update <- function(season = "2022") {
  
  # Get path to scripts
  path_to_scripts <-
    paste("Scripts/",
          season,
          "-Season/Team-Stats/",
          sep = "")
  
  # Get project wd
  project_wd <- getwd()
  
  # Change wd to folder with scripts
  setwd(path_to_scripts)
  
  # Render Season Team Stats Report
  quarto::quarto_render(
    "02-Team-Stats-Season-Summary.qmd",
    output_format = "html",
    output_file = paste("Season-Team-Stats-Report", ".html", sep = "")
  )
  
  # Render Season Opposition Stats Report
  quarto::quarto_render(
    "03-Opposition-Stats-Season-Summary.qmd",
    output_format = "html",
    output_file = paste("Season-Opposition-Stats-Report", ".html", sep = "")
  )
  
  # Move files to output folder
  current_files <- list.files(pattern = ".html")
  for (i in 1:length(current_files)) {
    file.rename(
      current_files[i],
      paste(
        "../../../Output/Season-Summaries/",
        season,
        "/",
        current_files[i],
        sep = ""
      )
    )
  }
  
  # Go back to project directory
  setwd(project_wd)
}

##%######################################################%##
#                                                          #
####                   Run Functions                    ####
#                                                          #
##%######################################################%##

#===============================================================================
# Update Data
#===============================================================================

stats_update()

#===============================================================================
# Update Weekly Reports
#===============================================================================

fantasy_weekly_reports_update()
weekly_player_stats_update()
weekly_team_stats_update()

#===============================================================================
# Update Fantasy Season Summaries
#===============================================================================

fantasy_season_player_reports_update()
# fantasy_season_reports_update()

#===============================================================================
# Update Player / Team Season Summaries
#===============================================================================

season_player_stats_update()
season_team_stats_update()
