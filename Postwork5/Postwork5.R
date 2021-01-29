library(dplyr)
library(fbRanks)

setwd("C:/...")

smalldata <- read.csv("resultado.csv")
smalldata <- select(smalldata,Date:FTAG)
smalldata <- rename(smalldata, date = Date, home.team = HomeTeam, away.team = AwayTeam, home.score = FTHG, away.score = FTAG)

write.csv(smalldata,row.names = F,"soccer.csv")


listasoccer <- create.fbRanks.dataframes("soccer.csv")
anotaciones <- listasoccer$scores
equipos <- listasoccer$teams

fecha <- unique(anotaciones$date)
n <- length(fecha)

ranking <- rank.teams(scores = anotaciones,teams = equipos,max.date = "2020-07-16",min.date = "2017-08-18")


predict(ranking, date=fecha[n])
