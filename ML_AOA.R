rm(list=ls())
#major required packages:
needs(raster)
needs(caret)
needs(mapview)
needs(sf)
#needs(devtools)
#install_github("HannaMeyer/CAST")
needs(CAST)
#additional required packages:
needs(tmap)
needs(latticeExtra)
needs(doParallel)
needs(parallel)
needs(Orcs)

sen_ms <- stack("Files/Sen_Muenster.grd")
#print(sen_ms)

# rgbplot_ms <- spplot(sen_ms[[1]],  col.regions="transparent",sp.layout =rgb2spLayout(sen_ms[[1:3]], quantiles = c(0.02, 0.98), alpha = 1))

sen_mr <- stack("Files/Sen_Marburg.grd")
# rgbplot_mr <- spplot(sen_mr[[1]],  col.regions="transparent",sp.layout =rgb2spLayout(sen_mr[[1:3]], quantiles = c(0.02, 0.98), alpha = 1))

# plot(sen_ms)

trainSites <- read_sf("Files/trainingsites_muenster.gpkg")
#print(trainSites)

#viewRGB(sen_ms, r = 3, g = 2, b = 1, map.types = "Esri.WorldImagery")
  # mapview(trainSites)

extr_pixel <- extract(sen_ms, trainSites, df=TRUE)
extr <- merge(extr_pixel, trainSites, by.x="ID", by.y="PolygonID")
# head(extr)

set.seed(100)
trainids <- createDataPartition(extr$ID,list=FALSE,p=0.05)
trainDat <- extr[trainids,]

predictors <- names(sen_ms)
response <- "Label"

indices <- CreateSpacetimeFolds(trainDat,spacevar = "ID",k=3,class="Label")
ctrl <- trainControl(method="cv", 
                     index = indices$index,
                     savePredictions = TRUE)

# train the model
set.seed(100)
model <- ffs(trainDat[,predictors],
               trainDat[,response],
               method="rf",
               metric="Kappa",
               trControl=ctrl,
               importance=TRUE,
               ntree=75)

