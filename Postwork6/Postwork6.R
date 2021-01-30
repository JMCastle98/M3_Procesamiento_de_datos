library(dplyr)
library(lubridate)

setwd("C:/.../DataSets")

df <- read.csv("match.data.csv")

str(df)

df <- mutate(df, sumagoles = (home.score+away.score))

df <- mutate(df, date = as.Date(date, "%Y-%m-%d"))

df <- mutate(df, month= month(date))

df <- mutate(df, year= year(date))

df2 <- select(df, sumagoles,month,year)

df3 <- df2 %>% group_by(year,month) %>%
  summarize(promedio=mean(sumagoles))

df4 <- filter(df3, month %in% c(8,9,10,11,12,1,2,3,4,5))
df5 <- filter(df4, year !=2010, year != 2020)

st <- ts(df5$promedio, start = c(2011,1),freq=10)
plot.ts(st, main = "Promedio de goles por año", xlab ="Años",
        ylab = "Promedio de goles", sub = "Serie mensual: Enero 2011 a Diciembre 2019"
        ,col = "coral3",lwd = 2)
