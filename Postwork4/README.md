# Postwork Sesión 4.

#### Objetivos

El objetivo de este postwork es investigar la dependencia o independecia de las variables aleatorias X y Y, que corresponden a el número de goles anotados por el equipo de casa y el número de goles anotados por el equipo visitante con los que hemos trabajado en postworks anteriores.

#### Sobre la independencia en probabilidad

La definición de **independencia** en teoría de probabilidad podemos encontrarla enunciada como:

*"Dos eventos son independientes si la probabilidad de que ocurran ambos simultáneamente es igual al producto de las probabilidades de que ocurra cada uno de ellos."*

En otras palabras:

*"Dos eventos son independientes si la probabilidad conjunta es igual al producto de las probabilidades marginales independientes."*

Matemáticamente:

<p align="center">
<img src="../Imágenes/Postwork4.1.png" alt=portfolio_view height="150" width="300">
</p>

Si son iguales, es lógico decir que el cociente de ambos sea igual a 1:

<p align="center">
<img src="../Imágenes/Postwork4.2.png" alt=portfolio_view height="150" width="300">
</p>

De esta forma podemos garantizar la **independencia** de ambas variables.

#### Desarrollo

En el [Postwork03](/Postwork3/) estimamos las probabilidades conjuntas de que el equipo de casa anote X goles, y el equipo visitante anote Y goles, en un partido. Por lo que el siguiente paso para verificar independencia sería obtener el producto de las probabilidades marginales. Haciendo uso de nuestro archivo `.csv` diseñamos el data frame y cargamos las bibliotecas `ggplot2()` y `dplyr()`:

```R
library(dplyr)
library(ggplot2)
setwd("C:/Users/JMCas/Directorio_Trabajo/DataSets")
data <- read.csv("resultado.csv")

goles <- select(data, FTHG, FTAG)
goles_tabla <- table(goles)

goles_casa <- margin.table(goles_tabla,1)
goles_visita <- margin.table(goles_tabla,2)

prob.casa <- prop.table(goles_casa)
prob.visita <- prop.table(goles_visita)
prob.conjunta <- prop.table(goles_tabla)

prob.casa.df <- as.data.frame(prob.casa)
prob.visita.df <- as.data.frame(prob.visita)
prob.conjunta.df <- as.data.frame(prob.conjunta)
```
Realizar el producto de las probabilidades marginales se simplifica utilizando dos ciclo `for`, uno anidado dentro del otro:

```R
for (i in 1:length(prob.visita.df$Freq)){
  for (j in 1:length(prob.casa.df$Freq)){
    x <- data.frame( "FTHG" = j-1, "FTAG" = i-1, "Freq" = (prob.visita.df$Freq[i])*(prob.casa.df$Freq[j]))
    if (i==1 && j==1 ){
      prob.producto.df <- x
    } else {
      prob.producto.df <- rbind(prob.producto.df,x)
    }
    
  }
}
```
De acuerdo al tamaño de los data frame establecemos la cantidad de iteraciones, en el primer ciclo se establece la estructura del data frame que será similar a los anteriores con los goles jugando en casa `FTHG`, goles como visitante `FTAH` y la probabilidad `Freq`. En el resto de ciclos se iran añadiendo filas al dataframe para las combinaciones de goles restantes. Inspeccionamos ambos data frame:

```R
prob.producto.df
prob.conjunta.df
```

Con ambas probabilidades calculadas, podemos dividir ambas y obtener coeficientes con los cuales verificar la independencia de las variables. Para una mejor observación de los coeficientes y de que combinaciones de los goles de casa (X) y goles de visita (Y) provienen, se diseña un data frame que contenga toda esta información:

```R
coef <- (prob.conjunta.df$Freq)/(prob.producto.df$Freq)
coef.df <- data.frame( "FTHG" = prob.conjunta.df$FTHG , "FTAG" = prob.conjunta.df$FTAG , "Conjun" = prob.conjunta.df$Freq, 
                       "Prod" = prob.producto.df$Freq,"Coef" = coef )
```

Inspeccionando un poco el data frame:

```R
head(coef.df)
tail(coef.df)
```

La consola muestra:

<p align="center">
<img src="../Imágenes/Postwork4.3.png" alt=portfolio_view>
</p>

Observamos algunos valores de los coeficientes, sin embargo podemos obtener más información analizando estos datos si obtenemos el promedio y la desviación estándar, junto a un histograma que muestre la frecuencia con la que se distribuyen:

```R
mean(coef)
sd(coef)
coef.df %>%
  ggplot() + 
  aes(Coef) +
  geom_histogram(bins = 16, col="black", fill = "green") + 
  ggtitle("Histograma de Mediciones") +
  ylab("Frecuencia") +
  xlab("Coeficientes") + 
  theme_light()
```
Sabemos entonces que los coeficientes tienen una media con valor de 0.8595708 y los valores de los coeficientes se alejan de la media aproximadamente en 0.9801441. y el histograma siguiente nos muestra de una manera más gráfica que la mayoría de los coeficientes tienen valores entre 0 y 2:

<p align="center">
<img src="../Imágenes/Postwork44.png" alt=portfolio_view>
</p>

También podemos observar que los coeficientes con valor 0 tienen una alta frecuencia y que valores superiores a 2 tienen muy poca frecuencia. Esto tiene una explicación algo sencilla desde el punto de vista futbolístico:

- **Muchos coeficientes 0**: Si el coeficiente vale cero, esto quiere decir que la probabilidad conjunta vale 0 y al realizar la división también le da un valor 0. Esto sucede cuando el marcador finaliza con resultados difíciles de alcanzar, como goleados 7-1 o partidos muy reñidos 5-4. 
- **Coeficientes superiores a 2**: Esto se da cuando la probabilidad conjunta es mucho más grande que el producto de las marginales. Por ejemplo el marcador 8-2 tiene una probabilidad conjunta baja (0.000877), pero las probabilidades marginales son aún más bajas (1.862e-04). Traduciendo esto, podemos decir que en conjunto es muchisimo más fácil que el marcador en general términe 8-2 en diferentes partidos, a que en un solo partido anotemos 8 goles.

Con solo esta información podriamos discutir la independencia de nuestros eventos. Pero tenemos muy pocos datos con los cuales realizar una afirmación sólida, aquí entra en juego el método boostrap.

#### El método bootstrap: *"Una tarea imposible"*.

*El nombre tiene relación con la especie de correas (straps, en inglés) que tienen las botas (boots, también en inglés) en su parte superior, sobre todo esas botas de vaqueros que vemos en las películas. Bootstrapping es un término que, al parecer, hace referencia a la acción de elevarse a uno mismo del suelo tirando simultáneamente de las correas de las dos botas. Como os dije, una tarea imposible gracias a la tercera ley Newton."* - [Manuel M. Arias](https://anestesiar.org/2015/una-tarea-imposible-la-tecnica-de-bootstrapping/) 


<img src="../Imágenes/Postwork4.5.jpg" align="right" height="200" width="200">

 obtén más cocientes similares a los obtenidos en la tabla del punto anterior. 
 Esto para tener una idea de las distribuciones de la cual vienen los cocientes en la tabla anterior.
 Menciona en cuáles casos le parece razonable suponer que los cocientes de la tabla en el punto 1, son iguales a 1 (en tal caso tendríamos independencia de las variables aleatorias X y Y).
