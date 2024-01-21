import React, { useEffect, useState } from "react";
import { Button, Col, Modal, Row, Table } from "react-bootstrap";
import { Link } from "react-router-dom";
import Errors from "./Errors";
import Loader from "./Loader";
import NoRecords from "./NoRecords";
import { api_v1_bookings_path } from "../core/api_routes";
import { api, ApiError } from "../core/api";
import { useDocumentTitle } from "../core/hooks";

const Bookings = () => {
  const [loading, setLoading] = useState(false);
  const [showParkModal, setShowParkModal] = useState(false);
  const [showUnparkModal, setShowUnparkModal] = useState(false);
  const [errors, setErrors] = useState([]);
  const [bookings, setBookings] = useState([]);

  useDocumentTitle("ParkingSystem | Bookings");

  const getBookings = async (abortController) => {
    try {
      setLoading(true);
      const { signal } = abortController;
      const response = await api.get(api_v1_bookings_path(), { signal });
      setBookings(response.data);
    } catch (error) {
      if (!abortController.signal.aborted) {
        if (error instanceof ApiError) {
          setErrors(error.all());
        } else {
          setErrors([error?.message]);
        }
      }
    } finally {
      setLoading(false);
    }
  };

  const dataTable = () => {
    return (
      <Table striped bordered hover>
        <thead>
          <tr>
            <th>Slot Code</th>
            <th>Vehicle Type</th>
            <th>Plate Number</th>
            <th>Date Park</th>
            <th>Date Unpark</th>
            <th>Fee</th>
            <th width="100">Actions</th>
          </tr>
        </thead>
        <tbody>
          {bookings.map((booking) => (
            <tr key={booking.id}>
              <td>{booking.slot_code}</td>
              <td>{booking.vehicle_type}</td>
              <td>{booking.plate_number}</td>
              <td>{booking.date_park}</td>
              <td>{booking.date_unpark}</td>
              <td>{booking.fee}</td>
              <td className="text-center">{actions(booking.date_park, booking.date_unpark)}</td>
            </tr>
          ))}
        </tbody>
      </Table>
    );
  };

  const content = () => {
    return bookings.length ? dataTable() : <NoRecords />;
  };

  const actions = (date_park, date_unpark) => {
    if (!date_park)
      return (
        <Button
          type="button"
          size="sm"
          variant="outline-success"
          onClick={() => {
            console.log("Park");
            setShowParkModal(!showParkModal);
            // handleSubmit(async (data) => await save(data), onError);
          }}
        >
          <i className="bi bi-p-circle"></i>
        </Button>
      );
    else if (date_park && !date_unpark)
      return (
        <Button
          type="button"
          size="sm"
          variant="outline-danger"
          onClick={() => {
            console.log("Unpark");
            setShowParkModal(!showParkModal);
          }}
        >
          <i className="bi bi-sign-no-parking"></i>
        </Button>
      );
  };

  useEffect(() => {
    const abortController = new AbortController();

    getBookings(abortController).catch(console.error);

    return () => {
      abortController.abort();
    };
  }, []);

  return (
    <>
      {errors.length > 0 && Errors(errors)}
      <Row>
        <Col md={{ span: 8, offset: 2 }}>
          <div className="d-flex justify-content-between align-items-center mb-2">
            <div className="fs-3 fw-bold">Bookings</div>
            <div>
              <Link to="/bookings/new" className="btn btn-primary btn-sm">
                <i className="bi bi-plus-lg me-1"></i>
                New Booking
              </Link>
            </div>
          </div>
          {loading ? <Loader /> : content()}
        </Col>
      </Row>
      <Modal
        centered
        show={showParkModal}
        onHide={() => {
          setShowParkModal(!showParkModal);
        }}
      >
        <Modal.Header closeButton>
          <Modal.Title>Modal heading</Modal.Title>
        </Modal.Header>
        <Modal.Body>Woohoo, you are reading this text in a modal!</Modal.Body>
        <Modal.Footer>
          <Button
            variant="secondary"
            onClick={() => {
              setShowParkModal(!showParkModal);
            }}
          >
            Close
          </Button>
          <Button
            variant="primary"
            onClick={() => {
              setShowParkModal(!showParkModal);
            }}
          >
            Save Changes
          </Button>
        </Modal.Footer>
      </Modal>
    </>
  );
};

export default Bookings;
