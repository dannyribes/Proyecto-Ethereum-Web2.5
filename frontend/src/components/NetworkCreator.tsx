import React, { FormEvent, FormEventHandler, useState } from "react";
import {
  Select,
  MenuItem,
  FormControl,
  InputLabel,
  Switch,
  FormControlLabel,
  Button,
} from "@mui/material";

const NetworkCreator = () => {
  const [networkNumber, setNetworkNumber] = useState<number>();
  const [nodeNumber, setNodeNumber] = useState<number>();
  const [httpAccess, setHttpAccess] = useState(false);

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault();
    fetch("http://localhost:3434/network", {
      method: "POST",
      body: JSON.stringify({ networkNumber, nodeNumber, httpAccess }),
      headers: {
        "Content-Type": "application/json",
      },
    });
  };
  return (
    <>
      <h3 className=" m-2 font-bold text-lg">Create Network</h3>
      <form className="m-2 flex justify-evenly" onSubmit={handleSubmit}>
        <FormControl className="w-1/3">
          <InputLabel>Network Number</InputLabel>
          <Select
            label="Network Number"
            id="network-number"
            name="network-number"
            value={networkNumber}
            onChange={(e) => setNetworkNumber(e.target.value as number)}
          >
            {[...Array(10).keys()].map((i) => (
              <MenuItem key={i} value={i + 1}>
                {i + 1}
              </MenuItem>
            ))}
          </Select>
        </FormControl>
        <FormControl className="w-1/3">
          <InputLabel>Node Number</InputLabel>
          <Select
            label="Node Number"
            id="node-number"
            name="node-number"
            value={nodeNumber}
            onChange={(e) => setNodeNumber(e.target.value as number)}
          >
            {[...Array(5).keys()].map((i) => (
              <MenuItem key={i} value={i + 1}>
                {i + 1}
              </MenuItem>
            ))}
          </Select>
        </FormControl>
        <FormControlLabel
          control={
            <Switch
              value={httpAccess}
              onChange={(_, checked) => console.log(checked)}
            />
          }
          label="Http Access"
        />
        <Button color="success" type="submit" variant="contained">
          Create
        </Button>
      </form>
    </>
  );
};

export default NetworkCreator;
