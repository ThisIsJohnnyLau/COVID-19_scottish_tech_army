

cumulative <- c("Cumulative people tested for COVID-19 - Positive",
                "Cumulative people tested for COVID-19 - Negative",
                "Total number of COVID-19 tests carried out by Regional Testing Centres - Cumulative",
                "Total number of COVID-19 tests carried out by NHS Labs - Cumulative",
                "Cumulative people tested for COVID-19 - Total")


daily <- c("Daily people found positive",
           "Total number of COVID-19 tests carried out by NHS Labs - Daily",
           "Total number of COVID-19 tests carried out by Regional Testing Centres - Daily")


cumulative_care <- c("Cumulative number of suspected COVID-19 cases",
"Cumulative number that have reported a suspected COVID-19 case",
"Cumulative number that have reported more t
p[{;0oiu7654321# one suspected COVID-19 case")
    
daily_care <- c("Daily number of new suspected COVID-19 cases","Number of staff reported as absent",
"Number with current suspected COVID-19 cases","Adult care homes which submitted a return", "Total number of staff in adult care homes which submitted a return")

proportion_care <- c("Proportion that have reported a suspected COVID-19 case", "Proportion with current suspected COVID-19 cases", "Response rate", "Staff absence rate")


# 1. Comprehensive data and regions
read_csv("raw_data/data_with_geo_names/A - covid19_management_with_geo_names.csv") %>% 
    clean_names() %>% 
    select(-units) %>%
    rename(date = date_code, area_code = feature_code
    ) %>%
    mutate(value = as.numeric(value)) %>%
    drop_na() %>% 
    write_csv("clean_data/covid_mgmt_geo.csv")






# 2. Populations
read_excel("raw_data/pop_estimates.xlsx", 
           sheet = "Table 9", col_names = FALSE, 
           skip = 5) %>%
    # mutate(...1 = ifelse(...1 == "S92000003", "SB0801", ...1)) %>% 
    rename(area_code = ...1,
           area = ...2,
           population = ...3,
           square_km = ...4,
           people_per_square_km = ...5) %>% 
    drop_na() %>% 
    write_csv("clean_data/population.csv")





# 3. Comprehensive data, regions and populations

    left_join(read_csv(here("clean_data/covid_mgmt_geo.csv")),
          read_csv(here("clean_data/population.csv")), by = "area_code") %>% 
    relocate(c(date, area, variable)) %>% 
    select(-official_name, -area_code) %>%
    mutate(variable = ifelse(variable == "Delayed discharges", "General - Delayed discharges", variable)) %>% 
    mutate(variable = ifelse(variable == "Number of COVID-19 confirmed deaths registered to date", "General - Number of COVID-19 confirmed deaths registered to date", variable)) %>% 
    separate(variable, c("data_set", "variable"), " - ", extra = "merge") %>%
    mutate(date = as.Date(date)) %>%
    mutate(data_set = ifelse(variable %in% cumulative, "Testing - Cumulative", data_set)) %>% 
    mutate(data_set = ifelse(variable %in% daily, "Testing - Daily", data_set)) %>%
    mutate(data_set = ifelse(variable %in% cumulative_care, "Adult Care Homes - Cumulative", data_set)) %>% 
    mutate(data_set = ifelse(variable %in% daily_care, "Adult Care Homes - Daily", data_set)) %>%
    mutate(data_set = ifelse(variable %in% proportion_care, "Adult Care Homes - Proportion", data_set)) %>%
    write_csv("clean_data/comprehensive_data_with_populations.csv")


# Area codes
    read_csv("raw_data/area_code_lookup.csv") %>% 
        clean_names() %>%
        write_csv("clean_data/area_codes_lookup.csv")
# Age splits
    
    read_csv("raw_data/iz2011-pop-est_01072020.csv") %>%
        clean_names() %>% 
        select(-int_zone_qf, -sex_qf) %>%
        write_csv("clean_data/age_split_int_zones.csv")
# # 4. FT Excess Deaths
# read_excel("raw_data/ft_excess_deaths.xls") %>% 
#     write_csv("clean_data/ft_excess_deaths_clean.csv")


# council area deaths