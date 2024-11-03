const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const getBalance = require('../../controllers/balanceControllers/balanceController');

const app = Router();
app.get('/listBlance/:desde/:hasta', getBalance);

module.exports = app;