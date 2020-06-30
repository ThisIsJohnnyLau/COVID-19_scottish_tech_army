library(readr)
library(tidyverse)
library(janitor)
library(lubridate)
library(here)
library(zoo)
library(xts)
library(tis)
library(readxl)
library(shiny)

full_data <-
    read_csv(here("clean_data/comprehensive_data_with_populations.csv"))

area_names <- full_data %>% 
    distinct(area) %>% 
    arrange(area)

variable_names <- full_data %>% 
    distinct(variable)

data_sets <- full_data %>%
    distinct(data_set)

testing_variables <- full_data %>%
    filter(data_set == "Testing") %>% 
    distinct(variable)

ICU_variables <- full_data %>%
    filter(data_set == "COVID-19 patients in ICU") %>% 
    distinct(variable)

general_patient_variables <- full_data %>%
    filter(data_set == "COVID-19 patients in hospital") %>% 
    distinct(variable)


calls_variables <- full_data %>%
    filter(data_set == "Calls") %>% 
    distinct(variable)

ambulance_variables <- full_data %>%
    filter(data_set == "Ambulance attendances") %>% 
    distinct(variable)

general_variables <- full_data %>%
    filter(data_set == "General") %>% 
    distinct(variable)


care_home_variables <- full_data %>%
    filter(data_set == "Adult care homes") %>% 
    distinct(variable)

NHS_workforce_variables <- full_data %>%
    filter(data_set == "NHS workforce COVID-19 absences") %>% 
    distinct(variable)



full_dataset_list <- 
    c(testing_variables, ICU_variables, general_patient_variables, calls_variables, ambulance_variables, general_variables, care_home_variables, NHS_workforce_variables)




df <- data.frame(site = c('A1', 'A1', 'A1', 'B1', 'B1','B1','B1','C1','C1'), 
                 part = c('a1', 'a1', 'a2', 'b1', 'b1', 'b2','b3','c1','c2'),
                 value = c(2,3,4,5,6,7,8,9,10))

site_choices <- as.list(df$site)
names(site_choices) <- df$site