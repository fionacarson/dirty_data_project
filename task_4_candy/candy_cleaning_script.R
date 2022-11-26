library(tidyverse)
library(readxl)

# Each xlsx only contains 1 sheet - checked with `excel_sheets()`
candy2015 <- read_excel("raw_data/boing-boing-candy-2015.xlsx")
candy2016 <- read_excel("raw_data/boing-boing-candy-2016.xlsx")
candy2017 <- read_excel("raw_data/boing-boing-candy-2017.xlsx")

# Initial clean of column names
candy2015 <- janitor::clean_names(candy2015)
candy2016 <- janitor::clean_names(candy2016)
candy2017 <- janitor::clean_names(candy2017)

# Man these column names are messy!!
# Let's set up a standard set of column names across the 3 datasets:
#     year
#     age
#     going_out
#     gender
#     country
#     all candy columns




# 2015
candy2015 <- candy2015 %>% 
# Removing columns I don't think are needed
    select(-timestamp, -c(97:113), -c(116, 124)) %>%
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

# Sort all columns alphabetically, the move 5 non-candy colummns to start
# This method should be more transferable to other datasets
# MAKE THIS A FUNCTION
candy2015 <- candy2015 %>% 
  select(sort(names(.))) %>% 
  relocate("year", "age", "going_out", "gender", "country", everything())

candy2016 <- candy2016 %>% 
  select(sort(names(.))) %>% 
  relocate("year", "age", "going_out", "gender", "country", everything())



arrange_columns <- function(x) {
  x %>%  
    select(sort(names(.))) %>% 
    relocate("year", "age", "going_out", "gender", "country", everything())
 return(y)
}
  
arrange_columns(candy2017)



