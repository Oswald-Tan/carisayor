import { HiMenuAlt3 } from "react-icons/hi";
import { useSidebar } from "../context/useSidebar";
import { useNavigate } from "react-router-dom";
import { useDispatch, useSelector } from "react-redux";
import { LogOut, reset } from "../features/authSlice";
import { useState } from "react";
import { IoLogOut } from "react-icons/io5";
import { AiOutlineUser } from "react-icons/ai";

const Navbar = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const { user } = useSelector((state) => state.auth);
  const { toggleSidebar } = useSidebar();
  const [isProfileOpen, setIsProfileOpen] = useState(false); // State untuk toggle profile menu

  const logout = async () => {
    dispatch(LogOut());
    dispatch(reset());
    navigate("/");
  };

  return (
    <div className="relative flex items-center justify-between h-[56px] px-4 bg-white">
      {/* Toggle Sidebar */}
      <button
        className="cursor-pointer text-[#0e0e0e]"
        onClick={toggleSidebar}
        aria-label="Toggle Sidebar"
      >
        <HiMenuAlt3 size={26} />
      </button>

      {/* Toggle Profile */}
      <div className="relative">
        <div
          className="flex items-center justify-center gap-1 cursor-pointer"
          onClick={() => setIsProfileOpen((prev) => !prev)} // Toggle state
        >
          <div className="border border-gray-500 rounded-full p-1">
            <AiOutlineUser size={20} className="text-gray-500 " />
          </div>
          <p className="text-xs text-gray-500">{user && user.username}</p>
        </div>

        {isProfileOpen && (
          <div className="absolute right-0 mt-2 w-40 bg-white border border-gray-200 rounded-lg shadow-lg">
            <button
              onClick={logout}
              className="block w-full px-4 py-2 text-left text-sm text-red-600 hover:bg-gray-100 hover:rounded-lg transition-all duration-150"
            >
              <span className="flex items-center gap-x-2">
                <IoLogOut size={20} /> <p className="font-semibold">Logout</p>
              </span>
            </button>
          </div>
        )}
      </div>
    </div>
  );
};

export default Navbar;
