import React, { useEffect, useState } from "react";
import { Web3 } from "web3";
import useMetamaskAccount from "../metamask/useMetamaskAccount";
import {
  Button,
  FormControl,
  InputLabel,
  MenuItem,
  Select,
  TextField,
  Typography,
} from "@mui/material";
import useMetamaskBalance from "../metamask/useMetamaskBalance";

const web3 = new Web3(window.ethereum);

const Transfer = () => {
  const senderAddress = useMetamaskAccount();
  const [recipientAddress, setReceipientAddress] = useState("");
  const [amount, setAmount] = useState("");
  const [addresses, setAddresses] = useState([]);
  const balance = useMetamaskBalance();

  useEffect(() => {
    fetch("http://localhost:3434/accounts")
      .then((res) => res.json())
      .then(setAddresses);
  }, []);

  const handleTransfer = (e) => {
    e.preventDefault();
    const amountWei = web3.utils.toWei(amount, "ether");
    const transactionObject = {
      chainId: 8888,
      from: senderAddress,
      to: recipientAddress, // Or use recipientAddress for a direct ETH transfer
      value: amountWei,
      gas: 30000,
      gasPrice: 3000,
    };
    web3.eth.sendTransaction(transactionObject);
  };

  const error = parseFloat(amount) > parseFloat(balance);
  return (
    <form
      className="flex center justify-around w-4/5 mt-5"
      onSubmit={handleTransfer}
    >
      <FormControl className="w-1/3">
        <InputLabel id="to">To</InputLabel>
        <Select
          labelId="to"
          label="To"
          value={recipientAddress}
          onChange={(e) => setReceipientAddress(e.target.value)}
        >
          {addresses.map((address) => (
            <MenuItem key={address} value={address}>
              {address}
            </MenuItem>
          ))}
        </Select>
      </FormControl>
      <FormControl className="w-1/3">
        <TextField
          type="number"
          label="Amount"
          placeholder="00000"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          error={error}
        />
        {error && <Typography color="error">Not enough balance</Typography>}
      </FormControl>
      <Button
        disabled={!recipientAddress || !amount || error}
        type="submit"
        variant="contained"
        color="success"
      >
        Transfer
      </Button>
    </form>
  );
};

export default Transfer;
