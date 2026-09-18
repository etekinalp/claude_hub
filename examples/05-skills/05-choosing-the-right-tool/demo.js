function add(a, b) {
  console.log("adding", a, b);
  return a + b;
}

function subtract(a, b) {
  console.log("subtracting", a, b);
  return a - b;
}

module.exports = { add, subtract };
