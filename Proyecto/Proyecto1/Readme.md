## Datasets: ¿Con qué información sobre eSports contamos?

<img src="../../Imágenes/logo_kaggle.png" align="right" height="200" width="300">

Los datasets que utilizamos en nuestro proyecto los obtuvimos del sitio web [kaggle](https://www.kaggle.com/), una comunidad online de científicos de datos y practicantesw de machine learning, donde los usuarios pueden encontrar y compartir data sets públicos, explorar modelos y análisis de otros usuarios e inclusive participar en competencias.


#### [Esports Earnings 1998 - 2020](https://www.kaggle.com/rankirsh/esports-earnings)

El usuario Ran.Kirsh nos comparte dos datasets llenos de información sobre eventos de eSports desde 1998 a 2020. El primero llamado `GeneralEsportData.csv` y el segundo `HistoricalEsportData.csv`. Ambos contienen información sobre las ganancias en torneos de eSports, participantes en torneos y número de torneos, así como información sobre los juegos en los que se compitió y a que géneros pertenecen. 

La mayor diferencia es que `GeneralEsportData` presenta un ponderado total e `HistoricalEsportData` presenta un desgloce mensual de estos datos.

#### [Esport Earnings](https://www.kaggle.com/rushikeshhiray/esport-earnings)

`ESport_Earnings.csv` es un dataset cortesía de Rushikesh Hiray, predecesor de `Esports Earnings 1998 - 2020`, presenta practicamente la misma estructura en cuanto a algunos campos, sin embargo este contiene un campo que para nosotros es de bastante interés: `Top_Country` que nos dice el país ganador en las competencias.


#### [eSport Earnings](https://www.kaggle.com/jackdaoud/esports-earnings-for-players-teams-by-game)

Jack Daoud mediante scrapping obtuvo información sobre jugadores y equipos ganadores con las ganancias más altas de diversos torneos y la plasmó en el diferentes data set. `highest_earning_players.csv` y `highest_earning_teams.csv` presentan información como nombres, nickname, país, juego del torneo, valor del premio, etc. 

#### [Top Streamers on Twitch](https://www.kaggle.com/aayushmishra1512/twitchdata)

Finalmente, dado que el medio de difusión más importante para los eSports son las plataformas de streaming, con ayuda del dataset `twitchdata-update.csv` de Aayush Mishra, tenemos acceso información que nos permitiría identificar a los eSports en estos medios.

### Exportando los dataset a R

Los data set de kaggle vienen convenientemente guardados en archivos `.csv`, por lo que si los hemos descargado, basta con establecer el directorio de trabajo y la función
`read.csv()` será más que suficiente para que R nos exporte nuestros archivos como un data frame:

```R
setwd("C:/.../Proyecto")

#Archivos que se usarán
general <- read.csv("GeneralEsportData.csv")
historical <- read.csv("HistoricalEsportData.csv")
earnings <- read.csv("ESport_Earnings.csv")
twitch <- read.csv("twitchdata-update.csv")
ganancias_jugadores <- read.csv("highest_earning_players.csv")
ganancias_equipos<- read.csv("highest_earning_teams.csv")
```

Una vez exportados, echamos un primer vistazo con las funciones `str()` y `summary()`:

```R
#Analizamos las características de los archivos
str(general); summary(general)
str(earnings); summary(earnings)
str(historical); summary(historical)
str(twitch); summary(twitch)
str(ganancias_jugadores); summary(ganancias_jugadores)
str(ganancias_equipos); summary(ganancias_equipos)
```

La mayoría de los datos son de númericos, o en su defecto *factores* a los cuales les sacaremos provecho gracias a los *niveles* que poseen, también hay campos de fecha que debemos tratar adecuadamente para una mejor representación de nuestros datos.

### Paquete utilizados

Para facilitar y en algunos casos posibilitar objetivos, hicimos uso de una serie de paquetes de R que deben ser cargados para que nuestras gráficas y resultados se presenten correctamente:

```R
#Bibliotecas que se usarán
library(dplyr)                #Manejo de dataframes
library(ggplot2)              #Manejo de gráficos
library(magrittr)             #Paquetería para optimizar código
library(multipanelfigure)     #Crear multipaneles con ggplot
library(lubridate)            #Manejo de fechas
library(ggrepel)              #Etiquetas/labels separadas en las gráficas
library(tsbox)                #TS_BOX le permite a ggplot plotear series de tiempo
library(ggeasy)               #Facilita el manejo de titulos de ggplot dentro de multipanelfigure
```

### Complementando información

Una de las características del archivo `GeneralEsportData.csv` es que contiene información de la fecha del lanzamiento de los vídeojuegos, más no así la fecha de los eventos, ni las ganancias por evento o jugadores por evento, debido a esto hallamos la primera dificultad. La cuál solucionaremos a través de realizar una conjunción de este archivo con el  archivo de `HistoricalEsportData.csv` con la función `merge()`:

```R
#JOIN  - merge() - Nos une dos archivos a partir de una llave
join <- merge(x = general, y = historical, by = "Game", all = TRUE)  
join <- mutate(join, Date = as.Date(Date, "%Y-%m-%d"))                #Pasamos a formato de fecha el campo Date

str(join)       #Características del data frame unido
summary(join)
```


