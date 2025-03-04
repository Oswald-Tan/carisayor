import Navbar from "../components/Navbar";
import About from "../sections/About";
import Categories from "../sections/Categories";
import Download from "../sections/Download";
import Features from "../sections/Features";
import Footer from "../sections/Footer";
import Hero from "../sections/Hero";
import WhyUs from "../sections/WhyUs";

const LandingPage = () => {
  return (
    <div className="md:w-4/5 w-11/12 mx-auto">
      <Navbar />
      <Hero />
      <About />
      <WhyUs />
      <Categories />
      <Features />
      <Download />
      <Footer />
    </div>
  );
};

export default LandingPage;
