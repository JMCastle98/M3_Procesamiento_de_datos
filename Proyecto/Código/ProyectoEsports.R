"###############################################################################
############################## P R O Y E C T O #################################
################################################################################"

setwd("C:/Users/USR/OneDrive/Documents/BEDU/RStudio/Proyecto")

#Librerías que se usarán
library(dplyr)                ##Manejo de dataframes
library(ggplot2)              #Manejo de graficos
library(magrittr)             #Paquetería para optimizar código
library(multipanelfigure)     #Crear multiplanes con ggplot
library(lubridate)            #Manejo de fechas
library(ggrepel)              #Etiquetas/lables separadas en las gráficas
library(tsbox)                #TS_BOX Le permite a ggplot plotear series de tiempo


#Archivos que se usarán

general <- read.csv("GeneralEsportData.csv")
historical <- read.csv("HistoricalEsportData.csv")
earnings <- read.csv("ESport_Earnings.csv")
twitch <- read.csv("twitchdata-update.csv")
ganancias_jugadores <- read.csv("highest_earning_players.csv")
ganancias_equipos<- read.csv("highest_earning_teams.csv")

#Analizamos las características de los archivos
str(general); summary(general)
str(earnings); summary(earnings)
str(historical); summary(historical)
str(twitch); summary(twitch)
str(ganancias_jugadores); summary(ganancias_jugadores)
str(ganancias_equipos); summary(ganancias_equipos)


'Las características del archivo "general" contine información de la fecha del 
lanzamiento de los vídeojuegos, más no así la fecha de los eventos, ni las ganancias 
por evento o jugadores por evento, debido a esto hallamos la primera dificultad, 
la cuál solucionaremos a través de realizar un conjunción de este archivo con el 
archivo de "historical'


#JOIN  - merge() - Nos une dos archivos a partir de una llave
join <- merge(x = general, y = historical, by = "Game", all = TRUE)
join <- mutate(join, Date = as.Date(Date, "%Y-%m-%d"))                #Pasamos a formato de fecha la fecha
str(join)
summary(join)



"***************************************************************************"
"***************************************************************************"
"***************************************************************************"
"***************************************************************************"
"***************************************************************************"

#Creamos una función, la cual nos muestre historicamente como han cambiado 
#las ganancias, jugadores y torneos por año


FuncionTotal <- function(iluminacion1, iluminacion2, iluminacion3){
  # Agrupamos por fecha y a partir de ahí elegimos las características deseadas 
  df <- join %>%
    group_by(Date) %>%
    summarise(Ganancias = sum(Earnings), 
              Jugadores = sum(Players), 
              Torneos = sum(Tournaments) )
  colnames(df) <- c("Temporada","Ganancias","Jugadores","Torneos")
  df <- na.omit(df)
  df <- as.data.frame(df)
  
  
  S1 <- df %>%
    ggplot()+
    aes(x= Temporada, y= Ganancias/10^6 )+
    geom_bar(stat  = "identity",fill = "aquamarine3",
             color = iluminacion1, alpha = 0.85) +
    labs(title="                               Esports a lo largo de los años   \n      
                                          Ganancias en mdd"
         , x = "Años", y =  "") +
    theme_bw()
  
  
  "***************************************************************************"
  S2 <- df %>%
    ggplot()+
    aes(x=Temporada, y= Jugadores)+
    geom_bar(stat  = "identity",fill = "aquamarine2",
             color = iluminacion2,alpha = 0.85) +
    labs(x = "Años", y =  "", title = "                Jugadores") +
    theme_bw()
  
  "***************************************************************************"
  S3 <- df %>%
    ggplot()+
    aes(x=Temporada, y=Torneos)+
    geom_bar(stat  = "identity",fill = "aquamarine3",
             color = iluminacion3,alpha = 0.85)+
    labs(x = "Años", y =  "", title = "                 Torneos") +
    theme_bw()
  
  "***************************************************************************"
  #Creamos el múltipanel en el cual mostraremos las gráficas
  figure1 <- multi_panel_figure(columns = 2, rows = 2, panel_label_type = "none")
  
  figure1
  
  figure1 %<>%
    fill_panel(S1, column = 1:2, row = 1) %<>%
    fill_panel(S2, column = 1, row = 2) %<>%
    fill_panel(S3, column = 2, row = 2)
  figure1
}
FuncionTotal('123','234','236')



"***************************************************************************"
"***************************************************************************"
"***************************************************************************"
"***************************************************************************"
"***************************************************************************"

#Realicemos ahora un análisis por genero:
#Describiremos por genero cuales han sido los juegos con más torneos y ganancias
#(también jugadores y ganancias en línea)

#Localizamos los juegos descritos, después creamos una función donde se describan
#También se cambia el nombre a los generos por detalles estéticos

general$Genre <- gsub(" Game","",general$Genre)
general$Genre[which(general$Genre == "Multiplayer Online Battle Arena")] <- "MOBA"
general$Genre[which(general$Genre == "Role-Playing")] <- "RPG"
general$Genre[which(general$Genre == "Third-Person Shooter")] <- "TPS"
general$Genre[which(general$Genre == "First-Person Shooter")] <- "FPS"
general$Genre[which(general$Genre == "Strategy")] <- "Estrategia"
general$Genre[which(general$Genre == "Collectible Card")] <- "Cartas Coleccionables"
general$Genre[which(general$Genre == "Sports")] <- "Deportes"
general$Genre[which(general$Genre == "Fighting")] <- "Peleas"
general$Genre[which(general$Genre == "Racing")] <- "Carreras"



best_genero <- function(Dato){
  
  df <- general %>% select(Genre,Game,contains(Dato)) 
  
  if (Dato == "TotalTournaments"){
    base <- 1e03
    df <- df %>% group_by(Genre) %>% filter( TotalTournaments == max(TotalTournaments))
    df <- df %>% mutate( Mejor = (TotalTournaments/base))
    xlabel <- "Número de torneos (miles)"
    ylabel <- "Juegos"
    title <- "Juegos con más torneos con base al genero"
  } 
  if (Dato == "TotalEarnings"){
    base <- 1e06
    df <- df %>% group_by(Genre) %>% filter( TotalEarnings == max(TotalEarnings))
    df <- df %>% mutate( Mejor = signif((TotalEarnings/base),3))
    xlabel <- "Premio en mdd"
    ylabel <- "Juegos"
    title <- "Juegos con los mejores premios con base al genero"
  }

  
  df <- df %>% arrange(desc(df[3]))
  
  df$Game <- factor(df$Game,
                    levels = df$Game[order(df[3])])
  
  df$Genre <- factor(df$Genre,
                     levels = df$Genre[order(df[3])])
  
  
  graph <- ggplot(df, aes_string( "Mejor", y= "Game", fill= "Genre" ))+
    geom_col()+
    guides(fill = guide_legend(reverse=T, title = "Genero"))+
    xlab(xlabel)+ylab(ylabel)+ggtitle(title)+
    geom_text(aes(label = Mejor),hjust = -0.1)+
    theme_bw()+
    theme(plot.title = element_text(hjust = 0.5))
    
  
  return(graph)
  
}


(best_genero("TotalEarnings"))
(best_genero("TotalTournaments"))




"***************************************************************************"
"***************************************************************************"
"***************************************************************************"
"***************************************************************************"
"***************************************************************************"
#Analizamos cuales son los juegos con mayor cantidad de seguidores 
#y mayor cantidad de visitas en promedio
twitch.juegos <- function(){

LOL <- twitch %>% slice(grep("Riot", twitch$Channel)) 
DOTA <- twitch %>% slice(grep("dota2ti",twitch$Channel))
df4 <- twitch %>% slice(grep("Rainbow", twitch$Channel))
df5 <- twitch %>% slice(grep("R6", twitch$Channel))
R6 <- rbind.data.frame(df4,df5)
RL <- twitch %>% slice(grep("RocketLeague", twitch$Channel))
CSGO <- twitch %>% slice(grep("ESL_CSGO", twitch$Channel))
HS <- twitch %>% slice(grep("Hearthstone", twitch$Channel))


LOL <-data.frame(Juego = "League of Legends",
                 Prom.Vistas =sum(LOL$Average.viewers), Seguidores = sum(LOL$Followers))

DOTA <- data.frame(Juego = "DOTA 2",
                   Prom.Vistas =sum(DOTA$Average.viewers), Seguidores = sum(DOTA$Followers))

R6 <-data.frame(Juego = "Rainbow 6",
                Prom.Vistas =sum(R6$Average.viewers), Seguidores = sum(R6$Followers))

RL <- data.frame(Juego = "Rocket League", 
                 Prom.Vistas = RL$Average.viewers, Seguidores = RL$Followers)

CSGO <- data.frame(Juego = "Counter Strike", 
                   Prom.Vistas =sum(CSGO$Average.viewers), Seguidores = sum(CSGO$Followers))

HS <- data.frame(Juego = "Hearthstone", 
                 Prom.Vistas = HS$Average.viewers, Seguidores = HS$Followers)

df2 <- rbind.data.frame(LOL,DOTA,R6,RL,CSGO,HS)
colores =  c("#ff0000","#4b0082","#008000","blue","#ffa500","#ee82ee") 

bar1 <- ggplot(df2, aes(x=reorder(Juego,Prom.Vistas),y=Prom.Vistas/1000,))+
  geom_bar(stat="identity", color = colores, fill =  colores)+
  labs(x = "Juegos", y = "Promedio de visitas en miles" )+ 
  theme_bw()


bar2 <- ggplot(df2, aes(x=reorder(Juego,Seguidores),y=Seguidores/10^6, fill = Juego))+
  geom_bar(stat="identity", color = colores, fill = colores   )+
  labs(x = "Juegos", y = "Seguidores en millones" )+
  theme_bw()


#Creamos el múltipanel en el cual mostraremos las gráficas
figure1 <- multi_panel_figure(columns = 2, rows = 2, panel_label_type = "none")

figure1

figure1 %<>%
  fill_panel(bar1, column = 1:2, row = 1) %<>%
  fill_panel(bar2, column = 1:2, row = 2)
figure1


}
twitch.juegos()

"***************************************************************************"
"***************************************************************************"
"***************************************************************************"
"***************************************************************************"
"***************************************************************************"
#Se prosigue a realizar un análisis con las los jugadores que más perciben dinero
#Así como las ganancias por equipo


######################### GANANCIAS_JUGADORES_EQUIPOS #############



#Media de ganancias por generos de un jugador

ganancias_jugadores %>% group_by(Genre) %>%
  summarise( Media = mean(TotalUSDPrize)) %>% arrange(Media)

#Ganancias máximas y mínimas de un jugador por genero

ganancias_jugadores %>% group_by(Genre) %>% 
  filter( TotalUSDPrize == max(TotalUSDPrize)) %>% arrange(desc(TotalUSDPrize))

ganancias_jugadores %>% group_by(Genre) %>% 
  filter( TotalUSDPrize == min(TotalUSDPrize)) %>% arrange(desc(TotalUSDPrize))

#Media de ganancias por generos de un equipo

ganancias_equipos %>% group_by(Genre) %>%
  summarise( Media = mean(TotalUSDPrize)) %>% arrange(Media)

#Ganancias máximas de un equipo por genero

ganancias_equipos %>% group_by(Genre) %>%
  filter( TotalUSDPrize == max(TotalUSDPrize)) %>% arrange(desc(TotalUSDPrize))


"***************************************************************************"
"***************************************************************************"
"***************************************************************************"
"***************************************************************************"
"***************************************************************************"

#Analizamos ahora los países que más han ganado torneos, esto para diferentes 
#generos 


##################### DATASET_EARNINGS ###############################
#Países con más torneos


earnings$Genre <- as.character(earnings$Genre)
earnings$Genre[which(earnings$Genre == "Multiplayer Online Battle Arena")] <- "MOBA"
earnings$Genre[which(earnings$Genre == "First-Person Shooter")] <- "FPS"
earnings$Genre[which(earnings$Genre == "Strategy")] <- "Estrategia"

#Generos que más dinero dan como premio top 4

(top <- earnings %>% group_by(Genre) %>% 
    summarise( TotalMoney = sum(TotalMoney)) %>%
    arrange(desc(TotalMoney)) %>% top_n(4, TotalMoney))

#Torneos ganados por país de estos generos de acuerdo al top

for (i in 1:4) {
  #Filtro del dataset Earnings los gÃ©neros que pertenezcan al top y 
  #la suma de torneos por país, despuÃ©s tomo el top 5 y acomodo descendente
  GENERO <- earnings %>% group_by(Genre, Top_Country) %>%
    filter(Genre == top$Genre[i]) %>%
    summarise( TournamentsCount = sum(TournamentNo)) %>%
    top_n(5, TournamentsCount) %>% arrange(desc(TournamentsCount))
  
  #El Battle Royale solo tiene 5 países en este dataset
  #y uno es el país "None" sin participantes, debe quitarse
  
  if(i==3){
    GENERO <- GENERO %>% filter( Top_Country!= "None")
  }
  
  #Obtengo el porcentaje de torneos de cada país
  GENERO  <- GENERO %>% 
    mutate( porcentaje = signif((TournamentsCount/sum(TournamentsCount))*100,3))
  
  #Obtengo las dimensiones para el ring plot
  GENERO$max <- cumsum(GENERO$porcentaje)
  GENERO$min <- c(0, head(GENERO$max, n=-1))
  #Obtengo la posición espacial de las labels del ring plot
  GENERO$pos <- (GENERO$max + GENERO$min) / 2
  
  #Ordeno en base a los niveles de los factores
  GENERO$Top_Country <- factor(GENERO$Top_Country,
                               levels = GENERO$Top_Country[order(GENERO$porcentaje)])
  #Genero las labels del ring plot
  GENERO$label <- paste0(GENERO$porcentaje, "%")
  
  if(i==1){
    TOP_PAISES <- GENERO
  }
  else{
    TOP_PAISES <- rbind.data.frame(TOP_PAISES,GENERO)
  }
  
}

TOP_PAISES$Top_Country <- as.character(TOP_PAISES$Top_Country)

TOP_PAISES$Top_Country[which(TOP_PAISES$Top_Country == "Viet Nam")] <- "Vietnam"
TOP_PAISES$Top_Country[which(TOP_PAISES$Top_Country == "Thailand")] <- "Tailandia"
TOP_PAISES$Top_Country[which(TOP_PAISES$Top_Country == "Denmark")] <- "Dinamarca"
TOP_PAISES$Top_Country[which(TOP_PAISES$Top_Country == "Korea, Republic of")] <- "Corea"
TOP_PAISES$Top_Country[which(TOP_PAISES$Top_Country == "Sweden")] <- "Suecia"
TOP_PAISES$Top_Country[which(TOP_PAISES$Top_Country == "United States")] <- "Estados Unidos"
TOP_PAISES$Top_Country[which(TOP_PAISES$Top_Country == "Russian Federation")] <- "Rusia"

#Se grafica

TOP_PAISES %>% ggplot( aes(ymax=max, ymin=min, xmax=4, xmin=3, fill=Top_Country))+
  geom_rect(color = "black") + 
  xlim(c(2, 4))+
  coord_polar(theta="y")+ 
  geom_label_repel( x=3.5,aes(y=pos,label=label),size=3,show.legend = FALSE)+
  scale_fill_brewer(palette="Spectral") + 
  facet_wrap("Genre")+
  guides(fill = guide_legend(reverse=F, title = "País"))+
  theme_void()+
  ggtitle("Países que han ganado más torneos por genero")+
  theme(plot.title = element_text(hjust = 0.5, vjust = 2))





"***************************************************************************"
"***************************************************************************"
"***************************************************************************"
"***************************************************************************"
"***************************************************************************"
#Nos surge la duda de que tipo de relación tienen estás variables, por lo que 
#se prosigue a realizar una regresión entre las variables
#Realizamos una función que nos describa la relación que sigue

#join
df <- join %>%
  group_by(Date) %>%
  summarise(Ganancias = sum(Earnings), 
            Jugadores = sum(Players), 
            Torneos = sum(Tournaments))


summary(df); class(df) 
df <- as.data.frame(df)
df <- na.omit(df)
attach(df)
m1 <- lm(Torneos ~ Jugadores)
m2 <- lm(Ganancias ~ Jugadores)
m3 <- lm(Ganancias ~ Torneos)
summary(m1)
summary(m2)
summary(m3)



regresion <- function(){
  
  S1 <- df %>%
    ggplot()+
    aes(x=Jugadores,y = Torneos, color = Date)+
    geom_point()+
    geom_smooth(method = "lm", se = T, color = "red")+
    labs(title="Método de Regresión lineal para las variables involucradas:   
                                Jugadores/Torneos/Ganancias
         ", y="Torneos", 
         x="Jugadores", caption="Esports", colour = "Fecha")+
    theme_bw()
    

  
  "***************************************************************************"
  S2 <- df %>%
    ggplot()+
    aes(x=Jugadores,y = Ganancias/10^6, color = Date)+
    geom_point()+
    geom_smooth(method = "lm", se = T, color = 'red')+
    labs( y="Ganancias en mdd", 
         x="Jugadores", caption="Esports", colour = "Fecha") +
    theme_bw()
  
  
  "***************************************************************************"
  S3 <- df %>%
    ggplot()+
    aes(x=Torneos,y = Ganancias/10^6, color = Date)+
    geom_point()+
    geom_smooth(method = "lm", se = T, color = 'red')+
    labs( y="Ganancias en mdd", 
         x="Torneos", caption="Esports", colour = "Fecha") +
    theme_bw()

  "***************************************************************************"

  figure1 <- multi_panel_figure(columns = 2, rows = 2, panel_label_type = "none")
  
  figure1
  
  figure1 %<>%
    fill_panel(S1, column = 1:2, row = 1) %<>%
    fill_panel(S2, column = 1, row = 2) %<>%
    fill_panel(S3, column = 2, row = 2)
  figure1
  
}
regresion()

par(mfrow = c(2, 2))
#Verificamos que los parámetros residuales vs los de ajuste no sigan un patrón
#así como la gráfica Q-Q se ajuste a la recta
plot(m1)
plot(m2)
plot(m3)
dev.off()



"***************************************************************************"
"***************************************************************************"
"***************************************************************************"
"***************************************************************************"
"***************************************************************************"

#Nos interesa saber el futuro que tendrán estás plataformas y saber si es factible 
#convertirse en un jugadores profesional

df <- join %>%
  group_by(Date) %>%
  summarise(Jugadores = sum(Players), Torneos = sum(Tournaments), Ganancias = sum(Earnings))

df <- df %>% filter( year(Date) >= 2001) #Lubridate


Serie_tiempo <- function(Dato,inicio,fin){
  
  Dato.ts <- ts(Dato, start = c(inicio,1), end =  c(fin,12), freq = 12)
  
  Time <- 1:length(Dato.ts)
  Imth <- cycle(Dato.ts)
  Dato.lm <- lm(log(Dato.ts) ~ Time + I(Time^2) + factor(Imth))
  
  plot(resid(Dato.lm), type = "l", main = "", xlab = "", ylab = "")
  title(main = "Serie de residuales del modelo de regresión ajustado",
        xlab = "Tiempo",
        ylab = "Residuales")
  
  best.order <- c(0, 0, 0)
  best.aic <- Inf
  for(i in 0:2)for(j in 0:2){
    model <- arima(resid(Dato.lm), order = c(i, 0, j))
    fit.aic <- AIC(model)
    if(fit.aic < best.aic){
      best.order <- c(i, 0, j)
      best.arma <- arima(resid(Dato.lm), order = best.order)
      best.aic <- fit.aic
    }
  }
  
  #best.order
  
  acf(resid(best.arma), main = "")
  title(main = "Serie de residuales del modelo ARMA(2, 0) ajustado",
        sub = "Serie de residuales del modelo de regresión ajustado a los datos")
  
  new.time <- seq(length(Dato.ts)+1, length = 36)
  new.data <- data.frame(Time = new.time, Imth = rep(1:12, 3))
  predict.lm <- predict(Dato.lm, new.data)
  predict.arma <- predict(best.arma, n.ahead = 36)
  Dato.pred <- ts(exp(predict.lm + predict.arma$pred), start = 2021, freq = 12)
  
  
  if(all(Dato == df$Torneos)){
    Titulo <- "Total de torneos de Esports por mes"
    ylabel <- "Torneos totales"
  }
  if(all(Dato == df$Jugadores)){
    Titulo <- "Total de participantes en torneos de Esports por mes"
    ylabel <- "Participantes totales"
  }
  
  if(all(Dato == df$Ganancias)){
    Titulo <- "Total de ganancias de Esports por mes"
    ylabel <- "Ganancias totales"
  }
  
  graph <- ts_ggplot(Evolucion = Dato.ts, Prediccion = Dato.pred)+
    theme_tsbox() + scale_color_tsbox()+
    labs(title= Titulo , subtitle = "Serie mensual desde Enero de 2001",
         x="Años", y= ylabel, caption="Predicción de 36 meses")+
    theme(plot.title = element_text(hjust = 0.5),plot.subtitle = element_text(hjust = 0.5))+
    geom_line(size=1)
  
  
  
  return(graph)
  
}


(A1 <- Serie_tiempo(df$Torneos,2001,2020))
(A2 <- Serie_tiempo(df$Jugadores,2001,2020))
(A3 <- Serie_tiempo(df$Ganancias,2001,2020))

