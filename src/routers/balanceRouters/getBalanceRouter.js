const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const getBalance = require('../../controllers/balanceControllers/balanceController');

const app = Router();
app.post('/creatBalance/:desde/:hasta', getBalance);

module.exports = app;