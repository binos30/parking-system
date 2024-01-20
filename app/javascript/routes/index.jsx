import React from "react";
import { Navigate, Routes, Route } from "react-router-dom";
import Dashboard from "../components/Dashboard";
import Entrances from "../components/Entrances";
// import Home from "../components/Home";
import ParkingLots from "../components/ParkingLots";
import ParkingSlots from "../components/ParkingSlots";

import EntranceForm from "../components/forms/EntranceForm";
import ParkingLotForm from "../components/forms/ParkingLotForm";

export default (
  <Routes>
    <Route path="/dashboard" element={<Dashboard />} />
    <Route path="/entrances" element={<Entrances />} />
    <Route path="/entrances/new" element={<EntranceForm />} />
    <Route path="/entrances/:id/edit" element={<EntranceForm />} />
    <Route path="/parking_lots" element={<ParkingLots />} />
    <Route path="/parking_lots/new" element={<ParkingLotForm />} />
    <Route path="/parking_lots/:id/edit" element={<ParkingLotForm />} />
    <Route path="/parking_slots" element={<ParkingSlots />} />
    <Route path="*" element={<Navigate to="/dashboard" replace />} />
    {/* <Route path="/" element={<Home />} /> */}
  </Routes>
);
