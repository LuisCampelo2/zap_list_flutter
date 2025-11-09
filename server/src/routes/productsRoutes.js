import express from 'express';
import { productController } from '../controllers/productsController.js'
const router = express.Router();
import { authMiddleWare } from '../middleware/authMiddleware.js';


router.get('/products', productController.getAllProducts); 
router.get('/scrapping-price', authMiddleWare.middleWare, productController.scrappingPrice);

export default router;