import React from "react";
import { Routes, Route } from "react-router-dom";
import Dashboard from "../components/Dashboard";
import Home from "../components/Home";

export default (
  <Routes>
    <Route path="/dashboard" element={<Dashboard />} />
    <Route path="/" element={<Home />} />
  </Routes>
);
