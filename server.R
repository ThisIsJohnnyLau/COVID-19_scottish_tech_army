

server <- function(input, output){
    
        output$covid_plot <- renderPlot({
            full_data %>%
                filter(variable == input$variable) %>%
                filter(data_set == input$data_set) %>%
                filter(area == input$area) %>% 
            # group_by(date) %>% 
            ggplot() +
            aes(x = date, y = value) +
            geom_line(colour = "dark blue")
            })
    }

