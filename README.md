# CodeClan Dirty Data Project

## Introduction

This project involves cleaning "dirty" datasets and performing analysis on the cleaned data. 
The main purpose is to gain experience in dealing with such datasets. The outputs of each task are a cleaning script, a cleaned dataset and a markdown document containing the results of the analysis. It should be noted that this analysis was conducted durinng week 4 of the CodeClan Data Analysis course and so the coding is at a somewhat basic level. 
 
The work in this repository was conducted with the R programming language. 

### Task 1 - Decathlon
The decathlon dataset contains the results from each of the 10 events in the decathlon. The data covers two competitions - the 2004 Olympic Games and the 2004 Decastar competition. The data also includes the place the athlete finished ("rank") and their total points. 
This dataset only required a few relatively minor cleaning steps before it was interrogated to answer questions on longest jump, average 100 metre times, highest points total etc. 
This is a nice dataset which shows the dominance of three decathletes during the 2004 season. 

### Task 4 - Halloween Candy
The boing boing candy dataset contains the results of a Halloween candy survey. The data covers three years (2015, 2016 and 2017) and includes information on the person completing the survey, such as age, gender and country. The ratings used were Joy, Despair, Meh or NA for the 2016 and 2017 data; Meh was not an option in 2015. The 2015 data also lacked information on the gender and country of the person completing the survey.
I believe it is accurate to say the original datasets were a mess and required extensive cleaning. The country column, in particular, had a lot of non-standard answers. 
Some analysis was conducted on the age of participants but most of the analysis focussed on which candies were most or least popular. The items rated weren't just candy, things like DVDs, glow sticks and pharmaceuticals were also included. Limiting the analysis to just candy was considered but it was decided to leave non-candy items in for completeness. 

### Task 3 - Seabirds
Work in progress...

## How to run the project

The file structure for each task within the project is as follows:
- analysis
- clean_data
- cleaning_script
- raw_data

The original dataset in .csv format can be sourced from the raw_data folder. This file is read in to the cleaning script and the output saved in the clean_data folder as a new .csv file. This new .csv file is then read in to the analysis .rmd file which can be found in the analysis folder 

## Versions

RStudio     2022.07.2+576 "Spotted Wakerobin" 

R           4.2.2

tidyverse   1.3.1

readxl      1.4.0

here        1.0.1
