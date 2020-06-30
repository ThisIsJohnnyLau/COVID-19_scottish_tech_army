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
    distinct(variable) %>% 
    arrange(variable)

data_sets <- full_data %>%
    distinct(data_set) %>% 
    arrange(data_set)

testing_variables_daily <- full_data %>%
    filter(data_set == "Testing - Daily") %>% 
    distinct(variable) %>% 
    arrange(variable)

testing_variables_cumulative <- full_data %>%
    filter(data_set == "Testing - Cumulative") %>% 
    distinct(variable) %>% 
    arrange(variable)

ICU_variables <- full_data %>%
    filter(data_set == "COVID-19 patients in ICU") %>% 
    distinct(variable) %>% 
    arrange(variable)

general_patient_variables <- full_data %>%
    filter(data_set == "COVID-19 patients in hospital") %>% 
    distinct(variable) %>% 
    arrange(variable)


calls_variables <- full_data %>%
    filter(data_set == "Calls") %>% 
    distinct(variable) %>% 
    arrange(variable)

ambulance_variables <- full_data %>%
    filter(data_set == "Ambulance attendances") %>% 
    distinct(variable) %>% 
    arrange(variable)

general_variables <- full_data %>%
    filter(data_set == "General") %>% 
    distinct(variable) %>% 
    arrange(variable)


care_home_variables_daily <- full_data %>%
    filter(data_set == "Adult Care Homes - Daily") %>% 
    distinct(variable) %>% 
    arrange(variable)

care_home_variables_cumulative <- full_data %>%
    filter(data_set == "Adult Care Homes - Cumulative") %>% 
    distinct(variable) %>% 
    arrange(variable)

care_home_variables_proportion <- full_data %>%
    filter(data_set == "Adult Care Homes - Proportion") %>% 
    distinct(variable) %>% 
    arrange(variable)

NHS_workforce_variables <- full_data %>%
    filter(data_set == "NHS workforce COVID-19 absences") %>% 
    distinct(variable) %>% 
    arrange(variable)




full_dataset_list <- 
    c(general_variables, testing_variables_daily, testing_variables_cumulative, general_patient_variables, ICU_variables, calls_variables, ambulance_variables, care_home_variables_daily, care_home_variables_cumulative, NHS_workforce_variables)


