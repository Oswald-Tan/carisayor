import { useState, useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import { useNavigate } from "react-router-dom";
import { getMe } from "../../features/authSlice";
import { HiUserGroup } from "react-icons/hi2";
import { MdPending, MdDoneAll, MdCancel } from "react-icons/md";
import Card from "../../components/ui/Card";
import axios from "axios";
import { API_URL } from "../../config";

const Layout = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const { isError, user } = useSelector((state) => state.auth);

  const [totalUsers, setTotalUsers] = useState(0);
  const [approvedTopUp, setApprovedTopUp] = useState(0);
  const [pendingTopUp, setPendingTopUp] = useState(0);
  const [cancelledTopUp, setCancelledTopUp] = useState(0);
  const [pesananPending, setPesananPending] = useState(0);

  // Fetch total users from API
  useEffect(() => {
    const fetchTotalUsers = async () => {
      try {
        const res = await axios.get(`${API_URL}/users/total-users`);
        setTotalUsers(res.data.totalUser);
      } catch (error) {
        console.error("Failed to fetch total users:", error);
      }
    };

    const fetchTotalApprovedTopUp = async () => {
      try {
        const res = await axios.get(`${API_URL}/topup/approved`);
        setApprovedTopUp(res.data.totalTopUp);
      } catch (error) {
        console.error("Failed to fetch total users:", error);
      }
    };

    const fetchTotalPendingTopUp = async () => {
      try {
        const res = await axios.get(`${API_URL}/topup/pending`);
        setPendingTopUp(res.data.totalTopUp);
      } catch (error) {
        console.error("Failed to fetch total users:", error);
      }
    };

    const fetchTotalCancelledTopUp = async () => {
      try {
        const res = await axios.get(`${API_URL}/topup/cancelled`);
        setCancelledTopUp(res.data.totalTopUp);
      } catch (error) {
        console.error("Failed to fetch total users:", error);
      }
    };

    const fetchTotalPendingPesanan = async () => {
      try {
        const res = await axios.get(`${API_URL}/count/pesanan-pending`);
        setPesananPending(res.data.totalPesananPending);
      } catch (error) {
        console.error("Failed to fetch total users:", error);
      }
    };

    fetchTotalUsers();
    fetchTotalPendingTopUp();
    fetchTotalApprovedTopUp();
    fetchTotalCancelledTopUp();
    fetchTotalPendingPesanan();
  }, []);

  useEffect(() => {
    dispatch(getMe());
  }, [dispatch]);

  useEffect(() => {
    if (isError) {
      navigate("/");
    }
  }, [isError, navigate]);

  return (
    <div>
      <div className=" p-5 text-white rounded-lg mb-5 bg-gradient-to-r from-pink-500 to-violet-600">
        <p>Hello, {user && user.role}!</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-5 gap-3">
        <Card
          title="Users"
          count={totalUsers}
          icon={<HiUserGroup />}
          iconColor="text-blue-500"
        />
        <Card
          title="Pending Top Up"
          count={pendingTopUp}
          icon={<MdPending />}
          iconColor="text-yellow-500"
        />
        <Card
          title="Approved Top Up"
          count={approvedTopUp}
          icon={<MdDoneAll />}
          iconColor="text-green-500"
        />
        <Card
          title="Cancelled Top Up"
          count={cancelledTopUp}
          icon={<MdCancel />}
          iconColor="text-red-500"
        />
        <Card
          title="Pesanan Pending"
          count={pesananPending}
          icon={<MdPending />}
          iconColor="text-orange-500"
        />
      </div>
    </div>
  );
};

export default Layout;
