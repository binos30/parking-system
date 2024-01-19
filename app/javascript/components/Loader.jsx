import React from "react";
import { Container, Spinner } from "react-bootstrap";

const Loader = () => {
  return (
    <Container fluid>
      <div className="d-flex justify-content-center align-items-center">
        <Spinner animation="border" role="status" variant="brand">
          <span className="visually-hidden">Loading...</span>
        </Spinner>
      </div>
    </Container>
  );
};

export default Loader;
