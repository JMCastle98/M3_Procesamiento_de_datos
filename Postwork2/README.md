# Postwork Sesión 1.

#### Objetivos
1. Importar los datos de soccer de las temporadas 2017/2018, 2018/2019 y 2019/2020 de la primera división de la liga española a R, los datos los podemos encontrar en el siguiente enlace: https://www.football-data.co.uk/spainm.php

2. Obtener una mejor idea de las características de los data frames al usar las funciones: str, head, View y summary

3. Con la función select del paquete dplyr seleccionar únicamente las columnas Date, HomeTeam, AwayTeam, FTHG, FTAG y FTR; esto para cada uno de los data frames. (Hint: también puedes usar lapply).

4. Asegúrarse de que los elementos de las columnas correspondientes de los nuevos data frames sean del mismo tipo (Hint 1: usa as.Date y mutate para arreglar las fechas). Con ayuda de la función rbind forma un único data frame que contenga las seis columnas mencionadas en el punto 3 (Hint 2: la función do.call podría ser utilizada).

#### Consideraciones

El data set correspondiente a la temporada 2017/2018 presentaba un formato de fecha donde el año se indicaba con los últimos números, es decir, 01/01/17 y 01/01/18. Esto por si solo podría no significar un problema, pero el formato de las siguientes temporadas corresponde a 01/01/2019 y 01/01/2020 respectivamente, por lo que para mantener un mismo formato nos apoyamos de un editor de texto como lo es `Sublime Text` para ajustar el formato.

#### Desarrollo

En este postwork se trabajó con la función `lapply()`, cuyo objetivo es tomar una lista y devolver como resultado dicha lista donde a cada elemento le fue aplicado una función, por ejemplo, aritmética. Como se indicó previamente en los objetivos, esta vez trabajamos con tres data sets a los cuales queremos aplicarles el mismo tratamiento, de modo que la forma más sencilla es crear una lista que contenga dichos data sets y aprovechar los beneficios de `lapply()` en conjunto con la biblioteca`dplyr`:

```R
library(dplyr)
setwd("C:/...") 
lista <- lapply(dir(),read.csv)
```
Primeramente cargamos la biblioteca `dplyr`, después establecemos el directorio de trabajo y finalmente ejecutamos la primer instrucción con `lapply()`. Esta instrucción leerá todos los archivos de tipo `.csv` que se encuentre en el directorio de trabajo y los colocará en una lista como data frames, por lo que es recomendable crear una sub-carpeta que contenga únicamente los archivos con los que se esta trabajando. A continuación hacemos uso de las siguientes funciones:

```R
str(lista)
summary(lista)
head(lista)
View(lista)
```

Estas funciones proporcionan mucha información:
- `str()` nos devolverá los campos y tipo de datos que contiene cada elemento de la lista, es decir, cada data frame.
- `summary()` generalmente presenta resultados de rápido acceso respecto a la información de un data frame, ya que estamos trabajando con una lista encontraremos menos información que de costumbre.
- `head()` devuelve los primeros renglones de los data frames contenidos en la lista.
- `View()` nos muestra una vista de la lista y los data frames que la componen.

Para seleccionar únicamente los campos deseados, nuevamente utilizamos la función `lapply()`, como argumento indicamos la lista a la que se aplicará la función, y la función a aplicar que en este caso es `select()` de la biblioteca `dplyr` siguiendo como argumentos los campos deseados:

```R
lista <- lapply(lista, select, Date, HomeTeam, AwayTeam,FTHG,FTAG,FTR) 
```

Sabemos que estos campos del data set son consecutivos por lo que podemos utilizar `:` para reducir la expresión:

```R
lista <- lapply(lista, select, Date:FTR) 
```

Con la función `str()` observamos que en el campo `Date` de los data frame tenemos un dato de tipo `Factor`, para realizar la conversión a un dato de tipo fecha nos apoyamos nuevamente de la función `lapply()` junto a la función `mutate`. Como argumentos de esta última indicamos el campo `Date` que se sobrescribirá con el resultado de la función `as.Date()` en el formato *día/mes/año*:

```R
lista <- lapply(lista, mutate, Date = as.Date(Date, "%d/%m/%Y")) 
```

Para formar un único data frame, nos apoyamos de la función `do.call()`, que realiza una llamada rápida a una función (en este caso `rbind()` para unir por filas) y utiliza los elementos de la lista como argumentos de la función, es decir, los data frame:

```R
data <- do.call(rbind, lista)
```

Podemos corroborar que el data frame resultante es la combinación deseada observando los primeros y últimos renglones con `head()` y `tail()` o bien observando el las dimensiones finales con `dim()`:

```R
head(data)
tail(data)
dim(data)
```
Una vez que terminamos de tratar nuestra información, podemos escribir un archivo *.csv* a partir de nuestro data frame resultante con la función `write.csv()` e indicando la dirección donde se creará dicho archivo:

```R
write.csv(data,"C:/.../resultado.csv")
```
