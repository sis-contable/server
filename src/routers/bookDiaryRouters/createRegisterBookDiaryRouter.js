const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const createRegisterBookDiary = require('../../controllers/bookDiaryControllers/createRegisterBookDiaryController.js');

const app = Router();
app.post('/createRegisterBookDiary', createRegisterBookDiary);


module.exports = app;