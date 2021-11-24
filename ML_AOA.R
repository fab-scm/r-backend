x <- function(data) {

data = 2 * data

#rm(list=ls())
#major required packages:
#needs(raster)
#needs(caret)
#needs(mapview)
#needs(sf)
#needs(devtools)
#install_github("HannaMeyer/CAST")
#needs(CAST)
#additional required packages:
#needs(tmap)
#needs(latticeExtra)
#needs(doParallel)
#needs(parallel)
#needs(Orcs)

#sen_ms <- stack("data/Sen_Muenster.grd")
#print(sen_ms)

#plot(sen_ms)

#trainSites <- read_sf("data/trainingsites_muenster.gpkg")
#print(trainSites)

#viewRGB(sen_ms, r = 3, g = 2, b = 1, map.types = "Esri.WorldImagery")+
#  mapview(trainSites)

#extr <- extract(sen_ms, trainSites, df=TRUE)
#extr <- merge(extr, trainSites, by.x="ID", by.y="PolygonID")
#head(extr)

#set.seed(100)
#trainids <- createDataPartition(extr$ID,list=FALSE,p=0.05)
#trainDat <- extr[trainids,]

#predictors <- names(sen_ms)
#response <- "Label"

#indices <- CreateSpacetimeFolds(trainDat,spacevar = "ID",k=3,class="Label")
#ctrl <- trainControl(method="cv", 
#                     index = indices$index,
#                     savePredictions = TRUE)

# train the model
#set.seed(100)
#model <- ffs(trainDat[,predictors],
#               trainDat[,response],
#               method="rf",
#               metric="Kappa",
#              trControl=ctrl,
#               importance=TRUE,
#               ntree=75)

#print(model)
return(data)
}