library(readr)
library(dplyr)
library(ggplot2)

# *********** Working with dates, time and timezones ************
ext_tracks_file <- "data/ebtrk_atlc_1988_2015.txt"
ext_tracks_widths <- c(7, 10, 2, 2, 3, 5, 5, 6, 4, 5, 4, 4, 5, 3, 4, 3, 3, 3,
                       4, 3, 3, 3, 4, 3, 3, 3, 2, 6, 1)
ext_tracks_colnames <- c("storm_id", "storm_name", "month", "day",
                         "hour", "year", "latitude", "longitude",
                         "max_wind", "min_pressure", "rad_max_wind",
                         "eye_diameter", "pressure_1", "pressure_2",
                         paste("radius_34", c("ne", "se", "sw", "nw"), sep = "_"),
                         paste("radius_50", c("ne", "se", "sw", "nw"), sep = "_"),
                         paste("radius_64", c("ne", "se", "sw", "nw"), sep = "_"),
                         "storm_type", "distance_to_land", "final")

ext_tracks <- read_fwf(ext_tracks_file, fwf_widths(ext_tracks_widths, ext_tracks_colnames), na = "-99")


# *********** Converting to a date or date-time class *********** 
library(lubridate)

ymd("2006-03-12")
ymd_hm("06/3/12 6:30 pm")

library(tidyr)

# Use the ymd_h function to transform the date and time information andrew_tracks(the storm tracks for Hurricane Andrew) to a date-time class (POSIXct)
andrew_tracks <-
  ext_tracks %>%
  filter(storm_name == "ANDREW") %>%
  select(year, month, day, hour, max_wind, min_pressure) %>%
  unite(datetime, year, month, day, hour) %>%
  mutate(datetime = ymd_h(datetime))

head(andrew_tracks)
class(andrew_tracks$datetime)

# plot maximum wind speed and minimum air pressure at different observation times for Hurricane Andrew
andrew_tracks %>%
  gather(measure, value, -datetime) %>%
  ggplot(aes(x = datetime, y = value)) + 
  geom_point() + geom_line() +
  facet_wrap( ~ measure, ncol = 1, scales = "free_y")


# *********** Pulling out date and time elements ************ 
# Use the datetime variable in the Hurricane Andrew track data to add new columns for the year, month, weekday, year day, and hour of each observation
andrew_tracks %>%
  select(datetime) %>%
  mutate(year = year(datetime), month = months(datetime), weekday = weekdays(datetime), yday = yday(datetime), hour = hour(datetime))

# look at the average value of max_wind storm observations by day of the week and by month
check_tracks <-
  ext_tracks %>%
  select(year, month, day, hour, max_wind) %>%
  unite(datetime, year, month, day, hour) %>%
  mutate(datetime = ymd_h(datetime),
         weekday = weekdays(datetime),
         weekday = factor(weekday, levels = c("hétfő", "kedd", "szerda", "csütörtök", "péntek", "szombat", "vasárnap")),
         month = months(datetime),
         month = factor(month, levels = c("január", "február", "március", "április", "május", "június", "július", "augusztus", "szeptember", "október", "november", "december")))

check_weekdays <-
  check_tracks %>%
  group_by(weekday) %>%
  summarise(avg_wind = mean(max_wind)) %>%
  rename(grouping = weekday)

check_months <-
  check_tracks %>%
  group_by(month) %>%
  summarise(avg_wind = mean(max_wind)) %>%
  rename(grouping = month)
  
a <- ggplot(check_weekdays, aes(x = grouping, y = avg_wind)) + 
  geom_bar(stat = "identity") + xlab("")
b <- a %+% check_months

library(gridExtra)
grid.arrange(a, b, ncol = 1)


# *********** Working with time zones ************ 
andrew_tracks <- ext_tracks %>%
  filter(storm_name == "ANDREW") %>% 
  slice(23:47) %>%
  select(year, month, day, hour, latitude, longitude) %>%
  unite(datetime, year, month, day, hour) %>%
  mutate(datetime = ymd_h(datetime),
         date = format(datetime, "%b %d")) 

library(ggmap)
miami <- get_map("miami", zoom = 5)
ggmap(miami) + 
  geom_path(data = andrew_tracks, aes(x = -longitude, y = latitude),
            color = "gray", size = 1.1) + 
  geom_point(data = andrew_tracks,
             aes(x = -longitude, y = latitude, color = date),
             size = 2)

# UTC to local time
andrew_tracks <- andrew_tracks %>%
  mutate(datetime = with_tz(datetime, tzone = "America/New_York"),
         date = format(datetime, "%b %d"))
