var histogram = require("ascii-histogram");
var bytes = require("bytes");

var data = {
  bakery: 10.96,
  gate: 456.72
};

console.log();
console.log(histogram(data, { bar: "=" }));
