const conexion = require('../../models/conexion');

module.exports = async (request, response) => {
    const { desde } = request.params;
    const { hasta } = request.params;

    try {
        //Estado de resultado
        conexion.query('CALL getBalanceGeneral(?,?)', [desde, hasta] , (error, result) => {
            if (error) {
                message = ""
                response.status(500).send({ message: 'Error al generar el balance', error: error.message });
            } else {
                //balance
                response.status(200).send(result)
                return response;
            }
        });
    } catch (e) {
        response.status(500).send(e);
    }
};