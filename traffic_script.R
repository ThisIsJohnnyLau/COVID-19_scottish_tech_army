

#  latest traffic data to june 8th with clean names and location
traffic_data <- read_excel("raw_data/traffic/automatic-traffic-counter-data-as-of-8-june-2020.xlsx",
           skip = 8) %>%
    mutate_at(vars(contains("4")), as.numeric) %>% # need a slicker select arg
    pivot_longer(-(`Site ID`:Longitude), names_to = "date", values_to = "cars") %>% 
    clean_names() %>%
    mutate(date = convertToDate(date))



read_excel("raw_data/traffic/automatic-traffic-counter-data-as-of-8-june-2020.xlsx",