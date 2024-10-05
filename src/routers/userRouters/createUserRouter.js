const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const createUser = require('../../controllers/userControllers/createUserController');

const app = Router();
app.post('/createUser', createUser);

module.exports = app;