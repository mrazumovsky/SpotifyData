head(spotify) 
g1 = spotify %>% filter(., Year > 1963) %>% 
            group_by(.,Year) %>% 
            summarise(num = n_distinct(Artist)) %>% 
            arrange(desc(num))
ggplot() +
  geom_line(data = g1,aes(x = Year,y = num,color = 'Valence'))

spotify[spotify$Popularity == max(spotify$Popularity),'Song']
spotify %>% filter(.,Popularity==max(Popularity)) %>% 
            select(.,Song)

spotify %>% group_by_at(colnames()) %>% 
          summarise(cor(Loudness,Valence))

cor(spotify$Popularity,spotify$Speechiness)
library(gtools)

Val_cor = cor(as.matrix(spotify[,18]), as.matrix(spotify[,-c(1:4,11,14,17:20)])) ##Valence
Pop_cor = cor(as.matrix(spotify[,5]), as.matrix(spotify[,-c(1:5,11,14,17,19,20)])) #Popularity
Speech_cor = cor(as.matrix(spotify[,15]), as.matrix(spotify[,-c(1:4,11,14,15,17,19,20)])) ##Speechiness
Inst_cor = cor(as.matrix(spotify[,10]), as.matrix(spotify[,-c(1:4,10,11,14,17,19,20)])) ##Instrumentalness 
cor_df = as.data.frame(rbind.fill(cor(as.matrix(spotify[,18]), as.matrix(spotify[,-c(1:4,11,14,17:20)])), ##Valence
      cor(as.matrix(spotify[,5]), as.matrix(spotify[,-c(1:5,11,14,17,19,20)])), #Popularity
      cor(as.matrix(spotify[,15]), as.matrix(spotify[,-c(1:4,11,14,15,17,19,20)])), ##Speechiness
      cor(as.matrix(spotify[,10]), as.matrix(spotify[,-c(1:4,10,11,14,17,19,20)]))))
cor_df = row.names(c('Valence','Popularity','Speechiness','Instrumnentalness'))
cor_df = as.data.frame(cor(as.matrix(spotify[,18]), as.matrix(spotify[,-c(1:4,11,14,17:20)])))
cor_df[2,] = cor(as.matrix(spotify[,5]), as.matrix(spotify[,-c(1:5,11,14,17,19,20)])) #Popularity
cor_df = data.frame("Popularity","Danceability",stringsAsFactors = FALSE)
cor_df

cor_df = smartbind(Val_cor,Pop_cor,Speech_cor,Inst_cor) ## combines all rows by true values
View(cor_df)
cor_df[,1]
row.names(cor_df) = c('Valence','Popularity','Speechiness','Instrumnentalness')
cor_df

library(ggplot2)
library(reshape2)
cor_dfmelt = melt(cor_df[,1:ncol(cor_df)]) 

cor_df[1,]
ggplot(cor_dfmelt,aes(variable,value,color = variable)) +
  geom_point(alpha=.9,aes(fill = variable)) + coord_flip()

ggplot(cor_df) +
  geom_point(aes(variable,value,color = 'value'))

cor_dfmelt$rowid = c("Valence","Popularity","Speechiness","Instrumentalness")
cor_dfmelt
ggplot(cor_dfmelt, aes(rowid, value, group=factor(variable))) + geom_point(aes(color=factor(variable)))
  
gvisGauge(spotify)



