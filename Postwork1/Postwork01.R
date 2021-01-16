url_csv <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
download.file(url = url_csv, destfile = "SP1.csv", mode = "wb")
datos <- read.csv("SP1.csv")

class(datos)
str(datos)

library(dplyr)
df <- select(datos, FTHG,FTAG)

t1 <- table(df) 

prob.casa <- prop.table(margin.table(t1,1))
prob.visita <- prop.table(margin.table(t1,2))
prob.conjunta <- prop.table(t1)

View(prob.casa)
View(prob.visita)
View(prob.conjunta)

sum(prob.casa)
sum(prob.visita)
sum(prob.conjunta)