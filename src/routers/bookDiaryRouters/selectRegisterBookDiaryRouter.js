const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const { getGroup, getType, getRubro, getSubRubro, getAccounts, getPaymentMethods } = require('../../controllers/bookDiaryControllers/selectRegisterBookDiaryController.js');

const app = Router();

app.get('/getGroup', getGroup);
app.get('/getType', getType);
app.get('/getRubro/:idg/:idt', getRubro);  
app.get('/getSubRubro/:id_rubro', getSubRubro);    
app.get('/getAccounts', getAccounts);
app.get('/getPaymentMethods', getPaymentMethods);

module.exports = app;