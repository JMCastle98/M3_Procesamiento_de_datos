library(dplyr)

setwd("C:/Users/JMCas/Directorio_Trabajo/DataSets")

data <- read.csv("match.data.csv")
data$suma <- data$home.score+data$away.score

data <- mutate(data, date = as.Date(date, "%Y-%m-%d"))
data$mes <- format(data$date, "%m")
data$año <- format(data$date, "%Y")

data <- mutate(data, mes = as.integer(mes))
data <- mutate(data, año = as.integer(año))

data2 <- select(data,suma,mes,año)

data3 <- data2 %>% group_by(año,mes) %>% summarize(promedio=mean(suma)) 

(saltos <- data3[which((diff(data3$mes) >1)),])
(reinicios <- data3[which((diff(data3$mes) >1))+1,])

data4 <- filter(data3, mes %in% c(8,9,10,11,12,1,2,3,4,5))
data5 <- filter(data4, año !=2010, año != 2020)

(saltos <- data5[which((diff(data5$mes) >1)),])
(reinicios <- data5[which((diff(data5$mes) >1))+1,])

st1 <- ts(data5$promedio, start = c(2011,1), end = c(2019,12), frequency = 10)

plot.ts(st1, main = "Promedio de goles por año", xlab ="Años",
        ylab = "Promedio de goles", sub = "Serie mensual: Enero 2011 a Diciembre 2019")
