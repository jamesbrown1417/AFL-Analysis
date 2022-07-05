##%######################################################%##
#                                                          #
####                Get list of team IDs                ####
#                                                          #
##%######################################################%##

# 1 = Mara
# 2 = Paul
# 3 = Baron
# 4 = Bish
# 5 = Kirch
# 6 = Brown
# 7 = Pansini
# 8 = Rossi

##%######################################################%##
#                                                          #
####     Get all permutations of potential fixtures     ####
#                                                          #
##%######################################################%##

library(tidyverse)
library(ggthemes)
library(pracma)
all_fixtures <- data.frame(perms(c(1,2,3,5,6,7,8)))

##%######################################################%##
#                                                          #
####           Rename and add rounds 8 to 17            ####
#                                                          #
##%######################################################%##

all_fixtures <-
  all_fixtures %>%
  transmute("Round 1" = X1,
            "Round 2" = X2,
            "Round 3" = X3,
            "Round 4" = X4,
            "Round 5" = X5,
            "Round 6" = X6,
            "Round 7" = X7,
            "Round 8" = X1,
            "Round 9" = X2,
            "Round 10" = X3,
            "Round 11" = X4,
            "Round 15" = X5,
            "Round 16" = X6,
            "Total Wins" = 0)

##%######################################################%##
#                                                          #
####  Mutate to get scores by opponent for each round   ####
#                                                          #
##%######################################################%##

all_fixtures <-
all_fixtures %>%
  mutate(`Round 1` =
           case_when(
             `Round 1` == 8 ~ 1521,  # Rossi
             `Round 1` == 7 ~ 1502,  # Pansini
             `Round 1` == 6 ~ 1441,  # Brown
             `Round 1` == 5 ~ 1411,  # Kirch
             `Round 1` == 4 ~ 1381,  # Bish
             `Round 1` == 3 ~ 1500,  # Baron
             `Round 1` == 2 ~ 1550,  # Paul
             `Round 1` == 1 ~ 1583), # Mara
         
         `Round 2` =
           case_when(
             `Round 2` == 8 ~ 1586,  # Rossi
             `Round 2` == 7 ~ 1549,  # Pansini
             `Round 2` == 6 ~ 1582,  # Brown
             `Round 2` == 5 ~ 1493,  # Kirch
             `Round 2` == 4 ~ 1424,  # Bish
             `Round 2` == 3 ~ 1540,  # Baron
             `Round 2` == 2 ~ 1689,  # Paul
             `Round 2` == 1 ~ 1564), # Mara
         
         `Round 3` =
           case_when(
             `Round 3` == 8 ~ 1562,  # Rossi
             `Round 3` == 7 ~ 1523,  # Pansini
             `Round 3` == 6 ~ 1562,  # Brown
             `Round 3` == 5 ~ 1482,  # Kirch
             `Round 3` == 4 ~ 1477,  # Bish
             `Round 3` == 3 ~ 1518,  # Baron
             `Round 3` == 2 ~ 1601,  # Paul
             `Round 3` == 1 ~ 1500), # Mara
         
         `Round 4` =
           case_when(
             `Round 4` == 8 ~ 1532,  # Rossi
             `Round 4` == 7 ~ 1362,  # Pansini
             `Round 4` == 6 ~ 1577,  # Brown
             `Round 4` == 5 ~ 1597,  # Kirch
             `Round 4` == 4 ~ 1344,  # Bish
             `Round 4` == 3 ~ 1475,  # Baron
             `Round 4` == 2 ~ 1635,  # Paul
             `Round 4` == 1 ~ 1684), # Mara
         
         `Round 5` =
           case_when(
             `Round 5` == 8 ~ 1590,  # Rossi
             `Round 5` == 7 ~ 1524,  # Pansini
             `Round 5` == 6 ~ 1528,  # Brown
             `Round 5` == 5 ~ 1379,  # Kirch
             `Round 5` == 4 ~ 1530,  # Bish
             `Round 5` == 3 ~ 1546,  # Baron
             `Round 5` == 2 ~ 1574,  # Paul
             `Round 5` == 1 ~ 1635), # Mara
         
         `Round 6` =
           case_when(
             `Round 6` == 8 ~ 1577,  # Rossi
             `Round 6` == 7 ~ 1668,  # Pansini
             `Round 6` == 6 ~ 1480,  # Brown
             `Round 6` == 5 ~ 1500,  # Kirch
             `Round 6` == 4 ~ 1464,  # Bish
             `Round 6` == 3 ~ 1784,  # Baron
             `Round 6` == 2 ~ 1787,  # Paul
             `Round 6` == 1 ~ 1543), # Mara
         
         `Round 7` =
           case_when(
             `Round 7` == 8 ~ 1547,  # Rossi
             `Round 7` == 7 ~ 1589,  # Pansini
             `Round 7` == 6 ~ 1528,  # Brown
             `Round 7` == 5 ~ 1243,  # Kirch
             `Round 7` == 4 ~ 1487,  # Bish
             `Round 7` == 3 ~ 1624,  # Baron
             `Round 7` == 2 ~ 1634,  # Paul
             `Round 7` == 1 ~ 1640), # Mara
         
         `Round 8` =
           case_when(
             `Round 8` == 8 ~ 1645,  # Rossi
             `Round 8` == 7 ~ 1506,  # Pansini
             `Round 8` == 6 ~ 1467,  # Brown
             `Round 8` == 5 ~ 1391,  # Kirch
             `Round 8` == 4 ~ 1675,  # Bish
             `Round 8` == 3 ~ 1694,  # Baron
             `Round 8` == 2 ~ 1511,  # Paul
             `Round 8` == 1 ~ 1551), # Mara
         
         `Round 9` =
           case_when(
             `Round 9` == 8 ~ 1535,  # Rossi
             `Round 9` == 7 ~ 1701,  # Pansini
             `Round 9` == 6 ~ 1414,  # Brown
             `Round 9` == 5 ~ 1441,  # Kirch
             `Round 9` == 4 ~ 1479,  # Bish
             `Round 9` == 3 ~ 1726,  # Baron
             `Round 9` == 2 ~ 1468,  # Paul
             `Round 9` == 1 ~ 1640), # Mara
         
         `Round 10` =
           case_when(
             `Round 10` == 8 ~ 1521,  # Rossi
             `Round 10` == 7 ~ 1489,  # Pansini
             `Round 10` == 6 ~ 1464,  # Brown
             `Round 10` == 5 ~ 1420,  # Kirch
             `Round 10` == 4 ~ 1508,  # Bish
             `Round 10` == 3 ~ 1665,  # Baron
             `Round 10` == 2 ~ 1572,  # Paul
             `Round 10` == 1 ~ 1551), # Mara
         
         `Round 11` =
           case_when(
             `Round 11` == 8 ~ 1603,  # Rossi
             `Round 11` == 7 ~ 1594,  # Pansini
             `Round 11` == 6 ~ 1522,  # Brown
             `Round 11` == 5 ~ 1422,  # Kirch
             `Round 11` == 4 ~ 1613,  # Bish
             `Round 11` == 3 ~ 1731,  # Baron
             `Round 11` == 2 ~ 1736,  # Paul
             `Round 11` == 1 ~ 1542), # Mara
         
         `Round 15` =
           case_when(
             `Round 15` == 8 ~ 1696,  # Rossi
             `Round 15` == 7 ~ 1534,  # Pansini
             `Round 15` == 6 ~ 1618,  # Brown
             `Round 15` == 5 ~ 1550,  # Kirch
             `Round 15` == 4 ~ 1453,  # Bish
             `Round 15` == 3 ~ 1677,  # Baron
             `Round 15` == 2 ~ 1569,  # Paul
             `Round 15` == 1 ~ 1493), # Mara
         
         `Round 16` =
           case_when(
             `Round 16` == 8 ~ 1704,  # Rossi
             `Round 16` == 7 ~ 1649,  # Pansini
             `Round 16` == 6 ~ 1731,  # Brown
             `Round 16` == 5 ~ 1307,  # Kirch
             `Round 16` == 4 ~ 1661,  # Bish
             `Round 16` == 3 ~ 1696,  # Baron
             `Round 16` == 2 ~ 1643,  # Paul
             `Round 16` == 1 ~ 1465)) # Mara
         
##%######################################################%##
#                                                          #
####      Get win or loss as Boolean true / false       ####
#                                                          #
##%######################################################%##

all_results <-
  all_fixtures %>%
  mutate(`Round 1` = ifelse(`Round 1` < 1381, TRUE, FALSE)) %>%
  mutate(`Round 2` = ifelse(`Round 2` < 1424, TRUE, FALSE)) %>%
  mutate(`Round 3` = ifelse(`Round 3` < 1477, TRUE, FALSE)) %>%
  mutate(`Round 4` = ifelse(`Round 4` < 1344, TRUE, FALSE)) %>%
  mutate(`Round 5` = ifelse(`Round 5` < 1530, TRUE, FALSE)) %>%
  mutate(`Round 6` = ifelse(`Round 6` < 1464, TRUE, FALSE)) %>%
  mutate(`Round 7` = ifelse(`Round 7` < 1487, TRUE, FALSE)) %>%
  mutate(`Round 8` = ifelse(`Round 8` < 1675, TRUE, FALSE)) %>%
  mutate(`Round 9` = ifelse(`Round 9` < 1479, TRUE, FALSE)) %>%
  mutate(`Round 10` = ifelse(`Round 10` < 1508, TRUE, FALSE)) %>%
  mutate(`Round 11` = ifelse(`Round 11` < 1613, TRUE, FALSE)) %>%
  mutate(`Round 15` = ifelse(`Round 15` < 1453, TRUE, FALSE)) %>%
  mutate(`Round 16` = ifelse(`Round 16` < 1661, TRUE, FALSE))

all_results$`Total Wins` <- rowSums(all_results[,1:13])

##%######################################################%##
#                                                          #
####      Get distribution of results vs observed       ####
#                                                          #
##%######################################################%##

# Table
all_results_summary <-
all_results %>%
  summarise(
    min = min(`Total Wins`),
    mode = Mode(`Total Wins`),
    mean = mean(`Total Wins`),
    max = max(`Total Wins`))

# Plot
all_results %>%
  ggplot(mapping = aes(x = `Total Wins`, fill = `Total Wins` == 4)) +
  geom_histogram(binwidth = 1, colour = "black") +
  scale_fill_manual(values = c("grey", "green"), name = "", labels = c("Potential Wins", "Observed Wins")) +
  scale_x_continuous(limits = c(-1,7), breaks = seq(0, 7, by = 1)) +
  ggtitle("Sam Bishop", subtitle = "Number of wins over all possible permutations of the fixtures") +
  theme_fivethirtyeight()

# Save plot to output folder
ggsave("Output/expected_vs_observed_wins_bish.png")

##%######################################################%##
#                                                          #
#### Get difference between observed and expected wins  ####
#                                                          #
##%######################################################%##

observed_vs_expected_wins_04 <-
  tibble(
    Coach = "Sam Bishop",
    `Observed Wins` = 4,
    `Expected Wins` = all_results_summary$mode)
