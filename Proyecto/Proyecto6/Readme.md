# Países: ¿Quién ha ganado más torneos?


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


TOP_PAISES %>% ggplot( aes(ymax=max, ymin=min, xmax=4, xmin=3, fill=Top_Country))+
  geom_rect(color = "black") + 
  xlim(c(2, 4))+
  coord_polar(theta="y")+ 
  geom_label_repel( x=3.5,aes(y=pos,label=label),size=3,show.legend = FALSE)+
  scale_fill_brewer(palette="Spectral") + 
  facet_wrap("Genre")+
  guides(fill = guide_legend(reverse=F, title = "País"))+
  theme_void()+
  ggtitle("Países que han ganado más torneos por género")+
  theme(plot.title = element_text(hjust = 0.5, vjust = 2))

#geom_label_repel es de ggrepel
