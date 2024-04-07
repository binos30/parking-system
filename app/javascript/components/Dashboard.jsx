import React, { useEffect, useState } from "react";
import { Card, Col, Row } from "react-bootstrap";
import Errors from "./Errors";
import Loader from "./Loader";
import { api_v1_dashboard_path } from "../core/api_routes";
import { api, ApiError } from "../core/api";
import { DEFAULT_SLOTS_COUNT } from "../core/constants";
import { useDocumentTitle } from "../core/hooks";

const Dashboard = () => {
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState([]);
  const [data, setData] = useState(DEFAULT_SLOTS_COUNT);

  useDocumentTitle("ParkingSystem | Dashboard");

  const getData = async (abortController) => {
    try {
      setLoading(true);
      const { signal } = abortController;
      const response = await api.get(api_v1_dashboard_path(), { signal });
      setData(response.data.data);
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

  const content = () => {
    return (
      <Card>
        <Card.Body>
          <Card.Title>Parking Slots</Card.Title>
          <Row>
            <Col>
              <Card body className="card--secondary slots-count-card">
                <h4>Vacant</h4>
                <h5>SP - {data.small_vacant_slots_count}</h5>
                <h5>MP - {data.medium_vacant_slots_count}</h5>
                <h5>LP - {data.large_vacant_slots_count}</h5>
              </Card>
            </Col>
            <Col>
              <Card body className="card--info slots-count-card">
                <h4>Reserved</h4>
                <h5>SP - {data.small_reserved_slots_count}</h5>
                <h5>MP - {data.medium_reserved_slots_count}</h5>
                <h5>LP - {data.large_reserved_slots_count}</h5>
              </Card>
            </Col>
            <Col>
              <Card body className="card--success slots-count-card">
                <h4>Occupied</h4>
                <h5>SP - {data.small_occupied_slots_count}</h5>
                <h5>MP - {data.medium_occupied_slots_count}</h5>
                <h5>LP - {data.large_occupied_slots_count}</h5>
              </Card>
            </Col>
          </Row>
        </Card.Body>
      </Card>
    );
  };

  useEffect(() => {
    const abortController = new AbortController();

    getData(abortController).catch(console.error);

    return () => {
      abortController.abort();
    };
  }, []);

  return (
    <>
      {errors.length > 0 && Errors(errors)}
      <Row className="dashboard">
        <Col md={{ span: 10, offset: 1 }}>
          <div className="fs-3 fw-bold mb-2">Dashboard</div>
          {loading ? <Loader /> : content()}
        </Col>
      </Row>
    </>
  );
};

export default Dashboard;
