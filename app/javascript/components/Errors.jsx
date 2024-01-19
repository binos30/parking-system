import React from "react";

const Errors = (errors) => {
  return (
    <div className="alert alert-danger alert-dismissible fade show" role="alert">
      <ul className="mb-0">
        {errors.map((error, index) => (
          <li key={index}>{error}</li>
        ))}
      </ul>
      <button
        type="button"
        className="btn-close"
        data-bs-dismiss="alert"
        aria-label="Close"
      ></button>
    </div>
  );
};

export default Errors;
