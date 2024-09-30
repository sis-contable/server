//Express nos permite crear y correr el servidor 
const express = require('express');
const app = express();
const port = 3000;
//Cors nos permite obtener los permisos para que la comunicasion entre el from y el back funcione correctamente.
const cors = require('cors');

//Esto es para ya interpretar el json que estamos enviando
app.use(express.json()); 
app.use(express.urlencoded({ extended: true }));

app.use(cors({
    //Aca agregamos el lugar donde egecutamos nuestro from
    origin: ["http://localhost:5173"],
    //Tipos de metodos que enviamos desde el from al back
    methods: ["GET", "POST" , "PUT" , "DELETE"]
}));

//traemos el archivo donde se encuentran las rutas
const allControllersUsers = require('./routers/allUsersRouters');
app.use('/', allControllersUsers.login);
app.use('/',allControllersUsers.listUsers);
app.use('/',allControllersUsers.editUser);
app.use('/',allControllersUsers.deleteUser);
app.use('/',allControllersUsers.createUser);

//traemos el archivo donde se encuentran las rutas del registro
const allControllersBook = require('./routers/bookDiaryRouters/allbookDiaryRouters');
app.use('/', allControllersBook.creatRegisterBook);
app.use('/', allControllersBook.listBookDiary);
app.use('/', allControllersBook.selectRegisterBookDiary);
app.use('/', allControllersBook.deleteBookDiary);
app.use('/', allControllersBook.LookForBookDiary);

const allAccountsPlan = require('./routers/accountsPlanRouters/allAccountsPlanRouters');
app.use('/', allAccountsPlan.getListAccountsPlan);
app.use('/', allAccountsPlan.getListAccountsPlanByKeyword);

app.listen(port, ()=>{
    console.log('El puerto que esta escuchando es:' + port);
})