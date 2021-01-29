library(dplyr)
setwd("C:/...")
lista <- lapply(dir(),read.csv)

str(lista)
summary(lista)
head(lista)
View(lista)

lista <- lapply(lista, select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)  

lista <- lapply(lista, mutate, Date = as.Date(Date, "%d/%m/%Y")) #Fecha originalmente es factor

data <- do.call(rbind, lista)

head(data)
tail(lista)
dim(data)

write.csv(data,"C:/Users/JMCas/Directorio_Trabajo/resultado.csv")
