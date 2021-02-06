#Jugadores y equipos: ¿Cuáles ganan más?¿Es viable convertirse en jugador profesional?


```R
#Media de ganancias por generos de un jugador

ganancias_jugadores %>% group_by(Genre) %>%
  summarise( Media = mean(TotalUSDPrize)) %>% arrange(Media)

#Ganancias máximas y mínimas de un jugador por genero

ganancias_jugadores %>% group_by(Genre) %>% 
  filter( TotalUSDPrize == max(TotalUSDPrize)) %>% arrange(desc(TotalUSDPrize))

ganancias_jugadores %>% group_by(Genre) %>% 
  filter( TotalUSDPrize == min(TotalUSDPrize)) %>% arrange(desc(TotalUSDPrize))

#Media de ganancias por generos de un equipo

ganancias_equipos %>% group_by(Genre) %>%
  summarise( Media = mean(TotalUSDPrize)) %>% arrange(Media)

#Ganancias máximas de un equipo por genero

ganancias_equipos %>% group_by(Genre) %>%
  filter( TotalUSDPrize == max(TotalUSDPrize)) %>% arrange(desc(TotalUSDPrize))
```
