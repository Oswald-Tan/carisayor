import { useEffect, useState } from "react";
import axios from "axios";
import { API_URL } from "../config";
import { useParams } from "react-router-dom";
import { formatDate } from "../utils/formateDate";

const UserStats = () => {
  const { id } = useParams();
  const [userStats, setUserStats] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const getStats = async () => {
      try {
        const res = await axios.get(`${API_URL}/user-stats/${id}/stats`);
        setUserStats(res.data);
      } catch (error) {
        setError(error.message);
      } finally {
        setLoading(false);
      }
    };
    getStats();
  }, [id]);

  if (loading) {
    return <div>Loading...</div>;
  }

  if (error) {
    return <div>{error}</div>;
  }

  // Memastikan last_login valid sebelum diproses
  const formattedLastLogin = userStats?.last_login
    ? formatDate(userStats.last_login)
    : "-";

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
                <th className="px-4 py-2 border-b">Last Login</th>
                <th className="px-4 py-2 border-b">Total Login</th>
              </tr>
            </thead>
            <tbody>
              <tr className="text-sm">
                <td className="px-4 py-2 border-b">{userStats.username}</td>
                <td className="px-4 py-2 border-b">{userStats.email}</td>
                <td className="px-4 py-2 border-b">{formattedLastLogin}</td>
                <td className="px-4 py-2 border-b">
                  {userStats.total_logins || "-"}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </>
  );
};

export default UserStats;
