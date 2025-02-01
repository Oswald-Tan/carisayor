import React, { useEffect, useState } from "react";
import { RiSettings4Line, RiCoinLine } from "react-icons/ri";
import { TbLayoutDashboard } from "react-icons/tb";
import { AiOutlineUser, AiOutlineProduct } from "react-icons/ai";
import { MdOutlinePriceChange } from "react-icons/md";
import { LuHandCoins } from "react-icons/lu";
import { PiMapPinSimpleAreaBold } from "react-icons/pi";
import { TbReportMoney } from "react-icons/tb";
import { LiaShippingFastSolid } from "react-icons/lia";
import { HiOutlineClipboardList } from "react-icons/hi";
import { useSidebar } from "../context/useSidebar";
import { Link } from "react-router-dom";
import { useSelector } from "react-redux";
import Logo from "../assets/cs.png";

const Sidebar = () => {
  const { user } = useSelector((state) => state.auth);
  const { open, toggleSidebar } = useSidebar();
  const [menus, setMenus] = useState([]);

  useEffect(() => {
    if (user?.role) {
      const userRole = user.role;

      // Update menus berdasarkan role setelah user tersedia
      const updatedMenus = [
        {
          name: "Dashboard",
          link: "/dashboard",
          icon: TbLayoutDashboard,
        },
        ...(userRole !== "delivery"
          ? [{ name: "User", link: "/users", icon: AiOutlineUser }]
          : []),

        ...(userRole !== "delivery"
          ? [
              {
                name: "Top up",
                link: "/topup/poin",
                icon: LuHandCoins,
                margin: true,
              },
            ]
          : []),

        ...(userRole !== "delivery"
          ? [
              {
                name: "Poin",
                link: "/poin",
                icon: RiCoinLine,
              },
            ]
          : []),
        ...(userRole !== "delivery"
          ? [
              {
                name: "Harga poin",
                link: "/harga/poin",
                icon: MdOutlinePriceChange,
              },
            ]
          : []),
        {
          name: "Pesanan",
          link: "/pesanan",
          icon: HiOutlineClipboardList,
          margin: true,
        },
        ...(userRole !== "delivery"
          ? [
              {
                name: "Products",
                link: "/products",
                icon: AiOutlineProduct,
              },
            ]
          : []),
        ...(userRole !== "delivery"
          ? [
              {
                name: "Harga product",
                link: "/harga/poin/product",
                icon: TbReportMoney,
              },
            ]
          : []),
        ...(userRole !== "delivery"
          ? [
              {
                name: "City Province",
                link: "/city/province",
                icon: PiMapPinSimpleAreaBold,
                margin: true,
              },
            ]
          : []),
          ...(userRole !== "delivery"
            ? [
                {
                  name: "Shipping Rate",
                  link: "/shipping/rates",
                  icon: LiaShippingFastSolid,
                },
              ]
            : []),
        {
          name: "Setting",
          link: "/setting",
          icon: RiSettings4Line,
          margin: true,
        },
      ];

      setMenus(updatedMenus);
    }
  }, [user]);

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
          className={`bg-gradient-to-b from-[#200a26] to-[#371141] min-h-screen ${
            open
              ? "w-[280px]"
              : "md:w-[68px] md:translate-x-0 -translate-x-[280px]"
          } fixed top-0 left-0 z-20 duration-500 text-gray-100 px-4`}
        >
          <div className="py-4 px-2 flex relative">
            <h2
              className={`whitespace-pre duration-1000 text-xl font-semibold ${
                !open && "-translate-x-[280px] opacity-0"
              }`}
            >
              Admin Dashboard
            </h2>
            <img
              src={Logo}
              className={`absolute left-[6px] w-6 overflow-hidden duration-300 transition-opacity ${
                open ? "opacity-0 delay-0" : "opacity-100 delay-500"
              }`}
              alt="Logo"
            />
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
