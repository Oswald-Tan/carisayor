import { useEffect, useState } from "react";
import axios from "axios";
import { API_URL } from "../config";
import { useParams } from 'react-router-dom';

const UserDetails = () => {
  const { id } = useParams();
  const [userDetails, setUserDetails] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const getUsers = async () => {
      try {
        const res = await axios.get(
          `${API_URL}/users/users/${id}/details`
        );
        if (!res.data) {
          setError("Belum ada detail");
        } else {
          setUserDetails(res.data);
          console.log(res.data);
        }
      } catch (error) {
        if (error.response && error.response.status === 404) {
          setError("Detail User Belum Ada");
        } else {
          setError(error.message); 
        }
      } finally {
        setLoading(false);
      }
    };
    getUsers();
  }, [id]);

  if (loading) {
    return <div>Loading...</div>;
  }

  if (error) {
    return <div>{error}</div>;
  }

  return (
    <>
      <div>
        <h2 className="text-2xl font-semibold mb-4">User Detail</h2>
        <div className="mt-5 overflow-x-auto bg-white rounded-xl p-4">
          <table className="table-auto w-full text-left text-black-100">
            <thead>
              <tr className="text-sm">
                <th className="px-4 py-2 border-b">Username</th>
                <th className="px-4 py-2 border-b">Email</th>
                <th className="px-4 py-2 border-b">Fullname</th>
                <th className="px-4 py-2 border-b">Phone Number</th>
                <th className="px-4 py-2 border-b">Image</th>
                <th className="px-4 py-2 border-b">Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr className="text-sm">
                <td className="px-4 py-2 border-b">{userDetails.username}</td>
                <td className="px-4 py-2 border-b">{userDetails.email}</td>
                <td className="px-4 py-2 border-b">{userDetails.fullname || "-"}</td>
                <td className="px-4 py-2 border-b">{userDetails.phone_number || "-"}</td>
                <td className="px-4 py-2 border-b">{userDetails.photo_profile || "-"}</td>
                <td className="px-4 py-2 border-b">
                  {/* Actions */}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </>
  );
};

export default UserDetails;
