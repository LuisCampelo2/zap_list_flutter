import User from "../models/user.js";

const normalizedUser = ({ id, email,name,lastName }) => {
  return {
    id,
    email,
    name,
    lastName,
  };
};

const findByEmail = (email) => {
  return User.findOne({ where: { email } });
}


export const userService = {
  normalizedUser,
  findByEmail
}
