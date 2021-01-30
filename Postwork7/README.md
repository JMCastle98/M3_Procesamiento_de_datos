# Postwork Sesión 7. 

#### Objetivos

<img src="../Imágenes/logo-mongodb.png" align="right" height="350" width="300">

Utilizando el manejador de BDD _Mongodb Compass_ (previamente instalado), deberás de realizar las siguientes acciones: 

- Alojar el fichero  `data.csv` en una base de datos llamada `match_games`, nombrando al `collection` como `match`

- Una vez hecho esto, realizar un `count` para conocer el número de registros que se tiene en la base

- Realiza una consulta utilizando la sintaxis de **Mongodb**, en la base de datos para conocer el número de goles que metió el Real Madrid el 20 de diciembre de 2015 y contra que equipo jugó, ¿perdió ó fue goleada?

- Por último, cerrar la conexión con la BDD

#### Desarrollo

El primer paso para desarrollar este postwork fue crear la base de datos `match_games` desde **MongoDB Compass**:

<p align="center">
<img src="../Imágenes/Postwork7.1.png">
</p>

Después se creo la colección `match`:

<p align="center">
<img src="../Imágenes/Postwork7.2.png">
</p>

Finalmente se subio el archivo `data.csv` a la colección de nuestra base de datos, observamos que hay un total de **1140** documentos :

<p align="center">
<img src="../Imágenes/Postwork7.3.png">
</p>

Ahora para conectarnos a nuestra base de datos desde R, lo primero que necesitamos es instalar el paquete [`mongolite`](https://jeroen.github.io/mongolite/) para su uso:

```R
install.packages("mongolite")
library(mongolite)
```

Al igual que con **MongoDB Compass**, realizar la conexión necesita de la dirección del servidor MongoDB en formato de cadena [URI](https://docs.mongodb.com/manual/reference/connection-string/) :

```R
mi url <- mongodb://[username:password@]host1[:port1][,host2[:port2],...[/[database][?options]]
```

Esta URL es un parámetro de la función `mongo()` que permite la conexión a una colección de MongoDB, otros parámetros necesarios son el nombre de la base de datos y el nombre de la colección:

```R
match <- mongo(collection = "match",
           db = "match_games", 
           url = mi_url)
print(match)           
```

*match* es un objeto de conexión a mongo, podemos dar un vistazo a los métodos de este objeto imprimiéndolo en la consola:

<p align="center">
<img src="../Imágenes/Postwork7.4.png">
</p>

Es de nuestro interés el método `count()`, el cual devuelve el número de documentos contenidos en nuestra colección:

```R
match$count()
```

El cual coincide con lo observado en **MongoDB Compass**:

<p align="center">
<img src="../Imágenes/Postwork7.5.png">
</p>

Para realizar consultas desde R, podemos recurrir a los diferentes métodos de los objetos de conexión a mongo, utilizando sintaxis [JSON](https://docs.mongodb.com/manual/tutorial/query-documents/). Uno de estos métodos es `find()` el cual nos permite encontrar aquellos documentos que satisfacen nuestra consulta. 

Una ventaja de los métodos del paquete `mongolite` es que devuelven data frames que podemos manipular e inspeccionar con las funciones locales de R, si realizamos una consulta vacía `{}` se nos devolverán todos los documentos de la colección, si queremos observar los primeros y últimos documentos podemos ejecutar:

```R
head(match$find('{}'))
tail(match$find('{}'))
```

En la consola se muestra:

<p align="center">
<img src="../Imágenes/Postwork7.6.png">
</p>



<br/>

[`Anterior`](../Postwork6) | [`Siguiente`](../Postwork8)      

</div>
