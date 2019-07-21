

shinyServer(function(input, session, output){

  output$maxpopular = renderValueBox({
    
    most_popsong = spotify %>% filter(Popularity == max(Popularity)) %>% 
                           select(Song)
    most_popartist = spotify %>% filter(Popularity == max(Popularity)) %>% 
                           select(Artist)
    # max_popular = spotify$Popularity[spotify[,input$selected] == max_value]
    infoBox(title = "Most popular song is", substr(most_popsong,4,12),subtitle = c("by",most_popartist), 
            icon = icon("line-chart"), color = 'light-blue')
  })
  
  output$maxpopularyear = renderValueBox({
    
    most_popyear = spotify %>% group_by(Year) %>% 
                               summarise(max = mean(Popularity)) %>% 
                               arrange(desc(max)) %>% 
                               filter(Year <2000)
    
    infoBox(title = "Most popular year before 2000",most_popyear[1,1],
            icon = icon("hand-o-up"), color = 'navy')
  })
  
  output$genre = renderPlot({
    
    genr = spotify %>% group_by(.,Genre) %>% 
                       summarise(Val = mean(Valence)) %>% 
                       top_n(10)   
  
    ggplot(genr) +
      geom_bar(aes(x= Genre,y = Val,fill = Genre),stat = 'identity') +
      scale_fill_ordinal() + theme_classic() + ylab('')
    
    })
  
 
 category_spotifyval = reactive ({
   
   spotify %>% group_by_(.,input$selected) %>% 
               summarise(avgval = mean(Valence),avginst = mean(Instrumentalness)) 
   
 })
 
 category_spotifyinst = reactive ({
   
   spotify %>% group_by_(.,input$selected) %>% 
     summarise(avgspeech = mean(Speechiness),avgpop = mean(Popularity))
 })
    
    output$valscatter = renderPlotly({
    
    ggplot() +
      geom_point(data = category_spotifyval(), aes(x = avgval, y = avginst,color = input$selected), alpha = (.9)) +
      geom_smooth(method = 'lm') + 
      scale_x_log10() +
      labs(x = "Valence", y = "Instrumentalness") +
      theme_fivethirtyeight() + ggtitle("Valence and Insrumentalness") +
      theme(legend.title = element_blank()) 
    
    })  
    
    output$speech = renderPlotly({
      
      ggplot() +
        geom_point(data = category_spotifyinst(), aes(x = avgspeech, y = avgpop,color = input$selected), alpha = (.9)) + 
        geom_smooth(method = 'lm',se = F) +
        scale_x_log10() +
        labs(x = "Instrumentalness", y = "Speechiness") +
        theme_fivethirtyeight() + ggtitle("Popularity and Speechiness") +
        theme(legend.title = element_blank()) +
        geom_smooth(method = 'lm')
      
    })
    
    output$analysis = renderPlotly({
      
      cor_dfmelt = melt(cor_df[,1:ncol(cor_df)]) 
      cor_dfmelt$Variable = c("Valence","Popularity","Speechiness","Instrumentalness")
      Measure = factor(cor_dfmelt$variable)
      
      ggplot(cor_dfmelt, aes(Variable, value, group= Measure)) + 
        geom_point(aes(color=Measure)) + 
        coord_flip() +
        labs(x = "", y = "Correlation") +
        theme(legend.title = element_blank(),panel.background = element_rect(color = 'black')) 
      
      
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
               theme_economist(base_size = 6) + 
               theme(legend.title = element_blank()) + scale_color_wsj()
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
       theme(legend.title = element_blank()) + scale_color_wsj()
    })
    
    ## Displaying datatable in the Data tab
    output$table = DT::renderDataTable({
      datatable(spotify,rownames = F, options = list(scrollX = TRUE)) %>% 
        formatStyle(input$selected,  
                    background="skyblue", fontWeight='bold') 
    })
  
  
})

