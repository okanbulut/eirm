
library("eirm")

shinyServer(function(input, output, session) {

  mydata <- shiny::reactive({

    if(!is.null(input$dataset2a)) {
      inFile <- input$dataset2a
      dataset <- readxl::read_xlsx(inFile$datapath, sheet=1)
      data <- as.data.frame(dataset)
      data
    } else

      if(!is.null(input$dataset2b)) {
        inFile <- input$dataset2b
        dataset<- read.csv(inFile$datapath,
                           header = input$header,
                           sep = input$sep,
                           quote = input$quote)
        data<-as.data.frame(dataset)
        data
      } else

        if (is.null(input$dataset2a) & is.null(input$dataset2b))
          return("Please upload data")
  })

  output$resp <- shiny::renderUI({
    textInput(inputId ="resp",label = "Response Variable",value = "")
  })

  output$vars <- shiny::renderUI({

    textInput(inputId ="vars",label ="Please, write all variables with a sign of plus (+) in between of each",value = "")

  })

  output$personid <- shiny::renderUI({
    textInput(inputId ="personid",label = "Person ID Variable",value = "")
  })

  output$param <- shiny::renderUI({
    selectInput(inputId ="param",label = "Select Parameter",choices =c("Easiness","Difficulty"),selected = "Easiness")
  })

  output$check <- shiny::renderUI({
    checkboxInput(inputId ="check",label = "I want to view the item-person plot",value=FALSE)
  })

  output$check2 <- shiny::renderUI({
    checkboxInput(inputId ="check2",label = "Use Intercept",value=FALSE)
  })

  #-------------------- Model Estimation ---------------------#

  test <- shiny::reactive({
    r2 <- input$resp
    data <- mydata()
    data$r2 <-as.factor(data$r2)
    id <- input$personid

    intercept<-(-1)
    if(input$check2==TRUE){
      intercept<- (1)
    }

    # Estimate the model only once
    eirm(formula = paste(r2,"~" ,intercept, "+", input$vars, "+", "(1|",id,")"), data = data)
  })

  #-----------------------------------------------------------#

  output$dicho <- shiny::renderPrint({

    if (is.null(input$dataset2a) && is.null(input$dataset2b))
      return("Please Upload Your Data File")

    if (is.null(input$vars))
      return("Please Define Your Variables")

    mod0 <- test()

    mod0[[2]][,1:4]<-round(mod0[[2]][,1:4],5)
    sig<-c()
    for(i in 1:nrow(mod0[[2]])){

      if(mod0[[2]][i,4]<0.05 & mod0[[2]][i,4]>=0.01 ){sig[i]<-"*  "}
      if(mod0[[2]][i,4]< 0.01 & mod0[[2]][i,4]>=0.001 ){sig[i]<-"** "}
      if(mod0[[2]][i,4]<0.001 ){sig[i]<-"***"}
      if(mod0[[2]][i,4]>=0.05){sig[i]<-""}

    }

    mod0[[2]][,5]<-sig
    colnames(mod0[[2]])<-c("Easiness","S.E","z-value","p-value","Sig.")
    if(input$param=="Difficulty") {
      print(mod0, difficulty=TRUE)
    } else

      print(mod0)
  })

  output$preview <- shiny::renderDataTable({

    data <- mydata()
    return(data)
    },

    options = list(pageLength = 10, info = FALSE))

  output$info <- shiny::renderText({
    paste(p(strong('Package:'), "eirm", tags$a(href="https://okanbulut.github.io/eirm/", "(okanbulut.github.io/eirm)")),
          p(strong('Title:'), "Explanatory Item Response Modeling for Dichotomous and Polytomous Items"),
          p(strong('Package Description:'), "Analysis of dichotomous and polytomous response data using the explanatory item response modeling framework, as described in Stanke & Bulut (2019) <doi:10.21449/ijate.515085> and De Boeck & Wilson (2004) <doi:10.1007/978-1-
4757-3990-9>. Generalized linear mixed modeling is used for estimating the effects of itemrelated and person-related variables on dichotomous and polytomous item responses."),
          p(strong('Package Author:'), "Okan Bulut", tags$a(href="https://sites.google.com/ualberta.ca/okanbulut", "(www.okanbulut.com)")),
          p(strong('e-mail:'), tags$a(href="mailto:bulut@ualberta.ca", "bulut@ualberta.ca")),
          p(strong('Shiny Application Developer:'), "Huseyin Yildiz"),
          p(strong('e-mail:'), tags$a(href="mailto:huseyinyildiz35@gmail.com", "huseyinyildiz35@gmail.com")),
          p(strong('Notes:'), 'This application is developed with', a("Shiny", href="http://www.rstudio.com/shiny/", target="_blank"), 'and',
            a("shinydashboard", href="http://rstudio.github.io/shinydashboard/", target="_blank"), 'and distributed as part of', ' the',
            a("eirm", href="https://CRAN.R-project.org/package=eirm", target="_blank"),"R package by",
            a("Okan Bulut", href="https://sites.google.com/ualberta.ca/okanbulut", target="_blank"),

          ". The application, as well as the eirm package, is free, and can be redistributed and or modified
           under the terms of the GNU General Public License as published by the Free Software Foundation version 3 of the License."))
  })

  output$itemplot <- shiny::renderPlot({
    if (is.null(input$dataset2a) && is.null(input$dataset2b))
      return(NULL)

    if (is.null(input$vars))
      return(NULL)

    if(input$check==FALSE)
      return(NULL)

    mod0 <- test()
    plot(mod0)
  })

  session$onSessionEnded(function() {
    stopApp()
  })

})



