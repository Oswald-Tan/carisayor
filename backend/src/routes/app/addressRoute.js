import express from "express";
import { createAddress, getUserAddresses, getDefaultAddress, deleteAddress } from "../../controllers/addressController.js";
import authMiddleware from "../../middleware/authMiddleware.js";
import { checkTokenBlacklist } from "../../middleware/checkTokenBlacklist.js";
const router = express.Router();


router.post("/", authMiddleware, checkTokenBlacklist, createAddress);
router.get('/:user_id', authMiddleware, checkTokenBlacklist, getUserAddresses);
router.get('/default/:user_id', authMiddleware, checkTokenBlacklist, getDefaultAddress);
router.delete('/:id', authMiddleware, checkTokenBlacklist, deleteAddress);

export default router;
