import React from "react";
import { Link, NavLink } from "react-router-dom";

const Sidebar = () => {
  return (
    <div className="border-end bg-white" id="sidebar-wrapper">
      <div className="sidebar-heading border-bottom bg-light">
        <Link to="/" className="navbar-brand">
          Logo
        </Link>
      </div>
      <div className="list-group list-group-flush">
        <NavLink
          to="/dashboard"
          className={({ isActive }) =>
            isActive
              ? "list-group-item list-group-item-action list-group-item-light p-3 active"
              : "list-group-item list-group-item-action list-group-item-light p-3"
          }
        >
          Dashboard
        </NavLink>
        <NavLink
          to="/entrances"
          className={({ isActive }) =>
            isActive
              ? "list-group-item list-group-item-action list-group-item-light p-3 active"
              : "list-group-item list-group-item-action list-group-item-light p-3"
          }
        >
          Entrances
        </NavLink>
      </div>
    </div>
  );
};

export default Sidebar;
