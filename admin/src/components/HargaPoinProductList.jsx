import { useState, useEffect } from "react";
import axios from "axios";
import { API_URL } from "../config";
import ButtonAction from "./ui/ButtonAction";
import { MdEditSquare } from "react-icons/md";

const HargaPoinProductList = () => {
  const [hargaPoin, setHargaPoin] = useState(null);


  useEffect(() => {
    getHargaPoin();
  }, []);

  const getHargaPoin = async () => {
    const res = await axios.get(`${API_URL}/settings/harga-poin`);
    setHargaPoin(res.data.hargaPoin);
    console.log(res.data);
  };

  return (
    <div className="h-screen">
      <h2 className="text-2xl font-semibold mb-4">Harga Poin</h2>
      <div className="mt-5 overflow-x-auto bg-white rounded-xl p-4">
        {/* Tabel responsif */}
        <table className="table-auto w-full text-left text-black-100">
          <thead>
            <tr className="text-sm">
              <th className="px-4 py-2 border-b whitespace-nowrap">No</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Harga</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Actions</th>
            </tr>
          </thead>
          <tbody>
            {hargaPoin !== null ? (
              <tr className="text-sm">
                <td className="px-4 py-2 border-b whitespace-nowrap">1</td>
                <td className="px-4 py-2 border-b whitespace-nowrap">{hargaPoin}</td>
                <td className="px-4 py-2 border-b whitespace-nowrap">
                  <div className="flex gap-x-2">
                    <ButtonAction
                      to={`/harga/poin/product/edit`}
                      icon={<MdEditSquare />}
                      className={"bg-orange-600 hover:bg-orange-700"}
                    />
                  </div>
                </td>
              </tr>
            ) : null}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default HargaPoinProductList;
