import Sequelize from 'sequelize';
import dotenv from 'dotenv';
dotenv.config();


const sequelize = new Sequelize({
  database: process.env.MYSQLDATABASE,
  username: process.env.MYSQLUSER,
  password: process.env.MYSQLPASSWORD,
  host: process.env.MYSQLHOST,
  port: process.env.MYSQLPORT,
  dialect: 'mysql',
});

export default sequelize;