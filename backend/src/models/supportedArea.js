import { DataTypes } from "sequelize";
import db from "../config/database.js";

const SupportedArea = db.define(
  "SupportedArea",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    postal_code: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    city: {  // Tambahkan kolom city
      type: DataTypes.STRING,
      allowNull: false,
    },
    state: {  // Tambahkan kolom state
      type: DataTypes.STRING,
      allowNull: false,
    },
    created_at: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: DataTypes.NOW,
    },
    updated_at: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: DataTypes.NOW,
    },
  },
  {
    timestamps: true,
    createdAt: "created_at",
    updatedAt: "updated_at",
    tableName: "supported_area",
  }
);

export default SupportedArea;
