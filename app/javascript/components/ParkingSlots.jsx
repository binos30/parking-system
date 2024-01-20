import React, { useEffect, useState } from "react";
import { Col, Row, Table } from "react-bootstrap";
import Errors from "./Errors";
import Loader from "./Loader";
import NoRecords from "./NoRecords";
import { api_v1_parking_slots_path } from "../core/api_routes";
import { api, ApiError } from "../core/api";
import { PARKING_SLOT_TYPES } from "../core/constants";
import { useDocumentTitle } from "../core/hooks";

const ParkingSlots = () => {
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState([]);
  const [parkingSlots, setParkingSlots] = useState([]);

  useDocumentTitle("ParkingSystem | Parking Slots");

  const getParkingSlots = async (abortController) => {
    try {
      setLoading(true);
      const { signal } = abortController;
      const response = await api.get(api_v1_parking_slots_path(), { signal });
      setParkingSlots(response.data);
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
            <th>Code</th>
            <th>Type</th>
            <th>Distances</th>
            <th>Parking Lot</th>
          </tr>
        </thead>
        <tbody>
          {parkingSlots.map((parkingSlot) => (
            <tr key={parkingSlot.id}>
              <td>{parkingSlot.code}</td>
              <td>{PARKING_SLOT_TYPES[parkingSlot.slot_type]}</td>
              <td>{parkingSlot.distances}</td>
              <td>{parkingSlot.parking_lot}</td>
            </tr>
          ))}
        </tbody>
      </Table>
    );
  };

  const content = () => {
    return parkingSlots.length ? dataTable() : <NoRecords />;
  };

  useEffect(() => {
    const abortController = new AbortController();

    getParkingSlots(abortController).catch(console.error);

    return () => {
      abortController.abort();
    };
  }, []);

  return (
    <>
      {errors.length > 0 && Errors(errors)}
      <Row>
        <Col md={{ span: 8, offset: 2 }}>
          <div className="fs-3 fw-bold mb-2">Parking Slots</div>
          {loading ? <Loader /> : content()}
        </Col>
      </Row>
    </>
  );
};

export default ParkingSlots;
