import { useState, useEffect } from "react"
import axios from "axios"
import { API_URL } from "../config";
import Swal from "sweetalert2";
import Button from "./ui/Button";
import ButtonAction from "./ui/ButtonAction";
import { RiApps2AddFill } from "react-icons/ri";
import { MdEditSquare, MdDelete } from "react-icons/md";

const UserList = () => {
    const [users, setUsers] = useState([]);

  useEffect(() => {
    getUsers();
  }, []);

  const getUsers = async () => {
    const res = await axios.get(`${API_URL}/users/users`);
    setUsers(res.data);
    console.log(res.data);
  };

  const deleteUser = async (userId) => {
    await axios.delete(`${API_URL}/users/user/${userId}`);
    getUsers();

    Swal.fire({
      icon: "success",
      title: "Success",
      text: "User deleted successfully",
    });
  };

  return (
    <div>
      <h2 className="text-2xl font-semibold mb-4">Users</h2>
      <Button text="Add New" to="/users/add" iconPosition="left" icon={<RiApps2AddFill />} width={"w-[120px]"} />

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
            {users.map((user, index) => (
              <tr key={user.id} className="text-sm">
                <td className="px-4 py-2 border-b">{index + 1}</td>
                <td className="px-4 py-2 border-b">{user.username}</td>
                <td className="px-4 py-2 border-b">{user.email}</td>
                <td className="px-4 py-2 border-b">{user.role}</td>
                <td className="px-4 py-2 border-b">
                 

                  <div className="flex gap-x-2">
                    <ButtonAction to={`/users/edit/${user.id}`} icon={<MdEditSquare />} className={"bg-orange-600 hover:bg-orange-700"} />
                    <ButtonAction onClick={() => deleteUser(user.id)} icon={<MdDelete />} className={"bg-red-600 hover:bg-red-700"} />
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}

export default UserList