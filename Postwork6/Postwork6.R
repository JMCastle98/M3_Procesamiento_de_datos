library(dplyr)
library(lubridate)

setwd("C:/.../DataSets")

df <- read.csv("match.data.csv")

str(df)

df <- mutate(df, sumagoles = (home.score+away.score))

df <- mutate(df, date = as.Date(date, "%Y-%m-%d"))

df <- mutate(df, month= floor_date(df$date, "month"))

df2 <- select(df, sumagoles,month)

df3 <- df2 %>% group_by(month) %>%
  summarize(promedio=mean(sumagoles))

st <- ts(df3[,2], start = c(2010,8),freq=12)

plot.ts(st, main = "Promedio de goles por año", xlab ="Años",
        ylab = "Promedio de goles", sub = "Serie mensual: Agosto 2010 a Diciembre 2018")

         