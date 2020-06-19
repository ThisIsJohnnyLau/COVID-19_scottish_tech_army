library(readr)
library(tidyverse)
library(janitor)
library(lubridate)

testing <- read_csv("Covid managment data/COVID19 - Daily Management Information - Scotland - Testing.csv") %>% 
    clean_names() %>%
    rename(cum_negative = testing_cumulative_people_tested_for_covid_19_negative,
           cum_positive = testing_cumulative_people_tested_for_covid_19_positive,
           cum_total = testing_cumulative_people_tested_for_covid_19_total)
