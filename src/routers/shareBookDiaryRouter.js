const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const { getShareBookDiaryWord , getShareBookDiaryDate } = require('../controllers/getShareBookDiaryController');

const app = Router();
app.get('/ShareBookDiaryWord', getShareBookDiaryWord);
app.get('/ShareBookDiaryDate', getShareBookDiaryDate);

module.exports = app;