import Home from "./components/Home";
import NetworkCreator from "./components/NetworkCreator";
import AccountDisplay from "./components/AccountDisplay";
import { AppBar, Typography, Button, Toolbar } from "@mui/material";
import { Link, Route, Routes } from "react-router-dom";

function App() {
  return (
    <main>
      <AppBar className="bg-gray-800" position="static">
        <Toolbar>
          <Typography variant="h5" component={Link} to="/">
            Eth Project
          </Typography>
          <Button
            as={Link}
            to="create-network"
            className="grow ml-8 text-white hover:underline underline-offset-8 mt-1"
          >
            Create Network
          </Button>
          <AccountDisplay />
        </Toolbar>
      </AppBar>
      <Routes>
        <Route index element={<Home />} />
        <Route path="create-network" element={<NetworkCreator />} />
      </Routes>
    </main>
  );
}

export default App;
