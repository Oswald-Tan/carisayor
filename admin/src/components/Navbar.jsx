import { HiMenuAlt3 } from "react-icons/hi";
import { useSidebar } from "../context/useSidebar";
import { useNavigate } from "react-router-dom";
import { useDispatch, useSelector } from "react-redux";
import { LogOut, reset } from "../features/authSlice";


const Navbar = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const { user } = useSelector((state) => state.auth);
  const { toggleSidebar } = useSidebar();

  const logout = async () => {
    dispatch(LogOut());
    dispatch(reset());
    navigate("/");
  };

  return (
    <div className="flex items-center justify-between h-[56px] px-4 bg-white">
      <button
        className="cursor-pointer text-[#0e0e0e]"
        onClick={toggleSidebar}
        aria-label="Toggle Sidebar"
      >
        <HiMenuAlt3 size={26} />
      </button>

      {/* Tombol Logout */}
      <div>
        <button onClick={logout} className="text-white text-sm bg-slate-900 px-4 py-1 rounded-lg">
          Logout
        </button>
      </div>
    </div>
  );
};

export default Navbar;
