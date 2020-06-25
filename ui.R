

ui <- fluidPage(titlePanel("Covid-19 in Scotland"),
                
    sidebarLayout(
        
        sidebarPanel(
            
            titlePanel("Data Selection"),

            
            helpText("What shall we look at?"),
            
            selectInput("region", h3("Region"), 
                        choices = list("Scotland" = "Scotland",
                                       "Lothian" = "Lothian")

            ),
        
        selectInput("variable", h3("Variable"), 
                    choices = list("Total" = "Total",
                                   "Confirmed" = "Confirmed",
                                   "Suspected" = "Suspected"),
                    selected = "Total")
        
    ),
        
        mainPanel(
            
            # selectInput("region", "Which Region?", unique(tidy_whisky$region)),
            
            leafletOutput("map"),
            
            plotOutput("covid_plot")
        )
        
        
    )
)

