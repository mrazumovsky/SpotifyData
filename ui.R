

shinyUI(dashboardPage(
                  skin = 'green',  
  dashboardHeader(title = 'Spotify',
                  titleWidth = "100%"),
  
  dashboardSidebar(
    sidebarUserPanel(name = '',
                     image = 'Spotlogo.jpg'),
    
    sidebarMenu(
      menuItem("Home",tabName = 'home',icon =icon('home')),
      menuItem("Artist",tabName = 'artist',icon = icon('address-book')),
      menuItem('Year',tabName = 'year',icon = icon('calendar')),
      menuItem("Analysis",tabName = 'analysis',icon = icon('dashboard')),
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
                        valueBoxOutput("minpopular",width = 10)))),
      tabItem(tabName = 'artist',
              plotlyOutput("valscatter")),
      tabItem(tabName = 'year',
              fluidRow(column(6,
                              plotlyOutput("time1")),
                       column(6,
                              plotlyOutput("time2")))),
      tabItem(tabName = 'analysis',
              plotlyOutput('correlation')),
      tabItem(tabName = 'data',
              fluidRow(box(DT::dataTableOutput("table"),width = 12)))
      )
    
    )
  )
)