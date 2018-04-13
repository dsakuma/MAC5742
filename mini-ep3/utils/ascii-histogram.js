var histogram = require("ascii-histogram");
var bytes = require("bytes");

var data = {
  0: 125,
  1: 112,
  2: 105,
  3: 90,
  4: 93,
  5: 103,
  6: 92,
  7: 94,
  8: 89,
  9: 97
};

console.log();
console.log(histogram(data, { bar: "=" }));
