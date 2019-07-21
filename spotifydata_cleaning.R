library(dplyr)
library(ggplot2)

genre = read.csv(file = 'Spotify_Genres.csv',stringsAsFactors = FALSE)
head(genre)
features = read.csv(file = "acoustic_features.csv",stringsAsFactors = FALSE)
head(features)
colnames(genre)
colnames(features)
features = features %>% rename(track_id = id)
head(features)
final = (inner_join(genre,features,by = 'track_id'))
colnames(final)
final = final %>% select(.,c(1:18,20,36))
colnames(final)
final = final %>% rename(Genre = genre,
                           Artist = artist_name,
                           Song = track_name,
                           TrackID = track_id,
                           Popularity = popularity,
                           Acousticness = acousticness.x,
                           Danceability = danceability.x,
                           Duration = duration_ms.x,
                           Energy = energy.x,
                           Instrumentalness = instrumentalness.x,
                           Key = key.x,
                           Liveness = liveness.x,
                           Loudness = loudness.x,
                           Mode = mode.x,
                           Speechiness = speechiness.x,
                           Tempo = tempo.x,
                           Time_Signature = time_signature.x,
                           Valence = valence.x,
                           Album = album,
                           Date = date)  
head(final)

final %>% mutate(Date = as.Date(as.numeric(Date)))
tail(final)
final$Year= year(as.Date(final$Date,"%m/%d/%y"))
head(final)


head(final)
final = final %>% mutate(.,Year = ifelse(is.na(Year),Date,Year))
unique(final$Genre)
final$Genre = gsub(final$Genre,pattern = 'Children\xd5s Music',replacement = "Children's Music")
final$Artist = gsub(final$Artist, pattern = 'Beyonc_',replacement = 'Beyonce')
head(final)
final = final %>% filter(.,Year <= 2019) 
complete.cases()
final$Year = as.numeric(substr(final$Year,1,4))
colnames(final)
# already ran this final = final %>% select(.,c(-4,-20))
lapply(final,class)





write.csv(final, file = "Spotifydata.csv")

summary(final$Genre)
## scatter plots for artist and the valence of songs by variables the user can input
## bar charts for genres so you're not plotting thousands of things over each other








final$Year = as.numeric(final$Year)
unique(final$Genre)
final$Genre = gsub(final$Genre,pattern = 'Children\xd5s Music',replacement = "Children's Music")
unique(final$Genre)


str(final)
val_by_genre = spotify %>% group_by(.,Genre) %>% 
          summarise(avg_valence = mean(Valence)) %>% 
          arrange(.,desc(avg_valence))

val_by_genre
ggplot(practice) +
  geom_bar(aes(x = Genre,y = avg_valence),stat = 'identity')

val_by_date = final %>% group_by(.,Year) %>% 
          summarise(avg_valence = mean(Valence)) %>% 
          arrange(desc(avg_valence))

val_by_key = final %>% group_by(.,Key) %>% 
  summarise(avg_valence = mean(Valence)) %>% 
  arrange(desc(avg_valence))
  

                    