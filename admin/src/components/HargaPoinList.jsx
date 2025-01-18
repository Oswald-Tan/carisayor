import { useState, useEffect } from "react";
import axios from "axios";
import { Link } from "react-router-dom";
import { API_URL } from "../config";
import Swal from "sweetalert2";

const HargaPoinList = () => {
  const [hargas, setHargas] = useState([]);

  useEffect(() => {
    getHargaPoin();
  }, []);

  const getHargaPoin = async () => {
    const res = await axios.get(`${API_URL}/harga`);
    setHargas(res.data);
    console.log(res.data);
  };

  const deleteHargaPoin = async (id) => {
    await axios.delete(`${API_URL}/harga/${id}`);
    getHargaPoin();

    Swal.fire({
      icon: "success",
      title: "Success",
      text: "User deleted successfully",
    });
  };

  return (
    <div className="h-screen">
      <h2 className="text-2xl font-semibold mb-4">Harga Poin</h2>
      <Link
        className="text-sm bg-indigo-600 text-white font-semibold rounded-md shadow hover:bg-indigo-700 focus:outline-none px-6 py-1"
        to="/harga/poin/add"
      >
        Add New
      </Link>
      <div className="mt-5 overflow-x-auto bg-white rounded-xl p-4">
        {/* Tabel responsif */}
        <table className="table-auto w-full text-left text-black-100">
          <thead>
            <tr className="text-sm">
              <th className="px-4 py-2 border-b">No</th>
              <th className="px-4 py-2 border-b">Harga</th>
              <th className="px-4 py-2 border-b">Actions</th>
            </tr>
          </thead>
          <tbody>
            {hargas.map((harga, index) => (
              <tr key={harga.id} className="text-sm">
                <td className="px-4 py-2 border-b">{index + 1}</td>
                <td className="px-4 py-2 border-b">{harga.harga}</td>
                <td className="px-4 py-2 border-b">
                  <Link
                    to={`/harga/poin/edit/${harga.id}`}
                    className="bg-indigo-600 text-white rounded-md shadow hover:bg-indigo-700 focus:outline-none px-6 py-1 mr-2"
                  >
                    Edit
                  </Link>
                  <button
                    onClick={() => deleteHargaPoin(harga.id)}
                    className=" bg-red-600 text-white rounded-md shadow hover:bg-red-700 focus:outline-none px-6 py-1"
                  >
                    Delete
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default HargaPoinList;
