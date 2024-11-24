//Express nos permite crear y correr el servidor 
const express = require('express');
const { PORT, SECRET_JWT_KEY } = require('./models/config.js');
const cookieParser = require('cookie-parser');
const jwt = require('jsonwebtoken');

const app = express();
app.use(cookieParser());

//Cors nos permite obtener los permisos para que la comunicasion entre el from y el back funcione correctamente.
const cors = require('cors');

//Esto es para ya interpretar el json que estamos enviando
app.use(express.json()); 
app.use(express.urlencoded({ extended: true }));

const newLocal = ["http://localhost:5173"];
app.use(cors({
    //Aca agregamos el lugar donde egecutamos nuestro from
    origin: newLocal,
    //Tipos de metodos que enviamos desde el from al back
    methods: ["GET", "POST" , "PUT" , "DELETE"],
    credentials: true,
}));

//Vamos a crear un middleware: son funciones por las que pasa la peticion, modificamos la peticion o la respuesta 
//y dejamos que pase la peticion a la siguiente funcion a la que le pertoca.
app.use((req, res, next) => {
    const token = req.cookies.access_token;
    try {
      const data = jwt.verify(token, SECRET_JWT_KEY);

      req.session = { user: data };
    } catch (e) {
      req.session = null; // Asegúrate de manejar esto correctamente
    }
    next();
  });

  //Nos falta agregar para guardar la session 
app.get('/api', (request, response) => {
  const { user } = request.session;
  response.json({
    success: true,
    user: user
  })
});

app.get('/api/protected', (request, response) => {
    const token = request.cookies.access_token;
    if (!token) {
      return response.status(403).send('Acceso no autorizado');
    }
  
    try {
      const data = jwt.verify(token, SECRET_JWT_KEY); 
      // Enviar los datos en formato JSON en lugar de usar render
      response.json({
        success: true,  // Indicamos que fue exitosa
        user: data      // Devolver el usuario que está en el token
      });
    } catch (e) {
      return response.status(401).send('Acceso no autorizado');
    }
  });



//traemos el archivo donde se encuentran las rutas Usuario y logeo
const allControllersUsers = require('./routers/userRouters/allUsersRouters');
app.use('/api',allControllersUsers.listUsers);
app.use('/api',allControllersUsers.editUser);
app.use('/api',allControllersUsers.deleteUser);
app.use('/api',allControllersUsers.createUser);
app.use('/api', allControllersUsers.login);
app.post('/api/logout', (request, response) => {
  response.clearCookie('access_token');
  response.status(200).json({ message: 'Logout successful' }); // Enviar respuesta exitosa
});

//traemos el archivo donde se encuentran las rutas del registro
const allControllersBook = require('./routers/bookDiaryRouters/allbookDiaryRouters');
app.use('/api', allControllersBook.createRegisterBook);
app.use('/api', allControllersBook.listBookDiary);
app.use('/api', allControllersBook.selectRegisterBookDiary);
app.use('/api', allControllersBook.deleteBookDiary);
app.use('/api', allControllersBook.LookForBookDiary);

const allAccountsPlan = require('./routers/accountsPlanRouters/allAccountsPlanRouters');
app.use('/api', allAccountsPlan.getListAccountsPlan);
app.use('/api', allAccountsPlan.getListAccountsPlanByKeyword);
app.use('/api', allAccountsPlan.deletAccount);

const allLedgerDiary = require('./routers/ledgerRouters/allLedgerRouter');
app.use('/api', allLedgerDiary.getLedger);
app.use('/api', allLedgerDiary.getLookForLedger);

//Trmoes las rutas paara el balance
const allBalanceRouters = require('./routers/balanceRouters/allRoutersBalance.js');
app.use('/api', allBalanceRouters.getBalanceGeneral);

app.listen(PORT, ()=>{
    console.log('El puerto que esta escuchando es:' + PORT);
})