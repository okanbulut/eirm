#' @title Graphical user interface (GUI) of the eirm function
#' @import shiny
#' @importFrom shinydashboard box dashboardHeader dashboardSidebar dashboardBody sidebarMenu tabItem tabItems
#' @importFrom shinycssloaders withSpinner
#' @importFrom readxl read_xlsx
#' @description
#' An interactive Shiny application for running the eirm function. The application allows users
#' to import the (long-format) response data, define the response variable and predictors, and
#' run the estimation, and produce the output, as well as the item-person plot, on the screen.
#'
#' @examples
#' \dontrun{
#' eirmShiny()
#' }
#' @export

eirmShiny <- function() {

  if (!requireNamespace(c("shiny","shinydashboard", "shinycssloaders", "readxl"), quietly = TRUE)) {
    stop("shiny, shinydashboard, shinycssloaders, and readxl are needed for
         eirmShiny. Please install them.",
         call. = FALSE)
  }

  cat("Please wait while loading...\n")

  runApp(appDir = system.file("shiny", package="eirm"), launch.browser = TRUE)

}


