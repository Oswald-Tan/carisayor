import express from "express";
import { getProducts, getProductById, createProduct, updateProduct, deleteProduct } from "../../controllers/productController.js";
import { verifyUser } from "../../middleware/authUser.js";
import { upload } from "../../middleware/upload.js";

const router = express.Router();

router.get('/', verifyUser, getProducts);
router.get('/:id', verifyUser, getProductById);
router.post('/', verifyUser, upload.single('image'), createProduct);
router.patch('/:id', verifyUser, upload.single('image'), updateProduct);
router.delete('/:id', verifyUser, deleteProduct);

export default router;