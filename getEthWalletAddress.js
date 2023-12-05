const fs = require("fs");
const ethers = require("ethers");

const data = fs
  .readFileSync(
    "./UTC--2023-11-29T23-20-10.599257713Z--5c78815158d7acbc59401c12202f2c20d8e165c3"
  )
  .toString("utf-8");

const wallet = ethers.Wallet.fromEncryptedJsonSync(data, "my-secret-pw");

console.log("Private Key: ", wallet.privateKey);
console.log("Address: ", wallet.address);
console.log("Public Key: ", wallet.publicKey);
