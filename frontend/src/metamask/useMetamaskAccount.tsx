import { useContext } from "react";
import { MetamaskContext } from "./MetamaskProvider";

const useMetamaskAccount = () => {
  const metamaskInfo = useContext(MetamaskContext);
  return metamaskInfo.account;
};

export default useMetamaskAccount;
