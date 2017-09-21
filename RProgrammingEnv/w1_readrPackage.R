library(readr)

teams <- read_csv("data/team_standings.csv", col_types = "ic")
teams

logs <- read_csv("data/2016-07-19.csv.gz", col_types = "Dticccccci")
logs

logdates <- read_csv("data/2016-07-19.csv.gz", col_types = cols_only(date = col_date()), n_max = 100)
logdates
