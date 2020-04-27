#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
# install.packages("mlbench")
# install.packages("caret")
library(mlbench)
library(caret)
library(randomForest)
library(e1071)
set.seed(56789)
data(Glass)
cn <- names(Glass)[1:9]

desc<- c("building_windows_float_processed",
"building_windows_non_float_processed",
"vehicle_windows_float_processed",
"vehicle_windows_non_float_processed (none in this database)",
"containers",
"tableware",
"headlamps")

leg <- data.frame(
    cbind(
    seq(1:length(desc)), desc)
    )
colnames(leg) <- c("Type", "Type of glass")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    dss <- reactive({input$dssize})
    trainIndex <- reactive({createDataPartition(Glass$Type, p=dss(), list=FALSE)})
    trainData <- reactive({Glass[trainIndex(),]})
    testData <- reactive({Glass[-trainIndex(),]})
    mtry <- reactive({sqrt(ncol(trainData()))})
    metric <- reactive({"Accuracy"})
    tunegrid <- reactive({expand.grid(.mtry=c(1:9))})
    control <- reactive({trainControl(method="repeatedcv", number=10, repeats=3, search="grid")})
    set.seed(56789)
    rf <- reactive({train(data=trainData(), Type ~ ., method = "rf", metric=metric(), tuneGrid=tunegrid(), trControl=control())})
    testres <- reactive({
        predict(rf(), newdata = testData())
    })
    ms <- reactive({
        confusionMatrix(testres(), reference = testData()[,10])
        })
    msbyClass <- reactive({ cbind (row.names(ms()$byClass), round(ms()$byClass, 2) )
                            })
    msOvrall <- reactive({ cbind (names(ms()$overall), round( ms()$overall, 2) )
        })
    rv <- reactive({rbind(Glass[,c(1:9)],
                          c(input$Ri, input$Na, input$Mg, input$Al, input$Si, input$K,input$Ca, input$Ba, input$Fe))[length(Glass[,1])+1,]
    })

    pred <- reactive({
        predict(rf(), newdata = (rv()))
        })


    
    output$RFsumm = renderText(as.character(pred()))
    output$SysDate = renderText(as.character(tme))
    output$ChemTestRes = renderTable(rv())
    output$dssize = renderText(dss())
    output$ModelSummary = renderTable((msbyClass()))
    output$legend = renderTable(leg)
    output$ovrall= renderTable(msOvrall())
    })
tme <- Sys.time()