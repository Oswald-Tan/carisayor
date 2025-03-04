import { useState, useEffect } from "react";
import axios from "axios";
import { API_URL } from "../config";
import Button from "./ui/Button";
import ButtonAction from "./ui/ButtonAction";
import { RiApps2AddFill } from "react-icons/ri";
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
      <h2 className="text-2xl font-semibold mb-4 dark:text-white">Poins</h2>

  
      <Button
        text="Add New"
        to="/poin/add"
        iconPosition="left"
        icon={<RiApps2AddFill />}
        width={"w-[120px] "}
        className={"bg-purple-500 hover:bg-purple-600"}
      />

      <div className="overflow-x-auto bg-white dark:bg-[#282828] rounded-xl p-4 mt-5">
        {/* Tabel responsif */}
        <table className="table-auto w-full text-left text-black-100">
          <thead>
            <tr className="text-sm dark:text-white">
              <th className="px-4 py-2 border-b dark:border-[#3f3f3f] whitespace-nowrap">No</th>
              <th className="px-4 py-2 border-b dark:border-[#3f3f3f] whitespace-nowrap">Poin</th>
              <th className="px-4 py-2 border-b dark:border-[#3f3f3f] whitespace-nowrap">
                Diskon (%)
              </th>
              <th className="px-4 py-2 border-b dark:border-[#3f3f3f] whitespace-nowrap">
                Harga Asli
              </th>
              <th className="px-4 py-2 border-b dark:border-[#3f3f3f] whitespace-nowrap">
                Harga Setelah Diskon
              </th>
              <th className="px-4 py-2 border-b dark:border-[#3f3f3f] whitespace-nowrap">Actions</th>
            </tr>
          </thead>
          <tbody>
            {poins.map((poin, index) => (
              <tr key={index} className="text-sm dark:text-white">
                <td className="px-4 py-2 border-b dark:border-[#3f3f3f] whitespace-nowrap">{index + 1}</td>
                <td className="px-4 py-2 border-b dark:border-[#3f3f3f] whitespace-nowrap">{poin.poin}</td>
                <td className="px-4 py-2 border-b dark:border-[#3f3f3f] whitespace-nowrap">
                  {poin.discountPercentage}
                </td>
                <td className="px-4 py-2 border-b dark:border-[#3f3f3f] whitespace-nowrap">
                  Rp. {poin.originalPrice.toLocaleString()}
                </td>
                <td className="px-4 py-2 border-b dark:border-[#3f3f3f] whitespace-nowrap">
                  Rp. {poin.price.toLocaleString()}
                </td>
                <td className="px-4 py-2 border-b dark:border-[#3f3f3f] whitespace-nowrap">
                  <div className="flex gap-x-2">
                    <ButtonAction
                      to={`/poin/edit/${poin.id}`}
                      icon={<MdEditSquare />}
                      className={"bg-orange-600 hover:bg-orange-700"}
                    />
                    <ButtonAction
                      to={`/poin/add/discount/${poin.id}`}
                      icon={<MdDiscount />}
                      className={"bg-blue-600 hover:bg-blue-700"}
                    />
                    <ButtonAction
                      onClick={() => deletePoin(poin.id)}
                      icon={<MdDelete />}
                      className={"bg-red-600 hover:bg-red-700"}
                    />
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
