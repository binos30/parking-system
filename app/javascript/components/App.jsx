import React from "react";
import Navbar from "./Navbar";
import Sidebar from "./Sidebar";
import Routes from "../routes";

export default () => {
  return (
    <>
      <Sidebar />
      <div id="page-content-wrapper">
        <Navbar />
        <section className="container-fluid mt-2">{Routes}</section>
      </div>
    </>
  );
};
