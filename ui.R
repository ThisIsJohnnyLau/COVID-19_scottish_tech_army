

ui <- fluidPage(
  
  theme = shinytheme("superhero"),
  
  navbarPage(
    # Page title
    # Displayed to the left of the navigation bar
    title = div(img(
      src = "tt_sq.png",
      height = "40px"
    ),
    HTML(paste0(
      "<a href=", shQuote(paste0("https://www.scottishtecharmy.org/")), target="_blank", ">",
      img(
        src = "sta.png",
        height = "40px"
      ), "</a>"
    )),
    style = "position: relative; top: -10px"
    ),
    
    windowTitle = "Scotland COVID-19 Visualisation",
  
    
    # Contains the MVP and a broad overview of the data
    tabPanel(
      title = "Overview",
    
    
    
    column(12, # Start of top title row
           
    column(6,
           titlePanel("COVID-19 in Scotland"),
           helpText("What was the situation like in Scotland previously?")
           ),
    
    column(6,
           titlePanel("Data Selection"),
           helpText("Let's look at changes over time")
           )
    ), # End of top title row
           
           
    fluidRow(  # Start of 2nd Data selection row  
      column(12,
               # column(3, # 1st quarter
             
        column(3, # Dateslider
               
               sliderInput(
                 "date",
                 h3("Date"),
                 min = min(management$date_code),
                 max = max(management$date_code),
                 value = max(management$date_code)
               )
               
               ), # Dateslider
        
        column(3, # Heatmap select
               selectInput(
                 "data",
                 label = h3("Heat Map Info"),
                 choices = list(
                   "COVID-19 positive cases" = "Testing - Cumulative people tested for COVID-19 - Positive",
                   "COVID-19 patients in ICU - Total",
                   "COVID-19 patients in hospital - Suspected",
                   "COVID-19 patients in hospital - Confirmed"
                 ),
                 selected = "Testing - Cumulative people tested for COVID-19 - Positive"
               )
               ), # Heatmap select
               
        
        column(3,  # Graph Region Select
               selectInput(inputId = "area_choice",
                           label = h3("Region"), 
                           choices = area_names,
                           selected = "Scotland"
               )), # Graph Region Select
               
        column(3,  # Dataset select      
               selectInput(inputId = "data_set_choice",
                           label = h3("Data Set"),
                           choices = data_sets,
                           multiple = FALSE
               )) # Dataset select      
        
              
    )
    ), # Fluidrow - 2nd row end
        
      fluidRow( # Fluidrow charts - 3rd row start
        
        column(12, 
        column(6,
               leafletOutput("scot_plot", height = 550)
        ),
        column(6,
               plotOutput("covid_plot", height = 550),
        )
        )
      ), # Fluidrow charts - 3rd row end
    

       
    fluidRow(     # Fluid row variable selection - Start
      column(12,
             
             column(6,"Info"),
             
             column(6,


       checkboxGroupInput("variable_choice",
                          label = h3("Selected Data"),
                          choices = NULL,
                          selected = NULL)
             )
      )
    )    # Fluid row variable selection - End
     
) # Tab panel
  ) # Nav bar
  )

