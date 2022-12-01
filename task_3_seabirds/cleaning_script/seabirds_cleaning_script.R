library(tidyverse)
library(readxl)

# May not need code files, can delete if we don't
ship <- read_excel("raw_data/seabirds.xls", sheet = "Ship data by record ID")
bird <- read_excel("raw_data/seabirds.xls", sheet = "Bird data by record ID")
ship_codes <- read_excel("raw_data/seabirds.xls", sheet = "Ship data codes")
bird_codes <- read_excel("raw_data/seabirds.xls", sheet = "Bird data codes")

bird <- janitor::clean_names(bird)
ship <- janitor::clean_names(ship)

# A lot of columns were removed from both the bird and ship datasets as they 
# didn't provide useful information or weren't relevant for answering the questions.  

bird <- bird %>% 
  rename(common_name = species_common_name_taxon_age_sex_plumage_phase, 
         scientific_name = species_scientific_name_taxon_age_sex_plumage_phase,
         accomp_num = nacc) %>% 
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
# been made in the record_id for an albatross in the bird dataset - this was fixed. 

bird <- bird %>% 
# Filtered to check there was only one record with this number before we change it. 
#    filter(record_id == 1184009) %>% 
    mutate(record_id = replace(record_id, record_id == 1184009, 1104009))


# Could use regex to remove the uppercase letters from the common_name
# variable but this also removes other information, such as from record 1087001 where 
# it says "NO BIRDS RECORDED".
# Decided to remove exact strings as this can also be used on scientific column.


bird <- bird %>% 
  mutate(common_name = str_remove_all(common_name, "sensu lato")) %>% 
  mutate(common_name = str_remove_all(common_name, "AD")) %>% 
  mutate(common_name = str_remove_all(common_name, "SUBAD")) %>% 
  mutate(common_name = str_remove_all(common_name, "SUB")) %>% 
  mutate(common_name = str_remove_all(common_name, "IMM")) %>% 
  mutate(common_name = str_remove_all(common_name, "JUV")) %>%
  mutate(common_name = str_remove_all(common_name, "PL[1-5]")) 


bird <- bird %>% 
  mutate(scientific_name = str_remove_all(scientific_name, "sensu lato")) %>% 
  mutate(scientific_name = str_remove_all(scientific_name, "AD")) %>% 
  mutate(scientific_name = str_remove_all(scientific_name, "SUBAD")) %>% 
  mutate(scientific_name = str_remove_all(scientific_name, "SUB")) %>% 
  mutate(scientific_name = str_remove_all(scientific_name, "IMM")) %>% 
  mutate(scientific_name = str_remove_all(scientific_name, "JUV")) %>%
  mutate(scientific_name = str_remove_all(scientific_name, "PL[1-5]")) 

bird %>% 
  str_trim(common_name, side = right)


  
birds_common_names <- bird %>% 
  group_by(common_name) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count))


  
# q#all_data <- full_join(bird, ship, by = "record_id")






ship2 %>% 
  group_by(wind_dir) %>% 
  summarise(count = n())
