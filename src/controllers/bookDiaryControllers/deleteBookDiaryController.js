const conexion = require('../../models/conexion');

module.exports = async (request, response) => {
    
    // Asignar el valor de codigo_cuentas al objeto JSON recibido
    const idBookDiary = parseInt(request.params.id, 10);
    try {
        //let registroJson = JSON.stringify(registro);
        conexion.query('CALL deleteBookDiary(?)', [ idBookDiary ], (error, result) => {
            
            if (error) {
                console.error('Error al ejecutar la consulta:', error); // Agregar un log para depuración
                response.status(500).send({ message: 'Error al eliminar el registro', error: error.message });
            } else {
                response.status(200).send({ message: 'Registro eliminado con exito' });
            }
        });
    } catch (e) {
        console.error('Error inesperado:', e); // Agregar un log para depuración
        // Manejar el error basado en el SQLSTATE específico si es relevante
        response.status(500).send({ message: 'Error interno del servidor', error: e.message });
    }
};