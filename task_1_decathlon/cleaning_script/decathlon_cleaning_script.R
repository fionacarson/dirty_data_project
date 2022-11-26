library(tidyverse)
library(janitor)

decathlon <- read_rds("raw_data/decathlon.rds")

# Cleaning column names
decathlon <- janitor::clean_names(decathlon)

# Correcting a typo
decathlon <- rename(decathlon, "javelin" = "javeline")

# Converting row names to a column
decathlon <- rownames_to_column(decathlon, "athlete")

# No NAs
# No NULLs
# all values in expected range

# Changing athletes names to all be lowercase
decathlon$athlete <- tolower(decathlon$athlete)

# Tidying up competition names 
decathlon <- decathlon %>% 
  mutate(competition = if_else(competition == "Decastar", "decastar", "olympics"))

write_csv(decathlon, "clean_data/clean_decathlon_data.csv")
