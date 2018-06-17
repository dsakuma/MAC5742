var histogram = require("ascii-histogram");
var bytes = require("bytes");

var data = {
  sequencial: 22.112,
  cuda: 12.887
};

console.log();
console.log(histogram(data, { bar: "=" }));
