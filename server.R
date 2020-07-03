

server <- function(input, output, session){
    
    observe({
        if (input$area_choice == "Scotland") {
            updateSelectInput(
                session,
                # Check
                "data_set_choice",
                choices = data_sets,
                selected = "General"
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
            updateCheckboxGroupInput(session, "variable_choice", choices = general_variables$variable, selected = "Number of COVID-19 confirmed deaths registered to date")
        }
    })
    
    observe({
        if (input$data_set_choice == "Testing - Daily") {
            updateCheckboxGroupInput(session, "variable_choice",
                                     choices = testing_variables_daily$variable,
                                     selected = "Daily people found positive")
        }
    })
    
    observe({
        if (input$data_set_choice == "Testing - Cumulative") {
            updateCheckboxGroupInput(session,
                                     "variable_choice",
                                     choices = testing_variables_cumulative$variable,
                                     selected = "Cumulative people tested for COVID-19 - Positive")
        }
    })
    
    observe({
        if (input$data_set_choice == "COVID-19 patients in ICU") {
            updateCheckboxGroupInput(session,
                                     "variable_choice",
                                     choices = ICU_variables$variable,
                                     selected = "Confirmed")
        }
    })
    
    observe({
        if (input$data_set_choice == "COVID-19 patients in hospital") {
            updateCheckboxGroupInput(session,
                                     "variable_choice",
                                     choices = general_patient_variables$variable,
                                     selected = "Confirmed")
        }
    })
    
    observe({
        if (input$data_set_choice == "Calls") {
            updateCheckboxGroupInput(session,
                                     "variable_choice",
                                     choices = calls_variables$variable,
                                     selected = "Coronavirus helpline")
        }
    })

    observe({
        if (input$data_set_choice == "Ambulance attendances") {
            updateCheckboxGroupInput(session,
                                     "variable_choice",
                                     choices = ambulance_variables$variable,
                                     selected = "Total")
        }
    })
    observe({
        if (input$data_set_choice == "Adult Care Homes - Daily") {
            updateCheckboxGroupInput(session, "variable_choice",
                                     choices = care_home_variables_daily$variable,
                                     selected = "Daily number of new suspected COVID-19 cases")
        }
    })
    
    observe({
        if (input$data_set_choice == "Adult Care Homes - Proportion") {
            updateCheckboxGroupInput(session,
                                     "variable_choice",
                                     choices = care_home_variables_proportion$variable,
                                     selected = "Response rate")
        }
    })
    
    observe({
        if (input$data_set_choice == "Adult Care Homes - Cumulative") {
            updateCheckboxGroupInput(session,
                                     "variable_choice",
                                     choices = care_home_variables_cumulative$variable,
                                     selected = "Cumulative number of suspected COVID-19 cases")
        }
    })
    
    observe({
        if (input$data_set_choice == "NHS workforce COVID-19 absences") {
            updateCheckboxGroupInput(session, "variable_choice", choices = NHS_workforce_variables$variable,
                                     selected = "All staff")
        }
    })
    observe({
        if (input$data_set_choice == "Calls") {
            updateCheckboxGroupInput(session, "variable_choice", choices = calls_variables$variable,
                                     selected = "Coronavirus helpline")
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
                # labs(title = filtered_data()$area,
                #      subtitle = filtered_data()$data_set,
                #      y = filtered_data()$measurement) +
                theme(legend.position = "bottom",
                      legend.title = element_blank(),
                      plot.title = element_text(size = 20),
                      plot.subtitle = element_text(size = 25, face = "bold"),
                      axis.text = element_text(size = 15)
                      )
            
            # }
            })
        
        
        ## ----------------------------------------------------------------
        ##                         Leaflet Dataset                      --
        ## ----------------------------------------------------------------
        
        # Create reactive dataset
        management_reactive <- reactive({
            if (input$data == "Testing - Cumulative people tested for COVID-19 - Positive") {
                management %>%
                    filter(variable == input$data) %>%
                    filter(date_code <= input$date) %>%
                    group_by(official_name) %>%
                    mutate(total = max(value)) %>%
                    ungroup()
            } else {
                management %>%
                    filter(variable == input$data) %>%
                    filter(date_code == input$date) %>%
                    mutate(total = value)
            }
        })
        
        ## ----------------------------------------------------------------
        ##                         Leaflet Plot                         --
        ## ----------------------------------------------------------------
        
        output$scot_plot <- renderLeaflet({
            
            # Join counts onto bondary geographical shape data
            scotland_count <- scotland %>%
                left_join(management_reactive(), by = c("HBName" = "official_name"))
            
            # creates bins and palette for leaflet plot
            #bins <- seq(0, max(management_reactive()$total), length.out = 6)
            
            pal <- colorBin("plasma", domain = scotland_count$total, bins = 5)
            
            # creates hover over labels
            labels <- sprintf(
                "<strong>%s</strong><br/>%g",
                scotland_count$HBName,
                scotland_count$total
            ) %>% lapply(htmltools::HTML)
            
            
            scotland_count %>%
                leaflet() %>%
                addPolygons(
                    fillColor = ~ pal(total),
                    weight = 2,
                    opacity = 1,
                    color = "white",
                    dashArray = "3",
                    fillOpacity = 0.5,
                    highlight = highlightOptions(
                        weight = 5,
                        color = "#666",
                        dashArray = "",
                        fillOpacity = 0.7,
                        bringToFront = TRUE
                    ),
                    label = labels,
                    labelOptions = labelOptions(
                        style = list(
                            "font-weight" = "normal",
                            padding = "3px 8px"
                        ),
                        textsize = "15px",
                        direction = "auto"
                    ) # labelOptions
                ) %>%
                addLegend(
                    pal = pal,
                    values = ~total,
                    opacity = 0.7,
                    title = "Count",
                    position = "topleft"
                ) # add legend
        })
        } # Server

