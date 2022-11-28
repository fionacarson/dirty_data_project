# Loading ibraries and reading data ----
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

#Sorting and fixing columns manually----

# Rerun alphabetising code on full dataset 
all_candy <- all_candy %>% 
  select(sort(names(.))) %>% 
  relocate("year", "age", "going_out", "gender", "country", everything())




# Read through column names, identified and fixed issues for following columns:
#   abstain from m and m 
#   brown globs and maryjanes
#   bonkers
#   box o raisins
#   hersheys - (dark chocolate and kisses)
#   m and ms
#   sweetums


all_candy2 <- all_candy %>% 
  rename(abstained_from_m_and_m_ing = abstained_from_m_ming) %>% 
# there are 3 columns which may be related. In 2015 and 2016 we have 1) anonymous brown globs that come in black and orange wrappers and 2) mary janes. In 2017 we have - anonymous brown globs that come in black and orange wrappers aka mary janes. Decision made to combine the columns which say have "mary jane" in name. Also an internet search shows that Mary Jane sweets have the name on the wrapper so they are unlikely to be anonymous brown blobs. 
  mutate(mary_janes = coalesce(anonymous_brown_globs_that_come_in_black_and_orange_wrappers_a_k_a_mary_janes, mary_janes)) %>% 
  select(-anonymous_brown_globs_that_come_in_black_and_orange_wrappers_a_k_a_mary_janes) %>% 
# In 2017 the bonkers column was split into 'bonkers the candy' and 'bonkers the board game'. Combine 'bonkers the candy' with other bonkers data from 2015 adn 2016 and remove the 'bonkers the candy column. 
  mutate(bonkers = coalesce(bonkers, bonkers_the_candy)) %>% 
  select(-bonkers_the_candy) %>% 
# box-o-raisins columns spelt differently, these were combined
  mutate(box_o_raisins = coalesce(box_o_raisins, boxo_raisins)) %>% 
  select(-boxo_raisins) %>% 
# combine the two dark chocolate hershey columns
  




hersheys <- all_candy %>% 
  select()







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
all_candy$country <- str_to_lower(all_candy$country)

# US seems to be written in lots and lots of different ways. Let's try to combine them. 
  

all_candy2 <- all_candy %>%    
  mutate(
    country = case_when(
      str_detect(country, "usa") ~ "usa",
      str_detect(country, "america") ~ "usa",
      str_detect(country, "merica") ~ "usa",
      str_detect(country, "murica") ~ "usa",
      str_detect(country, "amerca") ~ "usa",
      str_detect(country, "united s") ~ "usa",
      str_detect(country, "unites s") ~ "usa",
      str_detect(country, "alaska") ~ "usa",
      str_detect(country, "california") ~ "usa",
      TRUE ~ country
    )
  ) 

         
         


countries <- all_candy2 %>% 
  group_by(country) %>% 
  summarise(
    n = n()
  )
countries


countries <- all_candy3 %>% 
  group_by(country) %>% 
  summarise(
    n = n()
  )

convert_to_usa <- c("'merica")

convert_to_na <- c("1", "30.0", "32", "35", "44.0", "45", "46", "47.0", "51.0", "54.0", "a", "a tropical island southof the equator", "atlantis", "can", "canae", "cascadia", "denial", "earth", "europe", "fear and loathing", "god's country", "i don't know anymore", "i pretend to be from canada, but i am really from the united states.", "insanity lately", "narnia", "neverland", "not the usa or canada", "one of the best ones", "see above", "somewhere", "soviet canuckistan", "subscribe to dm4uz3 on youtube", "the republic of cascadia", "there isn't one for old men", "this one", "trumpistan", "ud")

all_candy3 <- all_candy2 %>% 
  mutate(country = na_if(country, country %in% c("1", "30.0", "32", "35", "44.0", "45", "46", "47.0", "51.0", "54.0", "a", "a tropical island southof the equator", "atlantis", "can", "canae", "cascadia", "denial", "earth", "europe", "fear and loathing", "god's country", "i don't know anymore", "i pretend to be from canada, but i am really from the united states.", "insanity lately", "narnia", "neverland", "not the usa or canada", "one of the best ones", "see above", "somewhere", "soviet canuckistan", "subscribe to dm4uz3 on youtube", "the republic of cascadia", "there isn't one for old men", "this one", "trumpistan", "ud")))


all_candy <- all_candy %>%
  mutate(age = as.integer(age)) %>% 
  mutate(age = na_if(age, age < 2 | age < 110))



# shows number of distinct values in each column
#sapply(all_candy, function(x) n_distinct(x))
