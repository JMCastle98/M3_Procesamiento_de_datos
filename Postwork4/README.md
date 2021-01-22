# Postwork Sesión 4.

#### Objetivos

El objetivo de este postwork es investigar la dependencia o independecia de las variables aleatorias X y Y, que corresponden a el número de goles anotados por el equipo de casa y el número de goles anotados por el equipo visitante con los que hemos trabajado en postworks anteriores.

#### Desarrollo

La definición de **independencia** en teoría de probabilidad podemos encontrarla enunciada como:

*"Dos eventos son independientes si la probabilidad de que ocurran ambos simultáneamente es igual al producto de las probabilidades de que ocurra cada uno de ellos."*

En otras palabras:

*"Dos eventos son independientes si la probabilidad conjunta es igual al producto de las probabilidades marginales independientes."*

Matemáticamente:

<p align="center">
<img src="../Imágenes/Postwork4.1.png" alt=portfolio_view height="150" width="300">
</p>

Ahora investigarás la dependencia o independencia del número de goles anotados por el equipo de casa y el número de goles anotados por el equipo visitante mediante un procedimiento denominado bootstrap, revisa bibliografía en internet para que tengas nociones de este desarrollo. 

1. Ya hemos estimado las probabilidades conjuntas de que el equipo de casa anote X=x goles (x=0,1,... ,8), y el equipo visitante anote Y=y goles (y=0,1,... ,6), en un partido. Obtén una tabla de cocientes al dividir estas probabilidades conjuntas por el producto de las probabilidades marginales correspondientes.

2. Mediante un procedimiento de boostrap, obtén más cocientes similares a los obtenidos en la tabla del punto anterior. Esto para tener una idea de las distribuciones de la cual vienen los cocientes en la tabla anterior. Menciona en cuáles casos le parece razonable suponer que los cocientes de la tabla en el punto 1, son iguales a 1 (en tal caso tendríamos independencia de las variables aleatorias X y Y).
