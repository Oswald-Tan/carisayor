import express from "express";
import {
  getAllShippingRates,
  getShippingRateByCity,
  createShippingRate,
  updateShippingRate,
  deleteShippingRate,
  getShippingRateById,
} from "../../controllers/shippingRateController.js";
import { verifyUser } from "../../middleware/authUser.js";

const router = express.Router();

router.get("/", verifyUser, getAllShippingRates);
router.get("/:cityId", verifyUser, getShippingRateByCity);
router.get("/price/:id", verifyUser, getShippingRateById);
router.post("/", verifyUser, createShippingRate);
router.put("/:id", verifyUser, updateShippingRate);
router.delete("/:id", verifyUser, deleteShippingRate);

export default router;
