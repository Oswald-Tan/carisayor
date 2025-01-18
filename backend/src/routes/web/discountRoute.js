import express from "express";
import {
  getDiscountPoin,
  getDiscountPoinById,
  createDiscountPoin,
  updateDiscountPoin,
  deleteDiscountPoin,
} from "../../controllers/discountController.js";
import { verifyUser } from "../../middleware/authUser.js";

const router = express.Router();

router.get("/", verifyUser, getDiscountPoin);
router.get("/:id", verifyUser, getDiscountPoinById);
router.post("/", verifyUser, createDiscountPoin);
router.patch("/:id", verifyUser, updateDiscountPoin);
router.delete("/:id", verifyUser, deleteDiscountPoin);

export default router;
