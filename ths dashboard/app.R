library(shiny); library(ggplot2); library(shinydashboard); library(lubridate); library(plotly)
tx <- ggplot2::txhousing

tx$date <- ymd(paste0(tx$year,"-",tx$month,"-1"))

ui <- dashboardPage(
  dashboardHeader(title = 'Texas Housing Data'),
  
  dashboardSidebar(
    selectInput("selection", "Select City", 
                choices =  c("City",tx$city), 
                selected = "City"),
    
    sliderInput("dates", "Select Date Range", min = 2000, 
                max = 2015, value = c(2000, 2015))
  ),
  
  dashboardBody(
    fluidRow(
      box(title = 'Median Price of Homes Sold ($)', plotlyOutput("median")),
      box(title = "Total Monthly Sales", plotlyOutput("sales")),
      box(title = "Total Monthly Volume", plotlyOutput("volume")),
      box(title = "Monthly listings", plotlyOutput("list"))
    )
  )
)

server <- shinyServer(function(input, output) {
  output$median <- renderPlotly({
    tx_filt <- tx %>% filter(city == input$selection & year >= input$dates[1] & year <= input$dates[2])
    plot_ly(data = tx_filt) %>% add_trace(x = ~date, y = ~median, mode = 'lines')
  })
  output$volume <- renderPlotly({
    tx_filt <- tx %>% filter(city == input$selection & year >= input$dates[1] & year <= input$dates[2])
    plot_ly(data = tx_filt) %>% add_trace(x = ~date, y = ~volume, mode = 'lines')
  })
  output$sales <- renderPlotly({
    tx_filt <- tx %>% filter(city == input$selection & year >= input$dates[1] & year <= input$dates[2])
    plot_ly(data = tx_filt) %>% add_trace(x = ~date, y = ~sales, mode = 'lines')
  })
  output$list <- renderPlotly({
    tx_filt <- tx %>% filter(city == input$selection & year >= input$dates[1] & year <= input$dates[2])
    plot_ly(data = tx_filt) %>% add_trace(x = ~date, y = ~listings, mode = 'lines')
  })
  
})

shinyApp(ui = ui, server = server)

