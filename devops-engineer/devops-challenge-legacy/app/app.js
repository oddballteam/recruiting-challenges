const express = require("express");
const fs = require("fs");
const app = express();

app.get("/", (req, res) => res.send("Hello World!"));
app.get("/version", (req, res) => {
  const path = `${__dirname}/version.txt`;
  const version = fs.readFileSync(path, "utf-8");
  res.write(version);
  return res.end();
});
app.listen(3000, () => console.log("Server ready"));
