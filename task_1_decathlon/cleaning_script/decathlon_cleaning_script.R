library(tidyverse)
library(janitor)

decathlon <- read_rds("raw_data/decathlon.rds")

# Cleaning column names

decathlon <- janitor::clean_names(decathlon)


decathlon <- rename(decathlon, "javelin" = "javeline")

decathlon <- rownames_to_column(decathlon, "athlete")

# No NAs
# No NULLs
# all values in expected range

#changing athletes names to all be lowercase
decathlon$athlete <- tolower(decathlon$athlete)

# Tidying up competition names (bit pedantic but looks neater)
decathlon <- decathlon %>% 
  mutate(competition = if_else(competition == "Decastar", "decastar", "olympics"))

write_csv(decathlon, "clean_data/clean_decathlon_data.csv")
