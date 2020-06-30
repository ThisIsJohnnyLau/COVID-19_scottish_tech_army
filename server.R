

server <- function(input, output, session){
    
    observe({
        if (input$area_choice == "Scotland") {
            updateSelectInput(
                session,
                # Check
                "data_set_choice",
                choices = data_sets
                )
        }
    })
    
    observe({
        if (input$area_choice != "Scotland") {
            updateSelectInput(
                session,
                "data_set_choice",
                choices = c(NULL, "Testing - Cumulative", "Testing - Daily", "COVID-19 patients in hospital", "COVID-19 patients in ICU")
            )
        }
    })
    
     
   observe({
        if (input$data_set_choice == "General") {
            updateCheckboxGroupInput(session, "variable_choice", choices = general_variables$variable)
        }
    })
    
    observe({
        if (input$data_set_choice == "Testing - Daily") {
            updateCheckboxGroupInput(session, "variable_choice", choices = testing_variables_daily$variable)
        }
    })
    
    observe({
        if (input$data_set_choice == "Testing - Cumulative") {
            updateCheckboxGroupInput(session, "variable_choice", choices = testing_variables_cumulative$variable)
        }
    })
    
    observe({
        if (input$data_set_choice == "COVID-19 patients in ICU") {
            updateCheckboxGroupInput(session, "variable_choice", choices = ICU_variables$variable)
        }
    })
    
    observe({
        if (input$data_set_choice == "COVID-19 patients in hospital") {
            updateCheckboxGroupInput(session, "variable_choice", choices = general_patient_variables$variable)
        }
    })
    
    observe({
        if (input$data_set_choice == "Calls") {
            updateCheckboxGroupInput(session, "variable_choice", choices = calls_variables$variable)
        }
    })

    observe({
        if (input$data_set_choice == "Ambulance attendances") {
            updateCheckboxGroupInput(session, "variable_choice", choices = ambulance_variables$variable)
        }
    })
    observe({
        if (input$data_set_choice == "Adult Care Homes - Daily") {
            updateCheckboxGroupInput(session, "variable_choice", choices = care_home_variables_daily$variable)
        }
    })
    
    observe({
        if (input$data_set_choice == "Adult Care Homes - Proportion") {
            updateCheckboxGroupInput(session, "variable_choice", choices = care_home_variables_proportion$variable)
        }
    })
    
    observe({
        if (input$data_set_choice == "Adult Care Homes - Cumulative") {
            updateCheckboxGroupInput(session, "variable_choice", choices = care_home_variables_cumulative$variable)
        }
    })
    
    observe({
        if (input$data_set_choice == "NHS workforce COVID-19 absences") {
            updateCheckboxGroupInput(session, "variable_choice", choices = calls_variables$variable)
        }
    })
    observe({
        if (input$data_set_choice == "Calls") {
            updateCheckboxGroupInput(session, "variable_choice", choices = NHS_workforce_variables$variable)
        }
    })
   
    
    
    filtered_data <- reactive({
        full_data %>%
            filter(area %in% input$area_choice) %>% 
            filter(data_set %in% input$data_set_choice) %>%
            group_by(variable) %>% 
            filter(variable %in% input$variable_choice)
    })
    
        output$covid_plot <- renderPlot({
            filtered_data() %>% 
            ggplot(aes(x = date, y = value, group = variable)) +
            geom_line(aes(colour = variable)) +
                theme(legend.position = "bottom",
                      legend.title = element_blank())
            # }
            })
    }

