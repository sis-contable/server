const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const { getGroup, getType, getRubro, getSubRubro, getAccounts, getPaymentMethods } = require('../../controllers/bookDiaryControllers/selectRegisterBookDiaryController.js');

const app = Router();

app.get('/group', getGroup);
app.get('/type', getType);
app.get('/rubro/:idg/:idt', getRubro);  
app.get('/subRubro/:id_rubro', getSubRubro);    
app.get('/accounts', getAccounts);
app.get('/paymentMethods', getPaymentMethods);

module.exports = app;