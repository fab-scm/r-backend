var express = require('express')
const R = require('r-integration');
const fs = require('fs')
var app = express();

var server = app.listen(9090, function () {
    var port = server.address().port
    console.log(`App listening at http://localhost:${port}`)
})

app.get('/sync', (req, res, next) => {
    console.log("sync test")
    let result = R.callMethod("./scripts/bla.R", "z", [""]);
    res.send(result);
    console.log(result);
})

app.get("/egal", (req, res, next) => {
    console.log("testing asyncronously...")

    callMethodAsync("./scripts/ML_AOA.R", "training", [""]).then((result) => {
        //console.log(result)
        callMethodAsync("./scripts/ML_AOA.R", "classifyAndAOA", [""]).then((result) => {
            console.log('ready');
            res.send('ready')
        }).catch((error) => {
            console.error(error);
        })
    }).catch((error) => {
        console.error(error);
    })
})

app.get('/async', (req, res, next) => {
    console.log("async test")

    const myPromise1 = new Promise((resolve, reject) => {
        let result = R.executeRScript("./scripts/training.R");
        if (result[0] == "1"){
            resolve('successfull');
        } else {
            reject('failed');
        } 
    })

    const myPromise2 = new Promise((resolve, reject) => {
        let result = R.executeRScript("./scripts/classifyAndAOA.R");
        if (result[0] == "1"){
            resolve('successfull');
        } else {
            reject('failed');
        } 
    })

    myPromise1.then((message) => {
        console.log('Model training was ' + message);
        myPromise2.then((message) => {
            res.send('Calculation ' + message)
            console.log('Classification and calculation of AOA were ' + message);
        }).catch((message) => {
            res.send('Calculation failed')
            console.log('Classification and calculation of AOA ' + message);
        })
    }).catch((message) => {
        console.log('Model training ' + message);
    })
})


// app.get('/test', (req, res, next) => {
//     console.log("testing...");
//     let result = R.executeRScript("./scripts/classifyAndAOA.R");
//     console.log(result[0]);
//     res.send('Calculation successfull');
// }) 