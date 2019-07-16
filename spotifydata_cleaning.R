library(dplyr)


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
colnames(final)
write.csv(final, file = "Spotifydata.csv")
