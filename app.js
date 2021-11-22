var express = require('express')
var app = express(); 

app.get('/', function(req, res) {
    res.send("Test")
})

var server = app.listen(9090, function() {
    var port = server.address().port
    console.log(`App listening at http://localhost:${port}`)
})

// Versuch das r-script über eine Route, also auf dem Server laufen zu lassen - funktioniert noch nicht
// glaube das Problem liegt an der Ausführung von needs - versucht die Packages über meine vorhandenen Packages zu installieren
// wie schaffe ich es eine library in meinem Repository anzulegen, auf welche zurückgegriffen wird?
/*var R = require("r-script");

app.get('/', (req, res, next) => {
    console.log("Test")

    // sync
    var out = R("ex-sync.R")
        .data(20)
        .callSync();

    console.log(out);
})*/