# Postwork sesión 8. Dashboard 

#### Objetivos

Para este postwork generar un dashboard en un solo archivo `app.R`, para esto realiza lo siguiente: 

- Ejecutar el código `momios.R`

- Almacenar los gráficos resultantes en formato `png` 

- Crear un dashboard donde se muestren los resultados con 4 pestañas:
   
- Unir con las gráficas de barras, donde en el eje de las x se muestren los goles de local y visitante con un menu de selección, con una geometria de tipo barras además de hacer un facet_wrap con el equipo visitante
   
- Realizar una pestaña donde agregues las imágenes de las gráficas del postwork 3
    
- En otra pestaña colocar el data table del fichero `match.data.csv` 
    
- Por último en otra pestaña agregar las imágenes de las gráficas de los factores de ganancia mínimo y máximo

Nota: Si se tienen problemas con el codificado guardar el archivo `app.R` con la codificacion `UTF-8`.

#### Desarrollo
    
Para poder ejecutar la app.R necesitaremos de dos paquetes `dplyr` y `shiny`, además establaceremos nuestro directorio de trabajo como la misma carpeta donde se guarda la app y leemos nuestro archivo `match.data.csv` del cual nos interesan los campos de goles de casa y visitante:

```R
library(shiny)
library(dplyr)
setwd("C:/..../Postwork8")
match.data <- read.csv("match.data.csv")
scores <- select(match.data, home.score,away.score)
```

La parte del código que representa nuestro *front-end*, es decir, lo que ve el usuario de la app es la siguiente:

```R
ui <- fluidPage(
  
  # Titulo del panel
  titlePanel("Postwork 8"),
  
  # Sidebar con las opciones para elegir el eje x 
  sidebarLayout(
    sidebarPanel(
      p("Crear gráfica de barras",
        selectInput("x", "Seleccione el valor de X",
                    choices = names(scores))
      )
    ),
    
    
    mainPanel(
      #Agregando pestañas
      tabsetPanel(              # <-----------
                                tabPanel("Gráfica de barras",   #Pestaña de gr{aficas}  <-----------
                                         h3(textOutput("output_text")), 
                                         plotOutput("output_plot"),
                                ),
                                
                                tabPanel("Imágenes Postwork 3",  #Pestaña de imágenes <-----------
                                         img( src = "Postwork3.1.png", 
                                              height = 262, width = 538),
                                         img( src = "Postwork3.2.png", 
                                              height = 262, width = 538),
                                         img( src = "Postwork3.3.png", 
                                              height = 262, width = 538)
                                ), 
                                
                                
                                tabPanel("Data Table", dataTableOutput("d1")),    # Salida del data table <-----------
                                tabPanel("Factores de ganancia",         #Salida de factores de ganancia
                                         img( src = "momios1.png", 
                                              height = 459, width = 782),
                                         img( src = "momios2.png", 
                                              height = 459, width = 782),
                                )              
      ) 
      
    )
  )
)

```

Mientras que la parte del código que representa nuestro *back-end* donde los datos se procesa es la siguiente:


```R
server <- function(input, output) {
  
  output$output_text <- renderText(paste(input$x)) #Titulo del main Panel
  
  #Gráficas                       <----------
  output$output_plot <- renderPlot(hist(scores[,input$x],xlab = input$x, main = paste("Gráfica de",input$x),breaks=10))
  #plot( as.formula(paste("home.score ~ ", input$x)),
  # data = match.data) )
  
  
  
  #Agregando el data table       <----------
  
  output$d1 <- renderDataTable( {match.data}, 
                                options = list(aLengthMenu = c(5,25,50),
                                               iDisplayLength = 5)
  )
  
}

# Run the application 
shinyApp(ui = ui, server = server)

```



