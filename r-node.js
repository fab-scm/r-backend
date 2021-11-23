var R = require("r-script");

console.log("Test")

// sync
var out = R("ex-sync.R")
  .data(20)
  .callSync();

console.log(out);