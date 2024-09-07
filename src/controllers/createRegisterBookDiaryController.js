const conexion = require('../models/conexion');

module.exports = async (request, response) => {
    const registro = request.body;

    try {
        let registroJson = JSON.stringify(registro);

        conexion.query('CALL insertRegisterBookDiary(?)', [registroJson], (error, result) => {
            
            if (error) {
                console.error('Error al ejecutar la consulta:', error); // Agregar un log para depuración
                response.status(500).send({ message: 'Error al cargar el registro', error: error.message });
            } else {
                response.status(200).send({ message: 'Registro cargado con existo' });
            }
        });
    } catch (e) {
        console.error('Error inesperado:', e); // Agregar un log para depuración
        // Manejar el error basado en el SQLSTATE específico si es relevante
        response.status(500).send({ message: 'Error interno del servidor', error: error.message });
    }
};