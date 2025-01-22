import express from "express";
  import { getTotalPesananPending } from "../../controllers/countController.js";
  import { verifyUser } from "../../middleware/authUser.js";
  
  const router = express.Router();
  
  router.get("/pesanan-pending", verifyUser, getTotalPesananPending);
  
  export default router;
  