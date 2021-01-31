#Instalación del paquete
#install.packages("mongolite")

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

#El real jugó un total de 114 partidos pero ninguno en la fecha solicita

match$disconnect( gc = TRUE)
rm(match)
