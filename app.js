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
    let result = R.callMethod("./scripts/bla.R", "x", {input: 2, upload: 4});
    res.send(result);
    console.log(result);
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
            console.log('Classification and calculation of AOA was ' + message);
        }).catch((message) => {
            console.log('Classification and calculation of AOA ' + message);
            res.send('Calculation completed')
        })
    }).catch((message) => {
        console.log('Model training ' + message);
    })
})


app.get('/test', (req, res, next) => {
    console.log("testing...");
    let result = R.executeRScript("./scripts/training.R");
    console.log(result[0]);
    res.send(result);
}) 