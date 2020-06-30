# Testing data
read_csv("raw_data/Covid managment data/COVID19 - Daily Management Information - Scotland - Testing.csv") %>% 
    clean_names() %>%
    rename(cum_negative = testing_cumulative_people_tested_for_covid_19_negative,
           cum_positive = testing_cumulative_people_tested_for_covid_19_positive,
           cum_total = testing_cumulative_people_tested_for_covid_19_total,
           daily_positive = testing_daily_people_found_positive,
           daily_tests_NHS = testing_total_number_of_covid_19_tests_carried_out_by_nhs_labs_daily,
           cum_tests_NHS = testing_total_number_of_covid_19_tests_carried_out_by_nhs_labs_cumulative,
           daily_tests_regional = testing_total_number_of_covid_19_tests_carried_out_by_regional_testing_centres_daily,
           cum_tests_regional = testing_total_number_of_covid_19_tests_carried_out_by_regional_testing_centres_cumulative
           ) %>%
    write_csv("clean_data/testing.csv")



# Deaths
read_csv("raw_data/Covid managment data/COVID19 - Daily Management Information - Scotland - Deaths.csv") %>%
    clean_names() %>%
    rename(confirmed_COVID_deaths = number_of_covid_19_confirmed_deaths_registered_to_date) %>%
    write_csv("clean_data/deaths.csv")


read_csv("raw_data/Covid managment data/COVID19 - Daily Management Information - Scotland - Ambulance.csv")

read_csv("raw_data/Covid managment data/COVID19 - Daily Management Information - Scotland - Calls.csv")

read_csv("raw_data/Covid managment data/COVID19 - Daily Management Information - Scotland - Care home workforce.csv")

read_csv("raw_data/Covid managment data/COVID19 - Daily Management Information - Scotland - Care homes.csv")


# delayed discharges
read_csv("raw_data/Covid managment data/COVID19 - Daily Management Information - Scotland - Delayed discharges.csv") %>% 
    clean_names() %>% 
    write_csv("clean_data/delayed_discharges.csv")

# Hospital care
read_csv("raw_data/Covid managment data/COVID19 - Daily Management Information - Scotland - Hospital care.csv") %>%
    clean_names() %>% 
    rename(ICU_COVID_suspected = covid_19_patients_in_icu_suspected,
           ICU_COVID_confirmed = covid_19_patients_in_icu_confirmed,
           ICU_COVID_total = covid_19_patients_in_icu_total,
           hospital_COVID_suspected = covid_19_patients_in_hospital_suspected,
           hospital_COVID_confirmed = covid_19_patients_in_hospital_confirmed,
           hospital_COVID_total = covid_19_patients_in_hospital_total
           ) %>%
    relocate(c(ICU_COVID_suspected,ICU_COVID_confirmed, ICU_COVID_total), .after = hospital_COVID_total) %>% 
    write_csv("clean_data/COVID_patients.csv")

# NHS Absences
read_csv("raw_data/Covid managment data/COVID19 - Daily Management Information - Scotland - Workforce.csv") %>% 
    clean_names() %>% 
    rename(nursing_and_midwifery = nhs_workforce_covid_19_absences_nursing_and_midwifery_staff,
           medical_and_dental = nhs_workforce_covid_19_absences_medical_and_dental_staff,
           other_staff = nhs_workforce_covid_19_absences_other_staff,
           all_staff = nhs_workforce_covid_19_absences_all_staff) %>%
    write_csv("clean_data/nhs_covid_absences.csv")


# Cumulative cases
read_csv("raw_data/Covid managment data/COVID19 - Daily Management Information - Scottish Health Boards - Cumulative cases.csv") %>% 
    clean_names() %>% 
    pivot_longer(-date) %>%
    filter(value != "*") %>%
    mutate(value = as.numeric(value)) %>% 
    write_csv("clean_data/cases_by_area.csv")

