import React from "react";
import { truncate } from "lodash";
import { Paper } from "@mui/material";
import useMetamaskBalance from "../metamask/useMetamaskBalance";

const AvailableBalance = () => {
  const balance = useMetamaskBalance();

  return (
    <Paper elevation={4} className="m-3 p-4 w-96">
      <span className="font-bold">Available Balance:</span>{" "}
      {truncate(balance, { length: 20 })} ETH
    </Paper>
  );
};

export default AvailableBalance;
