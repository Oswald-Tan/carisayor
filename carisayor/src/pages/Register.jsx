import { useFormik } from 'formik';
import * as Yup from 'yup';
import axios from 'axios';
import { useState } from 'react';
import { API_URL } from '../config';
import { useNavigate } from 'react-router-dom';
import { IoMdArrowBack } from 'react-icons/io';

const Register = () => {
  const [successMessage, setSuccessMessage] = useState('');
  const [errorMessage, setErrorMessage] = useState('');
  const navigate = useNavigate();

  const validationSchema = Yup.object().shape({
    fullname: Yup.string()
      .required('Nama lengkap wajib diisi'),
    email: Yup.string()
      .email('Email tidak valid')
      .required('Email wajib diisi'),
    phone: Yup.string()
      .matches(/^(?:\+62|0)[0-9]{9,12}$/, 'Format nomor handphone tidak valid')
      .required('Nomor handphone wajib diisi'),
    password: Yup.string()
      .min(6, 'Password minimal 6 karakter')
      .required('Password wajib diisi'),
    referralCode: Yup.string()
  });

  const formik = useFormik({
    initialValues: {
      fullname: '',
      email: '',
      phone: '',
      password: '',
      referralCode: ''
    },
    validationSchema,
    onSubmit: async (values, { setSubmitting }) => {
      try {
        setErrorMessage('');
        setSuccessMessage('');
        
        const payload = {
          fullname: values.fullname,
          email: values.email,
          password: values.password,
          phone_number: values.phone,
          referralCode: values.referralCode,
          role_name: 'user'
        };

        await axios.post(`${API_URL}/auth/register`, payload);
        
        setSuccessMessage('Registrasi berhasil! Silakan login menggunakan aplikasi Carisayor');
        formik.resetForm();
      } catch (error) {
        if (error.response) {
          setErrorMessage(error.response.data.message || 'Terjadi kesalahan saat registrasi');
        } else {
          setErrorMessage('Koneksi jaringan bermasalah');
        }
      } finally {
        setSubmitting(false);
      }
    }
  });

  return (
    <div className="min-h-screen w-full flex items-center justify-center bg-white">
      <div className="w-[450px] p-5">
        <div className='flex items-center gap-2 mb-4 cursor-pointer' onClick={() => navigate(-1)}>
          <IoMdArrowBack className='text-sm text-gray-500' />
          <span className='text-sm text-gray-500'>Kembali</span>
        </div>
        <h2 className="text-2xl font-bold mb-4 text-center">Register</h2>
        <p className="text-sm text-gray-500 text-center mb-10">
          Silakan daftar untuk membuat akun. Setelah registrasi, Anda dapat melakukan login melalui aplikasi{' '}
          <span className="text-primary font-bold">Carisayor</span>.
        </p>

        {errorMessage && (
          <div className="mb-4 p-3 bg-red-100 text-red-700 rounded-lg text-sm">
            {errorMessage}
          </div>
        )}

        {successMessage && (
          <div className="mb-4 p-3 bg-green-100 text-green-700 rounded-lg text-sm">
            {successMessage}
          </div>
        )}

        <form onSubmit={formik.handleSubmit}>
          {/* Input Fullname */}
          <div className="mb-4">
            <label className="block text-sm font-medium mb-2" htmlFor="fullname">
              Fullname<span className="text-red-500">*</span>
            </label>
            <input
              type="text"
              id="fullname"
              name="fullname"
              className="w-full px-3 py-2 border rounded-lg focus:outline-none text-sm"
              onChange={formik.handleChange}
              onBlur={formik.handleBlur}
              value={formik.values.fullname}
            />
            {formik.touched.fullname && formik.errors.fullname && (
              <div className="text-red-500 text-xs mt-1">{formik.errors.fullname}</div>
            )}
          </div>

          {/* Input Email */}
          <div className="mb-4">
            <label className="block text-sm font-medium mb-2" htmlFor="email">
              Email<span className="text-red-500">*</span>
            </label>
            <input
              type="email"
              id="email"
              name="email"
              className="w-full px-3 py-2 border rounded-lg focus:outline-none text-sm"
              onChange={formik.handleChange}
              onBlur={formik.handleBlur}
              value={formik.values.email}
            />
            {formik.touched.email && formik.errors.email && (
              <div className="text-red-500 text-xs mt-1">{formik.errors.email}</div>
            )}
          </div>

          {/* Input No Handphone */}
          <div className="mb-4">
            <label className="block text-sm font-medium mb-2" htmlFor="phone">
              No Handphone<span className="text-red-500">*</span>
            </label>
            <input
              type="tel"
              id="phone"
              name="phone"
              className="w-full px-3 py-2 border rounded-lg focus:outline-none text-sm"
              onChange={formik.handleChange}
              onBlur={formik.handleBlur}
              value={formik.values.phone}
            />
            {formik.touched.phone && formik.errors.phone && (
              <div className="text-red-500 text-xs mt-1">{formik.errors.phone}</div>
            )}
          </div>

          {/* Input Password */}
          <div className="mb-4">
            <label className="block text-sm font-medium mb-2" htmlFor="password">
              Password<span className="text-red-500">*</span>
            </label>
            <input
              type="password"
              id="password"
              name="password"
              className="w-full px-3 py-2 border rounded-lg focus:outline-none text-sm"
              onChange={formik.handleChange}
              onBlur={formik.handleBlur}
              value={formik.values.password}
            />
            {formik.touched.password && formik.errors.password && (
              <div className="text-red-500 text-xs mt-1">{formik.errors.password}</div>
            )}
          </div>

          {/* Input Referral Code */}
          <div className="mb-6">
            <label className="block text-sm font-medium mb-2" htmlFor="referralCode">
              Referral Code (Optional)
            </label>
            <input
              type="text"
              id="referralCode"
              name="referralCode"
              className="w-full px-3 py-2 border rounded-lg focus:outline-none text-sm"
              onChange={formik.handleChange}
              onBlur={formik.handleBlur}
              value={formik.values.referralCode}
            />
          </div>

          {/* Submit Button */}
          <button
            type="submit"
            disabled={formik.isSubmitting}
            className="w-full text-sm font-semibold bg-[#74B11A] text-white px-6 py-3 rounded-lg hover:bg-[#6DA718] transition disabled:opacity-50"
          >
            {formik.isSubmitting ? 'Memproses...' : 'Register'}
          </button>
        </form>
      </div>
    </div>
  );
};

export default Register;