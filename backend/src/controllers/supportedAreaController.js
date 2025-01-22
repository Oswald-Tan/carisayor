import SupportedArea from "../models/supportedArea.js";

//tambah area baru
export const createSupportedArea = async (req, res) => {
  try {
    const { postal_code, city, state } = req.body;  

    // Membuat data area yang baru termasuk city dan state
    const newArea = await SupportedArea.create({ 
      
      postal_code, 
      city,     
      state,     
    });

    res.status(201).json({
      message: "Area created successfully",
      data: newArea,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Mendapatkan area yang didukung berdasarkan ID
export const getSupportedAreaById = async (req, res) => {
  try {
    const { id } = req.params;  // Mendapatkan ID dari parameter URL

    // Mencari area berdasarkan ID
    const area = await SupportedArea.findOne({
      where: { id },
    });

    if (!area) {
      return res.status(404).json({
        message: "Supported area not found",
      });
    }

    res.status(200).json({
      message: "Supported area retrieved successfully",
      data: area,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};


// Mengupdate data area berdasarkan ID
export const updateSupportedArea = async (req, res) => {
  try {
    const { id } = req.params;  // Mendapatkan ID dari parameter URL
    const { postal_code, city, state } = req.body;  // Mendapatkan data yang baru dari request body

    // Mencari area berdasarkan ID
    const area = await SupportedArea.findOne({
      where: { id },
    });

    if (!area) {
      return res.status(404).json({
        message: "Supported area not found",
      });
    }

    // Mengupdate area dengan data baru
    const updatedArea = await area.update({
     
      postal_code,
      city,
      state,
    });

    res.status(200).json({
      message: "Supported area updated successfully",
      data: updatedArea,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};


//mendapatkan semua area yang didukung
export const getAllSupportedAreas = async (req, res) => {
  try {
    const areas = await SupportedArea.findAll();
    res.status(200).json({
      message: "Supported areas retrieved successfully",
      data: areas,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Mendapatkan semua kota yang didukung
export const getCities = async (req, res) => {
  try {
    // Mengambil semua kota yang ada pada SupportedArea
    const cities = await SupportedArea.findAll({
      attributes: ['city'],  // Hanya mengambil kolom city
      group: ['city'],        // Mengelompokkan berdasarkan kota untuk menghindari duplikasi
    });

    if (!cities || cities.length === 0) {
      return res.status(404).json({
        message: "No cities found",
      });
    }

    res.status(200).json({
      message: "Cities retrieved successfully",
      data: cities.map((item) => item.city), // Hanya mengembalikan nama kota
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Mendapatkan semua negara bagian (state) yang didukung
export const getStates = async (req, res) => {
  try {
    // Mengambil semua negara bagian yang ada pada SupportedArea
    const states = await SupportedArea.findAll({
      attributes: ['state'],  // Hanya mengambil kolom state
      group: ['state'],        // Mengelompokkan berdasarkan state untuk menghindari duplikasi
    });

    if (!states || states.length === 0) {
      return res.status(404).json({
        message: "No states found",
      });
    }

    res.status(200).json({
      message: "States retrieved successfully",
      data: states.map((item) => item.state), // Hanya mengembalikan nama negara bagian
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

//hapus area berdasarkan ID
export const deleteSupportedArea = async (req, res) => {
  try {
    const { id } = req.params;

    const deleted = await SupportedArea.destroy({
      where: { id },
    });
    if (deleted) {
      res.status(200).json({
        message: "Supported area deleted successfully",
      });
    } else {
      res.status(404).json({
        message: "Supported area not found",
      });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
