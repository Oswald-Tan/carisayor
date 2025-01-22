import { DataTypes } from "sequelize";
import db from "../config/database.js";

const Poin = db.define(
  "Poin",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    poin: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    discountPercentage: {
      type: DataTypes.FLOAT, 
      allowNull: true,
      defaultValue: 0, 
      validate: {
        min: 0,
        max: 100
      }
    },
  },
  {
    timestamps: false,
    tableName: "poin",
  }
);

export default Poin;
