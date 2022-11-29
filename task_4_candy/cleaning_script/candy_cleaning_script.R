# Loading libraries and reading data ----
library(tidyverse)
library(readxl)

# Each xlsx only contains 1 sheet - checked with `excel_sheets()`
candy2015 <- read_excel("raw_data/boing-boing-candy-2015.xlsx")
candy2016 <- read_excel("raw_data/boing-boing-candy-2016.xlsx")
candy2017 <- read_excel("raw_data/boing-boing-candy-2017.xlsx")


# Cleaning column names ----

candy2015 <- janitor::clean_names(candy2015)
candy2016 <- janitor::clean_names(candy2016)
candy2017 <- janitor::clean_names(candy2017)

# Man these column names are messy!!
# Let's set up a standard set of column names across the 3 datasets which look like 
# this:
#     year
#     age
#     going_out
#     gender
#     country
#     all candy columns

# 2015
candy2015 <- candy2015 %>% 
# Removing columns I don't think are needed
    select(-timestamp, -c(97:113), -c(116:124)) %>%
# Creating a year column (to distinguish datasets once joined)
  mutate(year = c(rep(2015, 5630))) %>% 
# fixing column names
    rename(age = how_old_are_you, 
         going_out = are_you_going_actually_going_trick_or_treating_yourself) %>% 
# Creating new columns to match other datasets
    mutate(gender = c(rep(NA, 5630)), country = c(rep(NA, 5630)))
  

# 2016
candy2016 <- candy2016 %>% 
  select(-timestamp, -which_state_province_county_do_you_live_in, -c(107:123)) %>%
  mutate(year = c(rep(2016, 1259))) %>% 
  rename(age = how_old_are_you, 
         going_out = are_you_going_actually_going_trick_or_treating_yourself,
         country = which_country_do_you_live_in,
         gender = your_gender) 


# 2017
candy2017 <- candy2017 %>% 
  select(-internal_id, -q5_state_province_county_etc, -c(110:120)) %>%
  mutate(year = c(rep(2017, 2460))) %>% 
  rename(age = q3_age, 
         going_out = q1_going_out,
         country = q4_country,
         gender = q2_gender) 


# 2017 data has "q6_" at the start of each candy column. This needs to be removed to allow alphabetising and joining with other datasets. 

names(candy2017) <- sub('^q6_', '', names(candy2017))

# janitor::clean_names didn't change the 100_grand_bar column in 2017 to x100_grand_bar like it did for 2015 and 2016 as it had the q6 prefix. Done manually below. 

candy2017 <- candy2017 %>% 
  rename(x100_grand_bar = `100_grand_bar`)

# Sort all columns alphabetically, then move 5 non-candy columns to start

# MAKE THIS A FUNCTION
candy2015 <- candy2015 %>% 
  select(sort(names(.))) %>% 
  relocate("year", "age", "going_out", "gender", "country", everything())

candy2016 <- candy2016 %>% 
  select(sort(names(.))) %>% 
  relocate("year", "age", "going_out", "gender", "country", everything())

candy2017 <- candy2017 %>% 
  select(sort(names(.))) %>% 
  relocate("year", "age", "going_out", "gender", "country", everything())


# THIS FUNCTION NOT WORKING YET
#arrange_columns <- function(x) {
#  x %>%  
#    select(sort(names(.))) %>% 
#    relocate("year", "age", "going_out", "gender", "country", everything())
# return(y)
#}
  
#arrange_columns(candy2017)


# Joining datasets ----

# Use full join, there should be no matching rows as the year will always be different. 

# Checking how many columns are in 2016 but not 2015
# setdiff(names(candy2016), names(candy2015))
# 22 columns only in 2016

# Expect 6889 (5630 + 1259) rows and 122 columns in all_candy
all_candy <- full_join(candy2015, candy2016)

# Now add 2017 data to all_candy
# setdiff(names(candy2017), names(all_candy))
# 7 columns in 2017 but not all_candy

# Expect 9349 (6889 + 2460) rows and 129 columns
all_candy <- full_join(all_candy, candy2017)

rm(candy2015, candy2016, candy2017)

#Fixing column names and combining columns----

# Rerun alphabetising code on full dataset 
all_candy <- all_candy %>% 
  select(sort(names(.))) %>% 
  relocate("year", "age", "going_out", "gender", "country", everything())


# Scanned through column names by eye, identified and fixed issues for following columns:
#   abstain from m and m 
#   brown globs and maryjanes
#   bonkers
#   box o raisins
#   hersheys
#   m and ms
#   sweetums

# Could this be a function? Where you input the columns to combine, the new column name and then delete the one you don't want?? 

all_candy <- all_candy %>% 
  rename(abstained_from_m_and_m_ing = abstained_from_m_ming) %>% 
# there are 3 columns which may be related. In 2015 and 2016 we have 1) anonymous brown globs that come in black and orange wrappers and 2) mary janes. In 2017 we have - anonymous brown globs that come in black and orange wrappers aka mary janes. Decision made to combine the columns which say have "mary jane" in name. Also an internet search shows that Mary Jane sweets have the name on the wrapper so they are unlikely to be anonymous brown blobs. 
  mutate(mary_janes = coalesce(anonymous_brown_globs_that_come_in_black_and_orange_wrappers_a_k_a_mary_janes, mary_janes)) %>% 
  select(-anonymous_brown_globs_that_come_in_black_and_orange_wrappers_a_k_a_mary_janes) %>% 
# In 2017 the bonkers column was split into 'bonkers the candy' and 'bonkers the board game'. Combine 'bonkers the candy' with other bonkers data from 2015 adn 2016 and remove the 'bonkers the candy column. 
  mutate(bonkers = coalesce(bonkers, bonkers_the_candy)) %>% 
  select(-bonkers_the_candy) %>% 
# box-o-raisins columns spelt differently in different years, these were combined
  mutate(box_o_raisins = coalesce(box_o_raisins, boxo_raisins)) %>% 
  select(-boxo_raisins) %>% 
# combine the two dark chocolate hershey columns
  mutate(hersheys_dark_chocolate = coalesce(dark_chocolate_hershey, hersheys_dark_chocolate)) %>% 
  select(-dark_chocolate_hershey) %>% 
# combine the two fake M&M columns
  mutate(third_party_m_ms = coalesce(independent_m_ms, third_party_m_ms)) %>% 
  select(-independent_m_ms) %>% 
# combine the two sweetums columns
mutate(sweetums = coalesce(sweetums, sweetums_a_friend_to_diabetes)) %>% 
  select(-sweetums_a_friend_to_diabetes)

# All columns were checked to make sure only NAs were being overwritten when columns were combined. 



all_candy <- all_candy %>% 
  select(sort(names(.))) %>% 
  relocate("year", "age", "going_out", "gender", "country", everything())

# Fixing column contents (non-candy columns)----

## Age----
# No nulls present. 
# Convert column to integer. 
# Unlikely anyone over 110 filled in survey. Convert ages above 110 to NAs.
# 3 people aged zero or 1 filled in survey, seems unlikely but perhaps there are some babies with strong opinions about sweets out there. Left this data as it was.
# So many NAs (477) that decided not to impute them.

all_candy <- all_candy %>%
  mutate(age = as.integer(age)) %>% 
  mutate(age = if_else(age > 110 , NA_integer_, age))


## Going out----

# The going_out column looks fine, it contains yes, no and NA 

## Gender---- 

# five responses for gender which all look fine
# convert to lowercase to help any analysis

all_candy$gender <- str_to_lower(all_candy$gender)


## Country----
# ok its the big one - how to fix this mess?!

# convert country names to lowercase
all_candy$country <- str_to_lower(all_candy$country)


all_candy <- all_candy %>%    
  mutate(
    country = case_when(
# US seems to be written in lots and lots of different ways - lets combine
      str_detect(country, "usa|america|merica|murica|amerca|united s|unites s|alaska|california|i pretend to be from canada, but i am really from the united states.|murrika|new jersey|new york|pittsburgh|north carolina|the yoo ess of aaayyyyyy|u s|u s a|u.s.|u.s.a.|unhinged states|unied states|unite states|units states|us of a|ussa|eua") ~ "usa",
# lots of funny, funny people whose answers need converted to NAs
        str_detect(country, "1|30.0|32|35|44.0|45|46|47.0|51.0|54.0|a tropical island south of the equator|atlantis|canae|cascadia|denial|earth|europe|fear and loathing|god's country|i don't know anymore|insanity lately|narnia|neverland|not the usa or canada|one of the best ones|see above|somewhere|soviet canuckistan|subscribe to dm4uz3 on youtube|the republic of cascadia|there isn't one for old men|this one|trumpistan|ud") ~ NA_character_,
      str_detect(country, "scotland|endland|england|u.k.|united kindom|united kingdom") ~ "uk",
      str_detect(country, "brasil") ~ "brazil",
      str_detect(country, "españa") ~ "spain",
      str_detect(country, "canada`") ~ "canada",
# korea added to south korea as unlikely anyone from north korea would be filling in such as survey and also likely they would put north korea rather than just korea as country
      str_detect(country, "korea") ~ "south korea",
      str_detect(country, "netherlands") ~ "the netherlands", 
      str_detect(country, "^[a]$") ~ NA_character_,
      str_detect(country, "^[u][s]$") ~ "usa",
# "can" might be canada but no way to be sure so just putting it in with NAs 
     str_detect(country, "^[c][a][n]$") ~ NA_character_,
      TRUE ~ country
    )
  ) 

# We've gone from 139 countries to 37 countries - woohoo!  


# Writing data ----

write_csv(all_candy, "clean_data/clean_candy_data.csv")
