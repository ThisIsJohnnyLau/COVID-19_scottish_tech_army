

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

    # 
    # conditionalPanel(
    #     condition = "input.area_choice == 'Scotland'",
    # selectInput(inputId = "data_set_choice",
    #             label = h3("Data Set"),
    #             choices = c(NULL, data_sets$data_set),
    #             selected = NULL,
    #             multiple = FALSE
    # )
    #             ),
    # 
    # conditionalPanel(
    #     condition = "input.area_choice != 'Scotland'",
    #     selectInput(inputId = "data_set_choice",
    #                 label = h3("Data Set"),
    #                 choices = c(NULL, "Testing", "COVID-19 patients in hospital", "COVID-19 patients in ICU"),
    #                 selected = NULL,
    #                 multiple = FALSE)
    # ),

    selectInput(inputId = "data_set_choice",
                label = h3("Data Set"),
                choices = c(NULL, "Testing", "COVID-19 patients in hospital", "COVID-19 patients in ICU"),
                selected = NULL,
                multiple = FALSE),

    # actionButton("go", "Go"),
    # actionButton("reset", "Clear"),

checkboxGroupInput("variable_choice", label = h3("Data"),
                   choices = NULL,
                   selected = NULL)
        ),
    
    # conditionalPanel(
    #             condition = "input.data_set_choice == 'General'",
    #             checkboxGroupInput("variable_choice", label = h3("General"),
    #                         choices = c(NULL, general_variables$variable),
    #                         selected = NULL)
    # ),
    # 
    # conditionalPanel(
    #     condition = "input.data_set_choice == 'Testing'",
    #     checkboxGroupInput(inputId = "variable_choice",
    #                 label = h3("Testing"),
    #                 choices = c(NULL, testing_variables$variable),
    #                 selected = NULL)
    # ),
    # 
    # conditionalPanel(
    #     condition = "input.data_set_choice == 'COVID-19 patients in ICU'",
    #     checkboxGroupInput("variable_choice",
    #                        label = h3("COVID-19 patients in ICU"),
    #                 choices = c(NULL, ICU_variables$variable),
    #                 selected = NULL)
    # ),
    # 
    # conditionalPanel(
    #     condition = "input.data_set_choice == 'COVID-19 patients in hospital'",
    #     checkboxGroupInput("variable_choice", label = h3("COVID-19 patients in hospital"),
    #                 choices = c(NULL, general_patient_variables$variable),
    #                 selected = NULL)
    # ),
    # 
    # conditionalPanel(
    #     condition = "input.data_set_choice == 'Calls'",
    #     checkboxGroupInput("variable_choice", label = h3("Calls"),
    #                 choices = c(NULL, calls_variables$variable),
    #                 selected = NULL)
    # ),
    # 
    # conditionalPanel(
    #     condition = "input.data_set_choice == 'Ambulance attendances'",
    #     checkboxGroupInput("variable_choice",
    #                        label = h3("Ambulances"),
    #                 choices = c(NULL, ambulance_variables$variable),
    #                 selected = NULL)
    # ),
    # 
    # conditionalPanel(
    #     condition = "input.data_set_choice == 'Adult care homes'",
    #     checkboxGroupInput("variable_choice", label = h3("Care Homes"),
    #                 choices = c(NULL, care_home_variables$variable),
    #                 selected = NULL)
    # ),
    # 
    # conditionalPanel(
    #     condition = "input.data_set_choice == 'NHS workforce COVID-19 absences'",
    #     checkboxGroupInput("variable_choice", label = h3("NHS Staff"),
    #                 choices = c(NULL, NHS_workforce_variables$variable),
    #                 selected = NULL)
    # ),
    

    
  
    
        mainPanel(
          plotOutput("covid_plot")
        ),
            # leafletOutput("map"),
        )
    )

