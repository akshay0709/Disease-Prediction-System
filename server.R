
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(sqldf)
library(e1071)

shinyServer(function(input, output) {
  
  observeEvent(input$submit,{
    output$text <- renderText({
      
      age <- as.numeric(as.character(input$age))
      sex <- as.factor(input$sex)
      chestpaintype <- as.factor(input$chestpaintype)
      restingbp <- as.numeric(as.character(input$restingbp))
      cholestrol <- as.numeric(as.character(input$cholestrol))
      fastingbloodsugar <- as.factor(input$fastingbloodsugar)
      electrocardiographic <- as.factor(input$electrocardiographic)
      maxheartrate<- as.numeric(as.character(input$maxheartrate))
      exerciseangina<- as.factor(input$exerciseangina)
      oldpeak <- as.numeric(as.character(input$oldpeak))
      slopeofpeakexercise <- as.factor(input$slopeofpeakexercise)
      ca <- as.factor(input$ca)
      thal <- as.factor(input$thal)
      num <- as.factor(0)
      
      #Diabetes Data Input
      
      pregnant <- as.numeric(as.character(input$pregnant))
      plasma <- as.numeric(as.character(input$plasma))
      bp <- as.numeric(as.character(input$bp))
      tricep <- as.numeric(as.character(input$tricep))
      insulin <- as.numeric(as.character(input$insulin))
      bmi <- as.numeric(as.character(input$bmi))
      pedigree<- as.numeric(as.character(input$pedigree))
      #dbage <- as.numeric(as.character(input$dbage))
      class <-  as.factor(0)
      
      
      
      
      DiabetesTestData <- data.frame("times.pregnant" = pregnant, "plasma.glucose" = plasma, "diastolic.bp" = bp, "triceps.skin" = tricep, "serium.insuline" = insulin, "bmi" = bmi, "diabetes.pedigree" = pedigree,"age" = age, "class" = class)
      write.csv(DiabetesTestData, file="DiabetesTestData.csv", row.names = FALSE)
      diabetesCsvData <- read.csv("DiabetesTestData.csv")
      
      #Code for HeartDisease
      HeartTestData <- data.frame("Age" = age, "Sex" = sex, "chesp.pain.type" = chestpaintype, "resting.bp" = restingbp, "cholestrol" = cholestrol, "fasting.blood.sugar" = fastingbloodsugar, "electrocardiographic" = electrocardiographic,"maximum.heart.rate" = maxheartrate, "exercise.induced.angina" = exerciseangina, "oldpeak" = oldpeak, "slope.of.peak.exercise" = slopeofpeakexercise, "ca" = ca, "thal" = thal, "num" = num)
      write.csv(HeartTestData, file="hearttestData.csv", row.names = FALSE)
      csvTestData <- read.csv("hearttestData.csv")
      db<-dbConnect(SQLite(), dbname="diseasedb")
      sqldf("attach 'diseasedb' as new")
      
      dbWriteTable(conn = db, name = "Heart", value = csvTestData , row.names= FALSE, header = FALSE, append = TRUE)
      
      dbWriteTable(conn = db, name = "DiabetesData", value = diabetesCsvData , row.names= FALSE, header = FALSE, append = TRUE)
      HeartDiseaseData <- dbReadTable(db,"Heart")
      
      DiabetesData <- dbReadTable(db,"DiabetesData")
      
      
      HeartDiseaseData$num[HeartDiseaseData$num > 0] <- 1
      
      namesFactor <- c(2:3,6:7,9,11:14)
      HeartDiseaseData[,namesFactor] <- lapply(HeartDiseaseData[,namesFactor], as.factor)
      namesNumeric <- c(1,4:5,8,10)
      HeartDiseaseData[,namesNumeric] <- lapply(HeartDiseaseData[,namesNumeric], as.numeric)
      HeartTestData <- tail(HeartDiseaseData,1)
      Heartmodel <- naiveBayes(num~., data = HeartDiseaseData)
      Heartresult <- predict(Heartmodel,HeartTestData)
      
      
      #Diabetes
      numericvalues <- c(1:8)
      DiabetesData[,numericvalues] <- lapply(DiabetesData[,numericvalues], as.numeric)
      factorValues <- c(9)
      DiabetesData[,factorValues] <- as.factor(as.character(DiabetesData[,factorValues]))
      
      DiabetesTestData <- tail(DiabetesData,1)
      
      DiabetesModel <- naiveBayes(class~., data = DiabetesData)
      DiabetesResult <- predict(DiabetesModel, DiabetesTestData)
      
      if(Heartresult ==1 && DiabetesResult== 1)
      {
        displayMessage <- "There is a possibility of Heart disease and Diabetes."
      }
      else if(Heartresult == 0 && DiabetesResult == 1)
      {
        displayMessage <- "There is a possibility of Diabetes."
      }
      else if(Heartresult == 1 && DiabetesResult == 0)
      {
        displayMessage <- "There is a possibility of Heart disease."
      }
      else
      {
        displayMessage<- "No disease present."
      }
      paste(displayMessage)
    })
  })
})
