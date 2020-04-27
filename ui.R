#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Forensic Science Services: glass type analyzer"),
    
    p("Tool for recognition of type of glass, given the chemical characteristics"),
    br(),
    br(),
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            h4("1. Please choose size of the training dataset"),
            sliderInput("dssize", "Traing dataset size", value = 0.7, min = 0.7, max = 0.9, step = 0.05),
                        br(),
            h4("2. Please type in the chemical test results of glass found at crime scene"),
            p("Typical vector of data is: 1.51, 13.00, 3.5, 2, 72, 0.6, 8, 0, 0.1"),
            br(), br(),
            numericInput("Ri", "RI (refractive index): ", value = 0, min = 0.0, width = "30%"),
            numericInput("Na", "Na (Sodium): ", value = 0, min = 0.0, width = "30%"),
            numericInput("Mg", "Mg (Magnesium): ", value = 0, min = 0.0, width = "30%"),
            numericInput("Al", "Al (Aluminum): ", value = 0, min = 0.0, width = "30%"),
            numericInput("Si", "Si (Silicon): ", value = 0, min = 0.0, width = "30%"),
            numericInput("K", "K (Potassium): ", value = 0, min = 0.0, width = "30%"),
            numericInput("Ca", "Ca (Calcium): ", value = 0, min = 0.0, width = "30%"),
            numericInput("Ba", "Ba (Barium): ", value = 0, min = 0.0, width = "30%"),
            numericInput("Fe", "Fe (Iron): ", value = 0, min = 0.0, width = "30%"),
            submitButton("3. Recognize the glass type")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            h2(p("Prediction:")),
            h1(textOutput("RFsumm")),
            br(),br(),
            p("Legend"),
            tableOutput("legend"),
            p("Prediction based on model:"),
            h2("Model statistics"),
            p("Overall"),
            tableOutput("ovrall"),
            p("Statistics by class"),
            tableOutput("ModelSummary"),
            br(),br(),
            p("Date of analysis: "), 
            textOutput("SysDate"),
            br(),br(),
            p("Given results vector: "),
            tableOutput("ChemTestRes"),
            br(),br(),

            p("Given training dataset size: "),
            textOutput("dssize"),
            br(),br()
            )
    )
))
