# Jugadores y equipos: ¿Cuáles ganan más dinero?

Cada vez surgen más [estudios](https://www.marca.com/esports/2016/03/15/56e81056ca474115778b4691.html) que demuestran que los jugadores de esports se ven sometidos a un desgaste similar al de los deportistas tradicionales. El último, realizado por la Universidad Alemana del Deporte en Colonia, revelaba que en intensas partidas profesionales los jugadores de esports generan niveles de estrés similares a los que generan conductores profesionales en carreras. El estudio concluía que *“Los esports son tan exigentes como muchos otros tipos de deporte, sino más."*

Todo este esfuerzo por parte de los jugadores se ve reflejado en cuantiosos premios que se llevan, ya sea de forma individual o en equipo. Para encontrar aquellos que ganan más dinero, haremos uso de los dataset  `highest_earnings_players.csv` y `highest_earnings_temas.csv` en las `variables ganancias_jugadores` y `ganancias_equipos` respectivamente.

### Pequeñas *"consultas"*



```R
#Media de ganancias por generos de un jugador

ganancias_jugadores %>% group_by(Genre) %>%
  summarise( Media = mean(TotalUSDPrize)) %>% arrange(Media)

#Ganancias máximas y mínimas de un jugador por genero

ganancias_jugadores %>% group_by(Genre) %>% 
  filter( TotalUSDPrize == max(TotalUSDPrize)) %>% arrange(desc(TotalUSDPrize))

ganancias_jugadores %>% group_by(Genre) %>% 
  filter( TotalUSDPrize == min(TotalUSDPrize)) %>% arrange(desc(TotalUSDPrize))
```



```R
#Media de ganancias por generos de un equipo

ganancias_equipos %>% group_by(Genre) %>%
  summarise( Media = mean(TotalUSDPrize)) %>% arrange(Media)

#Ganancias máximas de un equipo por genero

ganancias_equipos %>% group_by(Genre) %>%
  filter( TotalUSDPrize == max(TotalUSDPrize)) %>% arrange(desc(TotalUSDPrize))
```





