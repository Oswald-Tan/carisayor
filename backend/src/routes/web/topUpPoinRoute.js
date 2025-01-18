import express from "express";
import { getTopUp, deleteTopUp, getTopUpById, updateTopUp } from "../../controllers/topUpPoinController.js";
import { verifyUser } from "../../middleware/authUser.js";

const router = express.Router();

router.get("/", verifyUser, getTopUp);
router.get("/:id", verifyUser, getTopUpById);
router.patch("/:id", verifyUser, updateTopUp);
router.delete("/:id", verifyUser, deleteTopUp);

export default router;
