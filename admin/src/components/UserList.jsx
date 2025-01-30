import { useState, useEffect } from "react";
import axios from "axios";
import { API_URL } from "../config";
import Swal from "sweetalert2";
import Button from "./ui/Button";
import ButtonAction from "./ui/ButtonAction";
import { RiApps2AddFill } from "react-icons/ri";
import { MdEditSquare, MdDelete, MdSearch } from "react-icons/md";
import { GrPowerReset } from "react-icons/gr";
import { BiSolidUserDetail, BiStats } from "react-icons/bi";
import ReactPaginate from "react-paginate";

const UserList = () => {
  const [users, setUsers] = useState([]);
  const [page, setPage] = useState(0);
  const [limit, setLimit] = useState(10);
  const [message, setMessage] = useState("");
  const [pages, setPages] = useState(0);
  const [rows, setRows] = useState(0);
  const [keyword, setKeyword] = useState("");
  const [query, setQuery] = useState("");
  const [typingTimeout, setTypingTimeout] = useState(null);

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
    getUsers();
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

  const getUsers = async () => {
    try {
      const res = await axios.get(
        `${API_URL}/users/users?search=${keyword}&page=${page}&limit=${limit}`
      );
      setUsers(res.data.data);
      setPages(res.data.totalPage);
      setRows(res.data.totalRows);
      setPage(res.data.page);

      if (res.data.data.length === 0 && page > 0) {
        setPage(0);
      }
    } catch (error) {
      console.error("Error fetching data", error.response);
    }
  };

  const handleReset = async (id) => {
    Swal.fire({
      title: "Apakah Anda yakin?",
      text: "Password akan direset ke default!",
      icon: "warning",
      showCancelButton: true,
      confirmButtonText: "Ya, reset!",
    }).then(async (result) => {
      if (result.isConfirmed) {
        try {
          await axios.put(`${API_URL}/auth-web/update-pass/${id}`);
          Swal.fire("Berhasil!", "Password telah direset.", "success");
        } catch (error) {
          Swal.fire("Error!", error.response?.data?.message || "Terjadi kesalahan", "error");
        }
      }
    });
  };
  

  const deleteUser = async (userId) => {
    Swal.fire({
      title: "Are you sure?",
      text: "You won't be able to revert this!",
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#d33",
      cancelButtonColor: "#3085d6",
      confirmButtonText: "Yes, delete it!",
    }).then(async (result) => {
      if (result.isConfirmed) {
        await axios.delete(`${API_URL}/users/user/${userId}`);
        getUsers();
  
        Swal.fire({
          icon: "success",
          title: "Deleted!",
          text: "User deleted successfully.",
        });
      }
    });
  };
  

  return (
    <>
      <div>
        <h2 className="text-2xl font-semibold mb-4">Users</h2>

        <div className="flex gap-2 justify-between items-center">
          <Button
            text="Add New"
            to="/users/add"
            iconPosition="left"
            icon={<RiApps2AddFill />}
            width={"w-[120px] "}
          />
          <div className="flex gap-2">
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
                  className="px-4 py-2 border border-gray-300 rounded-md text-xs appearance-none"
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
        </div>

        <div className="mt-5 overflow-x-auto bg-white rounded-xl p-4">
          {/* Tabel responsif */}
          <table className="table-auto w-full text-left text-black-100">
            <thead>
              <tr className="text-sm">
                <th className="px-4 py-2 border-b">No</th>
                <th className="px-4 py-2 border-b">Username</th>
                <th className="px-4 py-2 border-b">Email</th>
                <th className="px-4 py-2 border-b">Role</th>
                <th className="px-4 py-2 border-b">Actions</th>
              </tr>
            </thead>
            <tbody>
              {users.length > 0 ? (
                users.map((user, index) => (
                  <tr key={user.id} className="text-sm">
                    <td className="px-4 py-2 border-b">{index + 1}</td>
                    <td className="px-4 py-2 border-b">{user.username}</td>
                    <td className="px-4 py-2 border-b">{user.email}</td>
                    <td className="px-4 py-2 border-b">
                      {user.role === "admin" ? (
                        <span className="px-2 py-1 text-xs text-orange-600 border border-orange-600 rounded-lg">
                          Admin
                        </span>
                      ) : user.role === "user" ? (
                        <span className="px-2 py-1 text-xs text-green-600 border border-green-600 rounded-lg">
                          User
                        </span>
                      ) : (
                        <span className="px-2 py-1 text-xs text-blue-600 border border-blue-600 rounded-lg">
                          Delivery
                        </span>
                      )}
                    </td>

                    <td className="px-4 py-2 border-b">
                      <div className="flex gap-x-2">
                        <ButtonAction
                          to={`/users/edit/${user.id}`}
                          icon={<MdEditSquare />}
                          className={"bg-orange-600 hover:bg-orange-700"}
                        />
                        <ButtonAction
                          to={`/users/${user.id}/details`}
                          icon={<BiSolidUserDetail />}
                          className={"bg-blue-600 hover:bg-blue-700"}
                        />
                        <ButtonAction
                          to={`/users/${user.id}/stats`}
                          icon={<BiStats />}
                          className={"bg-purple-600 hover:bg-purple-700"}
                        />
                        <ButtonAction
                          onClick={() => handleReset(user.id)}
                          icon={<GrPowerReset />}
                          className={"bg-green-600 hover:bg-green-700"}
                        />
                        <ButtonAction
                          onClick={() => deleteUser(user.id)}
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
                    colSpan="5"
                    className="px-4 pt-4 text-sm text-center text-gray-500"
                  >
                    Belum ada data
                  </td>
                </tr>
              )}
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

      {users.length > 0 ? (
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

export default UserList;
