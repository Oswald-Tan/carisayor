import express from "express";
import {
  createSupportedArea,
  getAllSupportedAreas,
  deleteSupportedArea,
  getSupportedAreaById,
  updateSupportedArea,
  getCities,
  getStates,
} from "../../controllers/supportedAreaController.js";
import authMiddleware from "../../middleware/authMiddleware.js";
import { checkTokenBlacklist } from "../../middleware/checkTokenBlacklist.js";

const router = express.Router();

router.get("/cities", authMiddleware, checkTokenBlacklist, getCities);
router.get("/states", authMiddleware, checkTokenBlacklist, getStates);

export default router;
