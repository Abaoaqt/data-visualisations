library(shiny); library(shinydashboard); library(plotly)


obesity <- read.csv('obesity.csv') #manually summarised from the sourced dataset

obesity$Age_Band <-factor(obesity$Age_Band, levels = c(1,2,3,4,5,6,7,8,9,10,11,12,13),
                          labels = c('2-4', '5-7', '8-11', '12-15', '16-17', '18-24', '25-34',
                                     '35-44', '45-54', '55-64', '65-74', '75-84', '85+'),
                          ordered = TRUE)

ui <- dashboardPage(
  dashboardHeader(title = "Obesity in Australia"),
  
  dashboardSidebar(
    br(),
    h4("This app allows you to view the rates of overweightness and obesity across the different age groups
      in Australia as of 2016. The article inspiring this app can be found ", 
      a("here", href = "http://www.abc.net.au/news/health/2018-04-24/hospitals-cannot-meet-demand-for-obesity-care-study/9689494")
      ),
    
    br(),
    br(),
    h3("Select a Category"),
    selectInput("Selection", "Choose either data for adults or children", 
                choices = c(levels(obesity$Age_Level)),
                selected = "Adult"),
    br(),
    h3("Select Genders"),
    selectInput("Filter", "Choose one or more genders for comparison",
                choices = c(levels(obesity$Gender)),
                multiple = TRUE,
                selected = "Both"),
    
    actionButton("Update", "Update Selections")
      
    ),
    
  dashboardBody(
    fluidRow(
      box(title = 'Percentage of Overweight and Obese Australians', plotlyOutput("bar1"), width = 12)
    ),
    
    fluidRow(
      box(title = 'Percentage of Obese Australians', plotlyOutput("bar2"), width = 6),
      box(title = 'Percentage of Overweight Australians', plotlyOutput("bar3"), width = 6)
    ),
    p("Source: ", a("Australian Institute of Health and Welfare",href = "https://www.aihw.gov.au/reports-statistics/behaviours-risk-factors/overweight-obesity/data"))
  )
)

server <- function(input, output){
  
  df <- eventReactive(input$Update, {
    data.frame(obesity %>% filter(Age_Level == input$Selection & 
                                    Gender %in% input$Filter))
  })
  
  output$bar1 <- renderPlotly({
    plot_ly(data = df(), x = ~Age_Band, y = ~Total, type = 'bar', color = ~Gender, hoverinfo = 'text',
            text = paste('<b> Age Group</b> =',
                         df()$Age_Band,
                         '<br> <b> Gender</b> = ',
                         df()$Gender,
                         '<br> <b> Percentage</b> =',
                         df()$Total, "%")) %>%
      layout(xaxis = list(zeroline = FALSE, title = 'Age Groups'),
             yaxis = list(zeroline = FALSE, range = c(0,100), title = 'Proportion of Total Population (%)')
      )
  })
  
  output$bar2 <- renderPlotly({
    plot_ly(data = df(), x = ~Age_Band, y = ~Obese, type = 'bar', color = ~Gender, hoverinfo = 'text',
            text = paste('<b> Age Group</b> =',
                         df()$Age_Band,
                         '<br> <b> Gender</b> = ',
                         df()$Gender,
                         '<br> <b> Percentage</b> =',
                         df()$Obese, "%")) %>%
      layout(xaxis = list(zeroline = FALSE, title = 'Age Groups'),
             yaxis = list(zeroline = FALSE, range = c(0,50), title = 'Proportion of Total Population (%)')
      )
  })
  
  output$bar3 <- renderPlotly({
    plot_ly(data = df(), x = ~Age_Band, y = ~Overweight, type = 'bar', color = ~Gender, hoverinfo = 'text',
            text = paste('<b> Age Group</b> =',
                         df()$Age_Band,
                         '<br> <b> Gender</b> = ',
                         df()$Gender,
                         '<br> <b> Percentage</b> =',
                         df()$Overweight, "%")) %>%
      layout(xaxis = list(zeroline = FALSE, title = 'Age Groups'),
             yaxis = list(zeroline = FALSE, range = c(0,50), title = 'Proportion of Total Population (%)'))

  })
  
}

shinyApp(ui = ui, server = server)
