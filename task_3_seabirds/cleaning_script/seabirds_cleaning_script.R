library(tidyverse)
library(readxl)

ship_record_id <- read_excel("raw_data/seabirds.xls", sheet = "Ship data by record ID")
bird_record_id <- read_excel("raw_data/seabirds.xls", sheet = "Bird data by record ID")
ship_codes <- read_excel("raw_data/seabirds.xls", sheet = "Ship data codes")
bird_codes <- read_excel("raw_data/seabirds.xls", sheet = "Bird data codes")



