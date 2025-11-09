import { DataTypes } from "sequelize";
import sequelize from "../utils/db.js";
import ShoppingList from "./shoppingList.js";
import Product from "./product.js";

const ShoppingListProduct = sequelize.define(
  "ShoppingListProduct",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    quantity: {
      type: DataTypes.DOUBLE,
    },
    isChecked: {
      type: DataTypes.BOOLEAN,
      defaultValue: false,
    },
    observation: {
      type:DataTypes.TEXT
    },
    shoppingListId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: "ShoppingLists",
        key: "id",
      },
    },
    productId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: "Products",
        key: "id",
      },
    },
  },
  {
    timestamps: false,
    tableName: 'shoppinglistproducts'
  }
);

ShoppingListProduct.belongsTo(Product, { foreignKey: "productId"});
ShoppingListProduct.belongsTo(ShoppingList, { foreignKey: "shoppingListId" });

export default ShoppingListProduct;
