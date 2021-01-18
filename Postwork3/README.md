# Postwork Sesión 3.

#### Objetivos

1. Con el último data frame obtenido en el postwork de la sesión 2, elaborar tablas de frecuencias relativas para estimar las siguientes probabilidades:

- La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x=0,1,2,)

- La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y=0,1,2,)

- La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como visitante anote y goles (x=0,1,2,, y=0,1,2,)

2. Realizar lo siguiente:

- Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo de casa
- Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo visitante.
- Un HeatMap para las probabilidades conjuntas estimadas de los números de goles que anotan el equipo de casa y el equipo visitante en un partido.

#### Desarrollo

El primer pasó para desarrollar este postwork es cargar las bibliotecas correspondientes a los paquetes `dplyr` y `ggplot2` ya que haremos uso de funciones pertenecientes a estos:

```R
library(dplyr)
library(ggplot2)
```

Posteriormente podemos repetir el procedimiento realizado en el [Postwork02](Postwork2/) para obtener el data frame con el que trabajaremos, o podemos llamar el archivo `.csv` que generamos para facilitar el proceso:

```R
data <- read.csv("resultado.csv")
```

El siguiente paso es seleccionar los campos de goles de casa (FTHG) y goles de visitante (FTAG) de nuestro data frame para trabajar con ellos:

```R
goles <- select(data, FTHG, FTAG)
```

Ya que necesitamos obtener el conteo de las combinaciones de goles que se dieron en las temporadas, nos apoyamos la función `table()`: 

```R
goles_tabla <- table(goles)
```

Como se vio en el [Postwork01](Postwork1/) `margin.table()` realiza una suma de los elementos de una tabla, ya sea de toda la tabla, de sus filas o de sus columnas. Aprovechando esto obtendremos las sumas de goles de casa y visita:

```R
goles_casa <- margin.table(goles_tabla,1)
goles_visita <- margin.table(goles_tabla,2)
```

El siguiente paso es obtener las probabilidades marginales y la probabilidad conjunta, como se ha visto anteriormente, esto se simplifica utilizando la función `prop.table()`:

```R
prob.casa <- prop.table(goles_casa)
prob.visita <- prop.table(goles_visita)
prob.conjunta <- prop.table(goles_tabla)
```

Es importante tener en cuenta que la biblioteca `ggplot2` trabaja directamente con data frames, por lo que es conveniente realizar la conversión de nuestros datos de tipo table a data frame: 

```R
prob.casa.df <- as.data.frame(prob.casa)
prob.visita.df <- as.data.frame(prob.visita)
prob.conjunta.df <- as.data.frame(prob.conjunta )
```

Podemos corroborar el cambio de tipo de dato con `class()`: 

```R
class(prob.conjunta.df)
```

Como resultado de este cambio, los data frame de tendrán columnas correspondientes a los números de goles y su probabilidad, confiamos en la función `str()` para conocer la información de nuestro data frame:

```R
str(prob.casa.df)
str(prob.visita.df)
str(prob.conjunta.df)
```

Si quisieramos corroborar que las probabilidad efectivamente suman 1 utilizariamos `sum()` y las columnas de `Freq`:

```R
sum(prob.casa.df$Freq)
sum(prob.visita.df$Freq)
sum(prob.conjunta.df$Freq)
```

Para construir el gráfico de barras para las probabilidades marginales del número de goles anotados por el equipo de casa, necesitamos emplear algunas funciones de la biblioteca `ggplot2`:

-  `ggplot(dataframe,aes(x,y))`: por sí sola, la función `ggplot()` crea un *protográfico* que contiene los datos del data frame indicado en el argumento.
-  `aex(x,y)`: el segundo argumento de la función anterior indica las *estéticas*, valores que definen las distancias de los ejes, colores o formas utilizadas para visualizar la información.
-  `geom_col()`: esta función crea un gráfico de barras a partir de los datos indicados en las *estéticas*.

Para realizar el gráfico deseado, indicamos el data frame `prob.casa.df` e indicamos los ejes que estarán dados por número de goles y sus probabilidades contenidos en él. Recordemos que dentro de la notación de `ggplot2` estas funciones se enlazan con el símbolo `+`:

```R
casa <- ggplot(prob.casa.df, aes( x = prob.casa.df$FTHG, y = prob.casa.df$Freq))+geom_col()
```

Para construir el gráfico de barras para las probabilidades marginales del número de goles anotados por el equipo de visita realizamos el mismo procedimiento pero utilizando el data frame correspondiente y sus campos:

```R
visita <- ggplot(prob.visita, aes( x = prob.visita$FTAG, y = prob.visita$Freq))+geom_col()
```

Finalmente, construir un HeatMap para las probabilidades conjuntas de los números de goles que anotan el equipo de casa y el equipo visitante en un partido, es necesita de algunos cambios en nuestra instrucción:

- Se hará uso de la función `geom_tile()` que genera un HeatMap en lugar de `geom_col()` que genera un gráfico de barras.
- Como se mencionó anteriormente `aex(x,y)` maneja las *estéticas*, en este caso los ejes estarán dados por los números de goles del equipo de casa y el equipo visitante pero necesitamos los valores de la probabilidad conjunta como tercer estética para rellenar el HeatMap, indicamos esto con un argumento más: `aex(x,y,fill)`.

Utilizando el data frame correspondiente la instrucción sería:

```R
conjun <- ggplot(prob.conjunta, aes( x = prob.conjunta$FTHG, y = prob.conjunta$FTAG, fill = prob.conjunta$Freq))+geom_tile()
```

Para observar los gráficos resultantes basta con llamar a las variables donde se guardaron desde la consola:

```R
casa
visita
conjun
```
