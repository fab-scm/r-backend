x <- function(data) {
    #rm(list=ls())
    data = 2 * data
    return(data)
}

test <- function(data) {
    trainData <- readRDS(data)
    return("works")
}

train <- function() {

    #data = 2 * data

    # R Script for estimation applicabillity tool

    ###################
    # Training script #
    ###################

    # Matching user story
    #####################
    # As a user I want to choose a default machine learning algorithm and provide training data.
    # I want a default model to be set up with my inputs and I want it to be trained with the training data I provided.
    # In the end I want to be able to download the my new model.

    # When is the script used/executed?
    ################################### 
    # If the user chooses a default machine learning algorithm and provides training data.

    # What does the script do?
    ##########################
    # Sets up a default model, trains it with the training data based on satellite imagery and returns the trained model.

    # Inputs
    ########
    # -Information about the algorithm to be used.
    # -Training Polygons
    # -Satellite imagery for the training data (provided by another script and stored on the server)

    # Outputs
    #########
    # -Trained model as .rds file

    rm(list=ls())
    #setwd("./")

    # #major required packages:
    # # library("library", lib.loc="./r-library")
    # # library(raster)
    # # library(caret)
    # # library(mapview)
    # # library(sf)
    # # #library(devtools)
    # # #  install_github("HannaMeyer/CAST")
    # # library(CAST)
    
    # library("sp", lib.loc="./r-library")
    # library("raster", lib.loc="./r-library")
    # library("withr", lib.loc="./r-library") 
    # library("crayon", lib.loc="./r-library")
    # library("ggplot2", lib.loc="./r-library")
    # library("caret", lib.loc="./r-library")
    # library("sf", lib.loc="./r-library")
    # library("CAST", lib.loc="./r-library")      
    # library("lattice", lib.loc="./r-library")
    # library("randomForest", lib.loc="./r-library")

    library(sp)
    library(raster)
    library(withr)
    library(crayon)
    library(ggplot2)
    library(caret)
    library(sf)
    library(CAST)
    library(lattice)
    library(randomForest)
    

    # load raster stack from data directory
    sen_ms <- stack("data/Sen_Muenster.grd")

    # load training data
    trainSites <- read_sf("data/trainingsites_muenster.gpkg")
    #trainSites <- read_sf(data)

    # Ergänze PolygonID-Spalte falls nicht schon vorhanden, um später mit extrahierten Pixeln zu mergen
    trainSites$PolygonID <- 1:nrow(trainSites)

    # Extrahiere Pixel aus den Stack, die vollständig vom Polygon abgedeckt werden
    extr_pixel <- extract(sen_ms, trainSites, df=TRUE)

    # Merge extrahierte Pixel mit den zusätzlichen Informationen aus den 
    extr <- merge(extr_pixel, trainSites, by.x="ID", by.y="PolygonID")

    # 50% der Pixel eines jeden Polygons für das Modeltraining extrahieren
    set.seed(100)
    trainids <- createDataPartition(extr$ID,list=FALSE,p=0.05)
    trainDat <- extr[trainids,]

    ###################
    # Modell Training #
    ###################

    # Prädiktoren und Response festlegen
    predictors <- names(sen_ms)
    response <- "Label"

    # Drei Folds für die Cross-Validation im Modell Training definieren und traincontrol festlegen
    indices <- CreateSpacetimeFolds(trainDat,spacevar = "ID",k=3,class="Label")
    ctrl <- trainControl(method="cv", 
                     index = indices$index,
                     savePredictions = TRUE)

    #Erstellen (Training) des Models
    set.seed(100)
    model <- ffs(trainDat[,predictors],
               trainDat[,response],
               method="rf",
               metric="Kappa",
               trControl=ctrl,
               importance=TRUE,
               ntree=75)
    
    saveRDS(model, file="./tempModel/model.RDS")

    #return(data);
}

classifyAndAOA <- function(data) {

    library(needs)
    library(sp)
    library(raster) 
    library(CAST) 
    library(tmap)
    library(latticeExtra)
    library(doParallel)
    library(parallel)
    library(Orcs)

    sen_ms <- stack("data/Sen_Muenster.grd")
    model <- readRDS("tempModel/model.RDS")

    prediction <- predict(sen_ms,model)
    writeRaster(prediction, "stack/prediction.tif", overwrite=TRUE)

    cl <- makeCluster(4)
    registerDoParallel(cl)
    AOA <- aoa(sen_ms,model,cl=cl)
    writeRaster(AOA, "stack/aoa.tif", overwrite=TRUE)
}