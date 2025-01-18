import Poin from "../models/poin.js";
import HargaPoin from "../models/hargaPoin.js";

// export const getPoins = async (req, res) => {
//   try {
//     const data = await Poin.findAll();
//     res.status(200).json(data);
//   } catch (error) {
//     res.status(500).json({ message: error.message });
//   }
// };

export const getPoins = async (req, res) => {
  try {
    //ambil harga tunggal
    const hargaPoinData = await HargaPoin.findOne({
      attributes: ["harga"]
    });
    const hargaPoin = hargaPoinData ? hargaPoinData.harga : 0;

    //ambil data poin
    const poins = await Poin.findAll({
      order: [['poin', 'ASC']]
    });

    const formattedPoinList = poins.map((poin) => {
      const originalPrice = poin.poin * hargaPoin;
      // const discountAmount = originalPrice * (poin.discountPercentage / 100) + poin.discountValue; //jika pakai nilai discount
      const discountAmount = originalPrice * (poin.discountPercentage / 100); //jika hanya pakai persentase
      const discountedPrice = Math.max(originalPrice - discountAmount, 0);

      return {
        id: poin.id,
        poin: poin.poin,
        discountPercentage: poin.discountPercentage,
        discountValue: poin.discountValue,
        originalPrice: originalPrice,
        price: discountedPrice,
      };
    });

    res.status(200).json(formattedPoinList);
  } catch (error) {
    console.error("Error in getPoins:", error); // Debugging log
    res.status(500).json({ message: error.message });
  }
};



export const getPoinById = async (req, res) => {
  try {
    const poin = await Poin.findOne({
      where: { id: req.params.id },
    });

    if (!poin) {
      return res.status(404).json({ message: "Poin not found" });
    }
    res.status(200).json(poin);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const createPoin = async (req, res) => {
  const { poin } = req.body;

  if (!poin) {
    return res.status(400).json({ message: "Poin is required" });
  }

  try {
    // Cek apakah poin sudah ada di dalam database
    const existingPoin = await Poin.findOne({ where: { poin } });

    if (existingPoin) {
      return res.status(400).json({ message: "Poin value already exists" });
    }

    // Jika tidak ada, maka buat poin baru
    await Poin.create({ poin });
    res.status(201).json({ message: "Poin created successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const updatePoin = async (req, res) => {
  try {
    const { id } = req.params; // Mengambil id dari URL parameter
    const { poin, discountPercentage } = req.body;

    // Cek apakah poin yang baru sudah ada di dalam database
    const existingPoin = await Poin.findOne({ where: { poin, discountPercentage } });

    if (existingPoin) {
      // Jika nilai poin sudah ada dan bukan nilai yang sama dengan yang akan diupdate
      if (existingPoin.id !== parseInt(id)) {
        return res.status(400).json({ message: "Poin value already exists" });
      }
    }

    // Cari poin berdasarkan id
    const update_poin = await Poin.findOne({ where: { id } });

    if (!update_poin) {
      return res.status(404).json({ message: "Poin not found" });
    }

    // Lakukan update poin
    await Poin.update({ poin, discountPercentage }, { where: { id } });

    res.status(200).json({ message: "Poin updated successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const updateDiscount = async (req, res) => {
  try {
    const { id, discountPercentage } = req.body;

    // Validasi input
    if (
      !id ||
      discountPercentage === undefined ||
      discountPercentage === null
    ) {
      return res
        .status(400)
        .json({ message: "Id and discountPercentage are required" });
    }

    // Validasi format discountPercentage
    if (
      isNaN(discountPercentage) ||
      discountPercentage < 0 ||
      discountPercentage > 100
    ) {
      return res
        .status(400)
        .json({
          message: "Discount percentage must be a number between 0 and 100",
        });
    }

    // Cari data poin berdasarkan ID
    const poin = await Poin.findOne({ where: { id } });

    if (!poin) {
      return res.status(404).json({ message: "Poin not found" });
    }

    // Hitung nilai diskon
    // const discountValue = Math.floor((poin.poin * discountPercentage) / 100);

    // Update data
    poin.discountPercentage = discountPercentage;
    // poin.discountValue = discountValue;
    await poin.save();

    // Kirimkan respon sukses
    res.status(200).json({ message: "Poin updated successfully", data: poin });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const deletePoin = async (req, res) => {
  try {
    const { id } = req.params;
    const poin = await Poin.findOne({ where: { id } });

    if (!poin) {
      return res.status(404).json({ message: "Poin not found" });
    }

    await Poin.destroy({ where: { id } });

    res.status(200).json({ message: "Poin deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
