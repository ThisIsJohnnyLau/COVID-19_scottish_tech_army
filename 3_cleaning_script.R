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
    # mutate(variable = replace(variable, variable == "Delayed discharges", "General - Delayed discharges")) %>% 
    # mutate(variable = replace(variable, variable == "Number of COVID-19 confirmed deaths registered to date", "General - Number of COVID-19 confirmed deaths registered to date")) %>%
    mutate(variable = ifelse(variable == "Delayed discharges", "General - Delayed discharges", variable)) %>% 
    mutate(variable = ifelse(variable == "Number of COVID-19 confirmed deaths registered to date", "General - Number of COVID-19 confirmed deaths registered to date", variable)) %>% 
    separate(variable, c("data_set", "variable"), " - ", extra = "merge") %>%
    write_csv("clean_data/comprehensive_data_with_populations.csv")
