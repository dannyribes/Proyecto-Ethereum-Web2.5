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
    <div className="w-80 text-ellipsis truncate">
      Selected Account: {account}{" "}
    </div>
  );
};

export default AccountDisplay;
