import express from "express";
import { getHargaPoin, getHargaPoinById, createHargaPoin, updateHargaPoin, deleteHargaPoin } from "../../controllers/hargaPoinController.js";
import { verifyUser } from "../../middleware/authUser.js";

const router = express.Router();

router.get('/', verifyUser, getHargaPoin);
router.get('/:id', verifyUser, getHargaPoinById);
router.post('/', verifyUser, createHargaPoin);
router.patch('/:id', verifyUser, updateHargaPoin);
router.delete('/:id', verifyUser, deleteHargaPoin);

export default router;