import sequelize from './src/utils/db.js';
import Product from './src/models/product.js';
import ShoppingList from './src/models/shoppingList.js';
import ShoppingListProduct from './src/models/shoppingListProducts.js';

ShoppingList.belongsToMany(Product, {
  through: ShoppingListProduct,
  foreignKey: 'shoppingListId',
});
Product.belongsToMany(ShoppingList, {
  through: ShoppingListProduct,
  foreignKey: 'productId',
});

sequelize.sync({ alter: true });
