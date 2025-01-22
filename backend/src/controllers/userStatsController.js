import User from "../models/user.js";
import UserStats from "../models/user_stats.js";

export const createOrUpdateUserStats = async (userId) => {
    try {
      // Cek apakah statistik pengguna sudah ada
      let userStats = await UserStats.findOne({
        where: { user_id: userId },
      });
  
      // Jika statistik pengguna belum ada, buat yang baru
      if (!userStats) {
        userStats = await UserStats.create({
          user_id: userId,
          last_login: new Date(),
          total_logins: 1, // Set total logins ke 1 saat pertama kali login
        });
      } else {
        // Jika sudah ada, perbarui data
        userStats.last_login = new Date();
        userStats.total_logins += 1; // Tambah total logins
        await userStats.save();
      }
  
      return userStats;
    } catch (error) {
      throw new Error("Failed to create or update user stats: " + error.message);
    }
  };

  export const getUserStats = async (req, res) => {
    const { id } = req.params;
  
    try {
      const userStats = await UserStats.findOne({
        where: { user_id: id },
        include: [
          {
            model: User,
            attributes: ["username", "email"],
          },
        ],
      });
  
      // Jika tidak ada user stats, hanya kirimkan username dan email
      if (!userStats) {
        const user = await User.findOne({ where: { id } });
        if (!user) {
          return res.status(404).json({ message: "User not found" });
        }
  
        return res.status(200).json({
          username: user.username,
          email: user.email,
        });
      }
  
      // Kirim data user stats jika ditemukan
      res.status(200).json({
        username: userStats.User.username,
        email: userStats.User.email,
        last_login: userStats.last_login,
        total_logins: userStats.total_logins,
      });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  };
  
  