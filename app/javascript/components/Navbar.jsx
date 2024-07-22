import React from "react";
import { Container, Navbar } from "react-bootstrap";
import { NavLink } from "react-router-dom";

const AppNavbar = () => {
  const handleClick = (e) => {
    e.preventDefault();
    document.body.classList.toggle("sb-sidenav-toggled");
    localStorage.setItem("sb|sidebar-toggle", document.body.classList.contains("sb-sidenav-toggled"));
  };

  return (
    <Navbar bg="dark" expand="lg" fixed="top" variant="dark">
      <Container fluid>
        <button className="btn btn-secondary" id="sidebarToggle" onClick={handleClick}>
          Toggle Menu
        </button>
        {/* <button
          className="navbar-toggler"
          type="button"
          data-bs-toggle="collapse"
          data-bs-target="#navbarSupportedContent"
          aria-controls="navbarSupportedContent"
          aria-expanded="false"
          aria-label="Toggle navigation"
        >
          <span className="navbar-toggler-icon"></span>
        </button>
        <div className="collapse navbar-collapse" id="navbarSupportedContent">
          <ul className="navbar-nav ms-auto mt-2 mt-lg-0">
            <li className="nav-item">
              <NavLink
                to="/"
                className={({ isActive }) => (isActive ? "nav-link active" : "nav-link")}
              >
                Home
              </NavLink>
            </li>
          </ul>
        </div> */}
      </Container>
    </Navbar>
  );
};

export default AppNavbar;
