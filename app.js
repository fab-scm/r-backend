var express = require('express')
//var R = require("r-script");
const R = require('r-integration');
const fs = require('fs')
var app = express();

var server = app.listen(9090, function () {
    var port = server.address().port
    console.log(`App listening at http://localhost:${port}`)
})

app.get('/sync', (req, res, next) => {
    console.log("sync test")
    let result = R.callMethod("bla.R", "x", {input: 2, upload: 4});
    res.send(result);
    console.log(result);
})

app.get('/async', (req, res, next) => {
    console.log("async test")
    // callMethodAsync("ML_AOA.R", "train", [""]).then((result) => {
    //     console.log(result);
    //     // callMethodAsync("ML_AOA.R", "classifyAndAOA", [""]).then((result) => {
    //     //     console.log(result);
    //     //     res.send('calculation done')
    //     // }).catch((error) => {
    //     //     console.error(error);
    //     //     res.send(error);
    //     // })
    //     res.send(result);
    // }).catch((error) => {
    //     console.error(error);
    //     res.send(error);
    // })

    let result = R.executeRScript("./test.R");
    console.log(result);
})


app.get('/test', (req, res, next) => {
    console.log("async test")
    callMethodAsync("ML_AOA.R", "classifyAndAOA", [""]).then((result) => {
        console.log(result);
        res.send(result);
    }).catch((error) => {
        console.error(error);
        res.send(error);
    })
}) 