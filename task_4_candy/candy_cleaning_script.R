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


# Joining datasets
# Use full join, there should be no matching rows as the year will always be different. 

# Checking how many columns are in 2016 but not 2015
setdiff(names(candy2015), names(candy2016))
# 22 columns only in 2016

# Expect 6889 (5630 + 1259) rows and 122 columns in all_candy
all_candy <- full_join(candy2015, candy2016)

# Now add 2017 data to all_candy
setdiff(names(candy2017), names(all_candy))
# 7 columns in 2017 but not all_candy

# Expect 9349 (6889 + 2460) rows and 129 columns
all_candy <- full_join(all_candy, candy2017)

# AGE
# No nulls present. Convert column to integer. 
# Unlikely anyone under 2 or over 110 filled in survey. Convert ages outside this range to NAs

all_candy <- all_candy %>%
  mutate(age = as.integer(age)) %>% 
  mutate(age = na_if(age, age < 2 | age < 110))

# GOING OUT

all_candy %>% 
  group_by(going_out) %>% 
  summarise(
    n = n()
  )

# The going_out column looks fine, it contains yes, no and NA 

# GENDER 

all_candy %>% 
  group_by(gender) %>% 
  summarise(
    n = n()
  )

# five responses for gender which all look fine

# COUNTRY
# ok its the big one - how to fix this mess?!

countries <- all_candy %>% 
  group_by(country) %>% 
  summarise(
    n = n()
  )

# convert country names to lowercase

# US seems to be written in lots and lots of different ways. Let's try to combine them. 
  


all_candy2 <- all_candy %>%    
  mutate(
    country = case_when(
      str_detect(country, "(?i)usa") ~ "USA",
      str_detect(country, "(?i)america") ~ "USA",
      str_detect(country, "(?i)united s") ~ "USA",
      str_detect(country, "(?i)canada") ~ "Canada",
      TRUE ~ country
    )
  ) 

         
         


countries <- all_candy2 %>% 
  group_by(country) %>% 
  summarise(
    n = n()
  )






# shows number of distinct values in each column
#sapply(all_candy, function(x) n_distinct(x))
