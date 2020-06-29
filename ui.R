

ui <- fluidPage(
    
    titlePanel("Covid-19 in Scotland"),
                
    sidebarLayout(
        
        sidebarPanel(
            
            titlePanel("Data Selection"),

            
            helpText("What shall we look at?"),
            
            selectInput(inputId = "area",
                        label = h3("Region"), 
                        choices = area_names,
                        selected = "Scotland"
            ),
        
    
    
    # selectInput("variable", h3("Variable"),
    #             choices = variable_names,
    #             selected = "Total"),
    
    selectInput(inputId = "data_set",
                label = h3("Data Set"),
                choices = data_sets,
                selected = "General"
                ),
    
    conditionalPanel(
                condition = "input.data_set == 'General'",
                selectInput("variable", label = h3("General"),
                            choices = general_variables,
                            selected = "Delayed discharges")
    ),
    
    conditionalPanel(
        condition = "input.data_set == 'Testing'",
        selectInput("variable", label = h3("Testing"),
                    choices = testing_variables,
                    selected = "Cumulative people tested for COVID-19 - Positive")
    ),
    
    conditionalPanel(
        condition = "input.data_set == 'COVID-19 patients in ICU'",
        selectInput("variable", label = h3("COVID-19 patients in ICU"),
                    choices = ICU_variables,
                    selected = "Confirmed")
    ),
    
    conditionalPanel(
        condition = "input.data_set == 'COVID-19 patients in hospital'",
        selectInput("variable", label = h3("COVID-19 patients in hospital"),
                    choices = general_patient_variables,
                    selected = "Confirmed")
    ),
    
    conditionalPanel(
        condition = "input.data_set == 'Calls'",
        selectInput("variable", label = h3("Calls"),
                    choices = calls_variables,
                    selected = "Coronavirus helpline")
    ),
    
    conditionalPanel(
        condition = "input.data_set == 'Ambulance attendances'",
        selectInput("variable", label = h3("Ambulances"),
                    choices = ambulance_variables,
                    selected = "Total")
    ),
    
    conditionalPanel(
        condition = "input.data_set == 'Adult care homes'",
        selectInput("variable", label = h3("Care Homes"),
                    choices = care_home_variables,
                    selected = "Response rate")
    ),

    conditionalPanel(
        condition = "input.data_set == 'NHS workforce COVID-19 absences'",
        selectInput("variable", label = h3("NHS Staff"),
                    choices = NHS_workforce_variables,
                    selected = "All staff")
    ),
    
    
    plotOutput("covid_plot")
        ),
    
        mainPanel(
            # leafletOutput("map"),
        )
    )
)