# Needs wird zum Laden der Pakete genutzt --> muss mit R Studio installiert werden und dann in der Windows-Konsole als Admin gestartet werden
# https://stackoverflow.com/questions/55562652/calling-r-script-from-node-js-issue-loading-libraries

#Loading packages
needs(sp)
needs(sf)
needs(raster)
needs(caret)
needs(mapview)
needs(CAST)
needs(tmap)
needs(latticeExtra)
needs(doParallel)
needs(parallel)
needs(Orcs)

#Das Laden der Datei hat nur funktioniert, als alle Dateien der Beispieldaten vorhanden waren.
sen_ms <- stack("./Files/Sen_Muenster.grd")

num = strtoi(input[[1]]) * 3

x = 25 

output = x + num

return(output)
