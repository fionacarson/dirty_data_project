library(tidyverse)
library(readxl)

# May not need code files, can delete if we don't
ship <- read_excel("raw_data/seabirds.xls", sheet = "Ship data by record ID")
bird <- read_excel("raw_data/seabirds.xls", sheet = "Bird data by record ID")
ship_codes <- read_excel("raw_data/seabirds.xls", sheet = "Ship data codes")
bird_codes <- read_excel("raw_data/seabirds.xls", sheet = "Bird data codes")

bird <- janitor::clean_names(bird)
ship <- janitor::clean_names(ship)


bird <- bird %>% 
  rename(common_name = species_common_name_taxon_age_sex_plumage_phase, 
         scientific_name = species_scientific_name_taxon_age_sex_plumage_phase,
         accomp_num = nacc) %>% 
# The columns below were removed as they didn't provide useful information or 
# weren't relevant for answering the questions  
  select(-record, -wanplum, -plphase, -sex, -nfeed, -ocfeed, -nsow,
         -ocsow, -nsoice, -ocsoice, -ocsoshp, -ocinhd, -nflyp, -ocflyp, -nfoll, 
         -ocfol, -ocmoult, -ocnatfed, -ocacc)


ship <- ship %>% 
  rename(cloud = cld, precip = prec, wind_speed = wspeed, sea_state = sste, 
         season = seasn) %>% 
  select(-record, -time, -ew, -sact, -speed, -sdir, -aprs, - atmp, -sal, -obs, 
         -month, -long360, -latcell, -longecell, -stmp, -depth, -csmeth, -wdir) 

# Conducted a full join to ensure we weren't losing any data. We originally get 
# one more record than expected. Upon investigation it looks like a typo has 
# been made in the record_id for an albatross. The sequence of numbers were 
# checked in both datasets and the order looks out in the bird dataset so this 
# record will be fixed manually. 

bird <- bird %>% 
# Filtered to check there was only one record with this number before we change it. 
#    filter(record_id == 1184009) %>% 
    mutate(record_id = replace(record_id, record_id == 1184009, 1104009))


# Could use regex for this and remove the uppercase letters from the common_name
# variable but this also remove other information, such as record 1087001 where 
# it says "NO BIRDS RECORDED".
# Decided to remove exact strings as this can also be used on scientific column.

fix_names <- function(col)
bird %>% 
  mutate(col = str_remove_all(common_name, "sensu lato")) %>% 
  mutate(common_name = str_remove_all(common_name, "AD")) %>% 
  mutate(common_name = str_remove_all(common_name, "SUBAD")) %>% 
  mutate(common_name = str_remove_all(common_name, "SUB")) %>% 
    mutate(common_name = str_remove_all(common_name, "IMM")) %>% 
  mutate(common_name = str_remove_all(common_name, "JUV")) 


fix_names <- function(col){
  bird %>% 
    mutate(col = str_remove_all(col, "sensu lato")) %>% 
    mutate(col = str_remove_all(col, "AD")) %>% 
    mutate(col = str_remove_all(col, "SUBAD")) %>% 
    mutate(col = str_remove_all(col, "SUB")) %>% 
    mutate(col = str_remove_all(col, "IMM")) %>% 
    mutate(col = str_remove_all(col, "JUV")) %>% 
    mutate(col = str_remove_all(col, "[PL][1-5]"))
}


bird2 <- fix_names("common_name")

  
# I'm not convinced regex is the best way to go here. Multiple lines of code to 
# remove the actual offending expression might be better and could then be used for 
bird3 <- bird %>% 
  mutate(common_name = str_remove_all(common_name, "sensu lato")) %>% 
  mutate(common_name = str_remove_all(common_name, "[A-Z]{2,}")) 



  
all_data <- full_join(bird, ship, by = "record_id")






ship2 %>% 
  group_by(wind_dir) %>% 
  summarise(count = n())
