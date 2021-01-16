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
datos <- read.csv("SP1.csv")
```

O bien podemos utilizar la URL de donde descargamos el archivo csv y utilizar la función `download.file()`, al que le indicaremos tanto la URL, como el nombre con el que queremos leer el archivo y el modo de apertura, de este modo podemos hacer todo el procedimiento desde R Studio:

```R
url_csv <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
download.file(url = url_csv, destfile = "SP1.csv", mode = "wb")
datos <- read.csv("SP1.csv")
```

Para comprobar que la variable **datos** efectivamente es un data frame utilizamos la función `class()`, y para conocer los campos del data frame utilizamos `str()`:

```R
class(datos)
str(datos)
```

De esta forma realizamos un primer acercamiento a la información contenida en el data frame, como lo son el número de variables y el tipo de estas, o bien la cantidad de registros. También podemos optar por utilizar la función `dim()` si no queremos desplegar tanta información en nustra consola. Para extraer las columnas FTHG y FTAG se utilizará la función `select()` de la librería `dplyr`, por lo que primero se llama a la librería para poder aplicar la función, una nueva variable es guardada únicamente con las columnas necesarias o podemos sobreescribir sobre la anterior.

```R
library(dplyr)
df <- select(datos, FTHG,FTAG)
```
Si no se contara con la librería `dplyr`,  se pueden extraer los campos del dataframe con `$` y utilizarlos para diseñar otro dataframe:

```R
df <- data.frame( goles_casa = datos$FTHG , goles_visitante = datos$FTAG)
```

Ahora se convierte el data frame resultante en una tabla con la función `table ()`, guardando la tabla en una nueva variable, para aplicar funciones `margin.table()` que utilizaremos para obtener las probabilidades de goles de casa y visita.

```R
t1 <- table(df) 
margin.table(t1)
margin.table(t1,1) 
margin.table(t1,2) 
```

Cabe resaltar la finalidad de estas funciones y sus argumentos:
- table() realiza un conteo de las combinaciones  de goles jugando en casa y como visita contenidas en nuestro dataframe. 
- margin.table() realiza una suma de la tabla de entrada devolviendo en este caso el total de goles.
  - Utilizando margin = 1 como argumento la función obtendremos la cantidad de veces que se anotó "X" goles de casa al sumar las filas de la tabla.
  - Utilizando margin = 2 como argumento la función obtendremos la cantidad de veces que se anotó "X" goles de visita al sumar las columnas de la tabla.

Con esta información se puede proceder a calcular la probabilidad marginal cuando el equipo que juega en casa o como visitante anote una cantidad "X" de goles:

```R
prob.casa <- margin.table(t1,1)/margin.table(t1) 
prob.visita <- margin.table(t1,2)/margin.table(t1)
```

Para la probabilidad conjunta, ya que la tabla `t1` tiene la información de las combinaciones, basta con dividir entre el total de goles como en el caso de las probabilidades marginales:

```R
prob.conjunta <- t1/margin.table(t1)
```

Para facilitar estos cálculos RStudio cuenta con la función `prop.table()`, la cual puede calcular la probabilidad de una tabla, de modo que las expresiones anteriores se pueden reducir a:

```R
prob.casa <- prop.table(margin.table(t1,1))
prob.visita <- prop.table(margin.table(t1,2))
prob.conjunta <- prop.table(t1)
```

Finalmente podemos observar las tablas resultantes de las 3 probabilidad calculadas:

```R
View(prob.casa)
View(prob.visita)
View(prob.conjunta)
```

Si queremos corroborar la validez de nuestros resultados, es sabido que la suma de las probabilidad debe ser igual a 1, es decir, el 100%. Esto es sencillo de observar utilizando la función `sum()`:

```R
sum(prob.casa)
sum(prob.visita)
sum(prob.conjunta)
```
