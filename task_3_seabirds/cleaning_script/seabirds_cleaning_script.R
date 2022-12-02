library(tidyverse)
library(readxl)

ship <- read_excel("raw_data/seabirds.xls", sheet = "Ship data by record ID")
bird <- read_excel("raw_data/seabirds.xls", sheet = "Bird data by record ID")

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

# Could use regex to remove the uppercase letters from the common_name
# variable but this also removes other information, such as from record 1087001 where 
# it says "NO BIRDS RECORDED".
# Decided to remove exact strings as this can also be used on scientific column.


  
fix_names <- function(dataset_name, colx) {
  dataset_name <- dataset_name %>% 
    mutate(colx = str_remove_all(colx, "sensu lato")) %>% 
    mutate(colx = str_remove_all(colx, " AD")) %>% 
    mutate(colx = str_remove_all(colx, " SUBAD")) %>% 
    mutate(colx = str_remove_all(colx, " SUB")) %>% 
    mutate(colx = str_remove_all(colx, " IMM")) %>% 
    mutate(colx = str_remove_all(colx, " JUV")) %>%
    mutate(colx = str_remove_all(colx, " ADF")) %>%
    mutate(colx = str_remove_all(colx, " PL[1-6]")) %>% 
    mutate(colx = str_remove_all(colx, " LGHT")) %>% 
    mutate(colx = str_remove_all(colx, " DRK")) %>% 
    mutate(colx = str_remove_all(colx, " INT")) %>% 
    mutate(colx = str_remove_all(colx, " WHITE")) %>% 
    #checked that this string wasn't being picked up elsewhere in names and it wasn't
    mutate(colx = str_remove_all(colx, " sp")) %>% 
    mutate(colx = str_remove_all(colx, " sp.")) %>% 
    mutate(colx = str_trim(colx, side = "right"))
}

bird <- fix_names(bird, "common_name")





bird <- bird %>% 
  mutate(common_name = str_remove_all(common_name, "sensu lato")) %>% 
  mutate(common_name = str_remove_all(common_name, " AD")) %>% 
  mutate(common_name = str_remove_all(common_name, " SUBAD")) %>% 
  mutate(common_name = str_remove_all(common_name, " SUB")) %>% 
  mutate(common_name = str_remove_all(common_name, " IMM")) %>% 
  mutate(common_name = str_remove_all(common_name, " JUV")) %>%
  mutate(common_name = str_remove_all(common_name, " ADF")) %>%
  mutate(common_name = str_remove_all(common_name, " PL[1-6]")) %>% 
  mutate(common_name = str_remove_all(common_name, " LGHT")) %>% 
  mutate(common_name = str_remove_all(common_name, " DRK")) %>% 
  mutate(common_name = str_remove_all(common_name, " INT")) %>% 
  mutate(common_name = str_remove_all(common_name, " WHITE")) %>% 
  #checked that this string wasn't being picked up elsewhere in names and it wasn't
  mutate(common_name = str_remove_all(common_name, " sp")) %>% 
  mutate(common_name = str_remove_all(common_name, " sp.")) %>% 
  mutate(common_name = str_trim(common_name, side = "right"))




bird <- bird %>% 
  mutate(scientific_name = str_remove_all(scientific_name, "sensu lato")) %>% 
  mutate(scientific_name = str_remove_all(scientific_name, "AD")) %>% 
  mutate(scientific_name = str_remove_all(scientific_name, "SUBAD")) %>% 
  mutate(scientific_name = str_remove_all(scientific_name, "SUB")) %>% 
  mutate(scientific_name = str_remove_all(scientific_name, "IMM")) %>% 
  mutate(scientific_name = str_remove_all(scientific_name, "JUV")) %>%
  mutate(scientific_name = str_remove_all(scientific_name, "PL[1-6]")) %>% 
  mutate(scientific_name = str_remove_all(scientific_name, "LGHT")) %>% 
  mutate(scientific_name = str_remove_all(scientific_name, "DRK")) %>% 
  mutate(scientific_name = str_remove_all(scientific_name, "INT")) %>% 
  mutate(scientific_name = str_remove_all(scientific_name, "WHITE")) %>% 
  mutate(scientific_name = str_remove_all(scientific_name, " sp")) %>%
  mutate(scientific_name = str_remove_all(scientific_name, " sp.")) %>%
  mutate(scientific_name = str_trim(scientific_name, side = "right"))


bird <- bird %>% 
  mutate(species_abbreviation = str_remove_all(species_abbreviation, "sensu lato")) %>% 
  mutate(species_abbreviation = str_remove_all(species_abbreviation, "AD")) %>% 
  mutate(species_abbreviation = str_remove_all(species_abbreviation, "SUBAD")) %>% 
  mutate(species_abbreviation = str_remove_all(species_abbreviation, "SUB")) %>% 
  mutate(species_abbreviation = str_remove_all(species_abbreviation, "IMM")) %>% 
  mutate(species_abbreviation = str_remove_all(species_abbreviation, "JUV")) %>%
  mutate(species_abbreviation = str_remove_all(species_abbreviation, "PL[1-6]")) %>% 
  mutate(species_abbreviation = str_remove_all(species_abbreviation, "LGHT")) %>% 
  mutate(species_abbreviation = str_remove_all(species_abbreviation, "DRK")) %>% 
  mutate(species_abbreviation = str_remove_all(species_abbreviation, "INT")) %>% 
  mutate(species_abbreviation = str_remove_all(species_abbreviation, "WHITE")) %>% 
  mutate(species_abbreviation = str_remove_all(species_abbreviation, " sp")) %>%
  mutate(species_abbreviation = str_remove_all(species_abbreviation, " sp.")) %>%
  mutate(species_abbreviation = str_trim(species_abbreviation, side = "right"))



birds_common_names <- bird %>% 
#  filter(str_detect(common_name, " sp")) %>% 
  group_by(common_name) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count))


  
birds_common_names <- bird %>% 
#  filter(str_detect(common_name, "skua")) %>% 
  group_by(scientific_name) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count))


#albatross    8
#petrel        50
#shearwater    15
#prion         8
#gannet       1
#mollymawk    10
#gull         4  
#tern         12
#skua         5


# 113 of 156




# Conducted a full join to ensure we weren't losing any data. We originally get 
# one more record than expected. Upon investigation it looks like a typo has 
# been made in the record_id for an albatross in the bird dataset - this was fixed. 

bird <- bird %>% 
  # Filtered to check there was only one record with this number before we change it. 
  #    filter(record_id == 1184009) %>% 
  mutate(record_id = replace(record_id, record_id == 1184009, 1104009))

all_data <- full_join(bird, ship, by = "record_id")

write_csv(all_data, "clean_data/clean_seabirds_data.csv")

