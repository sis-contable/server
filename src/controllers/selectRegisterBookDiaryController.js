const conexion = require('../models/conexion');

//GRUPO
module.exports.getGroup = async (request, response) => {
    //Trae  id_grupo y grupo
    try {
        conexion.query('CALL getGroupDiary()', (error, result) => {
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

//TIPO
module.exports.getType = async (request, response) => {
    //Trae id_tipo y tipo
    try {
        conexion.query('CALL getType()', (error, result) => {
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

//RUBRO
module.exports.getRubro = async (request, response) => {
    // Obtener el ID de grupo y tipo de los parámetros de la solicitud
    const groupId = request.params.id_grupo;
    const typeId = request.params.id_tipo;
    //Trae id_rubro y rubro, segun id_grupo y id_tipo
    try {
        conexion.query('CALL getRubro(?, ?)', [groupId,typeId], (error, result) => {
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

//SUBRUBRO
module.exports.getSubRubro = async (request, response) => {
    // Obtener el ID de rubro de los parámetros de la solicitud
    const rubroId = request.params.id_rubro;
    //Trae id_rubro y rubro, segun id_grupo y id_tipo
    try {
        conexion.query('CALL getSubRubro(?)', [rubroId,], (error, result) => {
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

//CUENTAS
module.exports.getAccounts = async (request, response) => {
    //Trae id_tipo y tipo
    try {
        conexion.query('CALL getAccounts()', (error, result) => {
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

//FORMAS DE PAGO
//CUENTAS
module.exports.getPaymentMethods = async (request, response) => {
    //Trae id_tipo y tipo
    try {
        conexion.query('CALL getPaymentMethods()', (error, result) => {
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