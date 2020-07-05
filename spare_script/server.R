server <- function(input, output){
  
  # =================================================================================================================== #
  # Reactive Data Tibble ####
  # =================================================================================================================== #
  
  # Please keep this section as the *first* section in the server.R script
  
  # Determine final catchment assignments depending on user-selected variables
  location_data_reactive_include <- reactive({
    location_data %>% 
      filter(
        # Exclude visitors who visited outside of the dates selected by the user
        date >= min(input$date),
        date <= max(input$date)
      ) %>% 
      mutate(
        final_catchment = if_else(
          condition = (distance_min <= input$catchment_radius),
          true = nearest_catchment,
          false = "None",
          missing = "None"
        )
      )
  })
  
  location_data_reactive <- reactive({
    location_data_reactive_include() %>% 
      filter(
        # Exclude visitors whose *final* catchment is not selected by the user
        final_catchment %in% input$catchment_select
      )
  })
  
  
  # =================================================================================================================== #
  # Other Reactive Data ####
  # =================================================================================================================== #
  
  catchment_coordinates_reactive <- reactive({
    catchment_coordinates %>% 
      filter(
        catchment %in% str_to_lower(input$catchment_select)
      )
  })
  
  total_sessions_reactive <- reactive({
    location_data %>% 
      filter(
        date >= min(input$date),
        date <= max(input$date)
      ) %>% 
      group_by(
        date
      ) %>% 
      summarise(
        sum_sessions = sum(sessions)
      )
  })
  
  total_sessions_reactive_sum <- reactive({
    sum(total_sessions_reactive()$sum_sessions) %>% 
      as.integer()
  })
  
  catchment_sessions_bydate <- reactive({
    location_data_reactive() %>% 
      group_by(
        date,
        final_catchment
      ) %>% 
      summarise(
        sum_sessions = sum(sessions)
      )
  })
  
  sum_catchment_sessions_bydate <- reactive({
    catchment_sessions_bydate()$sum_sessions %>% 
      sum() %>% 
      as.integer()
  })
  
  catchment_sessions_share <- reactive({
    location_data_reactive_include() %>% 
      select(
        final_catchment,
        sessions
      ) %>% 
      group_by(
        final_catchment
      ) %>% 
      summarise(
        sum_sessions = sum(sessions)
      ) %>% 
      mutate(
        session_share_pct = as.integer(
          round(sum_sessions/total_sessions_reactive_sum() * 100, 0)
        )
      )
  })
  
  
  # =================================================================================================================== #
  # Text and Number Output ####
  # =================================================================================================================== #
  
  # Total Scottish visitors
  output$text_sessions_sum <- renderText({
    total_sessions_reactive_sum() %>% 
      format(
        big.mark = ",",
        big.interval = 3L
      )
  })
  
  output$text_sum_catchment_sessions_bydate <- renderText({
    sum_catchment_sessions_bydate() %>% 
      format(
        big.mark = ",",
        big.interval = 3L
      )
  })
  
  output$text_catchment_sessions_share_ed <- renderText({
    catchment_sessions_share() %>% 
      filter(
        final_catchment == "Edinburgh"
      ) %>% 
      select(
        session_share_pct
      ) %>% 
      unlist() %>% 
      as.integer()
  })
  
  output$text_catchment_sessions_share_gl <- renderText({
    catchment_sessions_share() %>% 
      filter(
        final_catchment == "Glasgow"
      ) %>% 
      select(
        session_share_pct
      ) %>% 
      unlist() %>% 
      as.integer()
  })
  
  output$text_catchment_sessions_share_in <- renderText({
    catchment_sessions_share() %>% 
      filter(
        final_catchment == "Inverness"
      ) %>% 
      select(
        session_share_pct
      ) %>% 
      unlist() %>% 
      as.integer()
  })
  
  output$text_catchment_sessions_share_na <- renderText({
    catchment_sessions_share() %>% 
      filter(
        final_catchment == "None"
      ) %>% 
      select(
        session_share_pct
      ) %>% 
      unlist() %>% 
      as.integer()
  })
  
  # =================================================================================================================== #
  # Plots ####
  # =================================================================================================================== #
  
  output$leaflet_plot <- renderLeaflet({
    location_data_reactive() %>% 
      group_by(nearest_catchment) %>% 
      leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addCircles(lat = ~catchment_coordinates_reactive()$latitude,
                 lng = ~catchment_coordinates_reactive()$longitude,
                 radius = input$catchment_radius*1000,
                 stroke = F,
                 color = "magenta") %>% 
      # Set initial center to the Ordnance Survey centre of Mainland Scotland
      setView(
        lat = 56.393386,
        lng = -4.04037,
        zoom = 6
      )
  })
  
  # Total number of sessions line chart
  output$session_performance_plot <- renderPlot({
    location_data_reactive() %>% 
      group_by(
        date,
        final_catchment
      ) %>% 
      summarise(
        total_sessions = sum(sessions)
      ) %>%
      ggplot() +
      aes(
        x = date,
        y = total_sessions,
        color = final_catchment
      ) +
      geom_line() + 
      geom_smooth(
        method = "loess",
        formula = "y ~ x"
      ) + 
      labs(
        y = "Number of sessions"
      ) +
      theme(
        axis.title.x = element_blank(),
        legend.position = ""
      )
  })
  
  output$sum_catchment_sessions <- renderPlot({
    location_data_reactive() %>% 
      select(
        final_catchment,
        sessions
      ) %>% 
      group_by(
        final_catchment
      ) %>% 
      summarise(
        sum_sessions = sum(sessions)
      ) %>% 
      ggplot() + 
      aes(
        x = final_catchment,
        y = sum_sessions,
        fill = final_catchment
      ) + 
      geom_col() + 
      labs(
        y = "Total number of sessions"
      ) + 
      theme(
        axis.title.x = element_blank(),
        legend.position = "top",
        legend.title = element_blank()
      )
  })
  
  
  # =================================================================================================================== #
  # Debugging and Testing ####
  # =================================================================================================================== #
  
  # Outputs and server logic for the debug tab
  # Allows for testing, to make sure the server is doing intermediary logic correctly
  # Please keep this section as the *final* section in the server.R script
  
  # List selected date range
  output$debug_print_date <- renderText({
    input$date
  })
  
  # Debug / test functionality
  # Print selected catchment area radius
  output$debug_print_catchment_radius <- renderText({
    input$catchment_radius
  })
  
  # List selected catchment areas
  output$debug_print_catchment_select <- renderText({
    input$catchment_select
  })
  
  # Print reactive location data tibble
  output$debug_print_data <- renderTable({
    location_data_reactive()
  })
  
  # Print catchment coordinates tibble
  output$debug_print_catchment_coordinates <- renderTable({
    catchment_coordinates_reactive()
  })
  
  output$debug_print_total_sessions <- renderTable({
    total_sessions_reactive()
  })
  
  output$debug_print_total_sessions_sum <- renderText({
    total_sessions_reactive_sum()
  })
  
  output$debug_catchment_session_sum <- renderTable({
    catchment_sessions_bydate()
  })
  
}
