import React from "react";
import { Routes, Route } from "react-router-dom";
import Dashboard from "../components/Dashboard";
import Entrances from "../components/Entrances";
import Home from "../components/Home";

import EntranceForm from "../components/forms/EntranceForm";

export default (
  <Routes>
    <Route path="/dashboard" element={<Dashboard />} />
    <Route path="/entrances" element={<Entrances />} />
    <Route path="/entrances/new" element={<EntranceForm />} />
    <Route path="/entrances/:id/edit" element={<EntranceForm />} />
    <Route path="/" element={<Home />} />
  </Routes>
);
