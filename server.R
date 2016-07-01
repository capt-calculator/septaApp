

function (input, output) {
    
    # Reactives and observers
    
    selected <- reactive({ runTimes %>% filter(train_id==input$trainSelect) })
    source <- reactive({ as.character(selected()$source[1]) })
    destination <- reactive({ as.character(selected()$dest[1]) })
    service <- reactive({ as.character(selected()$service[1]) })
    meanRunTime <- reactive({ round(mean(selected()$delta), 2) })
    meanDelay <- reactive({ round(mean(selected()$avglate), 2) })
    otp <- reactive({ as.data.frame(performance[performance$train_id==input$trainSelect,])[2] })
    
    locations <- reactive({ trainView %>% filter(train_id==input$trainSelect) })
    
    
    observe({
      
        leafletProxy("trainMap", data=locations()) %>%
            clearMarkers() %>%
            addCircles(lng =  ~lon,
                       lat =  ~lat,
                       color='steelblue'
            )
    })
    
    # Outputs
    
    output$source <- renderText({ paste(strong('Source:'), source()) })
    output$destination <- renderText({ paste(strong('Destination: '), destination()) })
    output$service <- renderText({ paste(strong('Service:'), service()) })
    output$meanRunTime <- renderText({ paste(strong('Average Run Time:'), meanRunTime(), 'minutes') })
    output$meanDelay <- renderText({ paste(strong('Average Delay:'), meanDelay(), 'minutes') })
    output$otp <- renderText({ paste0(strong('On Time Performance: '), as.character(round(otp(), 3) * 100), '%')})
    
    
    output$plot <- renderPlot({
                    ggplot(selected(), aes(x=delta)) +
                    geom_histogram(aes(y=..density..), color='black', fill='grey') +
                    geom_density(fill='steelblue', alpha=0.5) +
                    xlab('Minutes') +
                    ggtitle(paste0('Train ', as.character(input$trainSelect), ' Run Time Distribution') ) + 
                    theme_minimal()
    })
    
        
    output$trainMap <- renderLeaflet({
                        leaflet(locations()) %>%
                        addProviderTiles('CartoDB.Positron') %>%
                        fitBounds(~min(lon, na.rm=T),
                                  ~min(lat, na.rm=T),
                                  ~max(lon, na.rm=T),
                                  ~max(lat, na.rm=T))
        })
}

