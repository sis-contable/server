const { Router } = require('express');
//Importamos los router que nos permiten enrutar nuestros ints.js
const creatRegisterBookDiary = require('../controllers/createRegisterBookDiaryController');

const app = Router();
app.post('/createRegisterBookDiary', creatRegisterBookDiary);


module.exports = app;