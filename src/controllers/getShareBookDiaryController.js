const conexion = require('../models/conexion');

//Buscador por palabra
module.exports.getShareBookDiaryWord = async (request, response) => {
    const shareWord = request.body;

    try {
        conexion.query('CALL getShareBookDiaryWord(?)', [shareWord], (error, result) => {
            
            if (error) {
                
                response.status(400).send({ message: 'No se encontro resultado para su busqueda', error: error.message });
                
            } else {
                response.status(200);
            }
        });
    } catch (e) {
        console.error('Error inesperado:', e); // Agregar un log para depuración
        // Manejar el error basado en el SQLSTATE específico si es relevante
        response.status(500).send({ message: 'Error interno del servidor', error: error.message });
    }
};

//Buscador por fecha
module.exports.getShareBookDiaryDate = async (request, response) => {
    const shareDate = request.body;

    try {
        conexion.query('CALL getShareBookDiary(?)', [JSON.stringify(shareDateJson)], (error, result) => {
            
            if (error) {
                
                response.status(400).send({ message: 'No se encontro resultado para su busqueda', error: error.message });
                
            } else {
                response.status(200);
            }
        });
    } catch (e) {
        console.error('Error inesperado:', e); // Agregar un log para depuración
        // Manejar el error basado en el SQLSTATE específico si es relevante
        response.status(500).send({ message: 'Error interno del servidor', error: error.message });
    }
};