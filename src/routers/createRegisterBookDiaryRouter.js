const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const createUser = require('../controllers/createRegisterBookIvaController');

const app = Router();
app.post('/createRegisterBookIva', createUser);

module.exports = app;