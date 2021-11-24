var express = require('express')
var Rr = require("r-script");
const R = require('r-integration');
var app = express();

var server = app.listen(9090, function () {
    var port = server.address().port
    console.log(`App listening at http://localhost:${port}`)
})

app.get('/sync', (req, res, next) => {
    console.log("sync test")
    var out = Rr("bla.R")
        .data()
        .callSync();
    console.log(out);
})

app.get('/async', (req, res, next) => {
    console.log("async test")
    callMethodAsync("ML_AOA.R", "x", ["2"]).then((result) => {
        console.log(result);
        res.send(result);
    }).catch((error) => {
        console.error(error);
        res.send(error);
    })
})