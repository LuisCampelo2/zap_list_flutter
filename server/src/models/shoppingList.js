import { DataTypes } from "sequelize";
import sequelize from "../utils/db.js";

const ShoppingList = sequelize.define("ShoppingList", {
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  userId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  totalPrice: {
    type: DataTypes.DECIMAL(10, 2)
  }
},
  {
    timestamps: false,
    tableName: 'shoppinglists'
  }
);

export default ShoppingList;
