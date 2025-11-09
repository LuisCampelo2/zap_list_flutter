import { DataTypes } from "sequelize";
import sequelize from "../utils/db.js";

const Product = sequelize.define("Product", {
  photo: {
    type: DataTypes.STRING
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false
  },
  category: {
    type: DataTypes.ENUM,
    values: [
      'Conservas e enlatados',
      'Grãos',
      'Chás e cafés',
      'Farinhas e derivados',
      'Congelados',
      'Biscoitos e salgadinhos',
      'Utensílios de cozinha',
      'Açúcares e adoçantes',
      'Frutas',
      'Verduras',
      'Legumes',
      'Carnes',
      'Peixes',
      'Massas',
      'Laticínios e ovos',
      'Padaria',
      'Temperos e especiarias',
      'Doces e guloseimas',
      'Bebidas',
      'Material de higiene',
      'Material de limpeza',
      'Itens pra cachorro',
      'Outros',
    ],
    allowNull: false
  },
  averageWeight: {
    type: DataTypes.DOUBLE,
  },
  price: {
    type: DataTypes.DOUBLE,
  },
  unitOFMeasure: {
    type: DataTypes.ENUM,
    values: [
      'KG',
      'Pacote',
      'Unidade'
    ]
  },
  unitOfCalculation: {
    type: DataTypes.ENUM,
    values: [
      'KG',
      'Pacote',
      'Unidade'
    ]
  }
},
  {
    timestamps: false,
    tableName: 'products'
  }

);

export default Product;
