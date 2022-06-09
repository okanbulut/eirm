
library("eirm")

shinydashboard::dashboardPage(skin = "blue",
                              shinydashboard::dashboardHeader(title = "EXPLANATORY ITEM RESPONSE MODELING (eirm Package)",titleWidth = 750),
                              shinydashboard::dashboardSidebar(
                                shinydashboard::sidebarMenu(
                                  id="sidebarmenu",
                                  shinydashboard::menuItem("About the Package",tabName = "info",icon = icon("info-circle")),
                                  shinydashboard::menuItem("Import Dataset",tabName = "preview",icon = icon("table")),
                                  shinydashboard::menuItem("Analyze",tabName = "dicho",icon = icon("cogs")),
                                  shinydashboard::menuItem("Item-Person Plot",tabName = "itemplot",icon = icon("chart-line"))

                      )),

                      shinydashboard::dashboardBody(
                        shinydashboard::tabItems(
                          shinydashboard::tabItem(tabName = "dicho",
                                shiny::fluidRow(column(8,
                                                       shinydashboard::box(title="Output",verbatimTextOutput("dicho") %>%
                                                                             shinycssloaders::withSpinner(color="#0dc5c1",type=6,size = 1.5), solidHeader = TRUE,status = "info",width = 12)),
                                                column(4,
                                                       shinydashboard::box(title = "Define Variable Names",status = "warning",solidHeader = TRUE,width = 12,
                                                                           shiny::uiOutput(outputId="resp"),
                                                                           shiny::uiOutput(outputId="vars"),
                                                                           shiny::uiOutput(outputId="personid"),
                                                                           shiny::uiOutput(outputId="param"),
                                                                           shiny::uiOutput(outputId="check"),
                                                                           shiny::uiOutput(outputId="check2"),
                                                                           shiny::submitButton("Submit")
                                                )))),

                          shinydashboard::tabItem(tabName = "preview",
                                                  shiny::fluidRow(
                                                  shinydashboard::box(title = "Uploading Files",status = "warning",solidHeader = TRUE,width = 3,
                                                                        shiny::fileInput("dataset2a", "Choose .xls or .xlsx file", placeholder="File",buttonLabel = "Browse",accept = c(".xlsx",".xls")),
                                                                        shiny::h3("OR"),
                                                                        shiny::h3(" "),
                                                                        shiny::fileInput("dataset2b", "Choose .csv file", placeholder="File",buttonLabel = "Browse",accept = c(".csv")),

                                      # Input: Checkbox if file has header ----
                                      shiny::checkboxInput("header", "Header", TRUE),

                                      # Input: Select separator ----
                                      shiny::radioButtons("sep", "Separator",
                                                          choices = c(Comma = ",",
                                                                      Semicolon = ";",
                                                                      Tab = "\t"),
                                                          selected = ","),

                                      # Input: Select quotes ----
                                      shiny::radioButtons("quote", "Quote",
                                                   choices = c(None = "",
                                                               "Double Quote" = '"',
                                                               "Single Quote" = "'"),
                                                   selected = '"')

                                  ),

                                  shinydashboard::box(title = "Data Preview", solidHeader = TRUE, status = "info",
                                                      shiny::dataTableOutput("preview") %>%
                                                      shinycssloaders::withSpinner(color="#0dc5c1",type=6,size = 1.5),width = 9)

                                )),

                          shinydashboard::tabItem(tabName = "info",
                                                  shiny::fluidRow(
                                                    shinydashboard::box(title = "About Package", solidHeader = TRUE, status = "info",
                                                                         shiny::htmlOutput("info"), width = 12)
                                )),

                          shinydashboard::tabItem(tabName = "itemplot",
                                                  shiny::fluidRow(

                                                    shinydashboard::box(title = "Item-Person Plot", solidHeader = TRUE, status = "info",
                                                                        shiny::plotOutput("itemplot") %>%
                                                                          shinycssloaders::withSpinner(color="#0dc5c1",type=6,size = 1.5),width = 10)
                                ))
                      ))
                    )
