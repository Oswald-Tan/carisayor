import { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import axios from "axios";
import { API_URL } from "../config";
import ButtonAction from "./ui/ButtonAction";
import { MdDiscount, MdEditSquare, MdDelete } from "react-icons/md";

const PoinList = () => {
  const [poins, setPoins] = useState([]);

  useEffect(() => {
    getPoins();
  }, []);

  const getPoins = async () => {
    try {
      const res = await axios.get(`${API_URL}/poin`);
      setPoins(res.data); // Menyimpan data yang sudah diformat dari backend
      console.log(res.data); // Mengecek data yang diterima
    } catch (error) {
      console.error("Error fetching data", error);
    }
  };

  const deletePoin = async (id) => {
    await axios.delete(`${API_URL}/poin/${id}`);
    getPoins();
  };

  return (
    <div>
      <h2 className="text-2xl font-semibold mb-4">Poins</h2>
      <Link
        className="text-sm bg-indigo-600 text-white font-semibold rounded-md shadow hover:bg-indigo-700 focus:outline-none px-6 py-1"
        to="/poin/add"
      >
        Add New
      </Link>
      <div className="overflow-x-auto bg-white rounded-xl p-4 mt-5">
        {/* Tabel responsif */}
        <table className="table-auto w-full text-left text-black-100">
          <thead>
            <tr className="text-sm">
              <th className="px-4 py-2 border-b whitespace-nowrap">No</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Poin</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Diskon (%)</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Harga Asli</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Harga Setelah Diskon</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Actions</th>
            </tr>
          </thead>
          <tbody>
            {poins.map((poin, index) => (
              <tr key={index} className="text-sm">
                <td className="px-4 py-2 border-b">{index + 1}</td>
                <td className="px-4 py-2 border-b">{poin.poin}</td>
                <td className="px-4 py-2 border-b">{poin.discountPercentage}</td>
                <td className="px-4 py-2 border-b">
                  Rp. {poin.originalPrice.toLocaleString()}
                </td>
                <td className="px-4 py-2 border-b">
                  Rp. {poin.price.toLocaleString()}
                </td>
                <td className="px-4 py-2 border-b">
                  <div className="flex gap-x-2">
                    <ButtonAction to={`/poin/edit/${poin.id}`} icon={<MdEditSquare />} className={"bg-orange-600 hover:bg-orange-700"} />
                    <ButtonAction to={`/poin/add/discount/${poin.id}`} icon={<MdDiscount />} className={"bg-blue-600 hover:bg-blue-700"} />
                    <ButtonAction onClick={() => deletePoin(poin.id)} icon={<MdDelete />} className={"bg-red-600 hover:bg-red-700"} />
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default PoinList;
