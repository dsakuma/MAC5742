var histogram = require("ascii-histogram");
var bytes = require("bytes");

var data = {
  sequential: 22.112,
  openMP: 12.887,
  pthreads: 13.441
};

console.log();
console.log(histogram(data, { bar: "=" }));
