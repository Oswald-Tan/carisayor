import { useState } from "react";
import { Formik, Field } from "formik";
import { API_URL } from "../../config";
import { Link, useNavigate } from "react-router-dom";
import { TbPasswordUser } from "react-icons/tb";
import VerifyOtpForm from "./VerifyOtpForm";
import axios from "axios";
import Swal from "sweetalert2";
import * as Yup from "yup";

const ResetPasswordPage = () => {
  const [step, setStep] = useState("requestEmail");
  const [email, setEmail] = useState("");
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  // Handle email submission
  const handleEmailSubmitted = async (values) => {
    setLoading(true);
    try {
      await axios.post(`${API_URL}/auth-web/request-reset-otp`, {
        email: values.email,
      });
      setEmail(values.email);
      setStep("verifyOtp");
    } catch (error) {
      Swal.fire({
        title: "Error",
        text: error.response.data.message,
        icon: "error",
        confirmButtonText: "Ok",
      });
    } finally {
      setLoading(false);
    }
  };

  // Handle OTP verification
  const handleOtpVerified = () => {
    setStep("resetPassword");
  };

  // Handle password reset
  const handlePasswordReset = async (values) => {
    setLoading(true);
    try {
      await axios.post(`${API_URL}/auth-web/reset-password`, { ...values, email });
      Swal.fire({
        title: "Success",
        text: "Password has been reset successfully",
        icon: "success",
        confirmButtonText: "Ok",
      });
      navigate("/"); // Navigate to login page after success
    } catch (error) {
      Swal.fire({
        title: "Error",
        text: error.response.data.message,
        icon: "error",
        confirmButtonText: "Ok",
      });
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="w-full h-screen flex justify-center items-center bg-white p-5">
      <div className="w-full max-w-sm h-auto">
        <div className="flex justify-center">
          <div className="w-[80px] h-[80px] bg-[#f2fce2] p-[5px] rounded-full flex items-center justify-center">
            <div className="w-[50px] h-[50px] bg-[#d8faa5] p-[5px] rounded-full flex items-center justify-center">
              <TbPasswordUser
                size={30}
                className="bg-opacity-5 text-[#74B11A]"
              />
            </div>
          </div>
        </div>

        {step === "requestEmail" && (
          <Formik
            initialValues={{ email: "" }}
            onSubmit={handleEmailSubmitted}
            validationSchema={Yup.object({
              email: Yup.string()
                .required("Email harus disis")
                .email("Invalid email address"),
            })}
          >
            {({ errors, touched, handleSubmit, handleChange }) => (
              <form method="post" onSubmit={handleSubmit} className="space-y-4">
                <p className="mt-3 text-3xl font-semibold text-center">
                  Request OTP
                </p>
                <p className="text-sm text-center text-[#909090]">
                  Email yang di input merupkan email aktif terdaftar!
                </p>
                <div className="form-content">
                  <div className="form-group">
                    <Field
                      type="email"
                      id="email"
                      name="email"
                      onChange={handleChange}
                      placeholder="Masukan email"
                      className="w-full text-sm mt-2 px-4 py-3 border rounded-md focus:outline-none bg-[#eef0f4]"
                    />
                    {touched.email && errors.email ? (
                      <div className="text-red-600 text-sm mt-[5px] italic">
                        {errors.email}
                      </div>
                    ) : null}
                  </div>
                </div>
                <button
                  type="submit"
                  disabled={loading}
                  className="mt-[10px] w-full p-3 rounded-[10px] 
                  bg-gradient-to-[121deg] bg-[#74B11A] hover:bg-[#a1e043] text-white
                  transition-all duration-300 ease-in-out 
                  font-medium text-sm cursor-pointer"
                >
                  <span>{loading ? "Loading..." : "Request OTP"}</span>
                </button>
              </form>
            )}
          </Formik>
        )}
        {step === "verifyOtp" && (
          <VerifyOtpForm email={email} onVerified={handleOtpVerified} />
        )}
        {step === "resetPassword" && (
          <Formik
            initialValues={{
              newPassword: "",
              confirmPassword: "",
            }}
            onSubmit={handlePasswordReset}
            validationSchema={Yup.object({
              newPassword: Yup.string()
                .required("Password baru harus diisi")
                .min(8, "Password must be at least 8 characters")
                .matches(/[a-zA-Z]/, "Password must contain letters")
                .matches(/[0-9]/, "Password must contain numbers")
                .matches(/[\W_]/, "Password must contain special characters"),
              confirmPassword: Yup.string()
                .required("Confirm password is required")
                .oneOf([Yup.ref("newPassword"), null], "Passwords must match"),
            })}
          >
            {({ errors, touched, handleSubmit, handleChange }) => (
              <form
                method="post"
                onSubmit={handleSubmit}
                className="space-y-4"
              >
                <p className="mt-3 text-3xl font-semibold text-center">Reset Password</p>
                <div className="">
                  <div className="">
                    <Field
                      type="password"
                      id="newPassword"
                      name="newPassword"
                      onChange={handleChange}
                      placeholder="Password baru"
                      className="w-full text-sm mt-2 px-4 py-3 border rounded-md focus:outline-none bg-[#eef0f4]"
                    />
                    {touched.newPassword && errors.newPassword ? (
                      <div className="error-form">{errors.newPassword}</div>
                    ) : null}
                  </div>
                  <div className="">
                    <Field
                      type="password"
                      id="confirmPassword"
                      name="confirmPassword"
                      onChange={handleChange}
                      placeholder="Konfirmasi Password baru"
                      className="w-full text-sm mt-3 px-4 py-3 border rounded-md focus:outline-none bg-[#eef0f4]"
                    />
                    {touched.confirmPassword && errors.confirmPassword ? (
                      <div className="error-form">{errors.confirmPassword}</div>
                    ) : null}
                  </div>
                </div>
                <button
                  type="submit"
                  disabled={loading}
                  className="mt-[10px] w-full p-3 rounded-[10px] 
                  bg-gradient-to-[121deg] bg-[#74B11A] hover:bg-[#a1e043] text-white
                  transition-all duration-300 ease-in-out 
                  font-medium text-sm cursor-pointer"
                >
                  <span>{loading ? "Loading..." : "Reset Password"}</span>
                </button>
              </form>
            )}
          </Formik>
        )}
        <Link to="/" className="text-sm text-[#909090] mt-5 flex items-center justify-center underline">
          Back to login?
        </Link>
      </div>
    </div>
  );
};

export default ResetPasswordPage;
