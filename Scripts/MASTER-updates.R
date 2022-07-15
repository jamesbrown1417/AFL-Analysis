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
# Render Weekly Summaries Function
#===============================================================================

weekly_reports_update <- function(season = "2022") {
  
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
  date_today <- as.character(lubridate::today())
  
  # Render Top Players Report
  quarto::quarto_render(
    "01-top-players-report.qmd",
    output_format = "html",
    output_file = paste("Top-Players-Report-", date_today, ".html", sep = "")
  )
  
  # Render CBA Change Report
  quarto::quarto_render(
    "02-CBA-change-report.qmd",
    output_format = "html",
    output_file = paste("CBA-Change-Report-", date_today, ".html", sep = "")
  )
  
  # Render Heatmaps
  quarto::quarto_render(
    "03-heatmaps.qmd",
    output_format = "html",
    output_file = paste("Heatmaps-", date_today, ".html", sep = "")
  )
  
  # Render Fantasy Form Report
  quarto::quarto_render(
    "04-fantasy-form-report.qmd",
    output_format = "html",
    output_file = paste("Fantasy-Form-Report-", date_today, ".html", sep = "")
  )
  
  # Move files to output folder
  current_files <- list.files(pattern = ".html")
  for (i in 1:length(current_files)) {
    file.rename(
      current_files[i],
      paste(
        "../../../Output/Weekly-Reports/",
        current_files[i],
        ".html",
        sep = ""
      )
    )
  }
  
  # Go back to project directory
  setwd(project_wd)
}

#===============================================================================
# Render Season Summaries Function
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
  date_today <- as.character(lubridate::today())
  
  # Render Draft and FA Report
  quarto::quarto_render(
    "01-draft-and-FA-report.qmd",
    output_format = "html",
    output_file = paste("Draft-and-FA-Report-", date_today, ".html", sep = "")
  )
  
  # Render Fantasy Draft Season Summary
  quarto::quarto_render(
    "02-season-summary.qmd",
    output_format = "html",
    output_file = paste("Draft-Season-Summary-", date_today, ".html", sep = "")
  )
  
  # Render Fantasy Draft Player Summary
  quarto::quarto_render(
    "03-season-players-report.qmd",
    output_format = "html",
    output_file = paste("Draft-Player-Summary-", date_today, ".html", sep = "")
  )
  
  # Move files to output folder
  current_files <- list.files(pattern = ".html")
  for (i in 1:length(current_files)) {
    file.rename(
      current_files[i],
      paste(
        "../../../Output/Season-Summaries/",
        current_files[i],
        ".html",
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

# Update Data
stats_update()

# Update Weekly Reports
weekly_reports_update()

# Update Season Summaries
season_reports_update()
