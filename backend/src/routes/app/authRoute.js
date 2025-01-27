import express from "express";
import { registerUser, loginUser, getUserData, logoutUser, updateUser } from "../../controllers/authController.js";
import authMiddleware from "../../middleware/authMiddleware.js";
import { checkTokenBlacklist } from "../../middleware/checkTokenBlacklist.js";

const router = express.Router();

router.post('/register', registerUser);
router.post('/login', loginUser);
router.get('/user', authMiddleware, checkTokenBlacklist, getUserData);
router.post('/logout', authMiddleware, logoutUser);
router.put("/:userId", updateUser);

export default router;