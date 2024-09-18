const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js

const selectIdBookDiary = require('../../controllers/bookDiaryControllers/deleteBookDiaryController.js');

const app = Router();
app.delete('/deleteRegister/:id', selectIdBookDiary);

module.exports = app;