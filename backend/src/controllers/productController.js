import Products from "../models/product.js";
import Setting from "../models/setting.js";
import { Op } from "sequelize";


export const getProducts = async (req, res) => {
  try {
    const products = await Products.findAll();

    res.status(200).json(products);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const getProductById = async (req, res) => {
  try {
    const { id } = req.params;

    const product = await Products.findByPk(id);

    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    res.status(200).json(product);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const createProduct = async (req, res) => {
  try {
    const { nameProduk, deskripsi, hargaPoin, jumlah, satuan } = req.body;

    //validasi input
    if (!nameProduk || !deskripsi || !hargaPoin || !jumlah || !satuan || isNaN(hargaPoin)) {
      return res.status(400).json({ message: "Invalid input" });
    }

    //ambil nilai poin dari table settings
    const setting = await Setting.findOne({ where: { key: "hargaPoin" } });
    if (!setting) {
      return res.status(404).json({ message: "Harga Poin not found" });
    }

    const nilaiPoin = parseInt(setting.value, 10);

    //hitung hargaRp
    const hargaRp = hargaPoin * nilaiPoin;

    //ambil image file gambar jika ada
    const image = req.file ? req.file.filename : null;

    //simpan produk ke database
    const product = await Products.create({
      nameProduk,
      deskripsi,
      hargaPoin,
      hargaRp,
      jumlah,
      satuan,
      image,
    })

    res.status(201).json({ message: "Product created successfully", product });
  } catch (error) {
    res.status(500).json({ message: error.message }); 
  }
};

export const updateProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const { nameProduk, deskripsi, hargaPoin, jumlah, satuan } = req.body;

    // Ambil produk berdasarkan ID
    const product = await Products.findByPk(id);
    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    // Validasi hanya field yang ada di request body
    if (nameProduk || deskripsi || hargaPoin || jumlah || satuan) {
      // Jika ada nama produk
      if (nameProduk && (!nameProduk || nameProduk.length < 3 || nameProduk.length > 100)) {
        return res.status(400).json({ message: "nameProduk must be between 3 and 100 characters" });
      }

      // Jika ada deskripsi
      if (deskripsi && !deskripsi.trim()) {
        return res.status(400).json({ message: "Deskripsi is required" });
      }

      // Jika ada hargaPoin dan harus valid angka
      if (hargaPoin && (isNaN(hargaPoin) || hargaPoin <= 0)) {
        return res.status(400).json({ message: "hargaPoin must be a positive number" });
      }

      // Jika ada jumlah dan harus valid angka
      if (jumlah && (isNaN(jumlah) || jumlah <= 0)) {
        return res.status(400).json({ message: "Jumlah must be a positive number" });
      }

      // Jika ada satuan
      if (satuan && !satuan.trim()) {
        return res.status(400).json({ message: "Satuan is required" });
      }
    }

    // Ambil nilai poin dari table settings
    const setting = await Setting.findOne({ where: { key: "hargaPoin" } });
    if (!setting) {
      return res.status(404).json({ message: "Harga Poin not found" });
    }

    const nilaiPoin = parseInt(setting.value, 10);

    // Hitung hargaRp hanya jika hargaPoin diperbarui
    const hargaRp = hargaPoin ? hargaPoin * nilaiPoin : product.hargaRp;

    // Ambil nama file gambar baru jika ada
    const image = req.file ? req.file.filename : product.image;

    // Update hanya properti yang disertakan dalam request
    product.nameProduk = nameProduk || product.nameProduk;
    product.deskripsi = deskripsi || product.deskripsi;
    product.hargaPoin = hargaPoin || product.hargaPoin;
    product.hargaRp = hargaRp;
    product.jumlah = jumlah || product.jumlah;
    product.satuan = satuan || product.satuan;
    product.image = image;

    // Simpan perubahan
    await product.save();

    res.status(200).json({ message: "Product updated successfully", product });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};


export const deleteProduct = async (req, res) => {
  try {
    const { id } = req.params;

    const product = await Products.findByPk(id);

    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }

    await product.destroy();

    res.status(200).json({ message: "Product deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
