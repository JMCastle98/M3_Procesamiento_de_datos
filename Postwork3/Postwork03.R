#install.packages("dplyr")
#install.packages("ggplot2")
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

casa <- ggplot(data = prob.casa.df,aes(x=FTHG,y=Freq,fill=FTHG))+
  geom_bar(stat = "identity")+
  theme(legend.position = "none")+
  geom_text(aes(label=(round(Freq,4))),vjust=0, size=3.5)+
  labs(x="Goles de casa", y= "Probabilidad")

visita <- ggplot(data = prob.visita.df,aes(x=FTAG,y=Freq,fill=FTAG))+
  geom_bar(stat = "identity")+
  theme(legend.position = "none")+
  geom_text(aes(label=(round(Freq,4))),vjust=0, size=3.5)+
  labs(x="Goles de visita", y= "Probabilidad")

conjun <- ggplot(prob.conjunta.df, aes( x = FTHG, y = FTAG, fill = Freq))+
  geom_tile()+
  labs(x="Goles de casa", y= "Goles de visita", fill="Probabilidad")

casa
visita
conjun
