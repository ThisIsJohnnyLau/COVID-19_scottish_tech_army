

SIMD_2020v2_indicators <- read_excel("raw_data/SIMD/SIMD+2020v2+-+indicators.xlsx", 
                                     sheet = "Data", col_types = c("text", 
                                                                   "text", "text", "numeric", "numeric", 
                                                                   "numeric", "numeric", "numeric", 
                                                                   "numeric", "numeric", "numeric", 
                                                                   "numeric", "numeric", "numeric", 
                                                                   "numeric", "numeric", "numeric", 
                                                                   "numeric", "numeric", "numeric", 
                                                                   "numeric", "numeric", "numeric", 
                                                                   "numeric", "numeric", "numeric", 
                                                                   "numeric", "numeric", "numeric", 
                                                                   "numeric", "numeric", "numeric", 
                                                                   "numeric", "numeric", "numeric", 
                                                                   "numeric", "numeric"))


#data file
management <- read_csv("clean_data/management_clean.csv")

scotland_covid <- read_csv("clean_data/scotland_covid.csv")

local_authorities <- unique(scotland_covid$local_authority) %>% 
    sort()