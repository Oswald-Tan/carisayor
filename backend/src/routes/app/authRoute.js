import express from "express";
import {
  registerUser,
  loginUser,
  getUserData,
  logoutUser,
  updateUser,
  requestResetOtp,
  verifyResetOtp,
  resetPassword,
  getResetOtpExpiry,
} from "../../controllers/authController.js";
import authMiddleware from "../../middleware/authMiddleware.js";
import { checkTokenBlacklist } from "../../middleware/checkTokenBlacklist.js";

const router = express.Router();

router.post("/register", registerUser);
router.post("/login", loginUser);
router.get("/user", authMiddleware, checkTokenBlacklist, getUserData);
router.post("/logout", authMiddleware, logoutUser);
router.put("/:userId", updateUser);

router.post("/request-reset-otp", requestResetOtp);
router.post("/verify-reset-otp", verifyResetOtp);
router.post("/reset-password", resetPassword);
router.post("/get-reset-otp-expiry", getResetOtpExpiry);

export default router;
