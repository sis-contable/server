const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const listBookDiary = require('../controllers/getListBookDiaryController');

const app = Router();
app.get('/listBookDiary', listBookDiary);

module.exports = app;