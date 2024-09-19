const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const { getLookForBookDiaryWord , getLookForBookDiaryDate } = require('../../controllers/bookDiaryControllers/getLookForBookDiaryController.js');

const app = Router();
app.get('/LookForBookDiaryWord', getLookForBookDiaryWord);
app.get('/LookForBookDiaryDate', getLookForBookDiaryDate);

module.exports = app;