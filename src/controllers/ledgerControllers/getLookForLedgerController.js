const conexion = require('../../models/conexion');

//Buscador por palabra
module.exports.getLookForLedgerWord = async (request, response) => {
    const { word } = request.params;
    const { cuenta } = request.params;
    try {
        conexion.query('CALL getLookForLedgerWord(?,?)', [word , cuenta], (error, result) => {
            if (error) {
                response.status(400).send({ message: 'No se encontro resultado para su busqueda', error: error.message });
            } else {
                response.status(200).send(result);
            }
        });
    } catch (e) {
        console.error('Error inesperado:', e); // Agregar un log para depuración
        // Manejar el error basado en el SQLSTATE específico si es relevante
        response.status(500).send({ message: 'Error interno del servidor', error: error.message });
    }
};

//Buscador por fecha
module.exports.getLookForLedgerDate = async (request, response) => {
    const { desde } = request.params;
    const { hasta } = request.params;
    const { cuenta } = request.params;
    try {
        conexion.query('CALL getLookForLedgerDate(?,?,?)', [desde,hasta,cuenta], (error, result) => {
            if (error) {
                response.status(400).send({ message: 'No se encontro resultado para su busqueda', error: error.message });
            } else {
                response.status(200).send(result);
            }
        });
    } catch (e) {
        console.error('Error inesperado:', e); // Agregar un log para depuración
        // Manejar el error basado en el SQLSTATE específico si es relevante
        response.status(500).send({ message: 'Error interno del servidor', error: error.message });
    }
};