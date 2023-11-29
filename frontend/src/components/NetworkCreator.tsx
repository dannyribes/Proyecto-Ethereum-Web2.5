import React from "react";
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
  return (
    <>
      <h3 className=" m-2 font-bold text-lg">Create Network</h3>
      <form className="m-2 flex justify-evenly">
        <FormControl className="w-1/3">
          <InputLabel>Network Number</InputLabel>
          <Select
            label="Network Number"
            id="network-number"
            name="network-number"
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
          <Select label="Node Number" id="node-number" name="node-number">
            {[...Array(5).keys()].map((i) => (
              <MenuItem key={i} value={i + 1}>
                {i + 1}
              </MenuItem>
            ))}
          </Select>
        </FormControl>
        <FormControlLabel control={<Switch />} label="Http Access" />
        <Button color="success" type="submit" variant="contained">
          Create
        </Button>
      </form>
    </>
  );
};

export default NetworkCreator;
