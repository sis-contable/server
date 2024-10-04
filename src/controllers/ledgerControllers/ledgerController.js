const conexion = require('../../models/conexion');

module.exports = async (request, response) => {
    const {codigo_cuenta} = request.params;

    try {
        conexion.query('CALL getLedger(?)', [codigo_cuenta] , (error, result) => {
            if (error) {
                response.status(500).send(error.message);
            } else {
                response.status(200).send(result);
            }
        });
    } catch (e) {
        response.status(500).send(e);
    }
};