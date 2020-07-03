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
library(shinythemes)
library(shinycssloaders)
library(rmapshaper)
library(sf)
library(leaflet)
library(openxlsx)

##################################################################
##                    Rhi Data Wrangling                        ##
##################################################################

#data file
management <- read_csv("clean_data/management_clean.csv")

#shape file and reducing the polygons to increase render speed
scotland <- st_read("clean_data/scotland.shp", quiet = TRUE) %>%
    ms_simplify(keep = 0.025)

scotland_covid <- read_csv("clean_data/scotland_covid.csv")

local_authorities <- unique(scotland_covid$local_authority) %>% 
    sort()

cardio_prescriptions <- read_csv("clean_data/cardio_prescriptions.csv")



##################################################################
##                    Johnny Global                             ##
##                              #                               ##
##################################################################

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

# check testing variables
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

# check carehome variables
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





