import Address from "../models/address.js";
import User from "../models/user.js";
import SupportedArea from "../models/supportedArea.js";

//tambah alamat baru
export const createAddress = async (req, res) => {
  try {
    const {
      user_id,
      recipient_name,
      phone_number,
      address_line_1,
      city,
      state,
      postal_code,
      isDefault,
    } = req.body;

    console.log(req.body);
    console.log("Postal Code Received:", postal_code);
    console.log("Is Default:", isDefault); 

    // Cek apakah area didukung berdasarkan postal code
    const areaSupported = await SupportedArea.findOne({
      where: { postal_code },
    });

    if (!areaSupported) {
      return res.status(400).json({ message: "Postal area not supported" });
    }

    // Validasi city dan state berdasarkan data dari tabel SupportedArea
    if (areaSupported.city !== city || areaSupported.state !== state) {
      return res.status(400).json({
        message:
          "City or state does not match the postal code. Please check your input.",
      });
    }

    console.log("Area Supported:", areaSupported.city, areaSupported.state);
    console.log("Received city and state:", city, state);

    // Jika isDefault true, periksa apakah sudah ada alamat dengan is_default: true
    if (isDefault) {
      // Update alamat lama menjadi is_default: false
      await Address.update(
        { is_default: false },
        {
          where: {
            user_id,
            is_default: true, // Pastikan yang diupdate adalah yang sebelumnya default
          },
        }
      );
    }

    // Buat alamat baru dengan is_default sesuai pilihan
    const newAddress = await Address.create({
      user_id,
      recipient_name,
      phone_number,
      address_line_1,
      city,
      state,
      postal_code,
      is_default: isDefault,
      supported_area: true, // true karena area ditemukan
    });

    res.status(201).json({ message: "Address created successfully", data: newAddress });
  } catch (error) {
    res.status(500).json({ message: "Error creating address", error: error.message });
  }
};


//mendapatkan semua alamat milik user tertentu
export const getUserAddresses = async (req, res) => {
  try {
    const { user_id } = req.params;

    const addresses = await Address.findAll({
      where: { user_id },
      include: [
        {
          model: SupportedArea,
          as: "area",
        },
      ],
    });

    res
      .status(200)
      .json({ message: "Addresses retrieved successfully", data: addresses });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error retrieving addresses", error: error.message });
  }
};

// Mendapatkan alamat default untuk user tertentu
export const getDefaultAddress = async (req, res) => {
  try {
    const { user_id } = req.params;

    // Cari alamat default untuk user
    const defaultAddress = await Address.findOne({
      where: {
        user_id,
        is_default: true,
      }
    });

    if (!defaultAddress) {
      return res.status(404).json({ message: "Default address not found" });
    }

    res.status(200).json({
      message: "Default address retrieved successfully",
      defaultAddress,
    });
  } catch (error) {
    res.status(500).json({
      message: "Error retrieving default address",
      error: error.message,
    });
  }
};


//hapus alamat berdasarkan ID
export const deleteAddress = async (req, res) => {
  try {
    const { id } = req.params;

    // Cari alamat yang ingin dihapus berdasarkan ID
    const addressToDelete = await Address.findOne({ where: { id } });

    if (!addressToDelete) {
      return res.status(404).json({ message: "Address not found" });
    }

    // Jika alamat adalah alamat default, maka tidak bisa dihapus
    if (addressToDelete.is_default) {
      return res.status(400).json({
        message:
          "Default address cannot be deleted. Please update the default address first.",
      });
    }

    // Jika validasi berhasil, lanjutkan untuk menghapus alamat
    const deleted = await Address.destroy({ where: { id } });

    if (deleted) {
      res.status(200).json({ message: "Address deleted successfully" });
    } else {
      res.status(404).json({ message: "Address not found" });
    }
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error deleting address", error: error.message });
  }
};
