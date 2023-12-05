import { useContext } from "react";
import { MetamaskContext } from "./MetamaskProvider";

const useMetamaskBalance = () => {
  const metamaskInfo = useContext(MetamaskContext);
  return metamaskInfo.balance;
};

export default useMetamaskBalance;
