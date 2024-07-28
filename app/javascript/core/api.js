import axios from "axios";

export class ApiError extends Error {
  constructor(message, json) {
    super(message);
    this.name = this.constructor.name;
    this.json = json;
  }

  all() {
    if (Array.isArray(this.json)) {
      return this.json;
    } else {
      return [this.json];
    }
  }
}

const token = document.querySelector('meta[name="csrf-token"]').content;

axios.defaults.headers.common = {
  Accept: "application/json",
  "Content-Type": "application/json",
  "X-CSRF-Token": token,
};
axios.interceptors.response.use(
  (response) => response,
  (error) => {
    const { response } = error;
    const { data } = response;

    throw new ApiError(response.statusText, data);
  },
);

const get = async (url, config = {}) => {
  return await axios.get(url, config);
};

const post = async (url, data, config = {}) => {
  return await axios.post(url, data, config);
};

const put = async (url, data, config = {}) => {
  return await axios.put(url, data, config);
};

const destroy = async (url, config = {}) => {
  return await axios.delete(url, config);
};

export const api = {
  get,
  post,
  put,
  destroy,
};
