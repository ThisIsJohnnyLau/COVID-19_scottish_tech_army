
# Reading from raw Excel SIMD file - data tab
read_excel("raw_data/SIMD/SIMD+2020v2+-+indicators.xlsx", 
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
                                                                   "numeric", "numeric")) %>% 
    clean_names() %>%
    # renaming variables for my clarity
    rename(income_dep_pct = income_rate,
           income_dep = income_count,
           employ_dep = employment_count,
           employ_dep_pct = employment_rate,
           depress_pct = depress,
           lbwt_pct = lbwt,
           attendance_pct = attendance,
           attainment_score = attainment,
           no_qual_ratio_std = no_qualifications,
           not_participating_pct = not_participating,
           university_pct = university,
           petrol_ave_drive_mins = drive_petrol,
           gp_ave_drive_mins = drive_gp,
           prim_sch_ave_drive_mins = drive_primary,
           sec_sch_ave_drive_mins = drive_secondary,
           gp_ave_pub_trans_mins = pt_gp,
           shopping_ave_pub_trans_mins = pt_retail,
           bband_pct = broadband,
           crime_pct = crime_rate,
           overcrowd = overcrowded_count,
           nocentralheat = nocentralheat_count,
           overcrowded_pct = overcrowded_rate,
           nocentralheat_pct = nocentralheat_rate,
           ) %>%
    # turning decimals into percentages
    mutate(depress_pct = depress_pct * 100,
           lbwt_pct = lbwt_pct * 100,
           attendance_pct = attendance_pct * 100,
           not_participating_pct = not_participating_pct * 100,
           university_pct = university_pct * 100,
           bband_pct = bband_pct * 100,
           crime_pct = crime_pct * 100,
           overcrowded_pct = overcrowded_pct * 100,
           nocentralheat_pct = nocentralheat_pct * 100
           ) %>%
    # writing to CSV with only basic manipulation
    # data refers only to sub-intermedate zones at this point
    write_csv("clean_data/SIMD.csv")



# basic imputation and added rates / pcts for  

# included income and employ dep versus total_pop aswell
# Starting off with basic data to transform local area data only.
# Total population = the sub-intermediate zone
SIMD_imp <- read_csv(here("clean_data/SIMD.csv")) %>% 
    group_by(intermediate_zone) %>%
    mutate(
        crime_count = ifelse(is.na(crime_count), median(crime_count, na.rm=TRUE), crime_count),
        attainment_score = ifelse(is.na(attainment_score), median(attainment_score, na.rm=TRUE), attainment_score),
        attendance_pct = ifelse(is.na(attendance_pct), median(attendance_pct, na.rm=TRUE), attendance_pct),
        crime_pct = crime_count / total_population * 100,
        overcrowded_pct = overcrowd / total_population * 100,
        nocentralheat_pct = nocentralheat / total_population * 100,
        income_dep_pct = income_dep / working_age_population * 100,
        employ_dep_pct = employ_dep / working_age_population * 100,
        income_dep_pct_tot = income_dep / total_population * 100,
        employ_dep_pct_tot = employ_dep / total_population * 100,
        non_attendance_pct = 100 - attendance_pct,
        working_age_pct = working_age_population / total_population * 100)


# COVID deaths data
scotland_covid <- read_csv("clean_data/scotland_covid.csv")

intermediate_zone_deaths <- scotland_covid %>%
    clean_names() %>%
    select(name, long, lat, number_of_deaths) %>% 
    rename(intermediate_zone = name) %>% 
    unique()


SIMD_and_deaths <-
    #  Starting with basic imputed data for local-local areas
    SIMD_imp %>%
    # Creating overall zone values and 'contribution factor'
    group_by(intermediate_zone) %>% 
    mutate(intermediate_zone_pop = sum(total_population),
           intermediate_zone_working_pop = sum(working_age_population),
           weight_in_zone_pop = total_population / intermediate_zone_pop) %>% 
    relocate(c(weight_in_zone_pop,intermediate_zone_pop, intermediate_zone_working_pop), .before = total_population) %>%
    # removing local local population data
    select(-total_population, -working_age_population) %>% 
    # rename(intermediate_zone = name) %>%
    # Setup before dropping sub-residential area data
    pivot_longer(-data_zone:-weight_in_zone_pop) %>%
    # Creating weighted intermediary values
    mutate(value_contribution = value * weight_in_zone_pop) %>% 
    select(-value) %>%
    ungroup() %>%
    # Summing intermediary values
    group_by(intermediate_zone, name) %>% 
    mutate(zone_value = sum(value_contribution)
    ) %>%
    # Dropping reference to individual residential, weights and contributions
    select(-data_zone, -weight_in_zone_pop, -value_contribution, -council_area) %>%
    # Focussing on intermediary values
    distinct() %>%
    ungroup() %>%
    # Removing counts in favour of pct
    filter(str_detect(name, "count", negate = TRUE)) %>%
    # Setup wider data for regression
    pivot_wider(intermediate_zone,
                names_from = name,
                values_from = zone_value) %>%
    # adding intermediate COVID death data
    left_join(intermediate_zone_deaths) %>%
    # focussing on death pct and working pop pct
    mutate(covid_death_pct = number_of_deaths / intermediate_zone_pop * 100,
           working_pop_pct = intermediate_zone_working_pop / intermediate_zone_pop * 100,
           attainment_score = attainment_score * 100) %>%
    # reluctantly dropping NAs; consider how to impute later
    drop_na() %>%
    relocate(c(covid_death_pct, number_of_deaths))
    
    
# Reading in shape file for area sizes
    zone_data <- read_sf(here("raw_data/SG_IntermediateZoneBdry_2011/SG_IntermediateZone_Bdry_2011.shp")) %>%
    clean_names()

# Removing large geometry info
zone_data$geometry <-
    NULL

# Selecting and renaming area info
zone_area <- zone_data %>% 
    select(name, std_area_km2) %>% 
    rename(intermediate_zone = name)

# Setting up modelling data
modelling_data <-
    left_join(SIMD_and_deaths, zone_area) %>%
    mutate(density = (intermediate_zone_pop / std_area_km2)) %>% 
    select(-intermediate_zone)
    # dropping non-regression info group A
    # select(-intermediate_zone_working_pop, -number_of_deaths, -long, -lat, -no_qual_ratio_std, -attendance_pct, -income_dep, -employ_dep, -overcrowd, -nocentralheat)


#data file
management <- read_csv("clean_data/management_clean.csv")



local_authorities <- unique(scotland_covid$local_authority) %>% 
    sort()