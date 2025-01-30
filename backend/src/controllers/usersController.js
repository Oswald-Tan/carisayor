import User from "../models/user.js";
import Role from "../models/role.js";
import bcrypt from "bcrypt";
import { Op } from "sequelize";
import DetailsUsers from "../models/details_users.js";


export const getUsers = async (req, res) => {
  const page = parseInt(req.query.page) || 0;
  const limit = parseInt(req.query.limit) || 10;
  const search = req.query.search || "";
  const offset = limit * page;
  try {
    const totalUser = await User.count({
      where: { username: { [Op.substring]: search } },
    });

    const totalRows = totalUser;
    const totalPage = Math.ceil(totalRows / limit);

    const users = await User.findAll({
      where: search ? { username: { [Op.substring]: search } } : {},
      attributes: ["id", "username", "email", "role_id"],
      include: {
        model: Role,
        as: "userRole",
        attributes: ["role_name"],
      },
      order: [["username", "ASC"]],
      offset: offset,
      limit: limit,
    });
    

    const data = users.map((user) => ({
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.userRole.role_name,
    }));
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

//get total users
export const getTotalUsers = async (req, res) => {
  try {
    const totalUser = await User.count({
      where: { role_id: 1 },
    });
    res.status(200).json({ totalUser }); 
  } catch (error) {
    res.status(500).json({ message: error.message }); 
  }
}

// Fungsi untuk mendapatkan detail pengguna berdasarkan ID
export const getUserDetails = async (req, res) => {
  const { id } = req.params;

  try {
    // Cari detail pengguna berdasarkan user_id
    const userDetails = await DetailsUsers.findOne({
      where: { user_id: id },
      include: [
        {
          model: User,
          attributes: ["username", "email"], 
          as: "userDetails",  // Pastikan alias sesuai dengan asosiasi
        },
      ],
    });

    // Jika tidak ada detail pengguna, kirimkan username dan email saja
    if (!userDetails) {
      const user = await User.findOne({ where: { id } });
      return res.status(200).json({
        username: user.username,
        email: user.email,
        fullname: "-",
        phone_number: "-",
        photo_profile: "-",
      });
    }

    // Kirim response dengan data detail pengguna jika ada
    res.status(200).json({
      username: userDetails.userDetails.username,  // Akses dengan alias 'userDetails'
      email: userDetails.userDetails.email,
      id: userDetails.user_id,
      fullname: userDetails.fullname,
      phone_number: userDetails.phone_number,
      photo_profile: userDetails.photo_profile,
    });
  } catch (error) {
    console.error(error); // Periksa pesan error lebih lanjut
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

