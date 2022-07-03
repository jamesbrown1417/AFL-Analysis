##%######################################################%##
#                                                          #
####    Get heatmaps of CBA attendance for each team    ####
#                                                          #
##%######################################################%##


# Libraries and data
library(tidyverse)
library(ztable)
combined_stats_table <- read_rds("Data/RDS-files/combined_stats_table_2022.rds")

# Options
options(ztable.type="html")
options(ztable.colnames.bold=TRUE)

##%######################################################%##
#                                                          #
####                  Create heatmaps                   ####
#                                                          #
##%######################################################%##

#===============================================================================
# Adelaide Crows
#===============================================================================

# Create dataframe
ADL_CBAs <-
  combined_stats_table %>%
  filter(team == "Adelaide Crows") %>%
  select(`Player Name` = player_name, CBA_percentage, round_number) %>%
  group_by(`Player Name`) %>%
  filter(max(CBA_percentage, na.rm = TRUE) > 0) %>%
  ungroup() %>%
  arrange(`Player Name`, round_number) %>%
  pivot_wider(id_cols = `Player Name`, names_from = round_number, values_from = CBA_percentage)

ADL_CBA_avgs <-
combined_stats_table %>%
  filter(team == "Adelaide Crows") %>%
  group_by(player_name) %>%
  summarise(`Mean CBA Percentage` = mean(CBA_percentage, na.rm = TRUE)) %>%
  rename(`Player Name` = player_name)

ADL_heatmap <- ADL_CBAs %>% left_join(ADL_CBA_avgs) %>% arrange(desc(`Mean CBA Percentage`))

# Make playernames the row labels
ADL_heatmap <- as.data.frame(ADL_heatmap)
rownames(ADL_heatmap) <- ADL_heatmap$`Player Name`
ADL_heatmap <- ADL_heatmap %>% select(-`Player Name`)

# Make heatmap
ztable(ADL_heatmap,
       type = "viewer",
       align = "ccccccccccccccccccccc") %>%
  makeHeatmap(palette = "Oranges") %>%
  vlines(type = "all") %>%
  hlines(type = "all")

#===============================================================================
# Brisbane Lions
#===============================================================================

# Create dataframe
BRISBANE_CBAs <-
  combined_stats_table %>%
  filter(team == "Brisbane Lions") %>%
  select(`Player Name` = player_name, CBA_percentage, round_number) %>%
  group_by(`Player Name`) %>%
  filter(max(CBA_percentage, na.rm = TRUE) > 0) %>%
  ungroup() %>%
  arrange(round_number) %>%
  pivot_wider(id_cols = `Player Name`, names_from = round_number, values_from = CBA_percentage)

BRISBANE_CBA_avgs <-
  combined_stats_table %>%
  filter(team == "Brisbane Lions") %>%
  group_by(player_name) %>%
  summarise(`Mean CBA Percentage` = mean(CBA_percentage, na.rm = TRUE)) %>%
  rename(`Player Name` = player_name)

BRISBANE_heatmap <- BRISBANE_CBAs %>% left_join(BRISBANE_CBA_avgs) %>% arrange(desc(`Mean CBA Percentage`))

# Make playernames the row labels
BRISBANE_heatmap <- as.data.frame(BRISBANE_heatmap)
rownames(BRISBANE_heatmap) <- BRISBANE_heatmap$`Player Name`
BRISBANE_heatmap <- BRISBANE_heatmap %>% select(-`Player Name`)

# Make heatmap
ztable(BRISBANE_heatmap,
       type = "viewer",
       align = "ccccccccccccccccccccc") %>%
  makeHeatmap(palette = "Oranges") %>%
  vlines(type = "all") %>%
  hlines(type = "all")

#===============================================================================
# CARLTON
#===============================================================================

# Create dataframe
CARLTON_CBAs <-
  combined_stats_table %>%
  filter(team == "Carlton") %>%
  select(`Player Name` = player_name, CBA_percentage, round_number) %>%
  group_by(`Player Name`) %>%
  filter(max(CBA_percentage, na.rm = TRUE) > 0) %>%
  ungroup() %>%
  arrange(round_number) %>%
  pivot_wider(id_cols = `Player Name`, names_from = round_number, values_from = CBA_percentage)

CARLTON_CBA_avgs <-
  combined_stats_table %>%
  filter(team == "Carlton") %>%
  group_by(player_name) %>%
  summarise(`Mean CBA Percentage` = mean(CBA_percentage, na.rm = TRUE)) %>%
  rename(`Player Name` = player_name)

CARLTON_heatmap <- CARLTON_CBAs %>% left_join(CARLTON_CBA_avgs) %>% arrange(desc(`Mean CBA Percentage`))

# Make playernames the row labels
CARLTON_heatmap <- as.data.frame(CARLTON_heatmap)
rownames(CARLTON_heatmap) <- CARLTON_heatmap$`Player Name`
CARLTON_heatmap <- CARLTON_heatmap %>% select(-`Player Name`)

# Make heatmap
ztable(CARLTON_heatmap,
       type = "viewer",
       align = "ccccccccccccccccccccc") %>%
  makeHeatmap(palette = "Oranges") %>%
  vlines(type = "all") %>%
  hlines(type = "all")

#===============================================================================
# Collingwood
#===============================================================================

# Create dataframe
COLL_CBAs <-
  combined_stats_table %>%
  filter(team == "Collingwood") %>%
  select(`Player Name` = player_name, CBA_percentage, round_number) %>%
  group_by(`Player Name`) %>%
  filter(max(CBA_percentage, na.rm = TRUE) > 0) %>%
  ungroup() %>%
  arrange(round_number) %>%
  pivot_wider(id_cols = `Player Name`, names_from = round_number, values_from = CBA_percentage)

COLL_CBA_avgs <-
  combined_stats_table %>%
  filter(team == "Collingwood") %>%
  group_by(player_name) %>%
  summarise(`Mean CBA Percentage` = mean(CBA_percentage, na.rm = TRUE)) %>%
  rename(`Player Name` = player_name)

COLL_heatmap <- COLL_CBAs %>% left_join(COLL_CBA_avgs) %>% arrange(desc(`Mean CBA Percentage`))

# Make playernames the row labels
COLL_heatmap <- as.data.frame(COLL_heatmap)
rownames(COLL_heatmap) <- COLL_heatmap$`Player Name`
COLL_heatmap <- COLL_heatmap %>% select(-`Player Name`)

# Make heatmap
ztable(COLL_heatmap,
       type = "viewer",
       align = "ccccccccccccccccccccc") %>%
  makeHeatmap(palette = "Oranges") %>%
  vlines(type = "all") %>%
  hlines(type = "all")

#===============================================================================
# Essendon
#===============================================================================

# Create dataframe
ESS_CBAs <-
  combined_stats_table %>%
  filter(team == "Essendon") %>%
  select(`Player Name` = player_name, CBA_percentage, round_number) %>%
  group_by(`Player Name`) %>%
  filter(max(CBA_percentage, na.rm = TRUE) > 0) %>%
  ungroup() %>%
  arrange(round_number) %>%
  pivot_wider(id_cols = `Player Name`, names_from = round_number, values_from = CBA_percentage)

ESS_CBA_avgs <-
  combined_stats_table %>%
  filter(team == "Essendon") %>%
  group_by(player_name) %>%
  summarise(`Mean CBA Percentage` = mean(CBA_percentage, na.rm = TRUE)) %>%
  rename(`Player Name` = player_name)

ESS_heatmap <- ESS_CBAs %>% left_join(ESS_CBA_avgs) %>% arrange(desc(`Mean CBA Percentage`))

# Make playernames the row labels
ESS_heatmap <- as.data.frame(ESS_heatmap)
rownames(ESS_heatmap) <- ESS_heatmap$`Player Name`
ESS_heatmap <- ESS_heatmap %>% select(-`Player Name`)

# Make heatmap
ztable(ESS_heatmap,
       type = "viewer",
       align = "ccccccccccccccccccccc") %>%
  makeHeatmap(palette = "Oranges") %>%
  vlines(type = "all") %>%
  hlines(type = "all")

#===============================================================================
# Fremantle
#===============================================================================

# Create dataframe
FREO_CBAs <-
  combined_stats_table %>%
  filter(team == "Fremantle") %>%
  select(`Player Name` = player_name, CBA_percentage, round_number) %>%
  group_by(`Player Name`) %>%
  filter(max(CBA_percentage, na.rm = TRUE) > 0) %>%
  ungroup() %>%
  arrange(round_number) %>%
  pivot_wider(id_cols = `Player Name`, names_from = round_number, values_from = CBA_percentage)

FREO_CBA_avgs <-
  combined_stats_table %>%
  filter(team == "Fremantle") %>%
  group_by(player_name) %>%
  summarise(`Mean CBA Percentage` = mean(CBA_percentage, na.rm = TRUE)) %>%
  rename(`Player Name` = player_name)

FREO_heatmap <- FREO_CBAs %>% left_join(FREO_CBA_avgs) %>% arrange(desc(`Mean CBA Percentage`))

# Make playernames the row labels
FREO_heatmap <- as.data.frame(FREO_heatmap)
rownames(FREO_heatmap) <- FREO_heatmap$`Player Name`
FREO_heatmap <- FREO_heatmap %>% select(-`Player Name`)

# Make heatmap
ztable(FREO_heatmap,
       type = "viewer",
       align = "ccccccccccccccccccccc") %>%
  makeHeatmap(palette = "Oranges") %>%
  vlines(type = "all") %>%
  hlines(type = "all")

#===============================================================================
# Geelong Cats
#===============================================================================

# Create dataframe
GEE_CBAs <-
  combined_stats_table %>%
  filter(team == "Geelong Cats") %>%
  select(`Player Name` = player_name, CBA_percentage, round_number) %>%
  group_by(`Player Name`) %>%
  filter(max(CBA_percentage, na.rm = TRUE) > 0) %>%
  ungroup() %>%
  arrange(round_number) %>%
  pivot_wider(id_cols = `Player Name`, names_from = round_number, values_from = CBA_percentage)

GEE_CBA_avgs <-
  combined_stats_table %>%
  filter(team == "Geelong Cats") %>%
  group_by(player_name) %>%
  summarise(`Mean CBA Percentage` = mean(CBA_percentage, na.rm = TRUE)) %>%
  rename(`Player Name` = player_name)

GEE_heatmap <- GEE_CBAs %>% left_join(GEE_CBA_avgs) %>% arrange(desc(`Mean CBA Percentage`))

# Make playernames the row labels
GEE_heatmap <- as.data.frame(GEE_heatmap)
rownames(GEE_heatmap) <- GEE_heatmap$`Player Name`
GEE_heatmap <- GEE_heatmap %>% select(-`Player Name`)

# Make heatmap
ztable(GEE_heatmap,
       type = "viewer",
       align = "ccccccccccccccccccccc") %>%
  makeHeatmap(palette = "Oranges") %>%
  vlines(type = "all") %>%
  hlines(type = "all")

#===============================================================================
# Gold Coast Suns
#===============================================================================

# Create dataframe
GC_CBAs <-
  combined_stats_table %>%
  filter(team == "Gold Coast Suns") %>%
  select(`Player Name` = player_name, CBA_percentage, round_number) %>%
  group_by(`Player Name`) %>%
  filter(max(CBA_percentage, na.rm = TRUE) > 0) %>%
  ungroup() %>%
  arrange(round_number) %>%
  pivot_wider(id_cols = `Player Name`, names_from = round_number, values_from = CBA_percentage)

GC_CBA_avgs <-
  combined_stats_table %>%
  filter(team == "Gold Coast Suns") %>%
  group_by(player_name) %>%
  summarise(`Mean CBA Percentage` = mean(CBA_percentage, na.rm = TRUE)) %>%
  rename(`Player Name` = player_name)

GC_heatmap <- GC_CBAs %>% left_join(GC_CBA_avgs) %>% arrange(desc(`Mean CBA Percentage`))

# Make playernames the row labels
GC_heatmap <- as.data.frame(GC_heatmap)
rownames(GC_heatmap) <- GC_heatmap$`Player Name`
GC_heatmap <- GC_heatmap %>% select(-`Player Name`)

# Make heatmap
ztable(GC_heatmap,
       type = "viewer",
       align = "ccccccccccccccccccccc") %>%
  makeHeatmap(palette = "Oranges") %>%
  vlines(type = "all") %>%
  hlines(type = "all")

#===============================================================================
# GWS Giants
#===============================================================================

# Create dataframe
GWS_CBAs <-
  combined_stats_table %>%
  filter(team == "GWS Giants") %>%
  select(`Player Name` = player_name, CBA_percentage, round_number) %>%
  group_by(`Player Name`) %>%
  filter(max(CBA_percentage, na.rm = TRUE) > 0) %>%
  ungroup() %>%
  arrange(round_number) %>%
  pivot_wider(id_cols = `Player Name`, names_from = round_number, values_from = CBA_percentage)

GWS_CBA_avgs <-
  combined_stats_table %>%
  filter(team == "GWS Giants") %>%
  group_by(player_name) %>%
  summarise(`Mean CBA Percentage` = mean(CBA_percentage, na.rm = TRUE)) %>%
  rename(`Player Name` = player_name)

GWS_heatmap <- GWS_CBAs %>% left_join(GWS_CBA_avgs) %>% arrange(desc(`Mean CBA Percentage`))

# Make playernames the row labels
GWS_heatmap <- as.data.frame(GWS_heatmap)
rownames(GWS_heatmap) <- GWS_heatmap$`Player Name`
GWS_heatmap <- GWS_heatmap %>% select(-`Player Name`)

# Make heatmap
ztable(GWS_heatmap,
       type = "viewer",
       align = "ccccccccccccccccccccc") %>%
  makeHeatmap(palette = "Oranges") %>%
  vlines(type = "all") %>%
  hlines(type = "all")

#===============================================================================
# Hawthorn
#===============================================================================

# Create dataframe
HAW_CBAs <-
  combined_stats_table %>%
  filter(team == "Hawthorn") %>%
  select(`Player Name` = player_name, CBA_percentage, round_number) %>%
  group_by(`Player Name`) %>%
  filter(max(CBA_percentage, na.rm = TRUE) > 0) %>%
  ungroup() %>%
  arrange(round_number) %>%
  pivot_wider(id_cols = `Player Name`, names_from = round_number, values_from = CBA_percentage)

HAW_CBA_avgs <-
  combined_stats_table %>%
  filter(team == "Hawthorn") %>%
  group_by(player_name) %>%
  summarise(`Mean CBA Percentage` = mean(CBA_percentage, na.rm = TRUE)) %>%
  rename(`Player Name` = player_name)

HAW_heatmap <- HAW_CBAs %>% left_join(HAW_CBA_avgs) %>% arrange(desc(`Mean CBA Percentage`))

# Make playernames the row labels
HAW_heatmap <- as.data.frame(HAW_heatmap)
rownames(HAW_heatmap) <- HAW_heatmap$`Player Name`
HAW_heatmap <- HAW_heatmap %>% select(-`Player Name`)

# Make heatmap
ztable(HAW_heatmap,
       type = "viewer",
       align = "ccccccccccccccccccccc") %>%
  makeHeatmap(palette = "Oranges") %>%
  vlines(type = "all") %>%
  hlines(type = "all")

#===============================================================================
# Melbourne
#===============================================================================

# Create dataframe
MEL_CBAs <-
  combined_stats_table %>%
  filter(team == "Melbourne") %>%
  select(`Player Name` = player_name, CBA_percentage, round_number) %>%
  group_by(`Player Name`) %>%
  filter(max(CBA_percentage, na.rm = TRUE) > 0) %>%
  ungroup() %>%
  arrange(round_number) %>%
  pivot_wider(id_cols = `Player Name`, names_from = round_number, values_from = CBA_percentage)

MEL_CBA_avgs <-
  combined_stats_table %>%
  filter(team == "Melbourne") %>%
  group_by(player_name) %>%
  summarise(`Mean CBA Percentage` = mean(CBA_percentage, na.rm = TRUE)) %>%
  rename(`Player Name` = player_name)

MEL_heatmap <- MEL_CBAs %>% left_join(MEL_CBA_avgs) %>% arrange(desc(`Mean CBA Percentage`))

# Make playernames the row labels
MEL_heatmap <- as.data.frame(MEL_heatmap)
rownames(MEL_heatmap) <- MEL_heatmap$`Player Name`
MEL_heatmap <- MEL_heatmap %>% select(-`Player Name`)

# Make heatmap
ztable(MEL_heatmap,
       type = "viewer",
       align = "ccccccccccccccccccccc") %>%
  makeHeatmap(palette = "Oranges") %>%
  vlines(type = "all") %>%
  hlines(type = "all")

#===============================================================================
# North Melbourne
#===============================================================================

# Create dataframe
NM_CBAs <-
  combined_stats_table %>%
  filter(team == "North Melbourne") %>%
  select(`Player Name` = player_name, CBA_percentage, round_number) %>%
  group_by(`Player Name`) %>%
  filter(max(CBA_percentage, na.rm = TRUE) > 0) %>%
  ungroup() %>%
  arrange(round_number) %>%
  pivot_wider(id_cols = `Player Name`, names_from = round_number, values_from = CBA_percentage)

NM_CBA_avgs <-
  combined_stats_table %>%
  filter(team == "North Melbourne") %>%
  group_by(player_name) %>%
  summarise(`Mean CBA Percentage` = mean(CBA_percentage, na.rm = TRUE)) %>%
  rename(`Player Name` = player_name)

NM_heatmap <- NM_CBAs %>% left_join(NM_CBA_avgs) %>% arrange(desc(`Mean CBA Percentage`))

# Make playernames the row labels
NM_heatmap <- as.data.frame(NM_heatmap)
rownames(NM_heatmap) <- NM_heatmap$`Player Name`
NM_heatmap <- NM_heatmap %>% select(-`Player Name`)

# Make heatmap
ztable(NM_heatmap,
       type = "viewer",
       align = "ccccccccccccccccccccc") %>%
  makeHeatmap(palette = "Oranges") %>%
  vlines(type = "all") %>%
  hlines(type = "all")

#===============================================================================
# Port Adelaide
#===============================================================================

# Create dataframe
PA_CBAs <-
  combined_stats_table %>%
  filter(team == "Port Adelaide") %>%
  select(`Player Name` = player_name, CBA_percentage, round_number) %>%
  group_by(`Player Name`) %>%
  filter(max(CBA_percentage, na.rm = TRUE) > 0) %>%
  ungroup() %>%
  arrange(round_number) %>%
  pivot_wider(id_cols = `Player Name`, names_from = round_number, values_from = CBA_percentage)

PA_CBA_avgs <-
  combined_stats_table %>%
  filter(team == "Port Adelaide") %>%
  group_by(player_name) %>%
  summarise(`Mean CBA Percentage` = mean(CBA_percentage, na.rm = TRUE)) %>%
  rename(`Player Name` = player_name)

PA_heatmap <- PA_CBAs %>% left_join(PA_CBA_avgs) %>% arrange(desc(`Mean CBA Percentage`))

# Make playernames the row labels
PA_heatmap <- as.data.frame(PA_heatmap)
rownames(PA_heatmap) <- PA_heatmap$`Player Name`
PA_heatmap <- PA_heatmap %>% select(-`Player Name`)

# Make heatmap
ztable(PA_heatmap,
       type = "viewer",
       align = "ccccccccccccccccccccc") %>%
  makeHeatmap(palette = "Oranges") %>%
  vlines(type = "all") %>%
  hlines(type = "all")

#===============================================================================
# Richmond
#===============================================================================

# Create dataframe
RICH_CBAs <-
  combined_stats_table %>%
  filter(team == "Richmond") %>%
  select(`Player Name` = player_name, CBA_percentage, round_number) %>%
  group_by(`Player Name`) %>%
  filter(max(CBA_percentage, na.rm = TRUE) > 0) %>%
  ungroup() %>%
  arrange(round_number) %>%
  pivot_wider(id_cols = `Player Name`, names_from = round_number, values_from = CBA_percentage)

RICH_CBA_avgs <-
  combined_stats_table %>%
  filter(team == "Richmond") %>%
  group_by(player_name) %>%
  summarise(`Mean CBA Percentage` = mean(CBA_percentage, na.rm = TRUE)) %>%
  rename(`Player Name` = player_name)

RICH_heatmap <- RICH_CBAs %>% left_join(RICH_CBA_avgs) %>% arrange(desc(`Mean CBA Percentage`))

# Make playernames the row labels
RICH_heatmap <- as.data.frame(RICH_heatmap)
rownames(RICH_heatmap) <- RICH_heatmap$`Player Name`
RICH_heatmap <- RICH_heatmap %>% select(-`Player Name`)

# Make heatmap
ztable(RICH_heatmap,
       type = "viewer",
       align = "ccccccccccccccccccccc") %>%
  makeHeatmap(palette = "Oranges") %>%
  vlines(type = "all") %>%
  hlines(type = "all")

#===============================================================================
# St Kilda
#===============================================================================

# Create dataframe
STK_CBAs <-
  combined_stats_table %>%
  filter(team == "St Kilda") %>%
  select(`Player Name` = player_name, CBA_percentage, round_number) %>%
  group_by(`Player Name`) %>%
  filter(max(CBA_percentage, na.rm = TRUE) > 0) %>%
  ungroup() %>%
  arrange(round_number) %>%
  pivot_wider(id_cols = `Player Name`, names_from = round_number, values_from = CBA_percentage)

STK_CBA_avgs <-
  combined_stats_table %>%
  filter(team == "St Kilda") %>%
  group_by(player_name) %>%
  summarise(`Mean CBA Percentage` = mean(CBA_percentage, na.rm = TRUE)) %>%
  rename(`Player Name` = player_name)

STK_heatmap <- STK_CBAs %>% left_join(STK_CBA_avgs) %>% arrange(desc(`Mean CBA Percentage`))

# Make playernames the row labels
STK_heatmap <- as.data.frame(STK_heatmap)
rownames(STK_heatmap) <- STK_heatmap$`Player Name`
STK_heatmap <- STK_heatmap %>% select(-`Player Name`)

# Make heatmap
ztable(STK_heatmap,
       type = "viewer",
       align = "ccccccccccccccccccccc") %>%
  makeHeatmap(palette = "Oranges") %>%
  vlines(type = "all") %>%
  hlines(type = "all")

#===============================================================================
# Sydney Swans
#===============================================================================

# Create dataframe
SYD_CBAs <-
  combined_stats_table %>%
  filter(team == "Sydney Swans") %>%
  select(`Player Name` = player_name, CBA_percentage, round_number) %>%
  group_by(`Player Name`) %>%
  filter(max(CBA_percentage, na.rm = TRUE) > 0) %>%
  ungroup() %>%
  arrange(round_number) %>%
  pivot_wider(id_cols = `Player Name`, names_from = round_number, values_from = CBA_percentage)

SYD_CBA_avgs <-
  combined_stats_table %>%
  filter(team == "Sydney Swans") %>%
  group_by(player_name) %>%
  summarise(`Mean CBA Percentage` = mean(CBA_percentage, na.rm = TRUE)) %>%
  rename(`Player Name` = player_name)

SYD_heatmap <- SYD_CBAs %>% left_join(SYD_CBA_avgs) %>% arrange(desc(`Mean CBA Percentage`))

# Make playernames the row labels
SYD_heatmap <- as.data.frame(SYD_heatmap)
rownames(SYD_heatmap) <- SYD_heatmap$`Player Name`
SYD_heatmap <- SYD_heatmap %>% select(-`Player Name`)

# Make heatmap
ztable(SYD_heatmap,
       type = "viewer",
       align = "ccccccccccccccccccccc") %>%
  makeHeatmap(palette = "Oranges") %>%
  vlines(type = "all") %>%
  hlines(type = "all")

#===============================================================================
# West Coast Eagles
#===============================================================================

# Create dataframe
WCE_CBAs <-
  combined_stats_table %>%
  distinct(player_name, round_number, team, .keep_all = TRUE) %>%
  filter(team == "West Coast Eagles") %>%
  select(`Player Name` = player_name, CBA_percentage, round_number) %>%
  group_by(`Player Name`) %>%
  filter(max(CBA_percentage, na.rm = TRUE) > 0) %>%
  ungroup() %>%
  arrange(round_number) %>%
  pivot_wider(id_cols = `Player Name`, names_from = round_number, values_from = CBA_percentage)

WCE_CBA_avgs <-
  combined_stats_table %>%
  filter(team == "West Coast Eagles") %>%
  group_by(player_name) %>%
  summarise(`Mean CBA Percentage` = mean(CBA_percentage, na.rm = TRUE)) %>%
  rename(`Player Name` = player_name)

WCE_heatmap <- WCE_CBAs %>% left_join(WCE_CBA_avgs) %>% arrange(desc(`Mean CBA Percentage`))

# Make playernames the row labels
WCE_heatmap <- as.data.frame(WCE_heatmap)
rownames(WCE_heatmap) <- WCE_heatmap$`Player Name`
WCE_heatmap <- WCE_heatmap %>% select(-`Player Name`)

# Make heatmap
ztable(WCE_heatmap,
       type = "viewer",
       align = "ccccccccccccccccccccc") %>%
  makeHeatmap(palette = "Oranges") %>%
  vlines(type = "all") %>%
  hlines(type = "all")

#===============================================================================
# Western Bulldogs
#===============================================================================

# Create dataframe
WB_CBAs <-
  combined_stats_table %>%
  distinct(player_name, round_number, team, .keep_all = TRUE) %>%
  filter(team == "Western Bulldogs") %>%
  select(`Player Name` = player_name, CBA_percentage, round_number) %>%
  group_by(`Player Name`) %>%
  filter(max(CBA_percentage, na.rm = TRUE) > 0) %>%
  ungroup() %>%
  arrange(round_number) %>%
  pivot_wider(id_cols = `Player Name`, names_from = round_number, values_from = CBA_percentage)

WB_CBA_avgs <-
  combined_stats_table %>%
  filter(team == "Western Bulldogs") %>%
  group_by(player_name) %>%
  summarise(`Mean CBA Percentage` = mean(CBA_percentage, na.rm = TRUE)) %>%
  rename(`Player Name` = player_name)

WB_heatmap <- WB_CBAs %>% left_join(WB_CBA_avgs) %>% arrange(desc(`Mean CBA Percentage`))

# Make playernames the row labels
WB_heatmap <- as.data.frame(WB_heatmap)
rownames(WB_heatmap) <- WB_heatmap$`Player Name`
WB_heatmap <- WB_heatmap %>% select(-`Player Name`)

# Make heatmap
ztable(WB_heatmap,
       type = "viewer",
       align = "ccccccccccccccccccccc") %>%
  makeHeatmap(palette = "Oranges") %>%
  vlines(type = "all") %>%
  hlines(type = "all")
