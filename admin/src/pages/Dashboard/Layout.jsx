import { useState, useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import { useNavigate } from "react-router-dom";
import { getMe } from "../../features/authSlice";
import { HiUserGroup } from "react-icons/hi2";
import { RiUserForbidFill } from "react-icons/ri";
import { MdPending, MdDoneAll, MdCancel } from "react-icons/md";
import Card from "../../components/ui/Card";
import axios from "axios";
import { API_URL } from "../../config";
import CardTotalTopUp from "../../components/CardTotalTopUp";
import { format } from "date-fns";
import { id } from "date-fns/locale";

const Layout = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const { isError, user } = useSelector((state) => state.auth);
  const [currentDate, setCurrentDate] = useState("");

  

  const [totalUsers, setTotalUsers] = useState(0);
  const [totalApprove, setTotalApprove] = useState(0);
  const [approvedTopUp, setApprovedTopUp] = useState(0);
  const [pendingTopUp, setPendingTopUp] = useState(0);
  const [cancelledTopUp, setCancelledTopUp] = useState(0);
  const [pesananPending, setPesananPending] = useState(0);

  useEffect(() => {
    const formattedDate = format(new Date(), "EEE, dd MMM", { locale: id });
    setCurrentDate(formattedDate);
  }, []);

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

    const fetchTotalUserApproveFalse = async () => {
      try {
        const res = await axios.get(`${API_URL}/count/user-approve-false`);
        setTotalApprove(res.data.totalUserApproveFalse);
      } catch (error) {
        console.error("Failed to fetch total approve users:", error);
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
    fetchTotalUserApproveFalse();
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
      <div className="mb-5">
        <p className="text-sm mb-3 font-medium dark:text-white">{currentDate}</p>
        <p className="md:text-2xl text-xl font-semibold dark:text-white">
          Hello, {user && user.fullname}!
        </p>
        <p className="md:text-2xl text-xl font-semibold bg-gradient-to-r from-purple-400 to-red-600 bg-clip-text text-transparent">
          Let’s get started on your tasks today.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-6 gap-3">
        <Card
          title="Registered Users"
          count={totalUsers}
          icon={<HiUserGroup />}
          iconColor="text-blue-500"
        />
        <Card
          title="Unapproved Users"
          count={totalApprove}
          icon={<RiUserForbidFill />}
          iconColor="text-red-700"
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

      <div className="mt-5">
        <CardTotalTopUp />
      </div>
    </div>
  );
};

export default Layout;
