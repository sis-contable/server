const conexion = require('../models/conexion');

module.exports = async (request, response) => {
    
    // Obtener el ID del usuario de los parámetros de la solicitud
    const userId = request.params.id;
    // Obtener los datos actualizados del usuario del cuerpo de la solicitud
    const updatedUser = request.body;
    
    try{    
        // Si el ID de usuario no está en los datos actualizados, asignar el ID de los parámetros
        if (!updatedUser.id_usuario) {
            updatedUser.id_usuario = userId;
        }
        // Convertir los datos del usuario actualizado a una cadena JSON
        let userJson = JSON.stringify(updatedUser);
        console.log(updatedUser);
        // Ejecutar la consulta almacenada 'editUser' pasando los datos del usuario como parámetro
        conexion.query('CALL editUser(?)', [userJson], (error, result)=>{
            if (error) {
                response.status(500).send(error);
            } else {
                response.status(200).send(`actualizado`);
            }
        });
    } catch(e){
        // Capturar cualquier otro error
        response.send(e);

    }
};