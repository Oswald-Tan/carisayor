import { useState, useEffect } from "react";
import axios from "axios";
import { API_URL } from "../config";
import ButtonAction from "./ui/ButtonAction";
import { MdEditSquare, MdDelete } from "react-icons/md";
import formatDate from "../utils/formateDate";

const TopUpPoinList = () => {
  const [topUp, setTopUp] = useState([]);

  useEffect(() => {
    getTopUpPoin();
  }, []);

  const getTopUpPoin = async () => {
    try {
      const res = await axios.get(`${API_URL}/topup`);
      setTopUp(res.data);
    } catch (error) {
      console.error("Error fetching data", error);
    }
  };

  const deleteTopUpPoin = async (id) => {
    await axios.delete(`${API_URL}/topup/${id}`);
    getTopUpPoin();
  };

  return (
    <div>
      <h2 className="text-2xl font-semibold mb-4">Top Up</h2>
      <div className="overflow-x-auto bg-white rounded-xl p-4 mt-5">
        {/* Tabel responsif */}
        <table className="table-auto w-full text-left text-black-100">
          <thead>
            <tr className="text-sm">
              <th className="px-4 py-2 border-b whitespace-nowrap">No</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Username</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Email</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Poin</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Price</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Date</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Bank</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Status</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Actions</th>
            </tr>
          </thead>
          <tbody>
            {topUp.map((topup, index) => (
              <tr key={index} className="text-sm">
                <td className="px-4 py-2 border-b whitespace-nowrap">{index + 1}</td>
                <td className="px-4 py-2 border-b whitespace-nowrap">{topup.User.username}</td>
                <td className="px-4 py-2 border-b whitespace-nowrap">{topup.User.email}</td>
                <td className="px-4 py-2 border-b whitespace-nowrap">{topup.points}</td>
                <td className="px-4 py-2 border-b whitespace-nowrap">Rp. {topup.price.toLocaleString()}</td>
                <td className="px-4 py-2 border-b whitespace-nowrap">{formatDate(topup.date)}</td>
                <td className="px-4 py-2 border-b whitespace-nowrap">{topup.bankName}</td>
                <td className="px-4 py-2 border-b whitespace-nowrap">
                  {topup.status === "pending" ? (
                    <span className="px-2 py-1 text-xs text-white bg-orange-600 rounded-lg">Pending</span>
                  ) : topup.status === "approved" ? (
                    <span className="px-2 py-1 text-xs text-white bg-green-600 rounded-lg">Approved</span>
                  ) : topup.status === "rejected" ? (
                    <span className="px-2 py-1 text-xs text-white bg-red-600 rounded-lg">Rejected</span>
                  ) : (
                    <span className="px-2 py-1 text-xs text-white bg-gray-600 rounded-lg">Cancelled</span>
                  )}
                </td>
                <td className="px-4 py-2 border-b whitespace-nowrap">
                  <div className="flex gap-x-2">
                    {topup.status === "approved" ? null : <ButtonAction to={`/topup/poin/edit/${topup.id}`} icon={<MdEditSquare />} className={"bg-orange-600 hover:bg-orange-700"} />}
                    <ButtonAction onClick={() => deleteTopUpPoin(topup.id)} icon={<MdDelete />} className={"bg-red-600 hover:bg-red-700"} />
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

export default TopUpPoinList;
