predictAreas <- function(data) {

    rm(list=ls())
    #major required packages:
    library(raster)
    library(caret)
    library(mapview)
    library(sf)
    #library(devtools)
    #install_github("HannaMeyer/CAST")
    library(CAST)
    #additional required packages:
    library(tmap)
    library(latticeExtra)
    library(doParallel)
    library(parallel)
    library(Orcs)

    #Load raster data 
    sen_ms <- stack("data/Sen_Muenster.grd")

    #Create rgb plot 
    rgbplot_ms <- spplot(sen_ms[[1]],  col.regions="transparent",sp.layout =rgb2spLayout(sen_ms[[1:3]], quantiles = c(0.02, 0.98), alpha = 1))

    #Load the vector data (training sites)
    trainSites <- read_sf("data/trainingsites_muenster.gpkg")

    #Extract raster information
    extr <- extract(sen_ms, trainSites, df=TRUE)
    extr <- merge(extr, trainSites, by.x="ID", by.y="PolygonID")
    head(extr)

    #Reduce of the data frame to improve the running time 
    set.seed(100)
    trainids <- createDataPartition(extr$ID,list=FALSE,p=0.05)
    trainDat <- extr[trainids,]

    #Define predictor and response variable 
    predictors <- names(sen_ms)
    response <- "Label"

    #Model training
    indices <- CreateSpacetimeFolds(trainDat,spacevar = "ID",k=3,class="Label")
    ctrl <- trainControl(method="cv", 
                        index = indices$index,
                        savePredictions = TRUE)
    
    # train the model
    #set.seed(100)
    #model <- ffs(trainDat[,predictors],
    #            trainDat[,response],
    #            method="rf",
    #            metric="Kappa",
    #            trControl=ctrl,
    #            importance=TRUE,
    #            ntree=75)

    model <- readRDS("./tempModel/model.RDS")
    
    # get all cross-validated predictions:
    cvPredictions <- model$pred[model$pred$mtry==model$bestTune$mtry,]
    # calculate cross table:
    table(cvPredictions$pred,cvPredictions$obs)

    #Model prediction 
    prediction <- predict(sen_ms,model)
    cols <- c("sandybrown", "green", "darkred", "blue", "forestgreen", "lightgreen", "red")

    tm_shape(deratify(prediction)) +
    tm_raster(palette = cols,title = "LUC")+
    tm_scale_bar(bg.color="white",bg.alpha=0.75)+
    tm_layout(legend.bg.color = "white",
                legend.bg.alpha = 0.75)

    #Area of Applicability 
    cl <- makeCluster(4)
    registerDoParallel(cl)
    AOA <- aoa(sen_ms,model,cl=cl)

    improveArea <- spplot(AOA$AOA,col.regions=c("grey","transparent"))

   # writeRaster(spplot(AOA$AOA,col.regions=c("grey","transparent")), ".testData/improve.tiff")

    print(AOA$AOA)
    #print(improveArea)



}