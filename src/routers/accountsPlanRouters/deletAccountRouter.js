const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const deletAccount = require('../../controllers/accountPlanControllers/deletAccountController');

const app = Router();
app.post('/deletAccount/:codigo', deletAccount);

module.exports = app;