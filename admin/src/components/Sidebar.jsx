import React from "react";
import { RiSettings4Line, RiCoinLine } from "react-icons/ri";
import { TbLayoutDashboard } from "react-icons/tb";
import { AiOutlineUser, AiOutlineProduct } from "react-icons/ai";
import { MdOutlinePriceChange } from "react-icons/md";
import { LuHandCoins } from "react-icons/lu";
import { PiMapPinSimpleAreaBold } from "react-icons/pi";
import { TbReportMoney } from "react-icons/tb";
import { HiOutlineClipboardList } from "react-icons/hi";
import { useSidebar } from "../context/useSidebar";
import { Link } from "react-router-dom";
import { useSelector } from "react-redux";

const Sidebar = () => {
  const { user } = useSelector((state) => state.auth); // Ambil data user dari Redux store
  const { open, toggleSidebar } = useSidebar();

  // Menambahkan pengecekan role pada menu User
  const menus = [
    { 
      name: "dashboard", 
      link: "/dashboard", 
      icon: TbLayoutDashboard 
    },
    ...(user && user.role === "admin"
      ? [{ name: "User", link: "/users", icon: AiOutlineUser }]
      : []),
    { 
      name: "top up", 
      link: "/topup/poin", 
      icon: LuHandCoins, 
      margin: true },
    { 
      name: "poin", 
      link: "/poin", 
      icon: RiCoinLine },
    { 
      name: "harga poin", 
      link: "/harga/poin", 
      icon: MdOutlinePriceChange },
    { 
      name: "pesanan", 
      link: "/pesanan", 
      icon: HiOutlineClipboardList, 
      margin: true,
    },
    { 
      name: "products", 
      link: "/products", 
      icon: AiOutlineProduct, 
    },
    { 
      name: "harga product", 
      link: "/harga/poin/product", 
      icon: TbReportMoney, 
    },
    { 
      name: "Supported area", 
      link: "/supported/area", 
      icon: PiMapPinSimpleAreaBold,
      margin: true,
    },
    { 
      name: "City Province", 
      link: "/city/province", 
      icon: PiMapPinSimpleAreaBold,
    },
    { 
      name: "Setting", 
      link: "/setting", 
      icon: RiSettings4Line,
      margin: true,
    },
  ];

  return (
    <>
      {/* Overlay untuk sidebar mobile */}
      {open && (
        <div
          onClick={toggleSidebar}
          className="fixed inset-0 bg-black opacity-50 z-10 md:hidden"
        />
      )}

      <section className="flex gap-6 relative">
        <div
          className={` bg-gradient-to-b from-[#200a26] to-[#371141] min-h-screen ${
            open
              ? "w-[280px]"
              : "md:w-[68px] md:translate-x-0 -translate-x-[280px]"
          } fixed top-0 left-0 z-20 duration-500 text-gray-100 px-4`}
        >
          <div className="py-4 px-2 flex">
            <h2
              className={`whitespace-pre duration-500 text-xl font-semibold ${
                !open && "-translate-x-[280px] opacity-0"
              }`}
            >
              Admin Dashboard
            </h2>
          </div>
          <div className="mt-2 flex flex-col gap-4 relative">
            {menus.map((menu, i) => (
              <Link
                to={menu.link}
                key={i}
                className={`${
                  menu.margin && "mt-5"
                } group flex items-center text-sm gap-3.5 font-medium p-2 hover:bg-[#36143f] rounded-xl`}
              >
                <div>{React.createElement(menu.icon, { size: "20" })}</div>
                <h2
                  style={{
                    transitionDelay: `${i + 3}00ms`,
                  }}
                  className={`whitespace-pre duration-500 ${
                    !open && "opacity-0 translate-x-28 overflow-hidden"
                  }`}
                >
                  {menu.name}
                </h2>
                <h2
                  className={`${
                    open && "hidden"
                  } absolute left-48 bg-white font-semibold whitespace-pre text-gray-900 rounded-md drop-shadow-lg px-0 py-0 w-0 overflow-hidden group-hover:px-2 group-hover:py-1 group-hover:left-14 group-hover:duration-300 group-hover:w-fit`}
                >
                  {menu.name}
                </h2>
              </Link>
            ))}
          </div>
        </div>
      </section>
    </>
  );
};

export default Sidebar;
