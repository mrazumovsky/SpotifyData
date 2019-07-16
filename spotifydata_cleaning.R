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

final %>% mutate(Date = as.Date(Date))
tail(final)
final$Year= year(as.Date(final$Date,"%m/%d/%y"))
head(final)
write.csv(final, file = "Spotifydata.csv")
val_by_genre = final %>% group_by(.,Genre) %>% 
          summarise(avg_valence = mean(Valence)) 


ggplot(practice) +
  geom_bar(aes(x = Genre,y = avg_valence),stat = 'identity')

val_by_date = final %>% group_by(.,Date) %>% 
          summarise(avg_valence = mean(Valence))
  

                    