import Phone2 from "../assets/phone2.png";

const About = () => {
  return (
    <section
      id="about"
      className="md:mt-[120px] mt-[180px] min-h-screen flex itcems-center justify-center"
    >
      <div className="flex md:flex-row flex-col gap-[110px] items-center justify-center">
        <img src={Phone2} alt="phone2" className="w-[350px]" />
        <div>
          <h1 className="md:text-[40px] text-[30px] font-medium md:text-start text-center">
            About <span className="text-primary">Us</span>
          </h1>
          <p className="text-[#A1A1A1] text-sm mt-[60px] max-w-[480px] md:text-start text-center">
            Kami adalah aplikasi belanja kebutuhan dapur yang hadir untuk
            memudahkan Anda dalam memenuhi kebutuhan sehari-hari. Dengan
            berbagai pilihan produk segar dan berkualitas, kami bertujuan
            memberikan pengalaman belanja yang cepat, praktis, dan efisien,
            langsung dari genggaman tanganmu.
          </p>
          <a
            href="#"
            className="hidden md:block w-[150px] mt-[60px] text-center text-sm bg-[#F86E18] text-white px-6 py-2 rounded-lg hover:bg-[#f59154] transition"
          >
            Contact Us
          </a>
        </div>
      </div>
    </section>
  );
};

export default About;
