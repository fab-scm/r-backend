var express = require('express')
//var R = require("r-script");
const R = require('r-integration');
const fs = require('fs')
var app = express();

var server = app.listen(9090, function () {
    var port = server.address().port
    console.log(`App listening at http://localhost:${port}`)
})

let parameters = {
    "data": [
        "rf",
        "test", 
        "1", 
        "2", 
        "3" 

    ]
}

JSON.stringify(parameters)

//test = JSON.parse(parameters)

app.get('/', (req, res, next) => {
    console.log(typeof(parameters.data[0]))
    res.send("Gehe weiter zu /response um das r-Script zu starten")
})


app.get('/sync', (req, res, next) => {
    console.log("sync test")
    let result = R.callMethod("bla.R", "x", {input: 2, upload: 4});
    res.send(result);
    console.log(result);
})

app.get('/async', (req, res, next) => {
    console.log("async test")
     callMethodAsync("ML_AOA.R", "train", [""]).then((result) => {
        console.log(result);
        callMethodAsync("ML_AOA.R", "classifyAndAOA", [""]).then((result) => {
            console.log(result);
            res.send('calculation done')
        }).catch((error) => {
            console.error(error);
            res.send(error);
        })  
        res.send(result);
     }).catch((error) => {
    console.error(error);
    res.send(error);
})

    let result = R.executeRScript("./test.R");
    console.log(result);
})

app.get('/response', (req, res, next) => {
    console.log("response test")
    callMethodAsync("aoaAreas.R", "predictAreas", {algorithm: "rf", data: '[5]'}).then((result) => {
        console.log(result)
        res.send(result)
    }).catch((error) => {
        console.error(error)
        res.send(error)
    })
})

app.get('/a', (req, res, next) => {
    callMethodAsync("aoaAreas.R", "test", {algorithm: "xgbTree", data: '[400, 6, 0.05, 0.01, 0.75, 0.50, 0]'}).then((result) => {
        console.log(result)
        res.send(result)
    }).catch((error) => {
        console.log(error)
        res.send(error)
    })
})

