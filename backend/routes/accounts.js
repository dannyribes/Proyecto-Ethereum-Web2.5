var express = require("express");
const { Web3 } = require("web3");
var router = express.Router();

const web3 = new Web3("http://localhost:8545");

router.get("/", (req, res) => {
  web3.eth.getAccounts().then((accounts) => {
    res.send(accounts);
  });
});

module.exports = router;
