# CodeClan Dirty Data Project

## Introduction

This project involves cleaning "dirty" datasets and performing analysis on the cleaned data. 
The main purpose is to gain experience in dealing with such datasets. The project consists of multiple tasks which each have their own datasets and analysis questions. The outputs of each task are a cleaning script, a cleaned dataset and a markdown document containing the results of the analysis. 
 
The work in this repository was conducted with the R programming language. 

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