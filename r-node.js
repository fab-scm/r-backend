var R = require("r-script");

console.log("Test")

// sync
var out = R("ML_AOA.R")
  .data(20)
  .call(function(err, d) {
    if (err) throw err;
    return d;
  });

//console.log(out);