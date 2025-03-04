import { AiFillInstagram } from "react-icons/ai";
import { BsYoutube } from "react-icons/bs";
import { FaFacebookSquare, FaAt  } from "react-icons/fa";
import { FaPhone } from "react-icons/fa6";
import Logo from "../assets/casa_logo.png";

const Footer = () => {
  return (
    <footer className="w-full py-6">
      <div className="flex md:justify-between justify-center md:flex-row flex-col">
        <div>
          <div className="flex gap-3 items-center jc">
            <img src={Logo} alt="logo" className="w-9" />
            <h1 className="text-xl font-semibold">Carisayor</h1>
          </div>
          <div className="mt-5">
            <p className="">Address</p>
            <p className="text-[#A1A1A1] text-sm mt-2">
              Manado, Sulawesi Utara
            </p>
          </div>
          <div className="mt-5">
            <p className="">Contact Us</p>
            <p className="text-[#A1A1A1] text-sm mt-2 flex items-center gap-2">
              <FaPhone size={16} /> +62 896 7375 1717
            </p>
            <a
              href="mailto:contact@carisayor.co.id"
              className="text-[#A1A1A1] text-sm mt-2 flex items-center gap-2"
            >
              <FaAt size={16} /> contact@carisayor.co.id
            </a>
          </div>
        </div>
        <div>
          <div className="flex gap-20 mt-10 md:mt-0">
            <div>
              <h1 className="text-sm font-semibold">Sitemap</h1>
              <div className="mt-5 flex flex-col">
                <a href="#" className="text-[#A1A1A1] text-sm mt-2">
                  Home
                </a>
                <a href="#features" className="text-[#A1A1A1] text-sm mt-2">
                  Features
                </a>
              </div>
            </div>
            <div>
              <h1 className="text-sm font-semibold">Company</h1>
              <div className="mt-5 flex flex-col">
                <a href="#about" className="text-[#A1A1A1] text-sm mt-2">
                  About Us
                </a>
                <a href="#" className="text-[#A1A1A1] text-sm mt-2">
                  Contact Us
                </a>
              </div>
            </div>
          </div>
          <div className="md:mt-5 mt-10">
            <div className="flex gap-5">
              <a
                href="#"
                className="w-10 h-10 bg-[#F3F3F3] rounded-full text-orange-600 flex items-center justify-center cursor-pointer"
              >
                <AiFillInstagram size={22} />
              </a>
              <a
                href="#"
                className="w-10 h-10 bg-[#F3F3F3] rounded-full text-red-600 flex items-center justify-center cursor-pointer"
              >
                <BsYoutube size={22} />
              </a>
              <a
                href="#"
                className="w-10 h-10 bg-[#F3F3F3] rounded-full text-blue-600 flex items-center justify-center cursor-pointer"
              >
                <FaFacebookSquare size={22} />
              </a>
            </div>
          </div>
        </div>
      </div>
      <div className="border-t border-[#e9e9e9] my-6"></div>
      <div className="text-center text-sm text-gray-400">
        &copy; {new Date().getFullYear()} Carisayor. All rights reserved.
      </div>
    </footer>
  );
};

export default Footer;
