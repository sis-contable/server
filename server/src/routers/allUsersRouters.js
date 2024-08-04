//Importamos los controladores
const login = require('./loginRouter');
const listUsers = require('./getListUsersRouter');
const editUser = require('./editUserRouter');
const deleteUser = require('./deleteUserRouter');

//Controlador general (orquestador o organizador), un array que tiene todo los routers.
//// El 'orquestador' es un mediador entre los controladores y nuestro 'app.js'.
const allControllersUsers = {
    login,
    listUsers,
    editUser,
    deleteUser
};

//Aca le brindamos acceso para que puedan tomar el dato que necesitan,
//osea exportamos el orquestador
module.exports = allControllersUsers;
//Hacerlo con los router separados por tipo.