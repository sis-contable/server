const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const getListAccountsPlan = require('../../controllers/accountPlanControllers/getListAccountsPlanController');

const app = Router();
app.get('/listAccountsPlan', getListAccountsPlan);

module.exports = app;