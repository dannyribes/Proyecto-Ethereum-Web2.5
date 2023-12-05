import React from "react";
import { Button } from "@mui/material";
import { PropsWithChildren } from "react";
import { Link } from "react-router-dom";

type NavLinkProps = PropsWithChildren<{ to: string }>;

const NavLink = ({ children, to }: NavLinkProps) => {
  return (
    <Button
      as={Link}
      to={to}
      className="grow ml-8 text-white hover:underline underline-offset-8 mt-1"
    >
      {children}
    </Button>
  );
};

export default NavLink;
