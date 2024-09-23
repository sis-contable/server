const conexion = require('../../models/conexion');

//Buscador por palabra
module.exports.getLookForBookDiaryWord = async (request, response) => {
    const LookForWord = request.body;

    console.log(LookForWord);
    try {
        conexion.query('CALL getLookForBookDiaryWord(?)', [LookForWord], (error, result) => {
            
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
module.exports.getLookForBookDiaryDate = async (request, response) => {
    const LookForDate = request.body;

    console.log(LookForDate);
    try {
        conexion.query('CALL getLookForBookDiaryDate(?)', [JSON.stringify(LookForDate)], (error, result) => {
            
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