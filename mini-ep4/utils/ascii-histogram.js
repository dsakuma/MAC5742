var histogram = require("ascii-histogram");
var bytes = require("bytes");

var data = {
  bakery: 17.49,
  gate: 849.06
};

console.log();
console.log(histogram(data, { bar: "=" }));
