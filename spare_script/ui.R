# Define the app's user interface
ui <- fixedPage(
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "app.css")
  ),
  
  navbarPage(
    
    # Page title
    # Displayed to the left of the navigation bar
    title = div(
      img(
        src = "codeclan-logo.png",
        height = "40px"
      ),
      style = "position: relative; top: -10px"
    ),
    windowTitle = "CodeClan Location Data",
    
    # Parent sections organised by tab
    # Overview parent tab
    # Contains the MVP and a broad overview of the data
    tabPanel(
      
      title = "Overview",
      
      # Title
      titlePanel("Aggregate User Data by Location"),
      
      
      # =======================================================================================================================
      # CONTROLS
      # =======================================================================================================================
      
      fluidRow(
        
        class = "controls",
        
        # Date range controls
        column(
          width = 4,
          dateRangeInput(
            inputId = "date",
            label = "Date range",
            # Default start and end dates (set to Q1 2020)
            start = "2020-01-01",
            end = "2020-03-31",
            # Minimum and maximum dates (set to the minimum and maximum values defined by the dataset)
            min = ui_date_range[1],
            max = ui_date_range[2]
          )
        ),
        
        # Catchment area slider controls
        column(
          width = 4,
          sliderInput(
            inputId = "catchment_radius",
            label = "Catchment area radius (km)",
            # Minimum and maximum values
            # Set maximum value to 135 (approximately the distance from Edinburgh to Aberdeen)
            min = 0,
            max = 135,
            # Default end value
            value = 34,
            step = 1
          )
        ),
        
        # Catchment area checkbox selector
        # Choose which of the three (four including NAs) key catchment areas to display data for
        column(
          width = 4,
          checkboxGroupInput(
            inputId = "catchment_select",
            label = "Selected catchment areas",
            choices = c(
              "Edinburgh",
              "Glasgow",
              "Inverness",
              "None"
            ),
            selected = c(
              "Edinburgh",
              "Glasgow",
              "Inverness"
            )
          )
        )
        
      ),
      
      # Main body
      fluidRow(
        
        column(width = 3,
          
          # Leaflet plot
          fluidRow(
            h4("Catchment areas"),
            leafletOutput("leaflet_plot")
          ),
          br(class = "spacer"),
          
          # Total visitors
          fluidRow(
            h4("Total visitors"),
            # Total Scottish visitors
            div(
              style = "text-align: center",
              div(
                style = "font-size: 200%; font-weight: bold",
                textOutput("text_sessions_sum")
              ),
              tags$i("throughout Scotland"),
              br(),
              # Total visitors per catchment area
              div(
                style = "font-size: 300%; font-weight: bold",
                textOutput("text_sum_catchment_sessions_bydate")
              ),
              tags$i("in selected catchments")
            )
          ),
          br(class = "spacer"),
          
          # Percentage share of visitors per catchment area
          fluidRow(
            
            h4("Percentage share"),
            
            fluidRow(
              column(
                width = 6,
                div(class = "catchment-name", "Edinburgh")
              ),
              column(
                width = 6,
                div(
                  class = "percent",
                  textOutput("text_catchment_sessions_share_ed"),
                  p(class = "percent-sign", "%")
                )
              )
            ),
            fluidRow(
              column(
                width = 6,
                div(class = "catchment-name", "Glasgow")
              ),
              column(
                width = 6,
                div(
                  class = "percent",
                  textOutput("text_catchment_sessions_share_gl"),
                  p(class = "percent-sign", "%")
                )
              )
            ),
            fluidRow(
              column(
                width = 6,
                div(class = "catchment-name", "Inverness")
              ),
              column(
                width = 6,
                div(
                  class = "percent",
                  textOutput("text_catchment_sessions_share_in"),
                  p(class = "percent-sign", "%")
                )
              )
            ),
            fluidRow(
              column(
                width = 6,
                div(class = "catchment-name", "None")
              ),
              column(
                width = 6,
                div(
                  class = "percent",
                  textOutput("text_catchment_sessions_share_na"),
                  p(class = "percent-sign", "%")
                )
              )
            )
          )
          
        ),
        
        column(
          width = 9,
          h4("Number of sessions per catchment area"),
          plotOutput("session_performance_plot"),
          plotOutput("sum_catchment_sessions")
        )
        
      ),
      
      fluidRow(
        div(class = "footer")
      )
      
    ),
    
    
    # =======================================================================================================================
    # DEBUGGING AND TESTING
    # =======================================================================================================================  
    
    # Comment out for final version
    # Please keep this section as the *final* section in the ui.R script
    
    if(debug_section_enabled == 1){
      navbarMenu( # Keep the leading comma
        
        title = "Debug",
        
        # Section header
        "Debug",
        
        tabPanel(
          title = "User-selected control values",
          # Print the values selected by the user
          # Confirms that the reactive inputs are functional
          h2("User-selected control values"),
          h4("Date range"),
          textOutput("debug_print_date"),
          br(),
          h4("Catchment radius"),
          textOutput("debug_print_catchment_radius"),
          br(),
          h4("Catchment area names"),
          textOutput("debug_print_catchment_select")
        ),
        
        tabPanel(
          title = "Reactive vectors",
          h2("Vectors"),
          h4("Catchment area coordinates"),
          tableOutput("debug_print_catchment_coordinates"),
          br(),
          h4("Total number of sessions"),
          textOutput("debug_print_total_sessions_sum"),
        ),
        
        # Section header
        "----",
        "Tables",
        
        tabPanel(
          title = "Full reactive dataset",
          h4("Full reactive dataset"),
          tableOutput("debug_print_data")
        ),
        
        tabPanel(
          title = "Total sessions per day",
          h4("Total sessions per day"),
          tableOutput("debug_print_total_sessions")
        ),
        
        tabPanel(
          title = "Total sessions per day per catchment",
          # h4("Sum"),
          # textOutput("text_sum_catchment_sessions_bydate"),
          # h4("Table"),
          tableOutput("debug_catchment_session_sum")
        )
        
      )
    }
    
  )

)
