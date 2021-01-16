# Postwork Sesión 1.

#### Objetivos
<img src="../Imágenes/Imágen 2.png" align="right" height="400" width="250">

1. Importar los datos de soccer de la temporada 2019/2020 de la primera división de la liga española a `R`, los datos los podemos encontrar en el siguiente enlace: https://www.football-data.co.uk/spainm.php

2. Del data frame resultante de importar los datos a `R`, extraer las columnas que contienen los números de goles anotados por los equipos que jugaron en casa (FTHG) y los goles anotados por los equipos que jugaron como visitante (FTAG).

3. Consultar cómo funciona la función `table` en `R` al ejecutar en la consola `?table`.
 
4. Posteriormente elabora tablas de frecuencias relativas para estimar las siguientes probabilidades:

- La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x = 0, 1, 2, ...)
- La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y = 0, 1, 2, ...)
- La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como visitante anote y goles (x = 0, 1, 2, ..., y = 0, 1, 2, ...)


#### Desarrollo

Para cumplir con el primer objetivo debemos llamar a nuestro archivo csv dentro de R, podemos realizar esto de 2 formas, si tenemos el archivo descargado en nuestra computadora podemos establecer el directorio de trabajo con la función `setwd()` y abrir el archivo en una variable con la función `read.csv()`:

```R
setwd("C:/...") 
datos <- read.csv("SP1920.csv")
```

O bien podemos utilizar la URL de donde descargamos el archivo csv y utilizar la función `download.file()`, al que le indicaremos tanto la URL, como el nombre con el que queremos leer el archivo y el modo de apertura, de este modo podemos hacer todo el procedimiento desde R Studio:

```R
url_csv <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
download.file(url = url_csv, destfile = "SP1920.csv", mode = "wb")
datos <- read.csv("SP1920.csv")
```

Para comprobar que la variable **datos** efectivamente es un data frame utilizamos la función `class()`, y para conocer los campos del data frame utilizamos `str()`:

```R
class(datos)
str(datos)
```

De esta forma realizamos un primer acercamiento a la información contenida en el data frame, como lo son el número de variables y el tipo de estas, o bien la cantidad de registros. También podemos optar por utilizar la función `dim()` si no queremos desplegar tanta información en nustra consola.






