const conexion = require('../../models/conexion');

module.exports = async (request, response) => {

    try {
        conexion.query('CALL getListAccountsPlan()', (error, result) => {
            if (error) {
                response.status(500).send(error);
            } else {
                response.status(200).send(result);
            }
        });
    } catch (e) {
        response.status(500).send(e);
    }
};