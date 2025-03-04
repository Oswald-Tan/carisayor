import Pesanan from "../models/pesanan.js";
import User from "../models/user.js";
import DetailsUsers from "../models/details_users.js";
import UserPoints from "../models/userPoints.js";
import AfiliasiBonus from "../models/afiliasiBonus.js";
import moment from "moment";
import Setting from "../models/setting.js";
import Address from "../models/address.js";
import { v4 as uuidv4 } from "uuid";
import { Op } from "sequelize";
import Cart from "../models/cart.js";
import OrderItem from "../models/orderItem.js";
import db from "../config/database.js";
import Products from "../models/product.js";

export const getPesanan = async (req, res) => {
  const page = parseInt(req.query.page) || 0;
  const limit = parseInt(req.query.limit) || 10;
  const search = req.query.search || '';
  const status = req.query.status || 'all';
  const offset = limit * page;

  try {
    // Buat kondisi where untuk status
    const topUpWhere = {};
    if (status !== 'all') {
      topUpWhere.status = status;
    }

    // Hitung total pesanan dengan filter berdasarkan OrderItem.namaProduk
    const totalPesanan = await Pesanan.count({
      where: topUpWhere,
      include: [
        {
          model: OrderItem,
          as: "orderItems",
          where: search ? { namaProduk: { [Op.substring]: search } } : {},
          required: search ? true : false, // Jika ada pencarian, maka harus memiliki order item yang cocok
        },
      ],
    });

    const totalRows = totalPesanan;
    const totalPage = Math.ceil(totalRows / limit);

    // Ambil daftar pesanan dengan OrderItem dan User
    const data = await Pesanan.findAll({
      where: topUpWhere,
      include: [
        {
          model: User,
          as: "user",
          attributes: ["id", "email"],
          include: [
            {
              model: Address,
              as: "user",
              attributes: [
                "recipient_name",
                "phone_number",
                "address_line_1",
                "city",
                "state",
                "postal_code",
                "is_default",
              ],
              where: { is_default: true },
              required: false,
            },
            {
              model: DetailsUsers,
              as: "userDetails",
              attributes: ["fullname"],
            },
          ],
        },
        {
          model: OrderItem,
          as: "orderItems",
          attributes: ["id", "namaProduk", "jumlah", "satuan", "totalHarga"], // Ambil data order item
          where: search ? { namaProduk: { [Op.substring]: search } } : {}, // Filter berdasarkan nama produk
          required: search ? true : false,
          include: [
            {
              model: Products,
              as: "produk",
              attributes: ["image"],
            },
          ],
        },
      ],
      order: [["created_at", "DESC"]],
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

export const getPesananByUser = async (req, res) => {
  try {
    const { userId } = req.params;

    const pesanan = await Pesanan.findAll({
      where: { 
        userId,
        // status: { [Op.ne]: "Delivered" }
      },
      include: [
        {
          model: OrderItem,
          as: "orderItems",
          include: [
            {
              model: Products,
              as: "produk",
              attributes: ["id", "nameProduk", "image"],
            },
          ],
        },
      ],
      order: [["created_at", "DESC"]],
    });

    res.status(200).json({
      message: "Data pesanan berhasil diambil",
      data: pesanan,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const getPesananByUserDelivered = async (req, res) => {
  try {
    const { userId } = req.params;

    const pesanan = await Pesanan.findAll({
      where: { userId, status: "delivered" }, // Filter hanya pesanan dengan status "delivered"
      include: [
        {
          model: OrderItem,
          as: "orderItems",
          include: [
            {
              model: Products,
              as: "produk",
              attributes: ["id", "nameProduk", "image"], // Sesuaikan dengan field product
            },
          ],
        },
      ],
      order: [["created_at", "DESC"]],
    });

    res.status(200).json({
      message: "Data pesanan (delivered) berhasil diambil",
      data: pesanan,
    });
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

    // Update status
    pesanan.status = status;

    // Jika status menjadi "delivered", ubah paymentStatus menjadi "paid"
    if (status === "delivered") {
      pesanan.paymentStatus = "paid";
    }

    await pesanan.save();

    res.status(200).json({ message: "Pesanan updated successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const buatPesananCOD = async (req, res) => {
  const transaction = await db.transaction(); // Mulai transaction
  try {
    const {
      userId,
      metodePembayaran,
      hargaRp,
      ongkir,
      totalBayar,
      invoiceNumber,
      items,
    } = req.body;

    // Validasi items
    if (!items || items.length === 0) {
      await transaction.rollback();
      return res.status(400).json({ message: "Items are required" });
    }

    // Cek user
    const user = await User.findOne({ where: { id: userId }, transaction });
    if (!user) {
      await transaction.rollback();
      return res.status(404).json({ message: "User not found" });
    }

    // Generate orderId
    const uniqueId = uuidv4().replace(/-/g, "").substring(0, 8).toUpperCase();
    const orderId = `CS${uniqueId}`;

    // Buat pesanan dengan transaction
    const pesanan = await Pesanan.create(
      {
        userId,
        orderId,
        metodePembayaran,
        hargaRp,
        ongkir,
        totalBayar,
        paymentStatus: metodePembayaran === "COD" ? "unpaid" : "paid",
        status: "pending",
        invoiceNumber,
      },
      { transaction }
    );

    // Buat order items
    const orderItemsData = items.map((item) => ({
      pesananId: pesanan.id,
      productId: item.productId, // Pastikan ini ada di request body
      namaProduk: item.namaProduk,
      harga: item.harga,
      jumlah: item.jumlah,
      satuan: item.satuan, // Tambahkan ini
      totalHarga: item.totalHarga,
    }));

    await OrderItem.bulkCreate(orderItemsData, { transaction });

    // Proses bonus afiliasi jika totalBayar >= 200.000
    if (totalBayar >= 200000) {
      let currentUser = user;
      let bonusLevel = 1;
      const maxBonusBase = 200000;

      while (currentUser && bonusLevel <= 2) {
        const referredId = currentUser.referredBy;

        if (referredId) {
          const bonusPercentage = bonusLevel === 1 ? 0.1 : 0.05;
          const bonusAmount = Math.floor(maxBonusBase * bonusPercentage);

          await AfiliasiBonus.create(
            {
              userId: referredId,
              referralUserId: userId,
              pesananId: pesanan.id,
              bonusAmount,
              bonusLevel,
              expiryDate: moment().add(1, "month").toDate(),
              bonusReceivedAt: moment().toDate(),
            },
            { transaction }
          );

          currentUser = await User.findOne({
            where: { id: referredId },
            transaction,
          });
        } else {
          break;
        }

        bonusLevel++;
      }
    }

    // Commit transaction jika semua sukses
    await transaction.commit();

    res.status(201).json({
      message: "Pesanan created successfully",
      data: {
        ...pesanan.toJSON(),
        items: orderItemsData,
      },
    });
  } catch (error) {
    // Rollback transaction jika ada error
    await transaction.rollback();
    res.status(500).json({ message: error.message });
  }
};

export const buatPesananCODCart = async (req, res) => {
  const transaction = await db.transaction();
  try {
    const {
      userId,
      metodePembayaran,
      hargaRp,
      ongkir,
      totalBayar,
      invoiceNumber,
      items,
    } = req.body;

    // Validasi items
    if (!items || items.length === 0) {
      await transaction.rollback();
      return res.status(400).json({ message: "Items are required" });
    }

    // Cek apakah user dengan id yang diberikan ada
    const user = await User.findOne({ where: { id: userId }, transaction });
    if (!user) {
      await transaction.rollback();
      return res.status(404).json({ message: "User not found" });
    }

    // Generate orderId
    const uniqueId = uuidv4().replace(/-/g, "").substring(0, 8).toUpperCase();
    const orderId = `CS${uniqueId}`;

    //pisahkan nama produk
    // const namaProdukArray = nama.split(", ");

    const pesanan = await Pesanan.create(
      {
        userId,
        orderId,
        metodePembayaran,
        hargaRp,
        ongkir,
        totalBayar,
        paymentStatus: metodePembayaran === "COD" ? "unpaid" : "paid",
        status: "pending",
        invoiceNumber,
      },
      { transaction }
    );

    await Cart.destroy({
      where: {
        userId,
        productId: items.map((item) => item.productId),
        status: "active",
      },
    });

    // Buat order items
    const orderItemsData = items.map((item) => ({
      pesananId: pesanan.id,
      productId: item.productId, // Pastikan ini ada di request body
      namaProduk: item.namaProduk,
      harga: item.harga,
      jumlah: item.jumlah,
      satuan: item.satuan, // Tambahkan ini
      totalHarga: item.totalHarga,
    }));

    await OrderItem.bulkCreate(orderItemsData, { transaction });

    //cek apakah totalBayar lebih besar atau sama dengan 200.000
    if (totalBayar >= 200000) {
      //hitung bonus untuk user B, user C, dan seterus nya
      let currentUser = user;
      let bonusLevel = 1; //level dimulau dari 1 (user yang baru daftar)
      let bonusPercentage = 0; //persentase bonus awal
      const maxBonusBase = 200000;

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
          // const bonusAmount = Math.floor(
          //   (totalBayar - ongkir) * bonusPercentage
          // );

          // Hitung bonus dengan batas maksimal 200.000 tanpa mengurangi ongkir
          const bonusAmount = Math.floor(maxBonusBase * bonusPercentage);

          //catat bonus ke dalam table afiliasi bonus
          await AfiliasiBonus.create(
            {
              userId: referredId, // Pengguna yang menerima bonus
              referralUserId: userId, // Pengguna yang memberikan referral
              pesananId: pesanan.id,
              bonusAmount: bonusAmount,
              bonusLevel: bonusLevel,
              expiryDate: moment().add(1, "month").toDate(),
              bonusReceivedAt: moment().toDate(),
            },
            { transaction }
          );

          //melanjutkan ke pengguna yang mengundang pada level berikutnya
          currentUser = await User.findOne({
            where: { id: referredId },
            transaction,
          });
        } else {
          break;
        }

        bonusLevel++; //menaikan level afiliasi
      }
    }

    // Commit transaction jika semua sukses
    await transaction.commit();

    res.status(201).json({
      message: "Pesanan created successfully",
      data: {
        ...pesanan.toJSON(),
        items: orderItemsData,
      },
    });
  } catch (error) {
    await transaction.rollback();
    res.status(500).json({ message: error.message });
  }
};

export const buatPesananPoin = async (req, res) => {
  const transaction = await db.transaction();
  try {
    const {
      userId,
      metodePembayaran,
      hargaPoin,
      ongkir,
      totalBayar,
      invoiceNumber,
      items,
    } = req.body;

    // Validasi items
    if (!items || items.length === 0) {
      await transaction.rollback();
      return res.status(400).json({ message: "Items are required" });
    }

    if (totalBayar <= 0) {
      await transaction.rollback();
      return res.status(400).json({
        success: false,
        message: "Total bayar harus lebih dari 0",
      });
    }

    const user = await User.findOne({ where: { id: userId }, transaction });
    if (!user) {
      await transaction.rollback();
      return res.status(404).json({
        success: false,
        message: "User tidak ditemukan",
      });
    }

    const userPoints = await UserPoints.findOne({ where: { userId } });
    if (!userPoints) {
      await transaction.rollback();
      return res.status(404).json({
        success: false,
        message: "Data poin pengguna tidak ditemukan",
      });
    }

    if (userPoints.points === 0) {
      await transaction.rollback();
      return res.status(400).json({
        success: false,
        message: "Anda tidak memiliki poin untuk melakukan pembayaran ini",
      });
    }

    if (userPoints.points < totalBayar) {
      await transaction.rollback();
      return res.status(400).json({
        success: false,
        message: `Poin Anda hanya ${userPoints.points}, tidak cukup untuk membayar ${totalBayar}`,
      });
    }

    // Generate orderId
    const uniqueId = uuidv4().replace(/-/g, "").substring(0, 8).toUpperCase();
    const orderId = `CS${uniqueId}`;

    userPoints.points -= totalBayar;
    await userPoints.save();

    const pesanan = await Pesanan.create(
      {
        userId,
        orderId,
        metodePembayaran,
        hargaPoin,
        ongkir,
        totalBayar,
        paymentStatus: metodePembayaran === "COD" ? "unpaid" : "paid",
        status: "pending",
        invoiceNumber,
      },
      { transaction }
    );

    // Buat order items
    const orderItemsData = items.map((item) => ({
      pesananId: pesanan.id,
      productId: item.productId, // Pastikan ini ada di request body
      namaProduk: item.namaProduk,
      harga: item.harga,
      jumlah: item.jumlah,
      satuan: item.satuan, // Tambahkan ini
      totalHarga: item.totalHarga,
    }));

    await OrderItem.bulkCreate(orderItemsData, { transaction });

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
      const maxBonusBase = 200;

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
          // const bonusAmount = Math.floor(
          //   (totalBayar - ongkir) * nilaiPoin * bonusPercentage
          // );

          // Hitung bonus dengan dasar maksimal 200 tanpa mengurangi ongkir
          const bonusAmount = Math.floor(
            maxBonusBase * nilaiPoin * bonusPercentage
          );

          //catat bonus ke dalam table afiliasi bonus
          await AfiliasiBonus.create(
            {
              userId: referredId, // Pengguna yang menerima bonus
              referralUserId: userId, // Pengguna yang memberikan referral
              pesananId: pesanan.id,
              bonusAmount: bonusAmount,
              bonusLevel: bonusLevel,
              expiryDate: moment().add(1, "month").toDate(),
              bonusReceivedAt: moment().toDate(),
            },
            { transaction }
          );

          //melanjutkan ke pengguna yang mengundang pada level berikutnya
          currentUser = await User.findOne({
            where: { id: referredId },
            transaction,
          });
        } else {
          break;
        }

        bonusLevel++; //menaikan level afiliasi
      }
    }

    // Commit transaction jika semua sukses
    await transaction.commit();

    res.status(201).json({
      success: true,
      message: "Pesanan berhasil dibuat",
      data: {
        ...pesanan.toJSON(),
        items: orderItemsData,
      },
    });
  } catch (error) {
    await transaction.rollback();
    res.status(500).json({
      success: false,
      message: `Terjadi kesalahan: ${error.message}`,
    });
  }
};

export const buatPesananPoinCart = async (req, res) => {
  const transaction = await db.transaction();
  try {
    const {
      userId,
      metodePembayaran,
      hargaPoin,
      ongkir,
      totalBayar,
      invoiceNumber,
      items,
    } = req.body;

    // Validasi items
    if (!items || items.length === 0) {
      await transaction.rollback();
      return res.status(400).json({ message: "Items are required" });
    }

    if (totalBayar <= 0) {
      await transaction.rollback();
      return res.status(400).json({
        success: false,
        message: "Total bayar harus lebih dari 0",
      });
    }

    // Cek apakah user dengan id yang diberikan ada
    const user = await User.findOne({ where: { id: userId }, transaction });
    if (!user) {
      await transaction.rollback();
      return res.status(404).json({ message: "User not found" });
    }

    const userPoints = await UserPoints.findOne({ where: { userId } });
    if (!userPoints) {
      await transaction.rollback();
      return res.status(404).json({
        success: false,
        message: "Data poin pengguna tidak ditemukan",
      });
    }

    if (userPoints.points === 0) {
      await transaction.rollback();
      return res.status(400).json({
        success: false,
        message: "Anda tidak memiliki poin untuk melakukan pembayaran ini",
      });
    }

    if (userPoints.points < totalBayar) {
      await transaction.rollback();
      return res.status(400).json({
        success: false,
        message: `Poin Anda hanya ${userPoints.points}, tidak cukup untuk membayar ${totalBayar}`,
      });
    }

    // Generate orderId
    const uniqueId = uuidv4().replace(/-/g, "").substring(0, 8).toUpperCase();
    const orderId = `CS${uniqueId}`;

    userPoints.points -= totalBayar;
    await userPoints.save();

    await Cart.destroy({
      where: {
        userId,
        productId: items.map((item) => item.productId),
        status: "active",
      },
    });

    const pesanan = await Pesanan.create(
      {
        userId,
        orderId,
        metodePembayaran,
        hargaPoin,
        ongkir,
        totalBayar,
        paymentStatus: metodePembayaran === "COD" ? "unpaid" : "paid",
        status: "pending",
        invoiceNumber,
      },
      { transaction }
    );

    // Buat order items
    const orderItemsData = items.map((item) => ({
      pesananId: pesanan.id,
      productId: item.productId, // Pastikan ini ada di request body
      namaProduk: item.namaProduk,
      harga: item.harga,
      jumlah: item.jumlah,
      satuan: item.satuan, // Tambahkan ini
      totalHarga: item.totalHarga,
    }));

    await OrderItem.bulkCreate(orderItemsData, { transaction });

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
      const maxBonusBase = 200;

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
          // const bonusAmount = Math.floor(
          //   (totalBayar - ongkir) * nilaiPoin * bonusPercentage
          // );

          // Hitung bonus dengan dasar maksimal 200 tanpa mengurangi ongkir
          const bonusAmount = Math.floor(
            maxBonusBase * nilaiPoin * bonusPercentage
          );

          //catat bonus ke dalam table afiliasi bonus
          await AfiliasiBonus.create(
            {
              userId: referredId, // Pengguna yang menerima bonus
              referralUserId: userId, // Pengguna yang memberikan referral
              pesananId: pesanan.id,
              bonusAmount: bonusAmount,
              bonusLevel: bonusLevel,
              expiryDate: moment().add(1, "month").toDate(),
              bonusReceivedAt: moment().toDate(),
            },
            { transaction }
          );

          //melanjutkan ke pengguna yang mengundang pada level berikutnya
          currentUser = await User.findOne({
            where: { id: referredId },
            transaction,
          });
        } else {
          break;
        }

        bonusLevel++; //menaikan level afiliasi
      }
    }

    // Commit transaction jika semua sukses
    await transaction.commit();

    res.status(201).json({
      message: "Pesanan created successfully",
      data: {
        ...pesanan.toJSON(),
        items: orderItemsData,
      },
    });
  } catch (error) {
    await transaction.rollback();
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
