# Datos generales: ¿Cómo han crecido los jugadores, torneos y ganancias generadas a lo largo de los años?

Dan, Explicar un poquito el panorama y que buscas responder, el código es mejor ponerle más comentarios o si quieres ve separando la función, como creas prudente y al final pues ya explicas lo que sale x) 



Los eSports irrumpieron en la escena mundial a finales de los 2000 cuando las compañías de videojuegos deciden apostar e invertir cantidades considerables en el desarrollo de juegos y plataformas que permitieran la competencia multijugador. .....


### FuncionTotal()

Creamos una función, la cual nos muestre historicamente como han cambiado las ganancias, jugadores y torneos por año:

```R
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
  
  # https://stackoverflow.com/questions/1249548/side-by-side-plots-with-ggplot2
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
```

### Resultados 

<p align="center">
<img src="../../Imágenes/Proyecto1.jpeg">
</p>
