# Needs wird zum Laden der Pakete genutzt --> muss mit R Studio installiert werden und dann in der Windows-Konsole als Admin gestartet werden
# https://stackoverflow.com/questions/55562652/calling-r-script-from-node-js-issue-loading-libraries

#Loading packages
#needs(sp)
#needs(sf)
#needs(raster)
#needs(caret)
#needs(mapview)
#needs(CAST)
#needs(tmap)
#needs(latticeExtra)
#needs(doParallel)
#needs(parallel)
#needs(Orcs)


num = strtoi(input[[1]]) * 2

x = 25 

output = x + num

return(output)