library(tidyr)
library(readr)
library(dplyr)
library(ggplot2)

# ************** Basic Data Manipulation ****************
# readr: read data with fixed length
ext_tracks_file <- "data/ebtrk_atlc_1988_2015.txt"
ext_tracks_widths <- c(7, 10, 2, 2, 3, 5, 5, 6, 4, 5, 4, 4, 5, 3, 4, 3, 3, 3,#
                       4, 3, 3, 3, 4, 3, 3, 3, 2, 6, 1)
ext_tracks_colnames <- c("storm_id", "storm_name", "month", "day",#
                         "hour", "year", "latitude", "longitude",
                         "max_wind", "min_pressure", "rad_max_wind",
                         "eye_diameter", "pressure_1", "pressure_2",
                         paste("radius_34", c("ne", "se", "sw", "nw"), sep = "_"),
                         paste("radius_50", c("ne", "se", "sw", "nw"), sep = "_"),
                         paste("radius_64", c("ne", "se", "sw", "nw"), sep = "_"),
                         "storm_type", "distance_to_land", "final")

ext_tracks <- read_fwf(ext_tracks_file, #
                       fwf_widths(ext_tracks_widths, ext_tracks_colnames),
                       na = "-99")

# **************** Piping ****************
# dplyr: Select time, date and maximum winds of KATRINA with piping
ext_tracks %>%
  filter(storm_name == "KATRINA") %>%
  select(year, day, hour, max_wind) %>%
  head(20) %>%
  print

# **************** Summarizing data (with dplyr) ****************
# Summary of the number of observations in ext_tracks, highest measured maximum windspeed and the lowest minimum pressure
ext_tracks %>%
  summarise(n_ons = n(),
            worst_wind = max_wind %>% max,
            worst_pressure = min_pressure %>% min)

# Convert knots to mph and use it in summary
knotsToMph <- function(knots) {
  mph <- 1.152 * knots
}
ext_tracks %>%
  summarise(n_obs = n(),
            worst_wind = max_wind %>% max %>% knotsToMph,
            worst_pressure = min_pressure %>% min)

# Worst wind and worst pressure by storm and year with grouping
ext_tracks %>%
  group_by(storm_name, year) %>%
  summarise(n_obs = n(),
            worst_wind = max_wind %>% max %>% knotsToMph,
            worst_pressure = min_pressure %>% min)

# Plot summary with ggplot2
ext_tracks %>%
  group_by(storm_name) %>%
  summarise(worst_wind = max_wind %>% max) %>%
  ggplot(aes(x = worst_wind)) + geom_histogram(binwidth = 1.5)


# **************** Selecting and filtering data  ****************
# Select the storm name, date, time, latitude, longitude, and maximum wind speed from the ext_tracks
ext_tracks %>%
  select(storm_name, month, day, hour, year, latitude, longitude, max_wind)

# Select storm names, location, and radii of winds of 34 knots
ext_tracks %>%
  select(storm_name, latitude, longitude, starts_with("radius_34"))

# Filtering
ext_tracks %>%
  select(storm_name, hour,max_wind) %>%
  filter(hour == "00") %>%
  head(3)

# Determine which storms had maximum wind speed equal to or above 160 knots
ext_tracks %>%
  group_by(storm_name, year) %>%
  summarise(worst_wind = max(max_wind)) %>%
  filter(worst_wind >= 160)

# Pull out observations for Hurricane Andrew when it was at or above Category 5 strength (137 knots or higher),
ext_tracks %>%
  select(storm_name, month, day, hour, year, latitude, longitude, max_wind) %>%
  filter(max_wind >= 137 & storm_name == "ANDREW")


# **************** Adding, changing or renaming columns ****************
# Load in statistics from the 2010 World Cup
library(faraway)
data(worldcup)

# Use the mutate function to move the player names to its own column
worldcup <- 
  worldcup %>% mutate(player_name = rownames(worldcup))

worldcup %>% slice(1:10)

# Add a column with the average number of shots for a player’s position: First with summarise ->
# summary will not add a new row to the existing ones
worldcup %>% 
  group_by(Position) %>%
  summarise(avg_shots = mean(Shots))

# Same with mutate
worldcup <- 
worldcup %>% 
  group_by(Position) %>%
  mutate(avg_shots = mean(Shots)) %>%
  ungroup()

# Use the rename function
worldcup %>% 
  rename(Name = player_name)


# **************** Spreading and gathering data **************** 
# tidy up VADeaths from w1
data("VADeaths")
library(tidyr)

VADeaths <- VADeaths %>%
  tbl_df() %>%
  mutate(age = rownames(VADeaths)) %>%
  gather(key, death_rate, -age)

# Gather: plot the relationship between the time a player played in the World Cup and his number of saves, tackles, and shots, 
# with a separate graph for each position
library(ggplot2)
worldcup %>%
  select(Position, Time, Saves, Tackles, Shots) %>%
  gather(Type, Number, -Position, -Time) %>%
  ggplot(aes(x = Time, y= Number)) + geom_point() + facet_grid(Type ~ Position)

# Spread: print a table of the average number and range of passes by position for the top four teams in this World Cup 
# (Spain, Netherlands, Uruguay, and Germany)
wc_pass_table <- worldcup %>%
  filter(Team %in% c("Spain", "Netherlands", "Uruguay", "Germany")) %>%
  select(Team, Passes, Position) %>%
  group_by(Team, Position) %>%
  summarise(avg_passes = mean(Passes), 
            min_passes = min(Passes), 
            max_passes = max(Passes), 
            pass_summary = paste0(round(avg_passes), " (", min_passes, ",", max_passes, ")")) %>%
  select(Team, Position, pass_summary)

wc_pass_table %>%
  spread(Position, pass_summary)


# **************** Merging datasets **************** 
team_standings <- read_csv("data/team_standings.csv")

# join worldcup data and team_standings by Team name
left_join(worldcup, team_standings, by = "Team") # == worldcup %>% left_join(team_standings, by = "Team")
right_join(worldcup, team_standings, by = "Team")
inner_join(worldcup, team_standings, by = "Team")

# Create a table of the top 5 players by shots on goal, as well as the final standing for each of these player’s teams
library(knitr)
data(worldcup)
worldcup %>% 
  mutate(Name = rownames(worldcup),
         Team = as.character(Team)) %>%
  select(Name, Position, Shots, Team) %>%
  arrange(desc(Shots)) %>%
  slice(1:5) %>%
  left_join(team_standings, by = "Team") %>%
  kable()

