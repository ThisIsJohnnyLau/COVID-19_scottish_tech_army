

ui <- fluidPage(
  
  theme = shinytheme("superhero"),
  
  navbarPage(
    # Page title
    # Displayed to the left of the navigation bar
    title = div(img(
      src = "tt_sq.png",
      height = "86px"
    ),
    HTML(paste0(
      "<a href=", shQuote(paste0("https://www.scottishtecharmy.org/")), target="_blank", ">",
      img(
        src = "sta.png",
        height = "86px"
      ), "</a>"
    )),
    style = "position: relative; top: -10px; left: -15px"
    ),
    
    windowTitle = "Scotland COVID-19 Visualisation",
  
    
    # 1st Main Tab
    tabPanel(
      title = h2("Overview"),
    
    
    
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
               leafletOutput("scot_plot", height = 550) %>%
                 withSpinner(color = "#0dc5c1")
        ),
        column(6,
               plotOutput("covid_plot", height = 550) %>%
                 withSpinner(color = "#0dc5c1")
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
     
), # End of 1st main tab

# Start of 1st main tab
tabPanel(
  title = h2("Local Authorities"),
  
  # App title
  titlePanel("COVID-19 at a local level"),
  
  
  # Sidebar with a slider input for date and selector for data
  sidebarLayout(
    sidebarPanel(
      width = 3,
      h3("Local Authorities"),
      checkboxInput("bar", "All/None", value = T),
      checkboxGroupInput("local_auth",
                         label = NULL,
                         inline = TRUE,
                         choices = local_authorities,
                         selected = "All/None"
      )
    ),
    
    
    
    mainPanel(
      width = 9,
      tabsetPanel(
        type = "tabs",
        
        tabPanel(
          "Traffic",
          h4("Traffic Levels"),
          # column(6,
          leafletOutput("traffic_plot", width = 900, height = 500)
          %>% withSpinner(color = "#0dc5c1"),
          tags$a(href = "https://statistics.gov.scot/data/coronavirus-covid-19-management-information", target="_blank", "Data Source"),
          br(),
          # column(6,
          "Note: Some locations are named IZ followed by a number, please refer",
          tags$a(href = "https://www2.gov.scot/Topics/Statistics/sns/SNSRef/DZresponseplan", target="_blank", "here for more information.")
        ),
        
        
        tabPanel(
          "Deaths",
          h4("Total COVID 19 related deaths to date"),
          # column(6,
          leafletOutput("scot_covid_plot", width = 900, height = 500)
          %>% withSpinner(color = "#0dc5c1"),
          tags$a(href = "https://statistics.gov.scot/data/coronavirus-covid-19-management-information", target="_blank", "Data Source"),
          br(),
          # column(6,
          "Note: Some locations are named IZ followed by a number, please refer",
          tags$a(href = "https://www2.gov.scot/Topics/Statistics/sns/SNSRef/DZresponseplan", target="_blank", "here for more information.")
        ),
        
        tabPanel(
          "Cardiovascular Prescriptions",
          h4("Number of Cardiovascular Prescriptions in Scotland"),
          plotOutput("prescriptions"),
          tags$a(href = "https://scotland.shinyapps.io/phs-covid-wider-impact/", target="_blank", "Data Source")
        )
        
        
      )
    ) # main panel
  )# sidebar
), # End of 2nd main tab

tabPanel(
  title = h2("About Us"),
  
  # App title
  titlePanel(div(img(
    src = "tt_text.jpg",
    width = "100%"
  )
  )
  ),
  
  
  fluidRow(
    column(1),
    column(2,
           align = "center",
           tags$a(
             href = "https://www.linkedin.com/in/rhiannon-batstone-076191120", target="_blank",
             img(
               src = "rb.jpg",
               width = "85%"
             ),
           ),
           h3("Rhi Batstone")
    ),
    
    
    column(2,
           align = "center",
           tags$a(
             href = "https://www.linkedin.com/in/richard--clark", target="_blank",
             img(
               src = "rc.jpg",
               width = "85%"
             )
           ),
           h3("Ric Clark")
    ),
    
    column(2,
           align = "center",
           tags$a(
             href = "https://www.linkedin.com/in/jonathancylau", target="_blank",
             img(
               src = "jl.jpg",
               width = "85%"
             )
           ),
           h3("Jonathan Lau")
    ),
    
    column(2,
           align = "center",
           tags$a(
             href = "https://www.linkedin.com/in/euan-robertson-5845582", target="_blank",
             img(
               src = "er.jpg",
               width = "85%"
             )
           ),
           h3("Euan Robertson")
    ),
    
    column(2,
           align = "center",
           tags$a(
             href = "https://www.linkedin.com/in/alstev", target="_blank",
             img(
               src = "as.jpg",
               width = "85%"
             )
           ),
           h3("Allan Stevenson")
    ),
    
    column(1)
  )
)# End of 3rd main tab
  ) # Nav bar
  ) # End of UI

