import { useState, useEffect } from "react";
import axios from "axios";
import { useNavigate, useParams } from "react-router-dom";
import { API_URL } from "../config";
import Swal from "sweetalert2";

const FormEditTopUpPoin = () => {
  const [status, setStatus] = useState("");
  const [msg, setMsg] = useState("");
  const navigate = useNavigate();

  const { id } = useParams();

  useEffect(() => {
    const getTopUpById = async () => {
      try {
        const res = await axios.get(`${API_URL}/topup/${id}`);
        setStatus(res.data.status);
      } catch (error) {
        if (error.response) {
          setMsg(error.response.data.message);
        }
      }
    };

    getTopUpById();
  }, [id]);

  const updateTopUpPoin = async (e) => {
    e.preventDefault();
    try {
      await axios.patch(`${API_URL}/topup/${id}`, { status });
      navigate("/topup/poin");
      Swal.fire("Success", "Status updated successfully", "success");
    } catch (error) {
      if (error.response) {
        setMsg(error.response.data.message);
      }
    }
  };

  return (
    <div className="bg-gray-100">
      <div className="w-full">
        <h1 className="text-2xl font-semibold text-black-100">Edit Top Up</h1>
        <div className="bg-white p-6 rounded-lg shadow-md mt-4">
          <form onSubmit={updateTopUpPoin}>
            <p className="text-red-500">{msg}</p>
            <div className="mb-4">
              <label
                htmlFor="role"
                className="block text-sm font-medium text-gray-700"
              >
                Status
              </label>
              <select
                id="role"
                value={status}
                onChange={(e) => setStatus(e.target.value)}
                className="mt-1 block w-full px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
              >
                <option value="">...</option>
                <option value="pending">Pending</option>
                <option value="approved">Approved</option>
                <option value="rejected">Reject</option>
                <option value="cancelled">Cancelled</option>
              </select>
            </div>
            <button
              type="submit"
              className="text-sm py-2 px-4 bg-indigo-600 text-white font-semibold rounded-md shadow hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
            >
              Update
            </button>
          </form>
        </div>
      </div>
    </div>
  );
};

export default FormEditTopUpPoin;
