library(readr)

ext_tracks_file <- paste0("http://rammb.cira.colostate.edu/research/tropical_cyclones/tc_extended_best_track_dataset/data/ebtrk_atlc_1988_2015.txt")
ext_tracks_widths <- c(7, 10, 2, 2, 3, 5, 5, 6, 4, 5, 4, 4, 5, 3, 4, 3, 3, 3, 4, 3, 3, 3, 4, 3, 3, 3, 2, 6, 1)
ext_tracks_colnames <- c("storm_id", "storm_name", "month", "day", "hour", "year", "latitude", "longitude", #
                         "max_wind", "min_pressure", "rad_max_wind",
                         "eye_diameter", "pressure_1", "pressure_2",
                         paste("radius_34", c("ne", "se", "sw", "nw"), sep = "_"),
                         paste("radius_50", c("ne", "se", "sw", "nw"), sep = "_"),
                         paste("radius_64", c("ne", "se", "sw", "nw"), sep = "_"),
                         "storm_type", "distance_to_land", "final")

ext_tracks <- read_fwf(ext_tracks_file, fwf_widths(ext_tracks_widths, ext_tracks_colnames), na= "-99")
ext_tracks[1:3, 1:9]

ext_tracks %>%
  filter(storm_name == "KATRINA") %>%
  select(month, day, hour, year, max_wind, min_pressure, rad_max_wind) %>%
  sample_n(4)

zika_file <- "https://github.com/cdcepi/zika/raw/master/Brazil/COES_Microcephaly/data/COES_Microcephaly-2016-06-25.csv"
zika_brazil <- read_csv(zika_file)

zika_brazil %>%
  select(location, value, unit)


## Using HTTP requests
library(httr)

meso_url <- "https://mesonet.agron.iastate.edu/cgi-bin/request/asos.py/"
denver <- GET(url = meso_url,#
              query = list(station = "DEN",
                           data = "sped",
                           year1 = "2016",
                           month1 = "6",
                           day1 = "1",
                           year2 = "2016",
                           month2 = "6",
                           day2 = "30",
                           tz = "America/Denver",
                           format = "comma")) %>%
  content() %>% 
  read_csv(skip = 5, na = "M")

denver %>% slice(1:3)
