##%######################################################%##
#                                                          #
####             See which coaches have the             ####
####         highest and lowest score variance          ####
#                                                          #
##%######################################################%##

##%######################################################%##
#                                                          #
####                    Enter Scores                    ####
#                                                          #
##%######################################################%##

# Rossi Scores
rossi_scores <-
  c(1521,
    1586,
    1562,
    1532,
    1590,
    1577,
    1547,
    1645,
    1535,
    1521,
    1603)

# Pansini scores
pansini_scores <-
  c(1502,
    1549,
    1523,
    1362,
    1524,
    1668,
    1589,
    1506,
    1701,
    1489,
    1594)

# Brown scores
brown_scores <-
  c(1441,
    1582,
    1562,
    1577,
    1528,
    1480,
    1528,
    1467,
    1414,
    1464,
    1522)

# Kirch Scores
kirch_scores <-
  c(1411,
    1493,
    1482,
    1597,
    1379,
    1500,
    1243,
    1391,
    1441,
    1420,
    1422)

# Bish Scores
bish_scores <-
  c(1381,
    1424,
    1477,
    1344,
    1530,
    1464,
    1487,
    1675,
    1479,
    1508,
    1613)

# Baron Scores
baron_scores <-
  c(1500,
    1540,
    1518,
    1475,
    1546,
    1784,
    1624,
    1694,
    1726,
    1665,
    1731)

# Paul Scores
paul_scores <-
  c(1550,
    1689,
    1601,
    1635,
    1574,
    1787,
    1634,
    1511,
    1468,
    1572,
    1736)

  
  
# Mara Scores
mara_scores <-
  c(1583,
    1564,
    1500,
    1684,
    1635,
    1543,
    1640,
    1551,
    1640,
    1551,
    1542)

##%######################################################%##
#                                                          #
####                   Summary table                    ####
#                                                          #
##%######################################################%##

# Matt Baron
baron_summary <-
tibble(
  Coach = "Matt Baron",
  `Minimum Score` = min(baron_scores),
  `Median Score` = median(baron_scores),
  `Mean Score` = round(mean(baron_scores), digits = 1),
  `Maximum Score` = max(baron_scores),
  `Total Score` = sum(baron_scores),
  `Standard Deviation` = sd(baron_scores)
)

# Sam Bishop
bish_summary <-
  tibble(
    Coach = "Sam Bishop",
    `Minimum Score` = min(bish_scores),
    `Median Score` = median(bish_scores),
    `Mean Score` = round(mean(bish_scores), digits = 1),
    `Maximum Score` = max(bish_scores),
    `Total Score` = sum(bish_scores),
    `Standard Deviation` = sd(bish_scores)
  )
  
# James Brown
brown_summary <-
  tibble(
    Coach = "James Brown",
    `Minimum Score` = min(brown_scores),
    `Median Score` = median(brown_scores),
    `Mean Score` = round(mean(brown_scores), digits = 1),
    `Maximum Score` = max(brown_scores),
    `Total Score` = sum(brown_scores),
    `Standard Deviation` = sd(brown_scores)
  )

# Nick Kirchner
kirch_summary <-
  tibble(
    Coach = "Nick Kirchner",
    `Minimum Score` = min(kirch_scores),
    `Median Score` = median(kirch_scores),
    `Mean Score` = round(mean(kirch_scores), digits = 1),
    `Maximum Score` = max(kirch_scores),
    `Total Score` = sum(kirch_scores),
    `Standard Deviation` = sd(kirch_scores)
  )

# Alex Marateo
mara_summary <-
  tibble(
    Coach = "Alex Marateo",
    `Minimum Score` = min(mara_scores),
    `Median Score` = median(mara_scores),
    `Mean Score` = round(mean(mara_scores), digits = 1),
    `Maximum Score` = max(mara_scores),
    `Total Score` = sum(mara_scores),
    `Standard Deviation` = sd(mara_scores)
  )

# Nic Pansini
pansini_summary <-
  tibble(
    Coach = "Nic Pansini",
    `Minimum Score` = min(pansini_scores),
    `Median Score` = median(pansini_scores),
    `Mean Score` = round(mean(pansini_scores), digits = 1),
    `Maximum Score` = max(pansini_scores),
    `Total Score` = sum(pansini_scores),
    `Standard Deviation` = sd(pansini_scores)
  )

# Paul Aoukar
paul_summary <-
  tibble(
    Coach = "Paul Aoukar",
    `Minimum Score` = min(paul_scores),
    `Median Score` = median(paul_scores),
    `Mean Score` = round(mean(paul_scores), digits = 1),
    `Maximum Score` = max(paul_scores),
    `Total Score` = sum(paul_scores),
    `Standard Deviation` = sd(paul_scores)
  )

# John Rossi
rossi_summary <-
  tibble(
    Coach = "John Rossi",
    `Minimum Score` = min(rossi_scores),
    `Median Score` = median(rossi_scores),
    `Mean Score` = round(mean(rossi_scores), digits = 1),
    `Maximum Score` = max(rossi_scores),
    `Total Score` = sum(rossi_scores),
    `Standard Deviation` = sd(rossi_scores)
  )

# Combined summary table
overall_summary_table <-
bind_rows(
  baron_summary,
  bish_summary,
  brown_summary,
  kirch_summary,
  mara_summary,
  pansini_summary,
  paul_summary,
  rossi_summary
)

