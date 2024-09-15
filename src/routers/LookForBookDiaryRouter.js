const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const { getLookForBookDiaryWord , getLookForBookDiaryDate } = require('../controllers/getLookForBookDiaryController');

const app = Router();
app.get('/ShareBookDiaryWord', getLookForBookDiaryWord);
app.get('/ShareBookDiaryDate', getLookForBookDiaryDate);

module.exports = app;