"use client";
import React, { useState } from "react";
export default function RegisterPage() {
  const [values, setValues] = useState({
    firstName: "",
    lastName: "",
    email: "",
    password: "",
  });
  const handleInputChange = (event) => {
    event.preventDefault();

    const { name, value } = event.target;
    setValues((values) => ({
      ...values,
      [name]: value,
    }));
  };

  const [submitted, setSubmitted] = useState(false);
  const [valid, setValid] = useState(false);

  const handleSubmit = (event) => {
    event.preventDefault();
    if (values.firstName && values.lastName && values.email) {
      setValid(true);
    }
    setSubmitted(true);
  };

  return (
    <div className="form-container">
      <form className="register-form" onSubmit={handleSubmit}>
        {submitted && valid && (
          <div className="success-message">
            <h3>
              {" "}
              Welcome {values.firstName} {values.lastName}{" "}
            </h3>
            <div> Your registration was successful! </div>
          </div>
        )}
        {!valid && (
          <input
            type="text"
            placeholder="First Name"
            name="firstName"
            value={values.firstName}
            onChange={handleInputChange}
          />
        )}

        {submitted && !values.firstName && (
          <span id="first-name-error">Please enter a first name</span>
        )}

        {!valid && (
          <input
            type="text"
            placeholder="Last Name"
            name="lastName"
            value={values.lastName}
            onChange={handleInputChange}
          />
        )}

        {submitted && !values.lastName && (
          <span id="last-name-error">Please enter a last name</span>
        )}

        {!valid && (
          <input
            type="email"
            placeholder="Email"
            name="email"
            value={values.email}
            onChange={handleInputChange}
          />
        )}

        {submitted && !values.password && (
          <span id="email-error">Please enter an email address</span>
        )}

        {!valid && (
          <input
            type="password"
            placeholder="Password"
            name="password"
            value={values.password}
            onChange={handleInputChange}
          />
        )}

        {submitted && !values.password && (
          <span id="password-error">Please enter an password</span>
        )}

        {!valid && <button type="submit">Register</button>}
      </form>
    </div>
  );
}
