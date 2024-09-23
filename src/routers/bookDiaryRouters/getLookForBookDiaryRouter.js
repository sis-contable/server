const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const { getLookForBookDiaryWord , getLookForBookDiaryDate } = require('../../controllers/bookDiaryControllers/getLookForBookDiaryController.js');

const app = Router();
app.get('/LookForBookDiaryWord/:word', getLookForBookDiaryWord);
app.get('/LookForBookDiaryDate/:dede/:hasta', getLookForBookDiaryDate);

module.exports = app;