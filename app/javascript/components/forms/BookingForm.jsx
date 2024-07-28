import React, { useState } from "react";
import { Button, Card, Col, Form, OverlayTrigger, Row, Tooltip } from "react-bootstrap";
import { useNavigate } from "react-router-dom";
import { FormProvider, useForm } from "react-hook-form";
import { yupResolver } from "@hookform/resolvers/yup";
import Errors from "../Errors";
import { api_v1_bookings_path } from "../../core/api_routes";
import { api, ApiError } from "../../core/api";
import { VEHICLE_TYPE_OPTIONS } from "../../core/constants";
import { useDocumentTitle } from "../../core/hooks";
import { BookingSchema } from "../../core/schema";

const BookingForm = () => {
  const navigate = useNavigate();
  const methods = useForm({
    defaultValues: { vehicle_type: "", plate_number: "" },
    resolver: yupResolver(BookingSchema),
  });
  const { handleSubmit, register, formState } = methods;
  const { errors, isSubmitting } = formState;
  const [formErrors, setFormErrors] = useState([]);

  useDocumentTitle("ParkingSystem | New Booking");

  const onSubmit = async (data) => {
    try {
      await api.post(api_v1_bookings_path(), data);

      navigate("/bookings");
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

  return (
    <Row>
      <Col md={{ span: 6, offset: 3 }}>
        <Card>
          <Card.Body>
            <div className="fs-5 fw-bold">New Booking</div>
            <FormProvider {...methods}>
              <Form onSubmit={handleSubmit(onSubmit, onError)}>
                {formErrors.length > 0 && Errors(formErrors)}
                <Row>
                  <Col md={6}>
                    <Form.Label htmlFor="vehicle_type">
                      Vehicle Type
                      <OverlayTrigger
                        placement="right"
                        overlay={
                          <Tooltip id="tooltip">
                            S = Small
                            <br />
                            M = Medium
                            <br />L = Large
                          </Tooltip>
                        }
                      >
                        <i className="bi bi-question-circle ms-1"></i>
                      </OverlayTrigger>
                    </Form.Label>
                    <Form.Select {...register("vehicle_type")} id="vehicle_type">
                      {VEHICLE_TYPE_OPTIONS.map((type, index) => (
                        <option key={index} value={type.value}>
                          {type.label}
                        </option>
                      ))}
                    </Form.Select>
                    <p className="text-danger">{errors.vehicle_type?.message}</p>
                  </Col>
                </Row>
                <Row>
                  <Col md={6}>
                    <Form.Label htmlFor="plate_number">Plate Number</Form.Label>
                    <Form.Control {...register("plate_number")} id="plate_number" autoFocus="autofocus" />
                    <p className="text-danger">{errors.plate_number?.message}</p>
                  </Col>
                </Row>
                <Row>
                  <Col>
                    <Button
                      type="submit"
                      color="primary"
                      className="text-light"
                      disabled={isSubmitting}
                      title="Submit"
                    >
                      {isSubmitting ? "Submitting..." : "Submit"}
                    </Button>
                  </Col>
                </Row>
              </Form>
            </FormProvider>
          </Card.Body>
        </Card>
      </Col>
    </Row>
  );
};

export default BookingForm;
