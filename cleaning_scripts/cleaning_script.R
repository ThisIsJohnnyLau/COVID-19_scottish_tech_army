library(readr)
library(tidyverse)
library(janitor)
library(lubridate)


data <- read_csv("data.csv") %>% 
    clean_names() %>% 
    select(-feature_code, -units, -measurement) %>% 
    rename(date = date_code) %>% 
    mutate(date = ymd(date),
           value = as.numeric(value)) %>% 
    drop_na()

variables <- data %>% 
    distinct(variable)

care_homes <- data %>% 
    filter(str_detect(variable, "care"))

COVID_cases <- data %>% 
    filter(str_detect(variable, "COVID-19 patients|Testing|deaths"))
