import { useState, useEffect } from "react";
import axios from "axios";
import { API_URL } from "../config";
import ButtonAction from "./ui/ButtonAction";
import { MdEditSquare, MdDelete } from "react-icons/md";
import { formatDate } from "../utils/formateDate";
import ReactPaginate from "react-paginate";
import { MdSearch } from "react-icons/md";
import { io } from "socket.io-client";

const TopUpPoinList = () => {
  const [topUp, setTopUp] = useState([]);
  const [page, setPage] = useState(0);
  const [limit, setLimit] = useState(10);
  const [message, setMessage] = useState("");
  const [pages, setPages] = useState(0);
  const [rows, setRows] = useState(0);
  const [keyword, setKeyword] = useState("");
  const [query, setQuery] = useState("");
  const [typingTimeout, setTypingTimeout] = useState(null);

  useEffect(() => {
    const socket = io("http://localhost:8080", {
      withCredentials: true,
    });
    
  
    socket.on("connect", () => {
      console.log("Connected to socket server");
    });
  
    socket.on("disconnect", (reason) => {
      console.log("Disconnected from socket.io. Reason:", reason);
    });
  
    socket.on("newTopUp", (data) => {
      if (data.status === "pending") {
        new Notification("Top Up Pending", {
          body: `${data.username} has made a top-up of ${data.points} points.`,
        });
        console.log("New top-up pending:", data);
      }
    });
  
    return () => {
      socket.disconnect();
      console.log("Disconnected from socket.io");
    };
  }, []);
  
  
  

  useEffect(() => {
    // Meminta izin untuk notifikasi
    if ("Notification" in window && Notification.permission !== "granted") {
      Notification.requestPermission().then(permission => {
        if (permission !== "granted") {
          console.log("User denied notification permission");
        }
      });
    }
  }, []);
  

  const changePage = ({ selected }) => {
    setPage(selected);
    setMessage("");
  };

  const searchData = (e) => {
    e.preventDefault();
    setPage(0);
    setMessage("");
    setKeyword(query);
  };

  useEffect(() => {
    getTopUpPoin();
  }, [page, keyword, limit]);

  useEffect(() => {
    // Menangani pencarian otomatis
    if (typingTimeout) {
      clearTimeout(typingTimeout); // Menghapus timeout yang ada
    }
    const timeout = setTimeout(() => {
      setKeyword(query); // Mengatur keyword untuk pencarian
    }, 300); // Delay 300ms sebelum melakukan pencarian

    setTypingTimeout(timeout); // Menyimpan timeout
    return () => clearTimeout(timeout); // Membersihkan timeout saat komponen di-unmount
  }, [query]);

  const getTopUpPoin = async () => {
    try {
      const res = await axios.get(`${API_URL}/topup?search=${keyword}&page=${page}&limit=${limit}`);
      setTopUp(res.data.data || []); // Pastikan data array atau fallback ke array kosong
      setPages(res.data.totalPage || 0);
      setRows(res.data.totalRows || 0);
      setPage(res.data.page || 0);
  
      if (res.data.data.length === 0 && page > 0) {
        setPage(0);
      }
    } catch (error) {
      console.error("Error fetching data", error);
    }
  };
  

  const deleteTopUpPoin = async (id) => {
    await axios.delete(`${API_URL}/topup/${id}`);
    getTopUpPoin();
  };

  return (
    <>
      <div>
        <h2 className="text-2xl font-semibold">Top Up</h2>

        <div className="flex gap-2 mt-5">
          {/* Search filter */}
          <form onSubmit={searchData}>
            <div className="flex items-center relative w-[220px]">
              <input
                type="text"
                className="pr-10 pl-4 py-2 border border-gray-300 rounded-md w-full text-xs"
                placeholder="Search..."
                value={query}
                onChange={(e) => setQuery(e.target.value)}
              />
              <MdSearch
                size={20}
                className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400"
              />
            </div>
          </form>

          {/* Limit filter */}
          <form>
            <div className="flex items-center">
              <select
                id="limit"
                name="limit"
                className="px-4 py-2 border border-gray-300 rounded-md text-xs"
                onChange={(e) => {
                  setLimit(e.target.value);
                }}
              >
                <option value="">Select Limit</option>
                <option value="10">10</option>
                <option value="50">50</option>
                <option value="100">100</option>
              </select>
            </div>
          </form>
        </div>
        <div className="overflow-x-auto bg-white rounded-xl p-4 mt-5">
          {/* Tabel responsif */}
          <table className="table-auto w-full text-left text-black-100">
            <thead>
              <tr className="text-sm">
                <th className="px-4 py-2 border-b whitespace-nowrap">No</th>
                <th className="px-4 py-2 border-b whitespace-nowrap">
                  Username
                </th>
                <th className="px-4 py-2 border-b whitespace-nowrap">Email</th>
                <th className="px-4 py-2 border-b whitespace-nowrap">Poin</th>
                <th className="px-4 py-2 border-b whitespace-nowrap">Price</th>
                <th className="px-4 py-2 border-b whitespace-nowrap">Date</th>
                <th className="px-4 py-2 border-b whitespace-nowrap">Bank</th>
                <th className="px-4 py-2 border-b whitespace-nowrap">Status</th>
                <th className="px-4 py-2 border-b whitespace-nowrap">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody>
              {topUp.length > 0 ? (

              
              Array.isArray(topUp) &&
                topUp.map((topup, index) => (
                  <tr key={index} className="text-sm">
                    <td className="px-4 py-2 border-b whitespace-nowrap">
                      {index + 1}
                    </td>
                    <td className="px-4 py-2 border-b whitespace-nowrap">
                      {topup.User.username}
                    </td>
                    <td className="px-4 py-2 border-b whitespace-nowrap">
                      {topup.User.email}
                    </td>
                    <td className="px-4 py-2 border-b whitespace-nowrap">
                      {topup.points}
                    </td>
                    <td className="px-4 py-2 border-b whitespace-nowrap">
                      Rp. {topup.price.toLocaleString()}
                    </td>
                    <td className="px-4 py-2 border-b whitespace-nowrap">
                      {formatDate(topup.date)}
                    </td>
                    <td className="px-4 py-2 border-b whitespace-nowrap">
                      {topup.bankName}
                    </td>
                    <td className="px-4 py-2 border-b whitespace-nowrap">
                      {topup.status === "pending" ? (
                        <span className="px-2 py-1 text-xs text-white bg-orange-600 rounded-lg">
                          Pending
                        </span>
                      ) : topup.status === "approved" ? (
                        <span className="px-2 py-1 text-xs text-white bg-green-600 rounded-lg">
                          Approved
                        </span>
                      ) : topup.status === "rejected" ? (
                        <span className="px-2 py-1 text-xs text-white bg-red-600 rounded-lg">
                          Rejected
                        </span>
                      ) : (
                        <span className="px-2 py-1 text-xs text-white bg-gray-600 rounded-lg">
                          Cancelled
                        </span>
                      )}
                    </td>
                    <td className="px-4 py-2 border-b whitespace-nowrap">
                      <div className="flex gap-x-2">
                        {topup.status === "approved" ? null : (
                          <ButtonAction
                            to={`/topup/poin/edit/${topup.id}`}
                            icon={<MdEditSquare />}
                            className={"bg-orange-600 hover:bg-orange-700"}
                          />
                        )}
                        <ButtonAction
                          onClick={() => deleteTopUpPoin(topup.id)}
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
              )
              }
            </tbody>
          </table>
        </div>
      </div>

      <p className="mt-5 text-sm text-inverted-color pr-2">
        Total Rows: {rows} Page: {rows ? page + 1 : 0} of {pages}
      </p>
      <div>
        <span className="text-red-500">{message}</span>
      </div>

      {topUp.length > 0 ? (
        <nav key={rows}>
          <ReactPaginate
            previousLabel={"<"}
            nextLabel={">"}
            pageCount={Math.min(10, pages)}
            onPageChange={changePage}
            containerClassName="flex mt-2 list-none gap-1"
            pageLinkClassName="px-3 py-1 bg-blue-500 text-white rounded transition-all duration-300 cursor-pointer hover:bg-blue-400"
            previousLinkClassName="px-3 py-1 bg-blue-500 text-white rounded transition-all duration-300 cursor-pointer hover:bg-blue-400"
            nextLinkClassName="px-3 py-1 bg-blue-500 text-white rounded transition-all duration-300 cursor-pointer hover:bg-blue-400"
            activeLinkClassName="bg-purple-700 text-white cursor-default"
            disabledLinkClassName="opacity-50 cursor-not-allowed"
          />
        </nav>
      ) : null}
    </>
  );
};

export default TopUpPoinList;
