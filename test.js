const R = require('r-integration');

console.log("sync test")
let algorithm = "rf"
let result = R.callMethod("./scripts/test.R", "z", {algorithm: 'rf', trees: [80, 5]});
console.log(result);