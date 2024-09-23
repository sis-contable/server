const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const listUsers = require('../controllers/getListUsersController.js');

const app = Router();
app.get('/listUsers', listUsers);

module.exports = app;