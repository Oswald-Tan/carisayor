import express from "express";
import { getUserStats } from "../../controllers/userStatsController.js";

const router = express.Router();

// Rute untuk mendapatkan statistik pengguna
router.get("/:id/stats", getUserStats);

export default router;
