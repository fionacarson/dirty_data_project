library(tidyverse)
library(janitor)

decathlon <- read_rds("raw_data/decathlon.rds")

# Cleaning column names

decathlon <- janitor::clean_names(decathlon)
# Names starting with numbers now have an x at the start. Not sure if this is 
# acceptable?

decathlon <- rename(decathlon, "javelin" = "javeline")

decathlon <- rownames_to_column(decathlon, "athlete")

# No NAs
# No NULLs
# all values in expected range



check for values out of expected range
change names so all lowercase
do names match between competitions
change names of competitions
