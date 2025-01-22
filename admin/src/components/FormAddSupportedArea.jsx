import { useState } from "react";
import axios from "axios";
import { API_URL } from "../config"; // Pastikan Anda memiliki config.js untuk base URL
import { useNavigate } from "react-router-dom";
import Swal from "sweetalert2";

const FormAddSupportedArea = () => {
  const [postalCode, setPostalCode] = useState("");
  const [city, setCity] = useState("");
  const [state, setState] = useState("");
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  // Menangani pengiriman form untuk menambahkan supported area
  const handleAddArea = async (e) => {
    e.preventDefault();
    setLoading(true);

    if (!postalCode || !city || !state) {
      Swal.fire("Error", "Please fill in all fields", "error");
      setLoading(false);
      return;
    }

    try {
      const res = await axios.post(`${API_URL}/supported-area`, {
        postal_code: postalCode,
        city: city,
        state: state
      });

      Swal.fire("Success", res.data.message, "success");
      navigate("/supported/area");
    } catch (error) {
      console.error("Failed to add supported area:", error.response?.data?.message || error.message);
      Swal.fire("Error", error.response?.data?.message || "Failed to add area", "error");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="bg-gray-100">
      <div className="w-full">
        <h1 className="text-2xl font-bold text-gray-800 mb-6">Add Supported Area</h1>
        <div className="bg-white p-6 rounded-lg shadow-md">
          <form onSubmit={handleAddArea}>
            

            {/* Input untuk Postal Code */}
            <div className="mb-4">
              <label className="block text-sm font-medium text-gray-700">Postal Code</label>
              <input
                type="text"
                value={postalCode}
                onChange={(e) => setPostalCode(e.target.value)}
                className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                required
              />
            </div>

             {/* Input untuk City */}
             <div className="mb-4">
              <label className="block text-sm font-medium text-gray-700">City</label>
              <input
                type="text"
                value={city}
                onChange={(e) => setCity(e.target.value)}
                className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                required
              />
            </div>

            {/* Input untuk State */}
            <div className="mb-4">
              <label className="block text-sm font-medium text-gray-700">State</label>
              <input
                type="text"
                value={state}
                onChange={(e) => setState(e.target.value)}
                className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                required
              />
            </div>

            {/* Tombol Submit */}
            <button
              type="submit"
              disabled={loading}
              className="text-sm py-2 px-4 bg-indigo-600 text-white font-semibold rounded-md shadow hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
            >
              {loading ? "Adding..." : "Add Area"}
            </button>
          </form>
        </div>
      </div>
    </div>
  );
};

export default FormAddSupportedArea;
