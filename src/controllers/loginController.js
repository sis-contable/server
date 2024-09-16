const conexion = require('../models/conexion');
const jwt = require('jsonwebtoken');

module.exports = async (request, response) => {
    const { usuario , clave } = request.body;
    //Hacemos la consulta a la base de datos
    //const consult = 'SELECT * FROM usuarios WHERE usuario = ? and password = ?';

    try{
        let userJson = JSON.stringify(usuario, clave);
        conexion.query('CALL login(?)', [userJson], (error, result)=>{
            if(error){
                //Si hay un error envianoslo
                response.send(error);
            }

            if(result.length > 0){
                const token = jwt.sign({usuario}, "Stack",{
                    expiresIn: '3m' //Tiempo en el que expira
                })
                const idUser = result.id_usuario;
                console.log(result);
                response.send({token: token,
                    id_usuario : idUser
                });
            } else {
                // Si no hay resultados, envíanos un mensaje adecuado
                console.log('Wrong user');
                response.send({mensage: 'Wrong user'});
            }
        })
    } catch(e){
        // Capturar cualquier otro error
        response.send(e);

    }
};
