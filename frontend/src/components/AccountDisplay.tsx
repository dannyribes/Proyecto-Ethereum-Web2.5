import { Paper } from "@mui/material";
import React from "react";
import { useEffect, useState } from "react";

const AccountDisplay = () => {
  const [account, setAccount] = useState<any>(null);
  useEffect(() => {
    function handleAccountsChanged(accounts) {
      setAccount(accounts[0]);
    }
    window.ethereum
      .request({ method: "eth_requestAccounts" })
      .then((accounts) => {
        handleAccountsChanged(accounts);
      });
    window.ethereum.on("accountsChanged", handleAccountsChanged);
    return () => {
      window.ethereum.removeListener("accountsChanged", handleAccountsChanged);
    };
  }, []);
  return (
    <Paper
      elevation={5}
      className="w-80 text-ellipsis truncate p-2 text-white bg-gray-600"
    >
      Selected Account: {account}
    </Paper>
  );
};

export default AccountDisplay;
