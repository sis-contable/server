const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const editUser = require('../../controllers/userControllers/editUserController');

const app = Router();
app.put('/editUser/:id', editUser);

module.exports = app;