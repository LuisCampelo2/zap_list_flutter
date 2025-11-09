import { QueryTypes } from "sequelize";
import sequelize from "../utils/db.js";
import puppeteer from 'puppeteer';
import cron from 'node-cron';
import Product from "../models/product.js";


const getAllProducts = async (req, res) => {
  try {
    const { listId } = req.query;

    const products = await Product.findAll();


    const formattedProducts = products.map((p) => ({
      ...p.toJSON(),
      price:
        p.price !== null
          ? Number(p.price).toFixed(2).replace(".", ",")
          : null,
    }));

    let productsInList = [];

    if (listId) {
      const listProductsQuery = `
        SELECT productId FROM shoppinglistproducts
        WHERE shoppingListId = :listId
      `;
      const listProducts = await sequelize.query(listProductsQuery, {
        replacements: { listId },
        type: QueryTypes.SELECT,
      });
      productsInList = listProducts.map((p) => p.productId);
    }

    res.status(200).json({
      products: formattedProducts,
      productsInList: productsInList,
    });
  } catch (error) {
    console.error("Erro ao listar os produtos:", error);
    res.status(500).json({ message: "Erro ao listar os produtos", error });
  }
};

const scrappingPrice = async (req, res) => {
  try {
    await runScraping();
  } catch (error) {
    res.status(500).send({ message: "Erro ao atualizar produtos", error: error.message });
  }
}


const runScraping = async () => {
  let browser;
  let searchTerm;
  let url;
  let inputSearch;
  let elementPrice;
  const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms));
  try {
    browser = await puppeteer.launch({ headless: false });
    const page = await browser.newPage();
    const [products] = await sequelize.query('SELECT id, name,category,unitOFMeasure,unitOfCalculation FROM products');

    console.log('Produtos carregados:', products);


    for (const product of products) {
      if (product.category === "Carnes" || product.category === "Peixes") {
        url = `https://www.extramercado.com.br/`
        searchTerm = product.name.toLowerCase() + " o KG";
        inputSearch = `#input-search`;
        elementPrice = `.PriceValue-sc-20azeh-4.hHjSYF`
      } else if (product.category === "Legumes" || product.category === "Frutas"  &&   product.unitOfCalculation === "KG") {
        url = `https://www.superpaguemenos.com.br/`;
        searchTerm = product.name.toLowerCase() + " preço KG";
        inputSearch = `input[name="q"]`;
        elementPrice = `.price-weight`
      } else {
        searchTerm = product.name.toLowerCase();
        url = `https://www.extramercado.com.br/`
        inputSearch = `#input-search`;
        elementPrice = `.PriceValue-sc-20azeh-4.hHjSYF`
      }
      await page.goto(url, { waitUntil: "domcontentloaded" });
      await page.waitForSelector(inputSearch);
      await page.click(inputSearch);
      await page.type(inputSearch, `${searchTerm}`);
      await page.keyboard.press("Enter");
      await delay(2000);
      let priceText = null;
      try {
        await page.waitForSelector(elementPrice, { timeout: 5000 });
        priceText = await page.$eval(elementPrice, el => el.textContent.trim());
      } catch {
        console.log(`Preço não encontrado para ${product.name}`);
      }

      if (priceText) {
        const fraction = priceText.replace(/[^\d,]/g, '').replace(',', '.');
        const price = parseFloat(fraction);

        await sequelize.query(
          'UPDATE products SET price = ? WHERE id = ?',
          {
            replacements: [price.toFixed(2), product.id]
          }
        );
      } else {
        await sequelize.query(
          'UPDATE products SET price = NULL WHERE id = ?',
          { replacements: [product.id] }
        );
      }

      await delay(1000);
    }

    console.log('Preços Atualizados com sucesso!')
  } catch (error) {
    console.error('Erro no scraping:', error.message);
  } finally {
    if (browser) await browser.close();
  }
}

cron.schedule('0 3 * * *', async () => {
  console.log('Rodando scraping agendado...');
  await runScraping();
});


export const productController = {
  getAllProducts,
  scrappingPrice
};
