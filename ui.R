

ui <- fluidPage(
    
    titlePanel("Covid-19 in Scotland"),
                
    sidebarLayout(
        
        sidebarPanel(
            
            titlePanel("Data Selection"),

            
            helpText("What shall we look at?"),
            
# Main userselection starts here

            
            selectInput(inputId = "area_choice",
                        label = h3("Region"), 
                        choices = area_names,
                        selected = "Scotland"
            ),

  
    selectInput(inputId = "data_set_choice",
                label = h3("Data Set"),
                choices = NULL,
                selected = NULL,
                multiple = FALSE),


checkboxGroupInput("variable_choice", label = h3("Data"),
                   choices = NULL,
                   selected = NULL)

        ),
  
    
        mainPanel(
          

          plotOutput("covid_plot")
        ),
            # leafletOutput("map"),
        )
    )

