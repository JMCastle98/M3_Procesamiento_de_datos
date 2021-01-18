# Postwork Sesión 1.

#### Objetivos

1. Con el último data frame obtenido en el postwork de la sesión 2, elaborar tablas de frecuencias relativas para estimar las siguientes probabilidades:

- La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x=0,1,2,)

- La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y=0,1,2,)

- La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como visitante anote y goles (x=0,1,2,, y=0,1,2,)

2. Realiza lo siguiente:

- Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo de casa
- Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo visitante.
- Un HeatMap para las probabilidades conjuntas estimadas de los números de goles que anotan el equipo de casa y el equipo visitante en un partido.

#### Desarrollo

El primer pasó para desarrollar este postwork es 

library(dplyr)
library(ggplot2)

data <- read.csv("resultado.csv")
goles <- table(select(data, FTHG, FTAG))

#Obtención de probabilidades

prob.casa <- as.data.frame(prop.table(margin.table(goles,1)))
prob.visita <- as.data.frame(prop.table(margin.table(goles,2)))
prob.conjunta <- as.data.frame(prop.table(goles))



class(prob.conjunta)
sum(prob.casa)
sum(prob.visita)
sum(prob.conjunta)

#Gráficos

casa <- ggplot(prob.casa, aes( x = prob.casa$FTHG, y = prob.casa$Freq))+geom_col()
visita <- ggplot(prob.visita, aes( x = prob.visita$FTAG, y = prob.visita$Freq))+geom_col()
conjun <- ggplot(prob.conjunta, aes( x = prob.conjunta$FTHG, y = prob.conjunta$FTAG, fill = prob.conjunta$Freq))+geom_tile()
