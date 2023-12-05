import { Paper } from "@mui/material";
import React from "react";
import { useEffect, useState } from "react";
import Web3 from "web3";
import useMetamaskAccount from "../metamask/useMetamaskAccount";

const AccountDisplay = () => {
  const account = useMetamaskAccount();
  return (
    <Paper
      elevation={5}
      className="w-80 text-ellipsis truncate p-2 text-white bg-gray-600 justify-self-end"
    >
      Selected Account: {account}
    </Paper>
  );
};

export default AccountDisplay;
