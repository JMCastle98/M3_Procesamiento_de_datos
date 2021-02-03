#Instalación del paquete
#install.packages("mongolite")
#install.packages("dplyr")

library(mongolite)

#Conexión utilizando la url que usamos para Compass
mi_url <- "mongodb://[username:password@]host1[:port1][,host2[:port2],...[/[database][?options]]"

#Instrucción mongo() para conexión
match <- mongo(collection = "match",
           db = "match_games", 
           url = mi_url)

print(match)

#Conteo de los documentos en la colección
match$count()

#Despliegue de los documentos
head(match$find('{}'))
tail(match$find('{}'))

#Partidos en la fecha solicita 

match$find(
  query = '{"Date": "2015-12-20"}'
)

#No hay partidos con esa fecha, buscamos los partidos 
#que se jugaron ese día en otros años

match$find(
  query = '{"Date" : { "$regex" : "-12-20$", "$options" : "i" }}'
)

#El Real Madrid no jugo en esos partidos, veamos que partidos 
#jugó como local o visitante

match$count(
  query = '{"$or" : [{"AwayTeam": "Real Madrid"},{"HomeTeam": "Real Madrid"}]}'
)

#El real jugó un total de 114 partidos pero ninguno en la fecha solicitada

#Proponemos incluir el dataset de la temporada 2015-2016

setwd("C:/.../DataSets")

SP2015_2016 <- read.csv("SP2015_2016.csv")

library(dplyr)

SP2015_2016 <- mutate(SP2015_2016, Date = as.Date(Date, "%d/%m/%y"))

#Filtramos los campos correctos del data frame
SP2015_2016 <-SP2015_2016 %>% 
  select(Date,HomeTeam,AwayTeam,FTHG,FTAG,FTR)

#El método insert nos permite añadir documentos a la colección
  
match$insert(SP2015_2016)  

#Nuevo conteo de documentos totales
match$count()

#Encontramos los partidos de esa fecha
match$find(
  query = '{"Date": "2015-12-20"}'
)

#Buscamos si en esa fecha el Real Madrid jugó como visitante o en casa
match$find(
  query = '{"$and" : [{"Date": "2015-12-20"},
  {"$or" : [{"AwayTeam": "Real Madrid"},{"HomeTeam": "Real Madrid"}]}]}'
)

#El real Madrid ganó por goleada ese día

match$disconnect( gc = TRUE)
rm(match)
