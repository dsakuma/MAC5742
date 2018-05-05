var histogram = require("ascii-histogram");
var bytes = require("bytes");

var data = {
  bakery: 17.49,
  gate: 849.06
};

console.log();
console.log(histogram(data, { bar: "=" }));

var data = {
  bakery: 13.67,
  gate: 156.6
};

console.log();
console.log(histogram(data, { bar: "=" }));

var data = {
  bakery: 20.26,
  gate: 522.47
};

console.log();
console.log(histogram(data, { bar: "=" }));

