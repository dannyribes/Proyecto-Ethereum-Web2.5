var express = require("express");
var router = express.Router();

/* GET home page. */
router.post("/", (req, res, next) => {
  console.log(req.body);
  res.sendStatus(201);
});

module.exports = router;
