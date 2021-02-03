#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
setwd("C:/Users/Edgar/Documents/curso de python/BEDU/RStudio/Postworks/8/")
match.data <- read.csv("match.data.csv")
scores <- select(match.data, home.score,away.score)


# Define UI for application
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
                                      
                                      
                                      tabPanel("Data Table", dataTableOutput("d1")),    # salida del data table <-----------
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

# Define server logic
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
