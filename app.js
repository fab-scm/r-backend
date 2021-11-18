var express = require('express')
var app = express(); 

app.get('/', function(req, res) {
    res.send("Test")
})

var server = app.listen(9090, function() {
    var port = server.address().port
    console.log(`App listening at http://localhost:${port}`)
})

