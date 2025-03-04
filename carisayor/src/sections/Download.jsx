import Mockup from "../assets/mockup.png";
import { FaDownload } from "react-icons/fa6";

const Download = () => {
  return (
    <section className="w-full min-h-screen flex items-center justify-center">
      <div className="bg-[#F9F9F9] rounded-2xl w-full md:p-16 p-10 relative">
        <div className="flex flex-col md:items-start md:justify-start items-center justify-center">
          <h1 className="text-[20px] font-semibold">Download Sekarang</h1>
          <h1 className="text-[20px] font-semibold">& Nikmati Kemudahannya</h1>
          <p className="text-sm text-[#A1A1A1] mt-5 max-w-[720px] md:text-start text-center">
            Belanja kebutuhan dapur kini lebih cepat dan praktis! Unduh sekarang
            dan nikmati kemudahan belanja langsung dari genggamanmu.
          </p>
          <a
            href="https://carisayor.co.id/download/app"
            className="flex items-center gap-3 w-[190px] mt-5 text-center text-sm bg-[#338be3] text-white px-6 py-2 rounded-lg hover:bg-[#4d99e4] transition"
          >
            <FaDownload size={18} /> Download App
          </a>
        </div>
        <img
          src={Mockup}
          alt="mockup"
          className="absolute right-0 top-0 w-[474px] hidden md:block rounded-tr-2xl rounded-br-2xl"
        />
      </div>
    </section>
  );
};

export default Download;
