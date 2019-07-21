

shinyUI(dashboardPage(
                  skin = 'green',  
  dashboardHeader(title = 'Spotify',
                  titleWidth = "100%"),
  
  dashboardSidebar(
    sidebarUserPanel(name = '',
                     image = 'Spotlogo.jpg'),
    
    sidebarMenu(
      menuItem("Home",tabName = 'home',icon =icon('home')),
      menuItem('Year',tabName = 'year',icon = icon('calendar')),
      menuItem("Explore",tabName = 'artist',icon = icon('hourglass-1')),
      menuItem("Analysis",tabName = 'analysis',icon = icon('envelope-open')),
      menuItem("Data",tabName = 'data',icon = icon('table'))),

    selectizeInput("selected",
                   label = "Select Item to Display",
                   choices, selected=T)
    
  ), 
  
  
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    tabItems(
      tabItem(tabName = 'home',
              fluidRow(column(6,
                        valueBoxOutput("maxpopular",width = 10)),
                       column(6,
                        valueBoxOutput("maxpopularyear",width = 10))),
              fluidRow(plotOutput('genre'))
              ),
      tabItem(tabName = 'year',
              fluidPage(
                fluidRow(plotlyOutput("time1")),
                fluidRow(plotlyOutput("time2")))),
      tabItem(tabName = 'artist',
              fluidRow(column(6,plotlyOutput("valscatter")),
                       column(6,plotlyOutput('speech')))),
      tabItem(tabName = 'analysis',
              plotlyOutput('analysis')),
      tabItem(tabName = 'data',
              fluidRow(box(DT::dataTableOutput("table"),width = 12)))
      )
    
    )
  )
)
