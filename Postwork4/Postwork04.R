library(dplyr)
library(ggplot2)
setwd("C:/....")
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


#Hasta aquí es el procedimiento del postwork03

#Cálculo de los productos de las probabilidades marginales

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

#Para comparar los df
prob.producto.df
prob.conjunta.df

#Se hace la división, si da 1 es porque las variables son independientes 
coef <- (prob.conjunta.df$Freq)/(prob.producto.df$Freq)


#Se hace un dataframe para observar en que casos casi da 1
coef.df <- data.frame( "FTHG" = prob.conjunta.df$FTHG , "FTAG" = prob.conjunta.df$FTAG , "Conjun" = prob.conjunta.df$Freq, 
                       "Prod" = prob.producto.df$Freq,"Coef" = coef )

coef.df

#Se revisa la media y desviación de las divisiones, así como el histograma

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

#Aquí empieza el método de bootstrap 
medias <- numeric(5000) #vector de ceros

#Medias de remuestreos
for (i in 1:5000){
  muestra <- sample(coef, replace = T)
  medias[i] <- mean(muestra)
}

#Histograma de las medias
medias.df <- data.frame( "Medias" = medias)


medias.df %>%
  ggplot() + 
  aes(Medias) +
  geom_histogram(col="black", fill = "red") + 
  ggtitle("Histograma de medias de los coeficientes re-muestreados") +
  ylab("Frecuencia") +
  xlab("Medias") + 
  theme_light()


#Media de las medias y desviación
mean(medias)
sd(medias)

#Intervalo de confianza 
quantile(medias, c(0.025, 0.975))

#aplicando el paquete boot de R

library(boot)

coefdf <- data.frame(coef)


#Función que hará de estadístico
media <- function(coefdf, cocientes)
{
  d=coefdf[cocientes,]
  mean(d)
}


#Remuestreo
replicas <- boot(data=coefdf, statistic = media, R=5000)


names(replicas)
hist(replicas$t , main = "Histograma de medias con el paquete boot()",
     xlab = "Medias", ylab = "Frecuencia", col = "blue")


mean(replicas$t)
sd(replicas$t)
