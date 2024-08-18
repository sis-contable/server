const conexion = require('../models/conexion');

module.exports = async (request, response) => {
    
    // Obtener los datos actualizados del usuario del cuerpo de la solicitud
    const updatedUser = request.body;
    
    try{    
        // Convertir los datos del usuario ingresado a una cadena JSON
        let userJson = JSON.stringify(updatedUser);
        // Ejecutar la consulta almacenada 'createUser' pasando los datos del usuario como parámetro
        conexion.query('CALL createUser(?)', [userJson], (error, result)=>{
            if (error) {
                response.status(500).send(error);
            } else {
                response.status(200).send(`Usuario creado`);
            }
        });
    } catch(e){
        // Capturar cualquier otro error
        response.send(e);

    }
};