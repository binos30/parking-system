import * as yup from "yup";

export const EntranceSchema = yup.object({
  id: yup.number().nullable(true),
  name: yup
    .string()
    .min(1, "Name is too short (minimum is 1 character)")
    .max(15, "Name is too long (maximum is 15 characters)")
    .required("Name is required.")
});
