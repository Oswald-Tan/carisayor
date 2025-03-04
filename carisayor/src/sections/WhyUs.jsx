import { FaTruckFast } from "react-icons/fa6";
import { IoIosWallet } from "react-icons/io";
import { SiFresh } from "react-icons/si";
import { HiMiniShoppingBag } from "react-icons/hi2";

const WhyUs = () => {
  const whyus = [
    {
      icon: <HiMiniShoppingBag className="text-[#31B8A1]" size={30} />,
      title: "Belanja Praktis",
      description: "Pesan bahan dapur dari mana saja dan kapan saja.",
      bgColor: "#ebfffc", 
    },
    {
      icon: <SiFresh className="text-[#882E9A]" size={30} />,
      title: "Produk Selalu Segar",
      description:
        "Kualitas terbaik langsung dari petani & supplier terpercaya.",
      bgColor: "#fdf3ff", 
    },
    {
      icon: <FaTruckFast className="text-[#0F80E3]" size={30} />,
      title: "Pengiriman Cepat",
      description: "Produk dikirim dalam hitungan jam, langsung ke rumahmu.",
      bgColor: "#ebf5ff", 
    },
    {
      icon: <IoIosWallet className="text-[#F86E18]" size={30} />,
      title: "Pembayaran Aman",
      description: "Dukung berbagai metode pembayaran yang aman & mudah.",
      bgColor: "#ffeee3", 
    },
  ];

  return (
    <section id="whyus" className="w-full flex items-center md:mt-0 mt-[140px]">
      <div className="w-full container mx-auto">
        {/* Judul */}
        <h1 className="md:text-[40px] text-[30px] font-medium text-center">
          We provide the best
        </h1>
        <h1 className="md:text-[40px] text-[30px] font-medium text-center">
          customer <span className="text-primary">experieces</span>
        </h1>

        {/* List Container */}
        <div className="mt-20 w-full">
          <ul className="grid md:grid-cols-4 grid-cols-1 md:gap-12 gap-12 w-full px-6">
            {whyus.map((whyus, index) => (
              <li key={index} className="flex flex-col md:items-start items-center md:text-start text-center">
                <div
                  className="w-[70px] h-[70px] rounded-2xl flex items-center justify-center"
                  style={{ backgroundColor: whyus.bgColor }}
                >
                  {whyus.icon}
                </div>
                <h1 className="text-xl font-medium mt-4">{whyus.title}</h1>
                <p className="text-sm text-[#A1A1A1] mt-2">
                  {whyus.description}
                </p>
              </li>
            ))}
          </ul>
        </div>
      </div>
    </section>
  );
};

export default WhyUs;
