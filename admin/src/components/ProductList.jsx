import { useState, useEffect } from "react";
import axios from "axios";
import { API_URL, API_URL_STATIC } from "../config";
import Button from "./ui/Button";
import ButtonAction from "./ui/ButtonAction";
import { RiApps2AddFill } from "react-icons/ri";
import { MdEditSquare, MdDelete } from "react-icons/md";

const ProductList = () => {
  const [products, setProducts] = useState([]);

  useEffect(() => {
    getProduct();
  }, []);

  const getProduct = async () => {
    try {
      const res = await axios.get(`${API_URL}/products`);
      setProducts(res.data);
      console.log(res.data);
    } catch (error) {
      console.error("Error fetching data", error);
    }
  };

  const deleteProduct = async (id) => {
    await axios.delete(`${API_URL}/products/${id}`);
    getProduct();
  };

  return (
    <div>
      <h2 className="text-2xl font-semibold mb-4">Produk</h2>
      <Button
        text="Add New"
        to="/products/add"
        iconPosition="left"
        icon={<RiApps2AddFill />}
        width={"w-[120px]"}
      />
      <div className="overflow-x-auto bg-white rounded-xl p-4 mt-5">
        {/* Tabel responsif */}
        <table className="table-auto w-full text-left text-black-100">
          <thead>
            <tr className="text-sm">
              <th className="px-4 py-2 border-b whitespace-nowrap">No</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">
                Nama Produk
              </th>
              <th className="px-4 py-2 border-b whitespace-nowrap">
                Deskripsi
              </th>
              <th className="px-4 py-2 border-b whitespace-nowrap">
                Harga (Poin)
              </th>
              <th className="px-4 py-2 border-b whitespace-nowrap">
                Harga (Rp)
              </th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Jumlah</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Satuan</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Image</th>
              <th className="px-4 py-2 border-b whitespace-nowrap">Actions</th>
            </tr>
          </thead>
          <tbody>
            {products.length > 0 ? (
              products.map((product, index) => (
                <tr key={index} className="text-sm">
                  <td className="px-4 py-2 border-b whitespace-nowrap">
                    {index + 1}
                  </td>
                  <td className="px-4 py-2 border-b whitespace-nowrap">
                    {product.nameProduk}
                  </td>
                  <td className="px-4 py-2 border-b whitespace-normal break-words w-72 min-w-72">
                    {product.deskripsi}
                  </td>
                  <td className="px-4 py-2 border-b whitespace-nowrap">
                    {product.hargaPoin}
                  </td>
                  <td className="px-4 py-2 border-b whitespace-nowrap">
                    Rp. {product.hargaRp.toLocaleString("id-ID")}
                  </td>
                  <td className="px-4 py-2 border-b whitespace-nowrap">
                    {product.jumlah}
                  </td>
                  <td className="px-4 py-2 border-b whitespace-nowrap">
                    {product.satuan}
                  </td>
                  <td className="px-4 py-2 border-b whitespace-nowrap">
                    <img
                      src={`${API_URL_STATIC}/${product.image}`}
                      alt={product.nameProduk}
                      className="w-10"
                    />
                  </td>
                  <td className="px-4 py-2 border-b whitespace-nowrap">
                    <div className="flex gap-x-2">
                      <ButtonAction
                        to={`/products/edit/${product.id}`}
                        icon={<MdEditSquare />}
                        className={"bg-orange-600 hover:bg-orange-700"}
                      />
                      <ButtonAction
                        onClick={() => deleteProduct(product.id)}
                        icon={<MdDelete />}
                        className={"bg-red-600 hover:bg-red-700"}
                      />
                    </div>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td
                  colSpan="9"
                  className="px-4 pt-4 text-center text-sm text-gray-500"
                >
                  Belum ada data
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default ProductList;
