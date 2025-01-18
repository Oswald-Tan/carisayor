import express from "express";
import { handleLogin, handleLogout, Me } from "../../controllers/authWebController.js";

const router = express.Router();

router.post('/handle-login', handleLogin);
router.delete('/handle-logout', handleLogout);
router.get('/me', Me);

export default router;
