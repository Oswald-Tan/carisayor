import { useState, useEffect } from "react";
import axios from "axios";
import { useNavigate, useParams } from "react-router-dom";
import { API_URL } from "../config";
import Swal from "sweetalert2";

const FormAddDiscountPoin = () => {
  const { id } = useParams();
  const [poin, setPoin] = useState(null);
  const [discountPercentage, setDiscountPercentage] = useState("");
  const navigate = useNavigate();

  useEffect(() => {
    const fetchPoin = async () => {
      try {
        const res = await axios.get(`${API_URL}/poin/${id}`);
        setPoin(res.data);
      } catch (error) {
        console.error("Error fetching poin:", error);
      }
    };

    fetchPoin();
  }, [id]);

  const savePoin = async (e) => {
    e.preventDefault();
    if (!discountPercentage || isNaN(discountPercentage)) {
      Swal.fire("Error", "Please enter a valid discount percentage", "error");
      return;
    }

    if (discountPercentage < 0 || discountPercentage > 100) {
      Swal.fire("Error", "Discount percentage must be between 0 and 100", "error");
      return;
    }

    try {
      await axios.post(`${API_URL}/poin/update-discount`, {
        id: poin.id,
        discountPercentage: parseFloat(discountPercentage),
      });
      Swal.fire("Success", "Discount added successfully", "success");
      navigate("/poin");
    } catch (error) {
      if (error.response) {
        Swal.fire("Error", error.response.data.message, "error");
      } else {
        Swal.fire("Error", "An unexpected error occurred", "error");
      }
    }
  };

  return (
    <div className="bg-gray-100">
      <div className="w-full">
        <h1 className="text-2xl font-semibold text-black-100">Buat Discount</h1>
        <div className="bg-white p-6 rounded-lg shadow-md mt-4">
          <form onSubmit={savePoin}>
            <div className="mb-4">
              <label
                htmlFor="discountPercentage"
                className="block text-sm font-medium text-gray-700"
              >
                Persentase Diskon (%)
              </label>
              <input
                type="number"
                id="discountPercentage"
                value={discountPercentage}
                min="0"
                max="100"
                onChange={(e) => setDiscountPercentage(e.target.value)}
                className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
              />
            </div>
            <button
              type="submit"
              className="text-sm py-2 px-4 bg-indigo-600 text-white font-semibold rounded-md shadow hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
            >
              Save
            </button>
          </form>
        </div>
      </div>
    </div>
  );
};

export default FormAddDiscountPoin;
