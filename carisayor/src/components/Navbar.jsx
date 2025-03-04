import { useState } from "react";
import { FiX } from "react-icons/fi";
import { CgMenuRight } from "react-icons/cg";
import { motion } from "framer-motion";
import { Link } from "react-router-dom";

const Navbar = () => {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <nav className="bg-white w-full fixed top-0 left-0 z-50">
      <div className="container md:w-4/5 w-11/12 mx-auto py-3 flex justify-between items-center">
        {/* Logo */}
        <a href="#" className="text-xl font-bold text-primary">
          Carisayor
        </a>

        {/* Menu Items - Desktop */}
        <div className="hidden md:flex space-x-12 text-sm font-semibold">
          <a href="#" className="hover:text-primary">
            Home
          </a>
          <a href="#about" className="hover:text-primary">
            About Us
          </a>
          <a href="#whyus" className="hover:text-primary">
            Why Us
          </a>
          <a href="#features" className="hover:text-primary">
            Features
          </a>
        </div>

        {/* Button */}
        <Link to="/register"
          className="hidden md:block text-sm font-semibold bg-[#74B11A] text-white px-6 py-2 rounded-lg hover:bg-[#6DA718] transition"
        >
          Get Started
        </Link>

        {/* Mobile Menu Button */}
        <button
          onClick={() => setIsOpen(!isOpen)}
          className="md:hidden text-gray-600 focus:outline-none"
        >
          <motion.div
            initial={{ rotate: 0 }}
            animate={{ rotate: isOpen ? 90 : 0 }}
            transition={{ duration: 0.3 }}
          >
            {isOpen ? <FiX size={24} /> : <CgMenuRight size={24} />}
          </motion.div>
        </button>
      </div>

      {/* Mobile Menu */}
      <motion.div
        className="md:hidden bg-white shadow-md"
        initial={{ height: 0 }}
        animate={{ height: isOpen ? "auto" : 0 }}
        transition={{ duration: 0.5, ease: "easeInOut" }}
        style={{ overflow: "hidden" }} // Add this to ensure no content overflow
      >
        <a
          href="#"
          className="block px-6 py-2 text-gray-600 hover:text-primary"
        >
          Home
        </a>
        <a
          href="#about"
          className="block px-6 py-2 text-gray-600 hover:text-primary"
        >
          About Us
        </a>
        <a
          href="#whyus"
          className="block px-6 py-2 text-gray-600 hover:text-primary"
        >
          Why Us
        </a>
        <a
          href="#features"
          className="block px-6 py-2 mb-4 text-gray-600 hover:text-primary"
        >
          Features
        </a>
        <Link to={"/register"}
          className="block text-center mb-4 my-3 mx-6 text-sm font-semibold text-white bg-[#74B11A] px-6 py-2 rounded-lg hover:bg-[#6DA718] transition"
        >
          Get Started
        </Link>
      </motion.div>
    </nav>
  );
};

export default Navbar;
