import { useState, useEffect } from "react";
import axios from "axios";
import { API_URL } from "../config";
import ButtonAction from "./ui/ButtonAction";
import { MdEditSquare, MdDelete } from "react-icons/md";

const PesananList = () => {
  const [pesanan, setPesanan] = useState([]);

  useEffect(() => {
    getPesanan();
  }, []);

  const getPesanan = async () => {
    try {
      const res = await axios.get(`${API_URL}/pesanan`);
      setPesanan(res.data);
    } catch (error) {
      console.error("Error fetching data", error);
    }
  };

  const deletePesanan = async (id) => {
    await axios.delete(`${API_URL}/pesanan/${id}`);
    getPesanan();
  };

  return (
    <div>
      <h2 className="text-2xl font-semibold mb-4">Pesanan</h2>
      <div className="overflow-x-auto bg-white rounded-xl p-4 mt-5">
        {/* Tabel responsif */}
        <table className="table-auto w-full text-left text-black-100">
          <thead>
            <tr className="text-sm">
              <th className="px-4 py-2 border-b whitespace-nowrap">No</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Username</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">
                Nama Produk
              </th>
              <th className="px-4 py-2 border-b whitespace-nowrap">
                Metode Pembayaran
              </th>
              <th className="px-4 py-2 border-b whitespace-nowrap">
                Harga (Rp)
              </th>
              <th className="px-4 py-2 border-b whitespace-nowrap">
                Harga (Poin)
              </th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Ongkir</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">
                Total Bayar (Rp)
              </th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Status</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Actions</th>
            </tr>
          </thead>
          <tbody>
            {pesanan.map((pesanan, index) => (
              <tr key={index} className="text-sm">
                <td className="px-4 py-2 border-b whitespace-nowrap">
                  {index + 1}
                </td>
                <td className="px-4 py-2 border-b whitespace-nowrap">
                  {pesanan.User.username}
                </td>
                <td className="px-4 py-2 border-b whitespace-nowrap">
                  {pesanan.nama && pesanan.nama.includes(",") ? (
                    <div className="flex flex-col gap-y-1">
                      {pesanan.nama.split(",").map((item, index) => (
                        <div key={index}>{item.trim()}</div>
                      ))}
                    </div>
                  ) : (
                    <span>{pesanan.nama || "-"}</span>
                  )}
                </td>

                <td className="px-4 py-2 border-b whitespace-nowrap">
                  {pesanan.metodePembayaran === "Poin" ? (
                    <span className="px-2 py-1 text-xs text-white bg-yellow-500 rounded-lg">
                      {pesanan.metodePembayaran}
                    </span>
                  ) : pesanan.metodePembayaran === "COD" ? (
                    <span className="px-2 py-1 text-xs text-white bg-green-500 rounded-lg">
                      {pesanan.metodePembayaran}
                    </span>
                  ) : (
                    pesanan.metodePembayaran
                  )}
                </td>

                <td className="px-4 py-2 border-b whitespace-nowrap">
                  {pesanan.hargaRp
                    ? `Rp. ${pesanan.hargaRp.toLocaleString("id-ID")}`
                    : "-"}
                </td>
                <td className="px-4 py-2 border-b whitespace-nowrap">
                  {pesanan.hargaPoin || "-"}
                </td>
                <td className="px-4 py-2 border-b whitespace-nowrap">
                  {pesanan.ongkir
                    ? `Rp. ${pesanan.ongkir.toLocaleString("id-ID")}`
                    : "-"}
                </td>
                <td className="px-4 py-2 border-b whitespace-nowrap">
                  {pesanan.hargaPoin ? (
                    <span className="px-2 py-1 text-xs text-white bg-yellow-500 rounded-lg">{`${pesanan.totalBayar} Poin`}</span>
                  ) : pesanan.hargaRp ? (
                    <span className="px-2 py-1 text-xs text-white bg-green-500 rounded-lg">
                      Rp. {pesanan.totalBayar.toLocaleString("id-ID")}
                    </span>
                  ) : (
                    "-"
                  )}
                </td>

                <td className="px-4 py-2 border-b whitespace-nowrap">
                  {pesanan.status === "pending" ? (
                    <span className="px-2 py-1 text-xs text-white bg-orange-600 rounded-lg">
                      Pending
                    </span>
                  ) : pesanan.status === "confirmed" ? (
                    <span className="px-2 py-1 text-xs text-white bg-green-600 rounded-lg">
                      Confirmed
                    </span>
                  ) : pesanan.status === "processed" ? (
                    <span className="px-2 py-1 text-xs text-white bg-blue-600 rounded-lg">
                      Processed
                    </span>
                  ) : pesanan.status === "out-for-delivery" ? (
                    <span className="px-2 py-1 text-xs text-white bg-yellow-600 rounded-lg">
                      Out for Delivery
                    </span>
                  ) : pesanan.status === "delivered" ? (
                    <span className="px-2 py-1 text-xs text-white bg-gray-600 rounded-lg">
                      Delivered
                    </span>
                  ) : (
                    <span className="px-2 py-1 text-xs text-white bg-red-600 rounded-lg">
                      Cancelled
                    </span>
                  )}
                </td>
                <td className="px-4 py-2 border-b whitespace-nowrap">
                  <div className="flex gap-x-2">
                    <ButtonAction
                      to={`/pesanan/edit/${pesanan.id}`}
                      icon={<MdEditSquare />}
                      className={"bg-orange-600 hover:bg-orange-700"}
                    />
                    <ButtonAction
                      onClick={() => deletePesanan(pesanan.id)}
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

export default PesananList;
