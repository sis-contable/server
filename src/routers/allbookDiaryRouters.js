//Importamos los controladores
const bookIva = require('./loginRouter');


//Controlador general (orquestador o organizador), un array que tiene todo los routers.
//// El 'orquestador' es un mediador entre los controladores y nuestro 'app.js'.
const allControllersBook = {
    bookIva
};

//Aca le brindamos acceso para que puedan tomar el dato que necesitan,
//osea exportamos el orquestador
module.exports = allControllersBook;
//Hacerlo con los router separados por tipo.