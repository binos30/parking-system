import React, { useEffect, useState } from "react";
import { Button, Card, Col, Form, OverlayTrigger, Row, Tooltip } from "react-bootstrap";
import { useNavigate, useParams } from "react-router-dom";
import { FormProvider, useFieldArray, useForm } from "react-hook-form";
import { yupResolver } from "@hookform/resolvers/yup";
import Errors from "../Errors";
import Loader from "../Loader";
import { api_v1_parking_lots_path, api_v1_parking_lot_path } from "../../core/api_routes";
import { api, ApiError } from "../../core/api";
import { PARKING_SLOT_TYPE_OPTIONS } from "../../core/constants";
import { useDocumentTitle } from "../../core/hooks";
import { ParkingLotSchema } from "../../core/schema";

const ParkingLotForm = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const methods = useForm({
    defaultValues: { name: "" },
    resolver: yupResolver(ParkingLotSchema)
  });
  const { control, getValues, handleSubmit, register, reset, formState } = methods;
  const { errors, isSubmitting } = formState;
  const fieldArrayName = "parking_slots_attributes";
  const { fields, append, remove } = useFieldArray({
    control,
    name: fieldArrayName,
    keyName: "key"
  });
  const [processing, setProcessing] = useState(true);
  const [formErrors, setFormErrors] = useState([]);
  const [slotsForDestruction, setSlotsForDestruction] = useState([]);

  useDocumentTitle(`ParkingSystem | ${id ? "Edit Parking Lot" : "New Parking Lot"}`);

  const withSlotsForDestruction = (data) => {
    const { parking_slots_attributes } = data;

    return {
      ...data,
      parking_slots_attributes: [...parking_slots_attributes, ...slotsForDestruction]
    };
  };

  const onSubmit = async (data) => {
    setFormErrors([]);
    try {
      if (data.id) {
        await api.put(api_v1_parking_lot_path(data.id), withSlotsForDestruction(data));
      } else {
        await api.post(api_v1_parking_lots_path(), withSlotsForDestruction(data));
      }

      navigate("/parking_lots");
    } catch (error) {
      if (error instanceof ApiError) {
        setFormErrors(error.all());
      } else {
        console.error("messd", error);
        setFormErrors([error?.message]);
      }
    }
  };

  const onError = (data) => {
    console.error(data);
    const error = "There are errors on your form.";
    if (data?.parking_slots_attributes) {
      setFormErrors([
        data.parking_slots_attributes.message || data.parking_slots_attributes.root?.message || error
      ]);
    } else {
      setFormErrors([error]);
    }
  };

  useEffect(() => {
    const abortController = new AbortController();
    const getParkingLot = async () => {
      setProcessing(true);
      try {
        const response = await api.get(api_v1_parking_lot_path(id), {
          signal: abortController.signal
        });
        const values = {
          ...getValues(),
          ...response.data
        };
        reset(values);
      } catch (error) {
        if (!abortController.signal.aborted) {
          if (error instanceof ApiError) {
            setFormErrors(error.all());
          } else {
            setFormErrors([error?.message]);
          }
        }
      } finally {
        setProcessing(false);
      }
    };
    if (id) getParkingLot();
    else setProcessing(false);

    return () => {
      abortController.abort();
    };
  }, [id, getValues, reset]);

  if (processing) return <Loader />;

  return (
    <Row>
      <Col md={{ span: 8, offset: 2 }}>
        <Card>
          <Card.Body>
            <div className="fs-5 fw-bold">{`${id ? "Edit Parking Lot" : "New Parking Lot"}`}</div>
            <FormProvider {...methods}>
              <Form onSubmit={handleSubmit(onSubmit, onError)}>
                {formErrors.length > 0 && Errors(formErrors)}
                <Row>
                  <Col md={6}>
                    <Form.Label htmlFor="name">Name</Form.Label>
                    <Form.Control {...register("name")} id="name" autoFocus="autofocus" className="mb-2" />
                    <p className="text-danger">{errors.name?.message}</p>
                  </Col>
                </Row>
                <div className="d-flex align-items-center justify-content-between mb-3">
                  <div className="fs-5 fw-bold">Slots</div>
                  <Button
                    type="button"
                    variant="primary"
                    size="sm"
                    onClick={() => append({ slot_type: "", distances: "" })}
                    className="text-light"
                  >
                    <i className="bi bi-plus-lg me-1"></i>
                    Add Slot
                  </Button>
                </div>
                {fields.map((field, index) => (
                  <Row key={field.key} className="align-items-center">
                    <Col sm="2">
                      <Form.Label className="fw-semibold">Code</Form.Label>
                      <div className="form-control">{field.code}</div>
                      <p></p>
                    </Col>
                    <Col>
                      <Form.Label htmlFor={`${fieldArrayName}.${index}.slot_type`} className="fw-semibold">
                        Type
                        <OverlayTrigger
                          key={index}
                          placement="right"
                          overlay={
                            <Tooltip id={`tooltip-${index}`}>
                              SP = Small
                              <br />
                              MP = Medium
                              <br />
                              LP = Large
                            </Tooltip>
                          }
                        >
                          <i className="bi bi-question-circle ms-1"></i>
                        </OverlayTrigger>
                      </Form.Label>
                      <Form.Select
                        {...register(`${fieldArrayName}.${index}.slot_type`)}
                        id={`${fieldArrayName}.${index}.slot_type`}
                      >
                        {PARKING_SLOT_TYPE_OPTIONS.map((type, index) => (
                          <option key={index} value={type.value}>
                            {type.label}
                          </option>
                        ))}
                      </Form.Select>
                      <p className="text-danger">{errors.parking_slots_attributes?.[index]?.slot_type?.message}</p>
                    </Col>
                    <Col>
                      <Form.Label htmlFor={`${fieldArrayName}.${index}.distances`} className="fw-semibold">
                        Distances
                        <OverlayTrigger
                          key={index}
                          placement="right"
                          overlay={
                            <Tooltip id={`tooltip-${index}`}>
                              Slot distances must be comma-separated. For example, if your parking system has three
                              (3) entry points. The distances will be: 1,4,5, where the integer entry per tuple
                              corresponds to the distance unit from every parking entry point A,B,C
                            </Tooltip>
                          }
                        >
                          <i className="bi bi-question-circle ms-1"></i>
                        </OverlayTrigger>
                      </Form.Label>
                      <Form.Control
                        {...register(`${fieldArrayName}.${index}.distances`)}
                        id={`${fieldArrayName}.${index}.distances`}
                        placeholder="1,2,3"
                      />
                      <p className="text-danger">{errors.parking_slots_attributes?.[index]?.distances?.message}</p>
                    </Col>
                    <Col sm="1">
                      <Button
                        type="button"
                        size="sm"
                        variant="outline-danger"
                        onClick={() => {
                          if (field.id) setSlotsForDestruction((value) => [...value, { ...field, _destroy: "1" }]);
                          remove(index);
                        }}
                      >
                        <i className="bi bi-trash"></i>
                      </Button>
                    </Col>
                  </Row>
                ))}
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

export default ParkingLotForm;
