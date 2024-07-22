const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const editUser = require('../controllers/editUserController.js');

const app = Router();
app.put('/editUser/:id', editUser);

module.exports = app;