import { DataTypes } from "sequelize";
import db from "../config/database.js";
import User from "./user.js";

const Role = db.define('role', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    role_name: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true
    }
}, {
    timestamps: false,
    tableName: 'roles',
});

User.belongsTo(Role, { foreignKey: 'role_id', as: 'userRole' });
Role.hasMany(User, { foreignKey: 'role_id', as: 'users' });

export default Role;