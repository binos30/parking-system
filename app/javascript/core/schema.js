import * as yup from "yup";

export const EntranceSchema = yup.object({
  id: yup.number().nullable(true),
  name: yup
    .string()
    .min(1, "Name is too short (minimum is 1 character)")
    .max(15, "Name is too long (maximum is 15 characters)")
    .required("Name is required.")
});

export const ParkingSlotSchema = yup.object({
  id: yup.number().nullable(true),
  slot_type: yup.string().required("Type is required."),
  distances: yup.string().required("Distances are required.")
});

export const ParkingLotSchema = yup.object({
  id: yup.number().nullable(true),
  name: yup
    .string()
    .min(2, "Name is too short (minimum is 2 characters)")
    .max(15, "Name is too long (maximum is 15 characters)")
    .required("Name is required."),
  parking_slots_attributes: yup
    .array(ParkingSlotSchema)
    .min(1, "Parking lot must have at least one slot.")
    .required("required")
});
