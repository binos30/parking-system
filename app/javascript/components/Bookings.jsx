import React, { useEffect, useState } from "react";
import { Button, Col, Form, Modal, OverlayTrigger, Row, Table, Tooltip } from "react-bootstrap";
import { Link } from "react-router-dom";
import { FormProvider, useForm } from "react-hook-form";
import Errors from "./Errors";
import Loader from "./Loader";
import NoRecords from "./NoRecords";
import {
  api_v1_entrances_path,
  api_v1_bookings_path,
  api_v1_booking_park_vehicle_path,
  api_v1_booking_unpark_vehicle_path,
} from "../core/api_routes";
import { api, ApiError } from "../core/api";
import { currencyFormatter, formatDate } from "../core/helpers";
import { useDocumentTitle } from "../core/hooks";

const Bookings = () => {
  const methods = useForm({
    defaultValues: { date_park: "", date_unpark: "" },
  });
  const { formState, handleSubmit, register, reset } = methods;
  const { isSubmitting } = formState;
  const [entrances, setEntrances] = useState([]);
  const [loading, setLoading] = useState(false);
  const [showParkModal, setShowParkModal] = useState(false);
  const [showUnparkModal, setShowUnparkModal] = useState(false);
  const [errors, setErrors] = useState([]);
  const [formErrors, setFormErrors] = useState([]);
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

  const onPark = async (data) => {
    setFormErrors([]);
    try {
      const abortController = new AbortController();
      await api.put(api_v1_booking_park_vehicle_path(data.id), data);
      getBookings(abortController).catch(console.error);
      setShowParkModal(false);
    } catch (error) {
      if (error instanceof ApiError) {
        setFormErrors(error.all());
      } else {
        setFormErrors([error?.message]);
      }
    }
  };

  const onUnpark = async (data) => {
    setFormErrors([]);
    try {
      const abortController = new AbortController();
      await api.put(api_v1_booking_unpark_vehicle_path(data.id), data);
      getBookings(abortController).catch(console.error);
      setShowUnparkModal(false);
    } catch (error) {
      if (error instanceof ApiError) {
        setFormErrors(error.all());
      } else {
        setFormErrors([error?.message]);
      }
    }
  };

  const onError = (data) => {
    console.error(data);
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
              <td>{booking.date_park && formatDate(booking.date_park)}</td>
              <td>{booking.date_unpark && formatDate(booking.date_unpark)}</td>
              <td>{currencyFormatter.format(booking.fee)}</td>
              <td className="text-center">{actions(booking)}</td>
            </tr>
          ))}
        </tbody>
      </Table>
    );
  };

  const content = () => {
    return bookings.length ? dataTable() : <NoRecords />;
  };

  const actions = (booking) => {
    if (!booking.date_park)
      return (
        <OverlayTrigger placement="top" overlay={<Tooltip id="tooltip">Park Vehicle</Tooltip>}>
          <Button
            type="button"
            size="sm"
            variant="outline-success"
            onClick={() => {
              reset({ id: booking.id, date_park: "", date_unpark: "" });
              setShowParkModal(!showParkModal);
            }}
          >
            <i className="bi bi-p-circle"></i>
          </Button>
        </OverlayTrigger>
      );
    else if (booking.date_park && !booking.date_unpark)
      return (
        <OverlayTrigger placement="top" overlay={<Tooltip id="tooltip">Unpark Vehicle</Tooltip>}>
          <Button
            type="button"
            size="sm"
            variant="outline-danger"
            onClick={() => {
              reset({ id: booking.id, date_park: "", date_unpark: "" });
              setShowUnparkModal(!showUnparkModal);
            }}
          >
            <i className="bi bi-sign-no-parking"></i>
          </Button>
        </OverlayTrigger>
      );
  };

  useEffect(() => {
    const abortController = new AbortController();
    const getEntrances = async () => {
      try {
        const response = await api.get(api_v1_entrances_path(), {
          signal: abortController.signal,
        });
        const entranceOptions = response.data.map((entrance) => ({
          label: entrance.name,
          value: entrance.id,
        }));
        setEntrances(entranceOptions);
      } catch (error) {
        if (!abortController.signal.aborted) {
          if (error instanceof ApiError) {
            setFormErrors(error.all());
          } else {
            setFormErrors([error?.message]);
          }
        }
      }
    };

    getEntrances().catch(console.error);
    getBookings(abortController).catch(console.error);

    return () => {
      abortController.abort();
    };
  }, []);

  return (
    <>
      {errors.length > 0 && Errors(errors)}
      <Row>
        <Col md={{ span: 10, offset: 1 }}>
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
          <Modal.Title>Park Vehicle</Modal.Title>
        </Modal.Header>
        <FormProvider {...methods}>
          <Form onSubmit={handleSubmit(onPark, onError)}>
            <Modal.Body>
              {formErrors.length > 0 && Errors(formErrors)}
              <Form.Group className="mb-3">
                <Form.Label htmlFor="entrance_id">Entrance</Form.Label>
                <Form.Select required {...register("entrance_id")} id="entrance_id">
                  <option value="">Select</option>
                  {entrances.map((type, index) => (
                    <option key={index} value={type.value}>
                      {type.label}
                    </option>
                  ))}
                </Form.Select>
              </Form.Group>
              <Form.Group className="mb-3">
                <Form.Label htmlFor="date_park">Date Park</Form.Label>
                <Form.Control
                  required
                  id="date_park"
                  type="datetime-local"
                  aria-label="Date and time"
                  {...register("date_park")}
                />
              </Form.Group>
            </Modal.Body>
            <Modal.Footer>
              <Button
                variant="secondary"
                onClick={() => {
                  setShowParkModal(!showParkModal);
                }}
              >
                Close
              </Button>
              <Button type="submit" variant="primary" disabled={isSubmitting}>
                Save Changes
              </Button>
            </Modal.Footer>
          </Form>
        </FormProvider>
      </Modal>
      <Modal
        centered
        show={showUnparkModal}
        onHide={() => {
          setShowUnparkModal(!showUnparkModal);
        }}
      >
        <Modal.Header closeButton>
          <Modal.Title>Unpark Vehicle</Modal.Title>
        </Modal.Header>
        <FormProvider {...methods}>
          <Form onSubmit={handleSubmit(onUnpark, onError)}>
            <Modal.Body>
              {formErrors.length > 0 && Errors(formErrors)}
              <Form.Group className="mb-3">
                <Form.Label htmlFor="date_unpark">Date Unpark</Form.Label>
                <Form.Control
                  required
                  id="date_unpark"
                  type="datetime-local"
                  aria-label="Date and time"
                  {...register("date_unpark")}
                />
              </Form.Group>
            </Modal.Body>
            <Modal.Footer>
              <Button
                variant="secondary"
                onClick={() => {
                  setShowUnparkModal(!showUnparkModal);
                }}
              >
                Close
              </Button>
              <Button type="submit" variant="primary" disabled={isSubmitting}>
                Save Changes
              </Button>
            </Modal.Footer>
          </Form>
        </FormProvider>
      </Modal>
    </>
  );
};

export default Bookings;
