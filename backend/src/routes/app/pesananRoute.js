import express from "express";
import { buatPesananCOD, buatPesananCODCart, buatPesananPoin, buatPesananPoinCart, getPesanan, getPesananByUser, getPesananByUserDelivered } from "../../controllers/pesananController.js";
import authMiddleware from "../../middleware/authMiddleware.js";
import { checkTokenBlacklist } from "../../middleware/checkTokenBlacklist.js";

const router = express.Router();

router.get("/", authMiddleware, checkTokenBlacklist, getPesanan);
router.get("/user/:userId", getPesananByUser);
router.get("/user-delivered/:userId", getPesananByUserDelivered);
router.post("/cod", authMiddleware, checkTokenBlacklist, buatPesananCOD);
router.post("/cod-cart", authMiddleware, checkTokenBlacklist, buatPesananCODCart);
router.post("/poin", authMiddleware, checkTokenBlacklist, buatPesananPoin);
router.post("/poin-cart", authMiddleware, checkTokenBlacklist, buatPesananPoinCart);

export default router;
