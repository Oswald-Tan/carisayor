import Fruit from "../assets/fruits.png";
import Meat from "../assets/Meat.png";
import Fish from "../assets/Fish.png";
import Spice from "../assets/Spice.png";
import Vegetable from "../assets/Vegetable.png";

const Categories = () => {
  const categories = [
    { color: "bg-red-500", image: Vegetable, label: "Vegetables" },
    { color: "bg-primary", image: Spice, label: "Spices" },
    { color: "bg-purple-500", image: Fish, label: "Fish" },
    { color: "bg-orange-500", image: Meat, label: "Meat" },
    { color: "bg-teal-500", image: Fruit, label: "Fruits" },
  ];

  return (
    <section className="md:mt-0 mt-[140px] w-full min-h-screen flex items-center justify-center">
      <div className="text-center">
        <h1 className="md:text-[40px] text-[30px] font-medium">Explore Our Product</h1>
        <h1 className="md:text-[40px] text-[30px] font-medium text-primary">Categories</h1>

        <div className="mt-20 flex flex-wrap justify-center gap-3">
          {categories.map((item, index) => (
            <div
              key={index}
              className={`relative w-[350px] h-[160px] ${item.color} rounded-2xl overflow-hidden group cursor-pointer`}
            >
              {/* Teks sesuai dengan title category */}
              <div className="absolute inset-0 flex items-center justify-center text-white text-2xl font-bold transition-opacity duration-300 group-hover:opacity-0">
                {item.label}
              </div>

              {/* Gambar muncul saat hover */}
              <img
                src={item.image}
                alt={item.label}
                className="absolute inset-0 w-full h-full object-cover rounded-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              />

              {/* Overlay teks di atas gambar */}
              <div className="absolute inset-0 flex items-center justify-center text-white text-2xl font-bold bg-black/50 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                {item.label}
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Categories;
