const R = require('r-integration');

console.log("sync test")
let algorithm = "rf"
let result = R.callMethod("./scripts/bla.R", "z", {algorithm: 'rf', trees: 80});
console.log(result);