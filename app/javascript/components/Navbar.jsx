import React from "react";
import { Container, Nav, Navbar } from "react-bootstrap";

const AppNavbar = () => {
  return (
    <Navbar bg="primary" expand="lg" sticky="top" variant="dark">
      <Container fluid>
        <Navbar.Brand href="/">Logo</Navbar.Brand>
        <Navbar.Toggle aria-controls="basic-navbar-nav" />
        <Navbar.Collapse id="basic-navbar-nav">
          <Nav className="me-auto">
            <Nav.Link href="/">Home</Nav.Link>
          </Nav>
        </Navbar.Collapse>
      </Container>
    </Navbar>
  );
};

export default AppNavbar;
