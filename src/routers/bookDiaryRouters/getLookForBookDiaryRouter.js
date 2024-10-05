const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const { getLookForBookDiaryWord , getLookForBookDiaryDate } = require('../../controllers/bookDiaryControllers/getLookForBookDiaryController.js');

const app = Router();
app.get('/lookForBookDiaryWord/:word', getLookForBookDiaryWord);
app.get('/lookForBookDiaryDate/:desde/:hasta', getLookForBookDiaryDate);

module.exports = app;