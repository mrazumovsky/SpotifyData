

shinyServer(function(input, session, output){
## Displaying datatable in the Data tab
  output$table = DT::renderDataTable({
    datatable(spotify,rownames = F, options = list(scrollX = TRUE)) %>% 
      formatStyle(input$selected,  
                  background="skyblue", fontWeight='bold') 
  })
  
  output$maxpopular = renderValueBox({
    
    most_popsong = spotify %>% filter(Popularity == max(Popularity)) %>% 
                           select(Song)
    most_popartist = spotify %>% filter(Popularity == max(Popularity)) %>% 
                           select(Artist)
    # max_popular = spotify$Popularity[spotify[,input$selected] == max_value]
    infoBox(title = "Most popular song is", substr(most_popsong,4,12),subtitle = c("by",most_popartist), 
            icon = icon("line-chart"), color = 'light-blue')
  })
  
  output$minpopular = renderValueBox({
    
    min_value = min(spotify[,input$selected])
    min_popular = spotify$Popularity[spotify[,input$selected] == min_value]
    infoBox(paste("Min Popularity by",input$selected),min_popular,
            icon = icon("hand-o-down"), color = 'green')
  })
  
 category_spotify = reactive ({
   
   spotify %>% group_by_(.,input$selected) %>% 
               summarise(avgval = mean(Valence),avgpop = mean(Popularity)) 
   
   
 })
    
    output$valscatter = renderPlotly({
    
    ggplot() +
      geom_point(data = category_spotify(), aes(x = avgval, y = avgpop, label = input$selected), alpha = (1/3)) + scale_x_log10() +
      labs(x = "Valence", y = "Speechiness") +
      geom_smooth(method = 'lm')
      
    
    #ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, color = continent, text =      paste("country:", country))) +
     # geom_point(alpha = (1/3)) + scale_x_log10()  
    
    })  
    
    output$correlation = renderPlotly({
      
      
    })
    
    output$time1 = renderPlotly({
      
      avg_timeVal = spotify %>% filter(.,Year > 1963) %>% 
                   group_by(.,Year) %>% 
                   summarise(avgval = mean(Valence)*100)
      
      avg_timePop = spotify %>% filter(.,Year > 1963) %>%
                   group_by(.,Year) %>%
                   summarise(avgpop = mean(Popularity))
      
      ggplot() +
               geom_line(data = avg_timeVal,aes(x = Year,y = avgval,color = 'Valence')) + 
               geom_line(data = avg_timePop, aes(x = Year, y = avgpop, color = 'Popularity')) +
               labs(x = "Year", y = "Scale", title = "Valence and Popularity Over Time") +
               theme_economist(base_size = 6,) + 
               theme(legend.title = element_blank()) 
    })
    
    output$time2 = renderPlotly({
      
      avg_timeInstrumentalness = spotify %>% filter(.,Year > 1963) %>%
        group_by(.,Year) %>%
        summarise(avgI = mean(Instrumentalness))
      
      avg_timeSpeech = spotify %>% filter(.,Year > 1963) %>%
        group_by(.,Year) %>%
        summarise(avgS = mean(Speechiness)) 

     ggplot() +
       geom_line(data = avg_timeSpeech,aes(x = Year,y = avgS,color = 'Speechiness')) +
       geom_line(data = avg_timeInstrumentalness, aes(x = Year, y = avgI, color = 'Instrumentalness')) +
       labs(x = "Year", y = "Scale", title = "Instrumentalness and Speechiness Over Time") +
       theme_economist(base_size = 6,) + 
       theme(legend.title = element_blank()) 
    })
    

  
  
})

