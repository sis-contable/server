const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const { getListAccountsPlanByKeyword }  = require('../../controllers/accountPlanControllers/getListAccountsPlanByKeywordController');

const app = Router();
app.get('/listAccountsPlanByKeyword/:keyword', getListAccountsPlanByKeyword);

module.exports = app;