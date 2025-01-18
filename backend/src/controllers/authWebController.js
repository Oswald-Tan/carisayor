import bcrypt from "bcrypt";
import User from "../models/user.js";
import Role from "../models/role.js";

//handle login
export const handleLogin = async (req, res) => {
  const user = await User.findOne({
    where: {
      email: req.body.email,
    },
    include: "userRole",
  });

  if (!user) return res.status(404).json({ message: "User not found" });

  const match = await bcrypt.compare(req.body.password, user.password);
  if (!match) return res.status(400).json({ message: "Wrong Password" });

  req.session.userId = user.id;
  const id = user.id;
  const username = user.username;
  const email = user.email;
  const role = user.userRole.role_name;
  res.status(200).json({ id, username, email, role });
};

export const Me = async (req, res) => {
  if (!req.session.userId) {
    return res.status(401).json({ message: "Mohon login ke akun Anda!" });
  }

  const user = await User.findOne({
    attributes: ["id", "username", "email", "role_id"],
    include: {
      model: Role,
      as: "userRole",
      attributes: ["role_name"],
    },
    where: { id: req.session.userId },
  });
  if (!user) return res.status(404).json({ message: "User not found" });
  res.status(200).json({
    id: user.id,
    username: user.username,
    email: user.email,
    role: user.userRole.role_name,
  });
};

//handle logout
export const handleLogout = async (req, res) => {
  req.session.destroy((err) => {
    if (err) return res.status(400).json({ message: "Logout failed" });
    res.status(200).json({ message: "Logout success" });
  });
};
