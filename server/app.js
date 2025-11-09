import express from 'express';
const app = express();
import cors from 'cors';
import path from 'path';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import shoppingListRoutes from './src/routes/shoppingListRoutes.js';
import productsRoutes from './src/routes/productsRoutes.js';
import cookieParser from 'cookie-parser';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

dotenv.config();
app.use(cookieParser());
app.use(express.json());
app.use(cors({
  origin: process.env.FRONTEND_URL,
  credentials:true,
}));
app.use('/imgs', express.static(path.join(__dirname, 'src', 'imgs')));
app.use("/api", shoppingListRoutes);
app.use("/api", productsRoutes);


const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Servidor rodando em ${PORT}`);
});
