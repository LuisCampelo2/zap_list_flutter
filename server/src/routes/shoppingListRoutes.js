import express from 'express';
const router = express.Router();
import { shoppingListController } from '../controllers/shoppingListController.js';
import { authMiddleWare } from '../middleware/authMiddleware.js';

router.get('/lists', authMiddleWare.middleWare, shoppingListController.getAllShoppingList);
router.post('/shopping-lists',authMiddleWare.middleWare, shoppingListController.createShoppingList)
router.post('/shopping-list-add-product', shoppingListController.addProductToShopping);
router.get('/list/:id/productsList', authMiddleWare.middleWare, shoppingListController.getProductsShoppingList);
router.delete('/list-delete/:id', authMiddleWare.middleWare, shoppingListController.deleteList);
router.delete('/product-list-delete/:id', authMiddleWare.middleWare, shoppingListController.deleteProductList);
router.patch('/checked/:id', authMiddleWare.middleWare, shoppingListController.updateCheck);
router.patch('/edit-quantity/:id', authMiddleWare.middleWare, shoppingListController.updateQuantity);
router.patch('/product-list-update/:id', authMiddleWare.middleWare, shoppingListController.updateObservation);

export default router;