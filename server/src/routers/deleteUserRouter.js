const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const deleteUser = require('../controllers/deleteUserController.js');

const app = Router();
app.delete('/deleteUser/:id', deleteUser);

module.exports = app;