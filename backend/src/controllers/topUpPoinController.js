import TopUpPoin from "../models/topUpPoin.js";
import User from "../models/user.js";
import UserPoints from "../models/userPoints.js";
import { Op } from "sequelize";

export const getTopUp = async (req, res) => {
  const page = parseInt(req.query.page) || 0;
  const limit = parseInt(req.query.limit) || 10;
  const search = req.query.search || "";
  const offset = limit * page;

  try {
    const totalTopUp = await TopUpPoin.count({
      include: [
        {
          model: User,
          required: true, // Hanya hitung jika ada User terkait
          where: search ? { username: { [Op.substring]: search } } : {}, // Pencarian username
        },
      ],
    });
    

    const totalRows = totalTopUp;
    const totalPage = Math.ceil(totalRows / limit);

    const data = await TopUpPoin.findAll({
      include: [
        {
          model: User,
          attributes: ["id", "username", "email"],
          required: true, // Pastikan data hanya ditemukan jika ada relasi
          where: search ? { username: { [Op.substring]: search } } : {}, // Pencarian username
        },
      ],
      order: [[{ model: User }, "username", "ASC"]], // Urutkan berdasarkan username dari tabel User
      offset: offset,
      limit: limit,
    });
    

    res.status(200).json({
      data,
      page,
      limit,
      totalPage,
      totalRows,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

//get total top up yang status pending
export const getTotalPendingTopUp = async (req, res) => {
  try {
    const totalTopUp = await TopUpPoin.count({
      where: { status: "pending" },
    }) 

    res.status(200).json({ totalTopUp });
  } catch (error) {
    res.status(500).json({ message: error.message }); 
  }
}

export const getTotalCancelledTopUp = async (req, res) => {
  try {
    const totalTopUp = await TopUpPoin.count() 

    res.status(200).json({ totalTopUp });
  } catch (error) {
    res.status(500).json({ message: error.message }); 
  }
}

export const getTotalApprovedTopUp = async (req, res) => {
  try {
    const totalTopUp = await TopUpPoin.count({
      where: { status: "approved" },
    }) 

    res.status(200).json({ totalTopUp });
  } catch (error) {
    res.status(500).json({ message: error.message }); 
  }
}

export const getTopUpById = async (req, res) => {
  const { id } = req.params; // Mendapatkan id dari parameter URL

  try {
    const topUp = await TopUpPoin.findOne({
      where: { id },
    });

    if (!topUp) {
      return res.status(404).json({ message: "Top Up not found" });
    }

    res.status(200).json(topUp);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const getTopUpByUserId = async (req, res) => {
  try {
    const userId = req.user.id;

    const topUps = await TopUpPoin.findAll({
      where: { userId },
      include: {
        model: User,
        attributes: ["id", "username", "email"],
      },
    });

    if (topUps.length === 0) {
      return res.status(404).json({ message: "Belum ada Top Up" });
    }

    res.status(200).json(topUps);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const postTopUp = async (req, res) => {
  const { points, price, date, bankName, userId } = req.body;

  try {
    // Cek apakah user dengan id yang diberikan ada
    const user = await User.findOne({ where: { id: userId } });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const topUpData = await TopUpPoin.create({
      userId,
      points,
      price,
      date,
      bankName,
      status: "pending",
    });

    return res.status(201).json({ message: "Top Up successful", topUpData });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const updateTopUp = async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  try {
    const topUp = await TopUpPoin.findOne({ where: { id } });

    if (!topUp) {
      return res.status(404).json({ message: "Top Up not found" });
    }

    if (status === "approved") {
      let userPoints = await UserPoints.findOne({
        where: { userId: topUp.userId },
      });

      //jika belum ada data user points maka buat baru
      if (!userPoints) {
        userPoints = await UserPoints.create({
          userId: topUp.userId,
          points: topUp.points,
        });
      } else {
        userPoints.points += topUp.points;
        await userPoints.save();
      }
    }

    topUp.status = status;
    await topUp.save();

    res.status(200).json({ message: "Top Up updated successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const deleteTopUp = async (req, res) => {
  try {
    const { id } = req.params;
    const topUp = await TopUpPoin.findOne({ where: { id } });

    if (!topUp) {
      return res.status(404).json({ message: "Top Up not found" });
    }

    await TopUpPoin.destroy({
      where: { id },
    });

    res.status(200).json({ message: "Top Up deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Controller untuk mengubah status top-up
export const updateTopUpStatus = async (req, res) => {
  const { status } = req.body;
  const { id } = req.params;

  try {
    // Cari transaksi berdasarkan ID
    const topUp = await TopUpPoin.findByPk(id);
    if (!topUp) {
      return res.status(404).json({ message: "Top-up transaction not found" });
    }

    // Periksa apakah status saat ini adalah "pending"
    if (topUp.status !== "pending") {
      return res
        .status(400)
        .json({
          message: 'Status can only be updated from "pending" to "cancelled"',
        });
    }

    // Ubah status transaksi menjadi "cancelled"
    topUp.status = "cancelled";
    await topUp.save();

    return res
      .status(200)
      .json({ message: "Status updated successfully", topUp });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Internal server error" });
  }
};
