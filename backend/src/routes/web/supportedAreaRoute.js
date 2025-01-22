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
import { verifyUser } from "../../middleware/authUser.js";

const router = express.Router();

router.post("/", verifyUser, createSupportedArea);
router.get("/", verifyUser, getAllSupportedAreas);
router.get("/:id", verifyUser, getSupportedAreaById);
router.get("/cities", getCities);
router.get("/states", getStates);
router.put("/:id", verifyUser, updateSupportedArea);
router.delete("/:id", verifyUser, deleteSupportedArea);

export default router;
