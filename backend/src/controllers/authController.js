import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import User from "../models/user.js";
import Role from "../models/role.js";
import DetailsUsers from "../models/details_users.js";
import { addTokenToBlacklist } from "../middleware/checkTokenBlacklist.js";
import UserPoints from "../models/userPoints.js";
import moment from 'moment';
import { v4 as uuidv4 } from "uuid";
import { createOrUpdateUserStats } from "./userStatsController.js";
import Address from "../models/address.js";


//fungsi untuk mengasilkan kode referral unik
const generateReferralCode = (minLength = 6, maxLength = 10) => {
  const length = Math.floor(Math.random() * (maxLength - minLength + 1)) + minLength;
  return Math.random().toString(36).substring(2, 2 + length).toUpperCase();
};

export const registerUser = async (req, res) => {
  const { username, password, email, role_name, referralCode } = req.body;

  // Validasi input
  if (!username || !password || !email || !role_name) {
    return res.status(400).json({
      message: "Username, password, email, and role are required.",
    });
  }

  try {
    // Periksa apakah username atau email sudah ada
    const existingUserByEmail = await User.findOne({ where: { email } });
    if (existingUserByEmail) {
      return res.status(400).json({ message: "Email already registered." });
    }

    const existingUserByUsername = await User.findOne({ where: { username } });
    if (existingUserByUsername) {
      return res.status(400).json({ message: "Username already taken." });
    }

    // Cek apakah role valid atau tidak
    let role = await Role.findOne({ where: { role_name } });

    // Jika role tidak ada, tambahkan role default 'user'
    if (!role) {
      role = await Role.create({ role_name: "user" });
    }

    // Enkripsi password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Generate referral code unik
    const newReferralCode = generateReferralCode();
    
    // Tentukan siapa yang mengundang user (jika ada)
    let referredBy = null;
    if (referralCode) {
      // Cari user yang memiliki referralCode yang dimasukkan
      const referredUser = await User.findOne({ where: { referralCode } });
      if (referredUser) {
        referredBy = referredUser.id;

        // Catat waktu referral digunakan oleh User B (menggunakan referralCode dari User A)
        // Waktu penggunaan referral harus dicatat pada User B
        const newUser = await User.create({
          username,
          password: hashedPassword,
          email,
          role_id: role.id,
          referralCode: newReferralCode,
          referredBy,
          referralUsedAt: moment().toDate(), // Simpan waktu penggunaan referral di User B
        });

        // Buat JWT token
        const token = jwt.sign(
          { id: newUser.id, username: newUser.username, role: role_name },
          process.env.TOKEN_JWT,
          { expiresIn: "1h" }
        );

        return res.status(201).json({
          message: "User registered successfully.",
          token, // Kirim token JWT sebagai respon
        });
      } else {
        return res.status(400).json({ message: "Invalid referral code." });
      }
    }

    // Jika tidak ada referralCode, buat User baru tanpa referral
    const newUser = await User.create({
      username,
      password: hashedPassword,
      email,
      role_id: role.id,
      referralCode: newReferralCode,
    });

    // Buat JWT token
    const token = jwt.sign(
      { id: newUser.id, username: newUser.username, role: role_name },
      process.env.TOKEN_JWT,
      { expiresIn: "1h" }
    );

    return res.status(201).json({
      message: "User registered successfully.",
      token, // Kirim token JWT sebagai respon
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Internal server error" });
  }
};

export const loginUser = async (req, res) => {
  const { email, password } = req.body;

  // Validasi input
  if (!email || !password) {
    return res.status(400).json({
      message: "Email and password are required.",
    });
  }

  try {
    // Cek apakah email ada di database
    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(400).json({
        message: "Email not found.",
      });
    }

    // Cek apakah password yang dimasukan sesuai dengan yang ada di database
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(400).json({
        message: "Invalid password.",
      });
    }

    // Ambil role dari user
    const role = await Role.findOne({ where: { id: user.role_id } });

    // Buat JWT token
    const token = jwt.sign(
      { id: user.id, email: user.email, role: role.role_name },
      process.env.TOKEN_JWT,
      { expiresIn: "1d" }
    );

     // Update atau buat UserStats setelah login berhasil
     await createOrUpdateUserStats(user.id); // Memperbarui statistik pengguna

    return res.status(200).json({
      message: "Login successful.",
      token: token, // Kirimkan token sebagai bagian dari respons
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Internal server error" });
  }
};

export const logoutUser = async (req, res) => {
  try {
    // Ambil token dari header Authorization
    const authHeader = req.headers["authorization"];
    const token = authHeader && authHeader.split(" ")[1];

    if (!token) {
      return res.status(400).json({
        message: "Token is required for logout.",
      });
    }

    // Tambahkan token ke dalam blacklist
    addTokenToBlacklist(token);

    console.log("berhasil logout");

    return res.status(200).json({
      message: "Logout successful. Token has been invalidated.",
    });
  } catch (error) {
    console.error("Error in logoutUser:", error); // Log error untuk debug
    return res.status(500).json({ message: "Internal server error" });
  }
};

export const getUserData = async (req, res) => {
  try {
    // Cek apakah req.user ada
    if (!req.user) {
      console.log("Unauthorized: req.user not found");
      return res
        .status(401)
        .json({ message: "Unauthorized: User data not found" });
    }

    // Ambil ID user dari decoded token yang sudah disimpan di req.user
    const userId = req.user.id;
    console.log("User ID from token:", userId);

    // Ambil data user berdasarkan ID dan sertakan data role dalam query
    const user = await User.findOne({
      where: { id: userId },
      include: [
        {
          model: Role, 
          as: "userRole", 
          attributes: ["role_name"], 
        },
        {
          model: UserPoints,
          as: "userPoints",
          attributes: ["points"],
        },
        {
          model: User,
          as: "Referrals",
          attributes: ["id", "username", "referralUsedAt"],
        },
        {
          model: DetailsUsers,
          as: "userDetails",
          attributes: ["fullname", "phone_number", "photo_profile"],
        },
      ],
    });


    if (!user) {
      console.log("User not found in database");
      return res.status(404).json({ message: "User not found" });
    }

    // Gunakan fallback default jika points tidak ada
    const points = user.userPoints ? user.userPoints.points : 0;
    console.log("User points:", points);

    // Kirimkan data user beserta role
    const responseData = {
      id: user.id,
      username: user.username,
      phone_number: user.phone_number,
      full_name: user.full_name,
      email: user.email,
      role: user.userRole?.role_name, // Gunakan optional chaining untuk menghindari error jika null
      points: points,
      referralCode: user.referralCode,
      referrals: user.Referrals,
      userDetails: user.userDetails, // Perhatikan alias
     
    };

   

    return res.status(200).json(responseData);

  } catch (error) {
    console.error("Error in getUserData:", error); // Log error untuk debug
    return res.status(500).json({ message: "Internal server error" });
  }
};
