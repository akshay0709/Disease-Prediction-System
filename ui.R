
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(bootstrapPage(
  
  # Application title
  titlePanel("Disease prediction"),
  div(style="float:left; margin-left: 10px",
    id = "form",
    textInput("age", "Age", ""),
    textInput("sex", "Gender", ""),
    textInput("chestpaintype", "Chest Pain Type", ""),
    textInput("restingbp", "Resting blood pressure", ""),
    textInput("cholestrol", "Cholestrol", ""),
    textInput("fastingbloodsugar", "Fasting Blood Sugar", ""),
    textInput("electrocardiographic", "Resting Electrocardiographic results", ""),
    textInput("maxheartrate", "Maximum Heart Rate", ""),
    textInput("exerciseangina", "Exercise Induced Angina", ""),
    textInput("oldpeak", "OldPeak", ""),
    textInput("slopeofpeakexercise", "Slope of peak exercise", "")
   
   
    
  ),
  
  div(style="float:left; margin-left: 10px",
      textInput("ca", "Number of major vessels", ""),
      textInput("thal", "Thal", ""),
      textInput("pregnant", "Times Pregnant", ""),
    textInput("plasma", "Plasma Glucose", ""),
    textInput("bp", "Diastolic Blood Pressure", ""),
    textInput("tricep", "Tricep Skin", ""),
    textInput("insulin", "Serium Insulin", ""),
    textInput("bmi", "Body mass Index", ""),
    textInput("pedigree", "Diabetes Pedigree", ""),
    actionButton("submit","Submit", class="btn-primary")
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    verbatimTextOutput("text")
  )
)
)
