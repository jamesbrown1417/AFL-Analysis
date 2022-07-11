# Run all earlier scripts
source("Scripts/Fantasy-Coach-Performance/Fantasy-Actual-Versus-Expected-Wins/08-actual-vs-expected-wins-rossi.R")
source("Scripts/Fantasy-Coach-Performance/Fantasy-Actual-Versus-Expected-Wins/07-actual-vs-expected-wins-pansini.R")
source("Scripts/Fantasy-Coach-Performance/Fantasy-Actual-Versus-Expected-Wins/06-actual-vs-expected-wins-brown.R")
source("Scripts/Fantasy-Coach-Performance/Fantasy-Actual-Versus-Expected-Wins/05-actual-vs-expected-wins-kirch.R")
source("Scripts/Fantasy-Coach-Performance/Fantasy-Actual-Versus-Expected-Wins/04-actual-vs-expected-wins-bish.R")
source("Scripts/Fantasy-Coach-Performance/Fantasy-Actual-Versus-Expected-Wins/03-actual-vs-expected-wins-baron.R")
source("Scripts/Fantasy-Coach-Performance/Fantasy-Actual-Versus-Expected-Wins/02-actual-vs-expected-wins-paul.R")
source("Scripts/Fantasy-Coach-Performance/Fantasy-Actual-Versus-Expected-Wins/01-actual-vs-expected-wins-mara.R")

# Get into one dataframe and get difference, then rank
observed_vs_expected_wins_total <-
bind_rows(
  observed_vs_expected_wins_01,
  observed_vs_expected_wins_02,
  observed_vs_expected_wins_03,
  observed_vs_expected_wins_04,
  observed_vs_expected_wins_05,
  observed_vs_expected_wins_06,
  observed_vs_expected_wins_07,
  observed_vs_expected_wins_08
) %>%
  mutate(Difference = `Expected Wins` - `Observed Wins`) %>%
  arrange(desc(Difference), desc(`Observed Wins`))