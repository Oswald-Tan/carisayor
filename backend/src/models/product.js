import { DataTypes } from "sequelize";
import db from "../config/database.js";

const Products = db.define(
  "Products",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    nameProduk: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        notEmpty: true,
        len: [3, 100],
      },
    },
    deskripsi: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    hargaPoin: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    hargaRp: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    jumlah: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    satuan: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    image: {
      type: DataTypes.STRING,
      allowNull: true,
    },
  },
  {
    timestamps: true,
    tableName: "products",
    createdAt: "created_at",
    updatedAt: "updated_at",
  }
);

export default Products;
