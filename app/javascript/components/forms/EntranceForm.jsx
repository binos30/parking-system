import React, { useEffect, useState } from "react";
import { Button, Card, Col, Form, Row } from "react-bootstrap";
import { useNavigate, useParams } from "react-router-dom";
import { FormProvider, useForm } from "react-hook-form";
import { yupResolver } from "@hookform/resolvers/yup";
import Errors from "../Errors";
import Loader from "../Loader";
import { api_v1_entrances_path, api_v1_entrance_path } from "../../core/api_routes";
import { api, ApiError } from "../../core/api";
import { useDocumentTitle } from "../../core/hooks";
import { EntranceSchema } from "../../core/schema";

const EntranceForm = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const methods = useForm({
    defaultValues: { name: "" },
    resolver: yupResolver(EntranceSchema)
  });
  const { getValues, handleSubmit, register, reset, formState } = methods;
  const { errors, isSubmitting } = formState;
  const [processing, setProcessing] = useState(true);
  const [formErrors, setFormErrors] = useState([]);

  useDocumentTitle(`ParkingSystem | ${id ? "Edit Entrance" : "New Entrance"}`);

  const onSubmit = async (data) => {
    try {
      if (data.id) {
        await api.put(api_v1_entrance_path(data.id), data);
      } else {
        await api.post(api_v1_entrances_path(), data);
      }

      navigate("/entrances");
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

  useEffect(() => {
    const abortController = new AbortController();
    const getEntrance = async () => {
      setProcessing(true);
      try {
        const response = await api.get(api_v1_entrance_path(id), {
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
    if (id) getEntrance();
    else setProcessing(false);

    return () => {
      abortController.abort();
    };
  }, [id, getValues, reset]);

  if (processing) return <Loader />;

  return (
    <Row>
      <Col md={{ span: 6, offset: 3 }}>
        <Card>
          <Card.Body>
            <div className="fs-5 fw-bold">{`${id ? "Edit Entrance" : "New Entrance"}`}</div>
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

export default EntranceForm;
