import Phone from "../assets/phone.png";
import { motion } from "framer-motion";

const Hero = () => {
  return (
    <section className="md:min-h-screen sm:h-screen h-[650px] w-full relative">
      <div className="flex items-center justify-center">
        <div className="mt-[120px]">
          <div className="flex flex-col items-center justify-center">
            <motion.h1
              initial={{ opacity: 0, y: -20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: 0.3 }}
              className="md:text-[40px] text-[30px] font-medium"
            >
              Fresh Ingredients
            </motion.h1>
            <motion.h1
              initial={{ opacity: 0, y: -20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: 0.5 }}
              className="md:text-[40px] text-[30px] text-primary font-medium text-center"
            >
              Hassle Free Shopping
            </motion.h1>
            <motion.p
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: 0.7 }}
              className="text-[#A1A1A1] text-xs md:mt-4 mt-10 max-w-[480px] text-center"
            >
              Belanja Kebutuhan Dapur Jadi Lebih Mudah! Download Aplikasi Kami &
              Nikmati Kemudahan Berbelanja di Genggaman Tangan.
            </motion.p>
            <motion.a
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.5 }} 
            href="https://carisayor.co.id/download/app">
            <button className="w-[180px] mt-[30px] text-center text-sm font-semibold bg-primary text-white px-6 py-2 rounded-lg hover:bg-[#8ec53d] transition">Download Now</button>
          </motion.a>
          </div>
          
          <motion.div
            initial={{ scale: 0.8, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{ duration: 0.8, delay: 1 }}
            className="bg-[#AAEB4A] md:w-[980px] mx-auto sm:w-[450px] w-[250px] h-[130px] md:h-[220px] sm:mt-[70px] rounded-3xl flex items-center justify-center md:mt-[180px] mt-[50px]"
          ></motion.div>

          {/* Kontainer untuk gambar, posisi absolute */}
          <motion.div
            initial={{
              opacity: 0,
              y: 50,
              x: "-50%", 
            }}
            animate={{
              opacity: 1,
              y: 0,
              x: "-50%", 
            }}
            transition={{ duration: 0.8, delay: 1.2 }}
            className="absolute bottom-0 left-1/2 w-[750px] md:w-[680px] max-w-full" 
          >
            <img
              src={Phone}
              alt="phone"
              className="sm:w-full md:w-full"
            />
          </motion.div>
        </div>
        {/* Gradient bg */}
        <motion.div 
         initial={{
          opacity: 0,
          y: 50,
        }}
        animate={{
          opacity: 1,
          y: 0,
        }}
        transition={{ duration: 0.8, delay: 1.2 }}
        className="absolute -bottom-1 w-full h-[250px] bg-gradient-to-t from-white/100 to-white/0"></motion.div>
      </div>
    </section>
  );
};

export default Hero;
