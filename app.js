// express
const express = require('express')
const app = express();

// r-integration
const R = require('r-integration');

// initialize server on port 9090
var server = app.listen(9090, function () {
    var port = server.address().port
    console.log(`App listening at http://localhost:${port}`)
})




// async prototype
app.get("/async", (req, res, next) => {
    console.log("testing asyncronously...")
    let algorithm = '"rf"';
    let trees = 75;
    callMethodAsync("./scripts/ML_AOA.R", "training", {algorithm: 'rf', trees: 75}).then((result) => {
        console.log(result)
        callMethodAsync("./scripts/ML_AOA.R", "classifyAndAOA", ["success"]).then((result) => {
            console.log(result);
            res.send('success')
        }).catch((error) => {
            console.error(error);
        })
    }).catch((error) => {
        console.error(error);
    })
})


// sync test route
app.get('/test', (req, res, next) => {
    console.log("sync test")
    let algorithm = "rf"
    let result = R.callMethod("./scripts/test.R", "z", {algorithm: 'rf', trees: 75});
    res.send(result);
    console.log(result);
})


// app.get('/async', (req, res, next) => {
//     console.log("async test")

//     const myPromise1 = new Promise((resolve, reject) => {
//         let result = R.executeRScript("./scripts/training.R");
//         if (result[0] == "1"){
//             resolve('successfull');
//         } else {
//             reject('failed');
//         } 
//     })

//     const myPromise2 = new Promise((resolve, reject) => {
//         let result = R.executeRScript("./scripts/classifyAndAOA.R");
//         if (result[0] == "1"){
//             resolve('successfull');
//         } else {
//             reject('failed');
//         } 
//     })

//     myPromise1.then((message) => {
//         console.log('Model training was ' + message);
//         myPromise2.then((message) => {
//             res.send('Calculation ' + message)
//             console.log('Classification and calculation of AOA were ' + message);
//         }).catch((message) => {
//             res.send('Calculation failed')
//             console.log('Classification and calculation of AOA ' + message);
//         })
//     }).catch((message) => {
//         console.log('Model training ' + message);
//     })
// })