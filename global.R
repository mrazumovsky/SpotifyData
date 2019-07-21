library(DT)
library(shiny)
library(googleVis)
library(dplyr)
library(ggplot2)
library(shinydashboard)
library(plotly)
library(gtools)
library(ggthemes)


# convert matrix to dataframe

spotify = data.frame(read.csv(file = 'Spotifydata.csv',stringsAsFactors = FALSE, encoding = 'UTF-8', fileEncoding = 'ISO8859-1'))
spotify = spotify %>% rename(Number = X)
# remove row names
rownames(spotify) = NULL

# create variable with colnames as choice
choices = colnames(spotify[,-1])
LANG="en_US.UTF-8"

##creating a new data frame for correlation of year measurements
Val_cor = cor(as.matrix(spotify[,18]), as.matrix(spotify[,-c(1:4,11,14,17:20)])) ##Valence
Pop_cor = cor(as.matrix(spotify[,5]), as.matrix(spotify[,-c(1:5,11,14,17,19,20)])) #Popularity
Speech_cor = cor(as.matrix(spotify[,15]), as.matrix(spotify[,-c(1:4,11,14,15,17,19,20)])) ##Speechiness
Inst_cor = cor(as.matrix(spotify[,10]), as.matrix(spotify[,-c(1:4,10,11,14,17,19,20)])) ##Instrumentalness 

cor_df = smartbind(Val_cor,Pop_cor,Speech_cor,Inst_cor) ## combines all rows by true values


