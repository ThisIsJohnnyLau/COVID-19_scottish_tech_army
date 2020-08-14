



# housing data
read_csv("raw_data/dwellings-type.csv", 
         skip = 7) %>%
    separate("http://purl.org/linked-data/sdmx/2009/dimension#refArea",
             into = c("a", "b", "c", "d", "e", "f", "g", "data_zone"),
             fill = "right") %>% 
    select(-c("a", "b", "c", "d", "e", "f", "g")) %>% 
    clean_names() %>% 
    write_csv("clean_data/dwellings.csv")



read_csv("raw_data/household-estimates.csv",
         skip = 7) %>%
    separate("http://purl.org/linked-data/sdmx/2009/dimension#refArea",
             into = c("a", "b", "c", "d", "e", "f", "g", "data_zone"),
             fill = "right") %>% 
    select(-c("a", "b", "c", "d", "e", "f", "g")) %>% 
    clean_names() %>%
    write_csv("clean_data/household_estimates.csv")

# NB duplicated entries need addressing.  Potentially something to do with datazone changes
housing_data <-
    full_join(
        read_csv("clean_data/household_estimates.csv"),
        read_csv("clean_data/dwellings.csv"),
        by = c("data_zone", "reference_area")
        ) %>% 
  drop_na(.)

# Business stocks and sites 2017
read_csv("raw_data/business-stocks-and-sites.csv",
         skip = 9) %>% 
  separate("http://purl.org/linked-data/sdmx/2009/dimension#refArea",
           into = c("a", "b", "c", "d", "e", "f", "g", "data_zone"),
           fill = "right") %>% 
  select(-c("a", "b", "c", "d", "e", "f", "g")) %>% 
  clean_names() %>%
  rename(intermediate_zone = reference_area) %>% 
  drop_na() %>% 
  write_csv("clean_data/food_drink.csv")


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
    rename(local_population = total_population,
           income_dep_pct = income_rate,
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
#  joining housing data
SIMD_imp <- read_csv(here("clean_data/SIMD.csv")) %>% 
    group_by(intermediate_zone) %>%
    mutate(
        crime_count = ifelse(is.na(crime_count), median(crime_count, na.rm=TRUE), crime_count),
        attainment_score = ifelse(is.na(attainment_score), median(attainment_score, na.rm=TRUE), attainment_score),
        attendance_pct = ifelse(is.na(attendance_pct), median(attendance_pct, na.rm=TRUE), attendance_pct),
        crime_pct = crime_count / local_population * 100,
        overcrowded_pct = overcrowd / local_population * 100,
        nocentralheat_pct = nocentralheat / local_population * 100,
        income_dep_pct = income_dep / working_age_population * 100,
        employ_dep_pct = employ_dep / working_age_population * 100,
        income_dep_pct_tot = income_dep / local_population * 100,
        employ_dep_pct_tot = employ_dep / local_population * 100,
        non_attendance_pct = 100 - attendance_pct,
        working_age_pct = working_age_population / local_population * 100)





# joining housing data
SIMD_and_housing <- left_join(SIMD_imp, housing_data, by = "data_zone")
                                #c("data_zone", "intermediate_zone" = "reference_area"))

# Reading in shape file for area sizes
    zone_data <- read_sf(here("raw_data/SG_IntermediateZoneBdry_2011/SG_IntermediateZone_Bdry_2011.shp")) %>%
    clean_names()
    
        # Removing large geometry info
   zone_data$geometry <-
    NULL

   # Selecting and renaming area info for joining to local data
   zone_area <- zone_data %>%
     select(inter_zone, std_area_km2) %>% 
     rename(data_zone = inter_zone)
   
   area_codes <- read_csv("clean_data/area_codes_lookup.csv") %>% 
     rename(data_zone = int_zone,
            intermediate_zone = int_zone_name,
            council_area = ca_name,
            council_area_code = ca
     ) %>%
     select(data_zone:council_area)
   
   zone_area_codes <- left_join(area_codes, zone_area, by = "data_zone")
   
   #data file
   management <- read_csv("clean_data/management_clean.csv")
   
   local_authorities <- unique(scotland_covid$local_authority) %>% 
     sort()


   # COVID deaths data for joining to intermediate zone aggregate data
   
   intermediate_zone_deaths <- read_csv("clean_data/scotland_covid.csv") %>% 
     clean_names() %>% # intermediate_zone_code, local_authority, name,
     filter(!duplicated(intermediate_zone_code)) %>% 
     relocate(local_authority:intermediate_zone_code) %>% 
     rename(intermediate_zone = name,
            council_area = local_authority,
            data_zone = intermediate_zone_code) %>% 
     select(intermediate_zone, council_area, long, lat, number_of_deaths) %>% 
     left_join(., area_codes, by = c("intermediate_zone", "council_area"))
   
   
   

########## Full regression data ###################

SIMD_and_deaths <-
    #  Starting with basic imputed data for local-local areas and housing
    SIMD_and_housing %>%
    # Creating overall zone values and 'contribution factor'
    group_by(intermediate_zone) %>% 
    mutate(intermediate_zone_pop = sum(local_population),
           intermediate_zone_working_pop = sum(working_age_population),
           weight_in_zone_pop = local_population / intermediate_zone_pop) %>% 
    relocate(c(reference_area, weight_in_zone_pop,intermediate_zone_pop, intermediate_zone_working_pop), .before = local_population) %>%
    # removing local local population data
    select(-local_population, -working_age_population) %>%
    # rename(intermediate_zone = name) %>%
    # Setup before dropping sub-residential area data
    pivot_longer(-data_zone:-weight_in_zone_pop) %>%
    # Creating weighted intermediary values
    mutate(value_contribution = value * weight_in_zone_pop) %>% 
    select(-value, -data_zone, -reference_area) %>%
    ungroup() %>%
    # Summing intermediary values
    group_by(intermediate_zone, name) %>% 
    mutate(zone_value = sum(value_contribution)) %>%
    # Dropping reference to individual residential, weights and contributions
    select(-weight_in_zone_pop, -value_contribution) %>%
    # Removing counts in favour of pct
    filter(str_detect(name, "count", negate = TRUE)) %>% 
    # Focussing on intermediary values
    distinct() %>%
    ungroup() %>%
    # Setup wider data for regression
    pivot_wider(intermediate_zone:council_area,
                names_from = name,
                values_from = zone_value) %>%
  left_join(intermediate_zone_deaths, by = c("intermediate_zone", "council_area")) %>% 
  relocate(number_of_deaths, .after = council_area)

  

# N.B. Na h-Eilean are NAs
SIMD_and_deaths_and_area <-
    left_join(SIMD_and_deaths, zone_area, by = "data_zone") %>%
    mutate(overall_density = (intermediate_zone_pop / std_area_km2),
           working_pop_density = intermediate_zone_working_pop / std_area_km2,
           non_working_pop_density = (intermediate_zone_pop - intermediate_zone_working_pop) / std_area_km2,
           covid_death_pct = number_of_deaths / intermediate_zone_pop * 100,
           working_pop_pct = intermediate_zone_working_pop / intermediate_zone_pop * 100,
           attainment_score = attainment_score * 100) %>%
    relocate(c(council_area_code, data_zone, covid_death_pct, number_of_deaths), .after = council_area) %>%
  drop_na()


  FB <- read_csv("clean_data/food_drink.csv") %>% 
    rename(FB_count = "count")
    
# Shouldn't really be x 100
SIMD_and_deaths_and_area_and_FB <-
  left_join(SIMD_and_deaths_and_area, FB, by = c("data_zone", "intermediate_zone")
            ) %>%
  mutate(FB_density_area = FB_count / std_area_km2 * 100,
         FB_density_pop = FB_count / intermediate_zone_pop * 100,
         FB_density_working = FB_count / intermediate_zone_working_pop * 100) %>%
  select(-long:-lat) %>% 
  pivot_longer(-intermediate_zone:-data_zone)


age_split_2018 <-
  read_csv("clean_data/age_split_int_zones.csv") %>%
  filter(year == max(year),
         sex == "All") %>%
  select(-year, -sex) %>% 
  mutate(baby_pct = select(., age0:age4) %>% rowSums() / all_ages * 100,
         children_pct = select(., age5:age12) %>% rowSums() / all_ages * 100,
         teenager_pct = select(., age13:age19) %>% rowSums() / all_ages * 100,
         adult_pct = select(., age20:age65) %>% rowSums() / all_ages * 100,
         new_retiree_age_pct = select(., age66:age75) %>% rowSums() / all_ages * 100,
         elderly_age_pct = select(., age76:age90plus) %>% rowSums() / all_ages * 100) %>% 
  select(-all_ages, -age0:-age90plus) %>%
  rename(data_zone = "int_zone")


# Adding age data

SIMD_and_deaths_and_area_and_FB_and_ages <-
  left_join(SIMD_and_deaths_and_area_and_FB %>% 
              pivot_wider(), age_split_2018, by = "data_zone") %>% 
  pivot_longer(-intermediate_zone:-data_zone)

# Setting up modelling data
modelling_data <-
    left_join(SIMD_and_deaths, zone_area) %>%
    mutate(density = (intermediate_zone_pop / std_area_km2)) %>% 
    select(-intermediate_zone)
# dropping non-regression info group A
# select(-intermediate_zone_working_pop, -number_of_deaths, -long, -lat, -no_qual_ratio_std, -attendance_pct, -income_dep, -employ_dep, -overcrowd, -nocentralheat)
