import { useState, useEffect } from "react";
import axios from "axios";
import { useNavigate, useParams } from "react-router-dom";
import { API_URL } from "../config";
import Swal from "sweetalert2";

const FormEditPoin = () => {
  const [poin, setPoin] = useState("");
  const [discountPercentage, setDiscountPercentage] = useState("");
  const [msg, setMsg] = useState("");
  const navigate = useNavigate();

  const { id } = useParams();

  useEffect(() => {
    const getPoinById = async () => {
        try {
          const res = await axios.get(`${API_URL}/poin/${id}`);
          setPoin(res.data.poin);
          setDiscountPercentage(res.data.discountPercentage)
        } catch (error) {
          if (error.response) {
            setMsg(error.response.data.message);
          }
        }
    }

    getPoinById();
  }, [id]);

  const updatePoin = async (e) => {
    e.preventDefault();
    try {
      await axios.patch(`${API_URL}/poin/${id}`, { poin, discountPercentage });
      navigate("/poin");
      Swal.fire("Success", "Product updated successfully", "success");
    } catch (error) {
      if (error.response) {
        setMsg(error.response.data.message);
      }
    }
  };

    return (
      <div className="bg-gray-100">
        <div className="w-full">
          <h1 className="text-2xl font-semibold text-black-100">Edit Product</h1>
          <div className="bg-white p-6 rounded-lg shadow-md mt-4">
            <form onSubmit={updatePoin}>
            <p className="text-red-500">{msg}</p>
              <div className="mb-4">
                <label htmlFor="poin" className="block text-sm font-medium text-gray-700">
                  Poin
                </label>
                <input
                  type="text"
                  id="poin"
                  value={poin}
                  onChange={(e) => setPoin(e.target.value)}
                  className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                />
              </div>
              <div className="mb-4">
                <label htmlFor="discountPercentage" className="block text-sm font-medium text-gray-700">
                  Discount Percentage
                </label>
                <input
                  type="text"
                  id="discountPercentage"
                  value={discountPercentage}
                  onChange={(e) => setDiscountPercentage(e.target.value)}
                  className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                />
              <p className="italic text-xs py-2 text-gray-400">set 0 jika tidak ingin memberikan discount</p>
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
  
  export default FormEditPoin;
  