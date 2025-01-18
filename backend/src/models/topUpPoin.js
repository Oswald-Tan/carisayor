import { DataTypes } from "sequelize";
import db from "../config/database.js";
import User from "./user.js";

const TopUpPoin = db.define(
  "TopUpPoin",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    userId: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    points: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    price: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    date: {
      type: DataTypes.DATE,
      allowNull: false,
    },
    bankName: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    status: { 
      type: DataTypes.STRING,
      allowNull: false,
      defaultValue: 'pending',
    },
  },
  {
    timestamps: false,
    tableName: "topuppoin",
  }
);

TopUpPoin.belongsTo(User, { foreignKey: 'userId' });
User.hasMany(TopUpPoin, { foreignKey: 'userId' });

export default TopUpPoin;
