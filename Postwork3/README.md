# Postwork Sesión 3
En este postwork se realizan ejercicios correspondientes a la sesión 3 del curso de programación y estadística con R: Análisis Exploratorio de Datos.
Los objetivos del postwork son los siguientes

#### Objetivo

- Realizar descarga de archivos desde internet
- Generar nuevos data frames
- Visualizar probabilidades estimadas con la ayuda de gráficas

#### Requisitos

1. R, RStudio
2. Haber realizado el prework y seguir el curso de los ejemplos de la sesión
3. Curiosidad por investigar nuevos tópicos y funciones de R

#### Desarrollo

Ahora graficaremos probabilidades (estimadas) marginales y conjuntas para el número de goles que anotan en un partido el equipo de casa o el equipo visitante.

1. Con el último data frame obtenido en el postwork de la sesión 2, elabora tablas de frecuencias relativas para estimar las siguientes probabilidades:

- La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x=0,1,2,). 
- La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y=0,1,2,)
- La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como visitante anote y goles (x=0,1,2,, y=0,1,2,)

El último data frame obtenido corresponde a la recopilación de los datos de la Liga Española desde 2017 a 2020, donde se registran la fecha del partido `Date`
el equipo local `HomeTeam`, el equipo visitante `AwayTeam`, los goles del equipo local `FTHG`, los goles del equipo visitante `FTAG` y si ganó el local
o la visita o fue un empate (H/A/D) `FTR`. Ubicamos la carpeta de origen donde se tiene registrado el último data frame.

```R
setwd("C:/...") 
datos <- read.csv("Sesion2PostWork.csv")
```

Hacemos uso de la función table en el data frame, a partir de esto hacemos uso de la frecuencia relativa para obtener la probabilidad. 
Es decir, casos favorables entre casos totales, para cada caso.

```R 
Local <-  table(datos$FTHG)
Local <- as.data.frame(Local)
Local <- data.frame("Goles"=Local[,1],
                    "Proba"= round( (Local[,2])/colSums(Local[2]) , 3))
``` 


```R 
Visita <-  table(datos$FTAG)
Visita <- as.data.frame(Visita)
Visita <- data.frame("Goles"=Visita[,1],
                    "Proba"= round( (Local[,2])/colSums(Visita[2]) , 3))
``` 

```R 
Global <- xtabs(~FTAG+FTHG,datos)
Global <- as.data.frame(Global)
Global <- data.frame("Goles Local"=Global[,1], "Goles Visita" = Global[,2], 
                     "Proba"=round( (Global[,3])/colSums(Global[3]) , 4))
```

2. Realiza lo siguiente:

- Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo de casa.
```R 
casa <- ggplot(Local, aes( x = Goles, y= Proba, fill=Goles))+ 
  geom_col(col="black")+
  ggtitle("Densidad marginal de los goles de casa") +
  xlab("Goles de casa") +
  ylab("Probabilidad")+
  theme_dark()
casa
``` 
- Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo visitante.
```R 
visita <-  ggplot(Visita, aes( x = Goles, y= Proba, fill = Goles))+ 
  geom_col(col="black")+
  ggtitle("Densidad marginal de los goles de visita") +
  xlab("Goles de casa") +
  ylab("Probabilidad")+
  theme_dark()
visita
``` 
- Un HeatMap para las probabilidades conjuntas estimadas de los números de goles que anotan el equipo de casa y el equipo visitante en un partido.
```R 
conjunta <- ggplot(Global, aes( x = Goles.Local, y= Goles.Visita))+
              geom_tile(aes(fill = Proba))+
        ggtitle("Densidad conjunta de los goles anotados") +
        xlab("Goles de casa") +
        ylab("Goles de visita")+
        theme_grey()

conjunta
```
