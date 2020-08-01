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
library(glmulti)
library(GGally)
library(beepr)

# # mean versus median
# names <- SIMD_and_housing %>% 
#     names()
# names(names) <- "variable"
# 
# pcts <- names %>% 
#     filter(variable, str_detect(pattern = "pct"))
# 
# counts <- c("intermediate_zone_pop",			
#             "intermediate_zone_working_pop",
#             "income_dep",
#             "employ_dep")
# 
# ratios <- c("cif",
#             "alcohol",
#             "drug",
#             "smr")
# 
# 
# pcts <- c("employ_dep_pct",
#           "depress_pct",		
#           "lbwt_pct",
#           "attendance_pct",
#           "not_participating_pct",
#           "university_pct",	
#           "bband_pct",				
#           "crime_pct",
#           "overcrowded_pct",			
#           "nocentralheat_pct")

				
				
				
	
# emerg				
# attainment_score				
# no_qual_ratio_std				
# petrol_ave_drive_mins				
# gp_ave_drive_mins				
# drive_post				
# prim_sch_ave_drive_mins				
# drive_retail				
# sec_sch_ave_drive_mins				
# gp_ave_pub_trans_mins				
# pt_post				
# shopping_ave_pub_trans_mins				
# overcrowd				
# nocentralheat				
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






#  latest traffic data to june 8th with clean names and location
traffic_data <- read_excel("raw_data/traffic/automatic-traffic-counter-data-as-of-8-june-2020.xlsx",
                           skip = 8) %>%
    mutate_at(vars(contains("4")), as.numeric) %>% # need a slicker select arg
    pivot_longer(-(`Site ID`:Longitude), names_to = "date", values_to = "cars") %>% 
    clean_names() %>%
    mutate(date = convertToDate(date))

