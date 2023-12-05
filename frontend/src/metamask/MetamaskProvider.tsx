import React from "react";
import {
  PropsWithChildren,
  createContext,
  useEffect,
  useMemo,
  useState,
} from "react";
import Web3 from "web3";

type MetamaskInfo = {
  account: string;
  balance: string;
};

export const MetamaskContext = createContext<MetamaskInfo>({
  account: "",
  balance: "",
});

export const MetamaskProvider = ({ children }: PropsWithChildren) => {
  const [account, setAccount] = useState("");
  const [balance, setBalance] = useState("0");
  useEffect(() => {
    async function handleAccountsChanged(accounts) {
      setAccount(accounts[0]);
      const balance = await window.ethereum.request({
        method: "eth_getBalance",
        params: [accounts[0], "latest"],
      });
      const balanceInEther = Web3.utils.fromWei(balance, "ether");
      setBalance(balanceInEther);
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

  const metamaskInfo = useMemo(
    () => ({
      account,
      balance,
    }),
    [account, balance]
  );

  return (
    <MetamaskContext.Provider value={metamaskInfo}>
      {children}
    </MetamaskContext.Provider>
  );
};
