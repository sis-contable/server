const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const { getLookForLedgerWord , getLookForLedgerDate } = require('../../controllers/ledgerControllers/getLookForLedgerController.js');

const app = Router();
app.get('/lookForLedgerWord/:word/:cuenta', getLookForLedgerWord);
app.get('/lookForLedgerDate/:desde/:hasta/:cuenta', getLookForLedgerDate);

module.exports = app;