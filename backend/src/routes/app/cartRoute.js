import express from "express";
import { addToCart, getCartByUser, updateBeratInCart, getItemCountInCart } from "../../controllers/cartController.js";
import authMiddleware from "../../middleware/authMiddleware.js";
import { checkTokenBlacklist } from "../../middleware/checkTokenBlacklist.js";
const router = express.Router();

router.post('/', authMiddleware, checkTokenBlacklist, addToCart);
router.get('/:userId', authMiddleware, checkTokenBlacklist, getCartByUser);
router.get('/item-count/:userId', authMiddleware, checkTokenBlacklist, getItemCountInCart);
router.post('/update-berat', authMiddleware, checkTokenBlacklist, updateBeratInCart);

export default router;