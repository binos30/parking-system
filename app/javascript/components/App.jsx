import React from "react";
import Navbar from "./Navbar";
import Routes from "../routes";

export default () => {
  return (
    <>
      <Navbar />
      <section className="container">{Routes}</section>
    </>
  );
};
