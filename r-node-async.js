var R = require("r-script");


// async
var out = R("")
    .data()
    .call(function(err, d) {
        if (err) throw err;
        return d;
    });