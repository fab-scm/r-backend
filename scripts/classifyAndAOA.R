library(needs)
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

success <- 1
print(success)