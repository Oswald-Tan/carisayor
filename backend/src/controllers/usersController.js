import User from "../models/user.js";
import Role from "../models/role.js";
import bcrypt from "bcrypt";

export const getUsers = async (req, res) => {
  try {
    const users = await User.findAll({
      attributes: ["id", "username", "email", "role_id"],
      include: {
        model: Role,
        as: "userRole",
        attributes: ["role_name"],
      },
    });

    const data = users.map((user) => ({
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.userRole.role_name,
    }));
    res.status(200).json(data);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const getUserById = async (req, res) => {
  try {
    const user = await User.findOne({
      where: { id: req.params.id },
      attributes: ["id", "username", "email", "role_id"],
      include: {
        model: Role,
        as: "userRole",
        attributes: ["role_name"],
      },
    });

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    res.status(200).json({
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.userRole.role_name,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const createUser = async (req, res) => {
  const { username, email, password, confirmPassword, roleName } = req.body;
  if (password !== confirmPassword) {
    return res.status(400).json({ message: "Passwords do not match" });
  }

  try {
    //cari role berdasarkan roleName
    const role = await Role.findOne({ where: { role_name: roleName } });
    if (!role) {
      return res.status(404).json({ message: "Role not found" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = await User.create({
      username,
      email,
      password: hashedPassword,
      role_id: role.id,
    });

    res.status(201).json({
      message: "User created successfully",
      data: {
        id: newUser.id,
        username: newUser.username,
        email: newUser.email,
        role: role.role_name,
      },
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const updateUser = async (req, res) => {
  const user = await User.findOne({
    where: { id: req.params.id },
  });

  if (!user) {
    return res.status(404).json({ message: "User not found" });
  }
  const { username, email, password, confirmPassword, roleName } = req.body;
  let hashedPassword;
  if (password === "" || password === null) {
    hashedPassword = user.password;
  } else {
    hashedPassword = await bcrypt.hash(password, 10);
  }

  if (password !== confirmPassword) {
    return res.status(400).json({ message: "Passwords do not match" });
  }

  try {
    //cari role berdasarkan roleName
    const role = await Role.findOne({ where: { role_name: roleName } });
    if (!role) {
      return res.status(404).json({ message: "Role not found" });
    }

    const updateUser = await User.update(
      {
        username,
        email,
        password: hashedPassword,
        role_id: role.id,
      },
      {
        where: { id: user.id },
      }
    );

    res.status(200).json({ message: "User updated", data: updateUser });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const deleteUser = async (req, res) => {
  const user = await User.findOne({
    where: { id: req.params.id },
  });

  if (!user) {
    return res.status(404).json({ message: "User not found" });
  }

  try {
    const deletedUser = await User.destroy({
      where: { id: user.id },
    });

    res.status(200).json({ message: "User deleted", data: deletedUser });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
