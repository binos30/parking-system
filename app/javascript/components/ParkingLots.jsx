import React, { useEffect, useState } from "react";
import { Col, Row, Table } from "react-bootstrap";
import { Link } from "react-router-dom";
import Errors from "./Errors";
import Loader from "./Loader";
import NoRecords from "./NoRecords";
import { api_v1_parking_lots_path } from "../core/api_routes";
import { api, ApiError } from "../core/api";
import { useDocumentTitle } from "../core/hooks";

const ParkingLots = () => {
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState([]);
  const [parkingLots, setParkingLots] = useState([]);

  useDocumentTitle("ParkingSystem | Parking Lots");

  const getParkingLots = async (abortController) => {
    try {
      setLoading(true);
      const { signal } = abortController;
      const response = await api.get(api_v1_parking_lots_path(), { signal });
      setParkingLots(response.data);
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
            <th>Name</th>
            <th width="100">Actions</th>
          </tr>
        </thead>
        <tbody>
          {parkingLots.map((parkingLot) => (
            <tr key={parkingLot.id}>
              <td>{parkingLot.name}</td>
              <td className="text-center">
                <Link to={`/parking_lots/${parkingLot.id}/edit`}>
                  <i className="bi bi-pencil"></i>
                </Link>
              </td>
            </tr>
          ))}
        </tbody>
      </Table>
    );
  };

  const content = () => {
    return parkingLots.length ? dataTable() : <NoRecords />;
  };

  useEffect(() => {
    const abortController = new AbortController();

    getParkingLots(abortController).catch(console.error);

    return () => {
      abortController.abort();
    };
  }, []);

  return (
    <>
      {errors.length > 0 && Errors(errors)}
      <Row>
        <Col md={{ span: 6, offset: 3 }}>
          <div className="d-flex justify-content-between align-items-center mb-2">
            <div className="fs-3 fw-bold">Parking Lots</div>
            <div>
              <Link to="/parking_lots/new" className="btn btn-primary btn-sm">
                <i className="bi bi-plus-lg me-1"></i>
                New Parking Lot
              </Link>
            </div>
          </div>
          {loading ? <Loader /> : content()}
        </Col>
      </Row>
    </>
  );
};

export default ParkingLots;
