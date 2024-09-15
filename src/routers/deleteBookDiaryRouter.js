const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const selectIdBookDiary = require('../controllers/deleteBookDiaryController.js');

const app = Router();
app.delete('/deleteBookDiary/:id', selectIdBookDiary);

module.exports = app;