const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const getLedger = require('../../controllers/ledgerControllers/ledgerController');

const app = Router();
app.get('/listBookLedger/:codigo_cuenta', getLedger);

module.exports = app;