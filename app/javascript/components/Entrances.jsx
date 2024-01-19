import React, { useEffect, useState } from "react";
import { Col, Row, Table } from "react-bootstrap";
import { Link } from "react-router-dom";
import Errors from "./Errors";
import Loader from "./Loader";
import NoRecords from "./NoRecords";
import { api_v1_entrances_path } from "../core/api_routes";
import { api, ApiError } from "../core/api";

const Entrances = () => {
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState([]);
  const [entrances, setEntrances] = useState([]);

  const getEntrances = async (abortController) => {
    try {
      setLoading(true);
      const { signal } = abortController;
      const response = await api.get(api_v1_entrances_path(), { signal });
      setEntrances(response.data);
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
          {entrances.map((entrance) => (
            <tr key={entrance.id}>
              <td>{entrance.name}</td>
              <td className="text-center">
                <Link to={`/entrances/${entrance.id}/edit`}>
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
    return entrances.length ? dataTable() : <NoRecords />;
  };

  useEffect(() => {
    document.title = "ParkingSystem | Entrances";
    const abortController = new AbortController();

    getEntrances(abortController).catch(console.error);

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
            <div className="fs-3 fw-bold">Entrances</div>
            <div>
              <Link to="/entrances/new" className="btn btn-primary btn-sm">
                <i className="bi bi-plus-lg me-1"></i>
                New Entrance
              </Link>
            </div>
          </div>
          {loading ? <Loader /> : content()}
        </Col>
      </Row>
    </>
  );
};

export default Entrances;
