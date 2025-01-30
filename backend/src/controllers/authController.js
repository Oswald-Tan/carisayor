import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import User from "../models/user.js";
import Role from "../models/role.js";
import DetailsUsers from "../models/details_users.js";
import { addTokenToBlacklist } from "../middleware/checkTokenBlacklist.js";
import UserPoints from "../models/userPoints.js";
import moment from "moment";
import { createOrUpdateUserStats } from "./userStatsController.js";
import { Op } from "sequelize";
import transporter from "../config/email.js";
import crypto from "crypto";

//fungsi untuk mengasilkan kode referral unik
const generateReferralCode = (minLength = 6, maxLength = 10) => {
  const length =
    Math.floor(Math.random() * (maxLength - minLength + 1)) + minLength;
  return Math.random()
    .toString(36)
    .substring(2, 2 + length)
    .toUpperCase();
};

export const registerUser = async (req, res) => {
  const { username, password, email, role_name, referralCode, phone_number } = req.body;

  if (!username || !password || !email || !phone_number || !role_name) {
    return res.status(400).json({
      message: "Username, password, email, phone_number, and role are required.",
    });
  }

  try {
    const existingUserByEmail = await User.findOne({ where: { email } });
    if (existingUserByEmail) {
      return res.status(400).json({ message: "Email already registered." });
    }

    const existingUserByUsername = await User.findOne({ where: { username } });
    if (existingUserByUsername) {
      return res.status(400).json({ message: "Username already taken." });
    }

    let role = await Role.findOne({ where: { role_name } });
    if (!role) {
      role = await Role.create({ role_name: "user" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const newReferralCode = generateReferralCode();

    const newUser = await User.create({
      username,
      password: hashedPassword,
      email,
      role_id: role.id,
      referralCode: newReferralCode,
    });

    // Simpan data ke tabel DetailsUsers
    try {
      await DetailsUsers.create({
        user_id: newUser.id,
        phone_number,
      });
      console.log("DetailsUsers created successfully.");
    } catch (error) {
      console.error("Failed to save details_users:", error);
      return res.status(500).json({
        message: "Failed to save user details.",
      });
    }
    
    const token = jwt.sign(
      { id: newUser.id, username: newUser.username, role: role_name },
      process.env.TOKEN_JWT,
      { expiresIn: "1h" }
    );

    return res.status(201).json({
      message: "User registered successfully.",
      token,
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

export const updateUser = async (req, res) => {
  const { userId } = req.params;
  const { username, phone_number } = req.body;

  try {

    // Validasi apakah user ada
    const user = await User.findByPk(userId, {
      include: [{ model: DetailsUsers, as: "userDetails" }],
    });

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Update data username
    if (username) {
      const existingUser = await User.findOne({
        where: { username, id: { [Op.ne]: userId } },
      });
      if (existingUser) {
        return res.status(400).json({ message: "Username already exists" });
      }
      user.username = username;
    }

    // Update data phone_number di DetailsUsers
    if (phone_number) {
      const userDetails = user.userDetails;
      if (!userDetails) {
        // Jika data detail user belum ada, buat baru
        await DetailsUsers.create({
          user_id: userId,
          phone_number,
        });
      } else {
        // Jika data detail user ada, update
        userDetails.phone_number = phone_number;
        await userDetails.save();
      }
    }

    // Simpan perubahan pada User
    await user.save();

    return res.status(200).json({ message: "User updated successfully" });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "An error occurred", error });
  }
};


export const requestResetOtp = async (req, res) => {
  const { email } = req.body;

  try {
    // Cari user berdasarkan email
    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(404).json({ message: "User tidak ditemukan" });
    }

    console.log(`User with email ${email} found.`);

    // Generate OTP
    const resetOtp = crypto.randomInt(100000, 999999).toString();
    console.log(`Generated OTP: ${resetOtp}`); // Logging OTP untuk debugging

    // Simpan OTP dan waktu kadaluarsa ke database
    user.resetOtp = resetOtp;
    user.resetOtpExpires = Date.now() + 10 * 60 * 1000; // OTP expires in 10 minutes
    await user.save();

    // Kirim OTP ke email dengan styling
    const mailOptions = {
      from: process.env.EMAIL_FROM,
      to: email,
      subject: "Your OTP Code for Password Reset",
      html: `
        <!DOCTYPE html>
        <html>
        <head>
          <style>
            body {
              font-family: Arial, sans-serif;
              background-color: #f4f4f4;
              color: #333;
              margin: 0;
              padding: 0;
            }
            .container {
              max-width: 600px;
              margin: 20px auto;
              background: #fff;
              padding: 20px;
              border-radius: 8px;
              box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }
            h1 {
              color: #007BFF;
              text-align: center;
            }
            p {
              font-size: 16px;
              text-align: center;
            }
            .otp {
              font-size: 24px;
              font-weight: bold;
              color: #007BFF;
              text-align: center;
            }
          </style>
        </head>
        <body>
          <div class="container">
            <h1>Password Reset OTP</h1>
            <p>Your OTP code is:</p>
            <p class="otp">${resetOtp}</p>
            <p>This code will expire in 10 minutes.</p>
            <p>If you did not request this, please ignore this email.</p>
          </div>
        </body>
        </html>
      `,
    };

    // Logging data OTP dan waktu kadaluarsa untuk debugging
    console.log(
      `OTP Data to be Saved: resetOtp=${
        user.resetOtp
      }, resetOtpExpires=${new Date(user.resetOtpExpires).toISOString()}`
    );

    await transporter.sendMail(mailOptions);

    res.status(200).json({ message: "OTP telah dikirim ke email Anda." });
  } catch (error) {
    console.error("Error in requestResetOtp:", error.message);
    res.status(500).json({
      message: "Terjadi kesalahan saat mengirim OTP",
      error: error.message,
    });
  }
};

export const verifyResetOtp = async (req, res) => {
  const { email, otp } = req.body;

  try {
    const user = await User.findOne({ where: { email } });
    if (!user || user.resetOtp !== otp || user.resetOtpExpires < Date.now()) {
      return res
        .status(400)
        .json({ message: "OTP tidak valid atau telah kedaluwarsa" });
    }

    // OTP valid
    user.resetOtp = null;
    user.resetOtpExpires = null;
    await user.save();

    res.status(200).json({ message: "OTP berhasil diverifikasi" });
  } catch (error) {
    res.status(500).json({
      message: "Terjadi kesalahan saat memverifikasi OTP",
      error: error.message,
    });
  }
};

const validatePassword = (password) => {
  const minLength = 8;
  const hasLetter = /[a-zA-Z]/.test(password);
  const hasNumber = /[0-9]/.test(password);
  const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(password);
  return (
    password.length >= minLength && hasLetter && hasNumber && hasSpecialChar
  );
};

// Reset password after OTP verification
export const resetPassword = async (req, res) => {
  const { newPassword, confirmPassword, email } = req.body;

  try {
    // Validasi konfirmasi password
    if (newPassword !== confirmPassword) {
      return res
        .status(400)
        .json({ message: "Password baru dan konfirmasi password tidak cocok" });
    }

    // Validasi password baru
    if (!validatePassword(newPassword)) {
      return res.status(400).json({
        message:
          "Password baru harus memiliki minimal 8 karakter, mengandung huruf, angka, dan karakter khusus",
      });
    }

    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(404).json({ message: "User tidak ditemukan" });
    }

    // Enkripsi password baru
    const hashedNewPassword = await bcrypt.hash(newPassword, 10);

    // Update password di database, reset attempts, and clear lockout
    await User.update(
      {
        password: hashedNewPassword,
        resetOtp: null,
        resetOtpExpires: null,
      },
      { where: { email } }
    );

    res.status(200).json({ message: "Password berhasil diubah" });
  } catch (err) {
    console.error("Error resetting password:", err.message);
    return res.status(500).json({
      message: "Terjadi kesalahan saat mengubah password",
      error: err.message,
    });
  }
};

export const getResetOtpExpiry = async (req, res) => {
  const { email } = req.body;

  try {
    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(404).json({ message: "User tidak ditemukan" });
    }

    if (!user.resetOtpExpires) {
      return res.status(400).json({ message: "OTP belum dibuat" });
    }

    res.status(200).json({ expiryTime: user.resetOtpExpires });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Terjadi kesalahan", error: error.message });
  }
};
