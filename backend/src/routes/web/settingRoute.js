import express from "express";
import { getHargaPoin, setHargaPoin } from "../../controllers/settingController.js";
import { verifyUser } from "../../middleware/authUser.js";

const router = express.Router();

router.get('/harga-poin', verifyUser, getHargaPoin);
router.post('/harga-poin', verifyUser, setHargaPoin);

export default router;