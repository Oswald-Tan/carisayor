import express from "express";
import {
  getUsers,
  getUserById,
  getUserDetails,
  getTotalUsers,
  createUser,
  updateUser,
  deleteUser,
} from "../../controllers/usersController.js";
import { verifyUser, adminOnly } from "../../middleware/authUser.js";

const router = express.Router();

router.get("/users", verifyUser, adminOnly, getUsers);
router.get("/users/:id/details", verifyUser, adminOnly, getUserDetails);
router.get("/user/:id", verifyUser, adminOnly, getUserById);
router.get("/total-users", verifyUser, getTotalUsers);
router.post("/user", verifyUser, adminOnly, createUser);
router.patch("/user/:id", verifyUser, adminOnly, updateUser);

router.delete("/user/:id", verifyUser, adminOnly, deleteUser);

export default router;
