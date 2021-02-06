# Datos generales: ¿Cómo han crecido los jugadores, torneos y ganancias generadas a lo largo de los años?



Los Esports irrumpieron en la escena mundial a finales de los 2000 cuando las compañías de videojuegos decideron apostar e invertir cantidades considerables en el desarrollo de juegos y plataformas que permitieran la competencia multijugador, a partir de entonces una cantidad considerable de personas se unieron a estás plataformas, lo que trajo consigo un aumento en el número de jugadores, ganancias y torneos.

A contunación se desarrolla un panorama del como han crecido las variables mencionadas a lo largo de los últimos 20 años. 

Para esto vamos a crear una función donde se nos permita visualizar está información.


### FuncionTotal()

Creamos una función, la cual nos muestre historicamente como han cambiado las ganancias, jugadores y torneos por año:
Lo primero que se realiza en la función es mandar a llamar al dataset de join, el cuál contiene la información conjunta de dos dataset, GeneralEsportData.csv e  HistoricalEsportData.csv.

```R
#Creamos la función donde nuestros parámetros son sólo los colores en los que visualizaremos las gráficas

FuncionTotal <- function(iluminacion1, iluminacion2, iluminacion3){

  
                                                                        # Creamos una variable df donde almacenaremos un dataframe, el cual
   df <- join %>%                                                       #Agrupamos por fecha y a partir de ahí elegimos las variables deseadas 
    group_by(Date) %>%
    summarise(Ganancias = sum(Earnings),                                #Las variables deseadas son las ganancias, los jugadores y los torneos
              Jugadores = sum(Players),                                 #para conocer como han cambiado
              Torneos = sum(Tournaments) )
  colnames(df) <- c("Temporada","Ganancias","Jugadores","Torneos")      #Rescribimos las columnas
  df <- na.omit(df)                                                     #Omitimos valores nulos y lo reescribimos como un dataframe
  df <- as.data.frame(df)
  ```
  
  Una vez que tenemos el nuevo dataframe, proseguimos a agrupar las variables a pares para ser gráficadas, esto a través de la librería de ggplot2, para esto creamos tres variables donde almacenaremos las gráficas para después ser llevada a su visualización.
  
  ```R 
              
                              # GRÁFICA DE GANANACIAS EN MILLONES DE DOLARES CONTRA AÑOS
                  
  S1 <- df %>%
    ggplot()+                                                            
    aes(x= Temporada, y= Ganancias/10^6 )+                                  #A la variable ganancias al ser tan elevada la tomamos en millones de dolares
    geom_bar(stat  = "identity",fill = "aquamarine3",                       #Agreamos las carácteristicas a cada gráfico
             color = iluminacion1, alpha = 0.85)+
    labs(title="Esports a lo largo de los años   \n      
                       Ganancias en mdd"
         , x = "Años", y =  "") +
    theme_bw()
  
  
  "***************************************************************************"
              
                              # GRÁFICA DE JUGADORES CONTRA AÑOS
                  
  S2 <- df %>%
    ggplot()+
    aes(x=Temporada, y= Jugadores)+
    geom_bar(stat  = "identity",fill = "aquamarine2",
             color = iluminacion2,alpha = 0.85) +
    labs(x = "Años", y =  "", title = "                Jugadores") +
    theme_bw()
  
  "***************************************************************************"
               
                              # GRÁFICA DE TORNEOS CONTRA AÑOS
                  
  S3 <- df %>%
    ggplot()+
    aes(x=Temporada, y=Torneos)+
    geom_bar(stat  = "identity",fill = "aquamarine3",
             color = iluminacion3,alpha = 0.85)+
    labs(x = "Años", y =  "", title = "                 Torneos") +
    theme_bw()
   ```
   
   Una vez almacenadas las tres gráfica en distintas variables, creamos un panel con la función  multi_panel_figure() que nos sirvirá para visualizar las tres gráficas en una sola imagen
   
   ```R 

  figure1 <- multi_panel_figure(columns = 2, rows = 2, panel_label_type = "none")       #Creamos la variable del panel y le asignamos sus características 
  
  figure1                                                                               #Visualizamos el panel previamente
  
  figure1 %<>%
    fill_panel(S1, column = 1:2, row = 1) %<>%                                          #Le asignamos las variables con los gráficos y la posición en la que se encontrarán
    fill_panel(S2, column = 1, row = 2) %<>%
    fill_panel(S3, column = 2, row = 2)
  figure1
}

FuncionTotal('123','234','236')                                                          #Llamamos a la función donde se visualizará nuestro gráfica
```

### Resultados 

<p align="center">
<img src="../../Imágenes/Proyecto1.jpeg">
</p>

Como podemos notar, ha existido un crecimiento acelarado en cada una de estás tres variables en los últimos 20 años, por lo que es los deportes eléctronicos parecen una apuesta prometedora hacía los siguientes años, esto visto desde un panorama general, pero ¿Qué tipo de juegos más impacto y por qué? Debemos proseguir a investigar esto más adelante.
