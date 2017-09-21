# *********** Data manipulation and summary ************
library(readr)
library(dplyr)
daily_matter <- read_csv("data/daily_SPEC_2014.csv.bz2" )
summary(daily_matter)

# 1. What is average Arithmetic.Mean for “Bromine PM2.5 LC” in the state of Wisconsin in this dataset?
daily_matter %>% select(`Arithmetic Mean`, `State Name`, `Parameter Name`) %>% 
  filter(`State Name` == "Wisconsin" & `Parameter Name` == "Bromine PM2.5 LC" & !is.na(`Arithmetic Mean`)) %>%
  summarise(ari_mean = mean(`Arithmetic Mean`))
  

# 2. Calculate the average of each chemical constituent across all states, monitoring sites and all time points. 
#     Which constituent Parameter.Name has the highest average level?
daily_matter %>% select(`Arithmetic Mean`, `State Name`, `Parameter Name`, `State Code`, `County Code`, `Site Num`, `Date Local`) %>% 
  group_by(`State Name`, `Parameter Name`, `State Code`, `County Code`, `Site Num`, `Date Local`) %>% arrange(desc(`Arithmetic Mean`)) %>% head
  

# 3. Which monitoring site has the highest average level of “Sulfate PM2.5 LC” across all time?
# Indicate the state code, county code, and site number.
daily_matter %>% select(`Arithmetic Mean`, `Parameter Name`, `State Code`, `County Code`, `Site Num`) %>% 
  filter(`Parameter Name` == "Sulfate PM2.5 LC") %>% 
  group_by(`State Code`, `County Code`, `Site Num`) %>%
  summarise(avg_level = mean(`Arithmetic Mean`, na.rm = TRUE)) %>%
  arrange(desc(avg_level)) %>% head

# 4. What is the absolute difference in the average levels of “EC PM2.5 LC TOR” between the states California and Arizona, 
# across all time and all monitoring sites?
daily_matter %>% select(`Arithmetic Mean`, `State Name`, `Parameter Name`) %>% 
  filter(`State Name` %in% c("California", "Arizona") & `Parameter Name` == "EC PM2.5 LC TOR" & !is.na(`Arithmetic Mean`)) %>%
  group_by(`State Name`) %>%
  summarise(ari_sum = mean(`Arithmetic Mean`)) # 0.018567

# 5. What is the median level of “OC PM2.5 LC TOR” in the western United States, across all time? 
# Define western as any monitoring location that has a Longitude LESS THAN -100.
daily_matter %>% select(`Arithmetic Mean`, Longitude, `Parameter Name`) %>% 
  filter(Longitude < -100 & `Parameter Name` == "OC PM2.5 LC TOR") %>%
  summarise(ari_med = median(`Arithmetic Mean`)) # 0.43


# 6 How many monitoring sites are labelled as both RESIDENTIAL for "Land Use" and SUBURBAN for "Location Setting"?
library(readxl)
sites <- read_excel("data/aqs_sites.xlsx", col_types = c("text", "text", "text", "numeric", "numeric", "text", "numeric", "text", "text",
                                                         "date", "date", "text", "text", "text", "text", "text", "text", "numeric", "text", "text",
                                                         "text", "numeric", "text", "text", "text", "text", "text", "date"))
sites %>% select(`Land Use`, `Location Setting`, `State Code`, `County Code`, `Site Number`) %>%
  filter(`Land Use` == "RESIDENTIAL" & `Location Setting` == "SUBURBAN") %>%
  group_by(`State Code`, `County Code`, `Site Number`) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  summarise(n = sum(n)) # 3527

# 7. What is the median level of “EC PM2.5 LC TOR” amongst monitoring sites that are labelled as both “RESIDENTIAL” and “SUBURBAN” in the eastern U.S., 
#    where eastern is defined as Longitude greater than or equal to -100?
site_resi_suburban <- sites %>% filter(`Land Use` == "RESIDENTIAL" & `Location Setting` == "SUBURBAN") %>%
  select(`State Code`, `County Code`, `Site Number`) %>% mutate(site = paste(`State Code`, `County Code`, `Site Number`, sep = "_"))
daily_matter %>% select(`State Code`, `County Code`, `Site Num`, `Parameter Name`, Longitude, `Arithmetic Mean`) %>%
  mutate(site = paste(`State Code`, `County Code`, `Site Num`, sep = "_")) %>%
  filter(`Parameter Name` == "EC PM2.5 LC TOR" & Longitude >= -100 & site %in% site_resi_suburban$site) %>% head
  summarise(ari_med = median(`Arithmetic Mean`, na.rm = TRUE)) # ???
  
# Amongst monitoring sites that are labeled as COMMERCIAL for "Land Use", which month of the year has the highest average levels of "Sulfate PM2.5 LC"?
  library(lubridate)
matter_and_sites %>%
  filter(`Land Use` == "COMMERCIAL" & `Parameter Name` == "Sulfate PM2.5 LC") %>%
  mutate(month_ = month(`Date Local`)) %>%
  group_by(month_) %>%
  summarise(asd = sum(`Arithmetic Mean`)) %>%
  arrange(desc(asd))

