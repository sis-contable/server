const conexion = require('../models/conexion');

module.exports = async (request, response) => {
    
    // Obtener el ID del usuario de los parámetros de la solicitud
    const userId = parseInt(request.params.id, 10);
    
    try{    
        // Ejecutar la consulta almacenada 'deleteUser' pasando el id del usuario como parámetro
        conexion.query('CALL deleteUser(?)', [userId], (error, result)=>{
            if (error) {
                response.status(500).send(error);
            } else {
                response.status(200).send(`eliminado`);
            }
        });
    } catch(e){
        // Capturar cualquier otro error
        response.send(e);

    }
};