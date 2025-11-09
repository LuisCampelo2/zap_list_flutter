import ShoppingList from "../models/shoppingList.js";
import Product from "../models/product.js";
import ShoppingListProduct from '../models/shoppingListProducts.js'
import sequelize from "../utils/db.js";


const updateCheck = async (req, res) => {
  const { id } = req.params;
  const { isChecked } = req.body;
  try {
    const product = await ShoppingListProduct.findByPk(id);

    product.isChecked = isChecked;
    await product.save();
  } catch (error) {
    console.log(error);
  }
}

const updateObservation = async (req, res) => {
  const { id } = req.params;
  const { observation } = req.body;
  try {
    console.log(id);
    const product = await ShoppingListProduct.findByPk(id);
    if (!product) {
      return res.status(404).json({ message: "Produto não encontrado" });
    }
    product.observation = observation;
    await product.save();
    return res.status(200).json({ product: product, message: 'Observação editada com sucesso!' })
  } catch (error) {
    console.log(error);
  }
}

const updateQuantity = async (req, res) => {
  const { id } = req.params;
  const { quantity } = req.body;

  try {
    console.log(id);
    const product = await ShoppingListProduct.findByPk(id);
    if (!product) {
      return res.status(404).json({ message: "Produto não encontrado" });
    }
    product.quantity = quantity;
    await product.save();
    return res.status(200).json({ product: product, message: 'Quantidade atualizada com sucesso!' })
  } catch (error) {
    console.log(error);
  }
}

const getAllShoppingList = async (req, res) => {
  console.log(req.user)
  try {
    const shoppingList = await ShoppingList.findAll({
      where: { userId: req.user.uid },
      order: [['id', 'DESC']]
    });
    res.status(200).json(shoppingList);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Erro ao listar os produtos", error });
  }
};

const createShoppingList = async (req, res) => {
  try {
    const { name } = req.body;

    const newList = await ShoppingList.create({
      name,
      userId: req.user.uid,
    });

    res.status(201).json({ newList, message: "Lista criada com sucesso!" });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Erro ao criar lista de compras." });
  }
};


const addProductToShopping = async (req, res) => {
  const { shoppingListId, productId, quantity, observation } = req.body;

  try {
    const shoppingList = await ShoppingList.findByPk(shoppingListId);
    const product = await Product.findByPk(productId);

    if (product.unitOFMeasure !== 'KG' && !Number.isInteger(quantity)) {
      return res.status(500).json({ message: "Informe um valor inteiro" })
    }

    if (!shoppingList || !product) {
      return res
        .status(404)
        .json({ message: "Lista de compras ou produto não encontrado" });
    }

    const existing = await ShoppingListProduct.findOne({
      where: { shoppingListId, productId }
    });

    if (existing) {
      return res
        .status(400)
        .json({ message: "Produto já adicionado à lista de compras" });
    }

    const shoppingListProduct = await ShoppingListProduct.create({
      shoppingListId,
      productId,
      quantity: quantity || 1,
      observation
    });
    return res.status(200).json({
      message: "Produto adicionado à lista de compras",
      shoppingListProduct,
    });
  } catch (error) {
    console.error("Erro ao adicionar produto", error);
    return res.status(500).json({ message: "Erro interno do servidor" });
  }
};

const getProductsShoppingList = async (req, res) => {
  const { id } = req.params;

  try {
    const products = await ShoppingListProduct.findAll({
      where: { shoppingListId: id },
      include: [{ model: Product }],
    });

    const total_price = products.reduce((sum, p) => {
      const product = p.Product;
      if (!product) return sum;

      const { price, averageWeight } = product;
      const quantity = p.quantity;

      const total_item = averageWeight != null
        ? quantity * ((averageWeight / 1000) * price)
        : quantity * price;

      return sum + total_item;
    }, 0);

    const formatted_total_price = Number(total_price.toFixed(2));


    await sequelize.query(`
  UPDATE shoppinglists SET totalPrice = :totalPrice WHERE id = :id
`, {
      replacements: { totalPrice: formatted_total_price, id },
    });

    const list = await ShoppingList.findByPk(id);

    res.status(200).json({
      products: products,
      list: list
    })
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: 'Erro ao buscar produtos na lista' });
  }
};

const deleteList = async (req, res) => {
  const { id } = req.params;

  try {
    await ShoppingListProduct.destroy({
      where: { shoppingListId: id }
    })
    const list = await ShoppingList.findByPk(id)
    await list.destroy();
    return res.status(200).json({ message: "Lista deletada com sucesso!", listId: id });
  } catch (error) {
    console.log(error);
  }
}

const deleteProductList = async (req, res) => {
  const { id } = req.params;

  try {
    const deleted = await ShoppingListProduct.destroy({
      where: {
        id: id,
      },
    })
    return res.status(200).json({ productId: id, message: 'Produto removido da lista com sucesso' });
  } catch (error) {
    console.log(error);
  }
}

export const shoppingListController = {
  getProductsShoppingList,
  addProductToShopping,
  getAllShoppingList,
  createShoppingList,
  deleteList,
  deleteProductList,
  updateCheck,
  updateObservation,
  updateQuantity,
};
