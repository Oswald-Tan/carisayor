import Search from "../assets/search.png";
import Kategori from "../assets/kategori.png";
import Cart from "../assets/cart.png";
import { IoIosSearch } from "react-icons/io";

const featuresList = [
  {
    image: Search,
    title: "Search produk",
    description: "Temukan kebutuhan dapurmu dengan cepat dan mudah.",
    hasSearchBar: true,
  },
  {
    image: Kategori,
    title: "Kategori Lengkap",
    description: "Sayur, buah, bumbu dapur, dan lainnya dalam satu aplikasi.",
  },
  {
    image: Cart,
    title: "Keranjang Belanja",
    description: "Masukkan berbagai produk ke dalam keranjang belanja!",
  },
];

const Features = () => {
  return (
    <section id="features" className="w-full min-h-screen flex items-center justify-center mt-[140px] md:mt-0 px-4">
      <div className="max-w-6xl w-full">
        <div className="text-center">
          <h1 className="text-[30px] md:text-[40px] font-medium">Features</h1>
          <p className="text-[#A1A1A1] text-sm md:text-base mt-4 max-w-[480px] mx-auto">
            Nikmati pengalaman belanja kebutuhan dapur yang lebih mudah, cepat, dan praktis dengan fitur-fitur yang kami sediakan.
          </p>
        </div>

        <ul className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6 mt-10">
          {featuresList.map((feature, index) => (
            <li key={index} className="bg-[#F9F9F9] rounded-2xl p-4 border border-[#e9e9e9] shadow-sm">
              <div className="flex flex-col items-center bg-white rounded-2xl p-4 shadow-md h-[280px] relative w-full overflow-hidden">
                {feature.hasSearchBar && (
                  <div className="bg-[#F0F1F5] w-full rounded-xl text-[#A1A1A1] py-2 px-4 mb-4 flex items-center justify-between text-sm">
                    Search...
                    <IoIosSearch size={20} />
                  </div>
                )}
                <img src={feature.image} alt={feature.title} className="w-full h-full object-contain" />
                <div className="absolute bottom-0 w-full h-[200px] bg-gradient-to-t from-white/100 to-white/0 rounded-b-2xl"></div>
              </div>
              <h1 className="text-lg font-semibold text-center mt-4">{feature.title}</h1>
              <p className="text-sm text-[#A1A1A1] text-center mt-2">{feature.description}</p>
            </li>
          ))}
        </ul>
      </div>
    </section>
  );
};

export default Features;
