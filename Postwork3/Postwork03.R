library(dplyr)
library(ggplot2)

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

casa <- ggplot(prob.casa.df, aes( x = FTHG, y = Freq))+geom_col()

visita <- ggplot(prob.visita.df, aes( x = FTAG, y = Freq))+geom_col()

conjun <- ggplot(prob.conjunta.df, aes( x = FTHG, y = FTAG, fill = Freq))+geom_tile()
