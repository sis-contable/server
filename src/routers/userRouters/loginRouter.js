const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const login = require('../../controllers/userControllers/loginController');

const app = Router();
app.post('/login', login);

module.exports = app;