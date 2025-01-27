import { useState } from "react";
import axios from "axios";
import { API_URL } from "../config"; // Pastikan Anda memiliki config.js untuk base URL
import { useNavigate } from "react-router-dom";
// import Swal from "sweetalert2";

const FormAddCityProvince = () => {
  const [provinceName, setProvinceName] = useState("");
  const [cities, setCities] = useState([""]);
  const [message, setMessage] = useState("");
  const navigate = useNavigate();

  const handleProvinceChange = (e) => {
    setProvinceName(e.target.value);
  };

  const handleCityChange = (index, value) => {
    const updatedCities = [...cities];
    updatedCities[index] = value;
    setCities(updatedCities);
  };

  const addCityField = () => {
    setCities([...cities, ""]);
  };

  const removeCityField = (index) => {
    const updatedCities = cities.filter((_, i) => i !== index);
    setCities(updatedCities);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!provinceName || cities.some((city) => !city)) {
      setMessage("Please fill in all fields.");
      return;
    }

    try {
      const res = await axios.post(`${API_URL}/provinces-cities`, {
        provinceName,
        cities,
      });

      setMessage(
        res.data.message || "Province and cities created successfully!"
      );
      setProvinceName("");
      setCities([""]);
      navigate("/city/province");
    } catch (error) {
      setMessage(error.response?.data?.message || "An error occurred.");
    }
  };

  return (
    <div className="bg-gray-100">
      <div className="w-full">
        <h1 className="text-2xl font-bold text-gray-800 mb-6">
          Add City Province
        </h1>
        <div className="bg-white p-6 rounded-lg shadow-md">
          <form onSubmit={handleSubmit}>
            {message && <p className="text-red-500 mb-4">{message}</p>}

            {/* Input untuk Postal Code */}
            <div className="mb-4">
              <label className="block text-sm font-medium text-gray-700">
                Province Name
              </label>
              <input
                type="text"
                id="provinceName"
                value={provinceName}
                onChange={handleProvinceChange}
                className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                required
              />
            </div>

            {/* Input untuk City */}
            <div className="mb-4">
              <label className="block text-sm font-medium text-gray-700">
                Cities
              </label>
              {cities.map((city, index) => (
                <div key={index}>
                  <input
                    type="text"
                    placeholder={`City ${index + 1}`}
                    value={city}
                    onChange={(e) => handleCityChange(index, e.target.value)}
                    className=" block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                    required
                  />
                  {cities.length > 1 && (
                    <button
                      type="button"
                      onClick={() => removeCityField(index)}
                      className="text-sm mt-2 mb-2 py-2 px-4 bg-red-600 text-white font-semibold rounded-md shadow hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
                    >
                      Remove
                    </button>
                  )}
                </div>
              ))}
            </div>

            <div className="flex gap-2">
              <button
                type="button"
                onClick={addCityField}
                className="text-sm py-2 px-4 bg-orange-600 text-white font-semibold rounded-md shadow hover:bg-orange-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
              >
                Add City
              </button>
              <button
                type="submit"
                className="text-sm py-2 px-4 bg-indigo-600 text-white font-semibold rounded-md shadow hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
              >
                Submit
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default FormAddCityProvince;
