import Pesanan from "../models/pesanan.js";
import User from "../models/user.js";
import UserPoints from "../models/userPoints.js";
import AfiliasiBonus from "../models/afiliasiBonus.js";
import moment from "moment";
import Setting from "../models/setting.js";
import Address from "../models/address.js";
import { Op } from "sequelize";

export const getPesanan = async (req, res) => {
  const page = parseInt(req.query.page) || 0;
  const limit = parseInt(req.query.limit) || 10;
  const search = req.query.search || "";
  const offset = limit * page;
  try {
    const totalPesanan = await Pesanan.count({
      where: { nama: { [Op.substring]: search } },
      include: [
        {
          model: User,
          where: { username: { [Op.substring]: search } },
        },
      ],
    });

    const totalRows = totalPesanan;
    const totalPage = Math.ceil(totalRows / limit);

    const data = await Pesanan.findAll({
      where: search ? { nama: { [Op.substring]: search } } : {},
      include: [
        {
          model: User,
          attributes: ["id", "username"],
          
          include: {
            model: Address,
            as: "user",  // Menjaga alias yang sama dengan asosiasi
            attributes: [
              "recipient_name",
              "phone_number",
              "address_line_1",
              "city",
              "state",
              "postal_code",
              "is_default",
              "supported_area",
            ],
            where: { is_default: true },
          },
        },
      ],
      order: [["nama", "ASC"]],
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



export const getPesananUpById = async (req, res) => {
  const { id } = req.params; // Mendapatkan id dari parameter URL

  try {
    const pesanan = await Pesanan.findOne({
      where: { id },
    });

    if (!pesanan) {
      return res.status(404).json({ message: "Pesanan not found" });
    }

    res.status(200).json(pesanan);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const updatePesananStatus = async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  try {
    const pesanan = await Pesanan.findOne({ where: { id } });

    if (!pesanan) {
      return res.status(404).json({ message: "Pesanan not found" });
    }

    pesanan.status = status;
    await pesanan.save();

    res.status(200).json({ message: "Pesanan updated successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const buatPesananCOD = async (req, res) => {
  const { userId, nama, metodePembayaran, hargaRp, ongkir, totalBayar } =
    req.body;

  try {
    // Cek apakah user dengan id yang diberikan ada
    const user = await User.findOne({ where: { id: userId } });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // membuat pesanan
    const pesanan = await Pesanan.create({
      userId,
      nama,
      metodePembayaran,
      hargaRp,
      ongkir,
      totalBayar,
      status: "pending",
    });

    //cek apakah totalBayar lebih besar atau sama dengan 200.000
    if (totalBayar >= 200000) {
      //hitung bonus untuk user B, user C, dan seterus nya
      let currentUser = user;
      let bonusLevel = 1; //level dimulau dari 1 (user yang baru daftar)
      let bonusPercentage = 0; //persentase bonus awal

      //loop untuk menghitung bonus berdasarkan level afiliasi
      while (currentUser && bonusLevel <= 2) {
        const referredId = currentUser.referredBy;

        if (referredId) {
          if (bonusLevel === 1) {
            bonusPercentage = 0.1; //10% untuk user yang mengundang langsung
          } else if (bonusLevel === 2) {
            bonusPercentage = 0.05; //5% untuk user yang mengundang level sebelumnya
          }

          //hitunng bonus
          const bonusAmount = Math.floor(
            (totalBayar - ongkir) * bonusPercentage
          );

          //catat bonus ke dalam table afiliasi bonus
          await AfiliasiBonus.create({
            userId: referredId, // Pengguna yang menerima bonus
            referralUserId: userId, // Pengguna yang memberikan referral
            pesananId: pesanan.id,
            bonusAmount: bonusAmount,
            bonusLevel: bonusLevel,
            expiryDate: moment().add(1, "month").toDate(),
            bonusReceivedAt: moment().toDate(),
          });

          //melanjutkan ke pengguna yang mengundang pada level berikutnya
          currentUser = await User.findOne({
            where: { id: referredId },
          });
        } else {
          break;
        }

        bonusLevel++; //menaikan level afiliasi
      }
    }

    res.status(201).json({
      message: "Pesanan created successfully",
      data: pesanan,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const buatPesananCODCart = async (req, res) => {
  const { userId, nama, metodePembayaran, hargaRp, ongkir, totalBayar } =
    req.body;

  try {
    // Cek apakah user dengan id yang diberikan ada
    const user = await User.findOne({ where: { id: userId } });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    //pisahkan nama produk
    const namaProdukArray = nama.split(", ");

    const pesanan = await Pesanan.create({
      userId,
      nama,
      metodePembayaran,
      hargaRp,
      ongkir,
      totalBayar,
      status: "pending",
    });

    //cek apakah totalBayar lebih besar atau sama dengan 200.000
    if (totalBayar >= 200000) {
      //hitung bonus untuk user B, user C, dan seterus nya
      let currentUser = user;
      let bonusLevel = 1; //level dimulau dari 1 (user yang baru daftar)
      let bonusPercentage = 0; //persentase bonus awal

      //loop untuk menghitung bonus berdasarkan level afiliasi
      while (currentUser && bonusLevel <= 2) {
        const referredId = currentUser.referredBy;

        if (referredId) {
          if (bonusLevel === 1) {
            bonusPercentage = 0.1; //10% untuk user yang mengundang langsung
          } else if (bonusLevel === 2) {
            bonusPercentage = 0.05; //5% untuk user yang mengundang level sebelumnya
          }

          //hitunng bonus
          const bonusAmount = Math.floor(
            (totalBayar - ongkir) * bonusPercentage
          );

          //catat bonus ke dalam table afiliasi bonus
          await AfiliasiBonus.create({
            userId: referredId, // Pengguna yang menerima bonus
            referralUserId: userId, // Pengguna yang memberikan referral
            pesananId: pesanan.id,
            bonusAmount: bonusAmount,
            bonusLevel: bonusLevel,
            expiryDate: moment().add(1, "month").toDate(),
            bonusReceivedAt: moment().toDate(),
          });

          //melanjutkan ke pengguna yang mengundang pada level berikutnya
          currentUser = await User.findOne({
            where: { id: referredId },
          });
        } else {
          break;
        }

        bonusLevel++; //menaikan level afiliasi
      }
    }

    res.status(201).json({
      message: "Pesanan created successfully",
      data: pesanan,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const buatPesananPoin = async (req, res) => {
  const { userId, nama, metodePembayaran, hargaPoin, ongkir, totalBayar } =
    req.body;

  try {
    if (totalBayar <= 0) {
      return res.status(400).json({
        success: false,
        message: "Total bayar harus lebih dari 0",
      });
    }

    const user = await User.findOne({ where: { id: userId } });
    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User tidak ditemukan",
      });
    }

    const userPoints = await UserPoints.findOne({ where: { userId } });
    if (!userPoints) {
      return res.status(404).json({
        success: false,
        message: "Data poin pengguna tidak ditemukan",
      });
    }

    if (userPoints.points === 0) {
      return res.status(400).json({
        success: false,
        message: "Anda tidak memiliki poin untuk melakukan pembayaran ini",
      });
    }

    if (userPoints.points < totalBayar) {
      return res.status(400).json({
        success: false,
        message: `Poin Anda hanya ${userPoints.points}, tidak cukup untuk membayar ${totalBayar}`,
      });
    }

    userPoints.points -= totalBayar;
    await userPoints.save();

    const pesanan = await Pesanan.create({
      userId,
      nama,
      metodePembayaran,
      hargaPoin,
      ongkir,
      totalBayar,
      status: "pending",
    });

    //ambil nilai poin dari table settings
    const setting = await Setting.findOne({ where: { key: "hargaPoin" } });
    if (!setting) {
      return res.status(404).json({ message: "Harga Poin not found" });
    }

    const nilaiPoin = parseInt(setting.value, 10);

    //cek apakah totalBayar lebih besar atau sama dengan 200.000
    if (totalBayar >= 200) {
      //hitung bonus untuk user B, user C, dan seterus nya
      let currentUser = user;
      let bonusLevel = 1; //level dimulau dari 1 (user yang baru daftar)
      let bonusPercentage = 0; //persentase bonus awal

      //loop untuk menghitung bonus berdasarkan level afiliasi
      while (currentUser && bonusLevel <= 2) {
        const referredId = currentUser.referredBy;

        if (referredId) {
          if (bonusLevel === 1) {
            bonusPercentage = 0.1; //10% untuk user yang mengundang langsung
          } else if (bonusLevel === 2) {
            bonusPercentage = 0.05; //5% untuk user yang mengundang level sebelumnya
          }

          //hitunng bonus
          const bonusAmount = Math.floor(
            (totalBayar - ongkir) * nilaiPoin * bonusPercentage
          );

          //catat bonus ke dalam table afiliasi bonus
          await AfiliasiBonus.create({
            userId: referredId, // Pengguna yang menerima bonus
            referralUserId: userId, // Pengguna yang memberikan referral
            pesananId: pesanan.id,
            bonusAmount: bonusAmount,
            bonusLevel: bonusLevel,
            expiryDate: moment().add(1, "month").toDate(),
            bonusReceivedAt: moment().toDate(),
          });

          //melanjutkan ke pengguna yang mengundang pada level berikutnya
          currentUser = await User.findOne({
            where: { id: referredId },
          });
        } else {
          break;
        }

        bonusLevel++; //menaikan level afiliasi
      }
    }

    res.status(201).json({
      success: true,
      message: "Pesanan berhasil dibuat",
      data: pesanan,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: `Terjadi kesalahan: ${error.message}`,
    });
  }
};

export const buatPesananPoinCart = async (req, res) => {
  const { userId, nama, metodePembayaran, hargaPoin, ongkir, totalBayar } =
    req.body;
  console.log(req.body);

  try {
    if (totalBayar <= 0) {
      return res.status(400).json({
        success: false,
        message: "Total bayar harus lebih dari 0",
      });
    }

    // Cek apakah user dengan id yang diberikan ada
    const user = await User.findOne({ where: { id: userId } });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const userPoints = await UserPoints.findOne({ where: { userId } });
    if (!userPoints) {
      return res.status(404).json({
        success: false,
        message: "Data poin pengguna tidak ditemukan",
      });
    }

    if (userPoints.points === 0) {
      return res.status(400).json({
        success: false,
        message: "Anda tidak memiliki poin untuk melakukan pembayaran ini",
      });
    }

    if (userPoints.points < totalBayar) {
      return res.status(400).json({
        success: false,
        message: `Poin Anda hanya ${userPoints.points}, tidak cukup untuk membayar ${totalBayar}`,
      });
    }

    userPoints.points -= totalBayar;
    await userPoints.save();

    //pisahkan nama produk
    const namaProdukArray = nama.split(", ");

    const pesanan = await Pesanan.create({
      userId,
      nama,
      metodePembayaran,
      hargaPoin,
      ongkir,
      totalBayar,
      status: "pending",
    });

    //ambil nilai poin dari table settings
    const setting = await Setting.findOne({ where: { key: "hargaPoin" } });
    if (!setting) {
      return res.status(404).json({ message: "Harga Poin not found" });
    }

    const nilaiPoin = parseInt(setting.value, 10);

    //cek apakah totalBayar lebih besar atau sama dengan 200 poin
    if (totalBayar >= 200) {
      //hitung bonus untuk user B, user C, dan seterus nya
      let currentUser = user;
      let bonusLevel = 1; //level dimulau dari 1 (user yang baru daftar)
      let bonusPercentage = 0; //persentase bonus awal

      //loop untuk menghitung bonus berdasarkan level afiliasi
      while (currentUser && bonusLevel <= 2) {
        const referredId = currentUser.referredBy;

        if (referredId) {
          if (bonusLevel === 1) {
            bonusPercentage = 0.1; //10% untuk user yang mengundang langsung
          } else if (bonusLevel === 2) {
            bonusPercentage = 0.05; //5% untuk user yang mengundang level sebelumnya
          }

          //hitunng bonus
          const bonusAmount = Math.floor(
            (totalBayar - ongkir) * nilaiPoin * bonusPercentage
          );
          console.log(bonusAmount);

          //catat bonus ke dalam table afiliasi bonus
          await AfiliasiBonus.create({
            userId: referredId, // Pengguna yang menerima bonus
            referralUserId: userId, // Pengguna yang memberikan referral
            pesananId: pesanan.id,
            bonusAmount: bonusAmount,
            bonusLevel: bonusLevel,
            expiryDate: moment().add(1, "month").toDate(),
            bonusReceivedAt: moment().toDate(),
          });

          //melanjutkan ke pengguna yang mengundang pada level berikutnya
          currentUser = await User.findOne({
            where: { id: referredId },
          });
        } else {
          break;
        }

        bonusLevel++; //menaikan level afiliasi
      }
    }

    res.status(201).json({
      message: "Pesanan created successfully",
      data: pesanan,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const deletePesananUp = async (req, res) => {
  try {
    const { id } = req.params;
    const pesanan = await Pesanan.findOne({ where: { id } });

    if (!pesanan) {
      return res.status(404).json({ message: "Pesanan not found" });
    }

    await Pesanan.destroy({
      where: { id },
    });

    res.status(200).json({ message: "Pesanan deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
