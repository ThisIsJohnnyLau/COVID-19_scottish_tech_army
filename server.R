

#NEED TO CHANGE SLIDERS TO NONE LOW MEDIUM HIGH
server <- function(input, output){
    output$covid_plot <- renderPlot({
        
        full_data %>%
            group_by(area, data_set, variable) %>% 
            arrange(area, data_set, variable, date) %>% 
            mutate(value_week = rollmean(x = value, 7, align = "right", fill = NA)) %>% 
            filter(area == input$region,
                   variable == input$variable) %>%
            ggplot() +
            aes(date, value_week, colour = variable) +
            geom_line() +
            theme(legend.position = "bottom")
        })

    }

