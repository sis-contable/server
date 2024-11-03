const conexion = require('../../models/conexion');

module.exports = async (request, response) => {
    const { desde } = request.params;
    const { hasta } = request.params;

    try {
        // Llamar al procedimiento almacenado
        conexion.query('CALL getBalanceGeneral(?,?)', [desde, hasta], (error, results) => {
            if (error) {
                return response.status(500).send({ message: 'Error al generar el balance', error: error.message });
            } 
    
            // Verifica si se obtuvieron resultados
            if (results && results.length > 0) {
                const resultPacket = results[0]; // El primer elemento contiene los JSON
                console.log(resultPacket);
                // Accede a los JSON dentro del RowDataPacket
                const estadoResultado = resultPacket[0].json_estado_resultado;
                const asientoCierre = resultPacket[0].json_asiento_cierre;
                const situacionPatrimonial = resultPacket[0].json_situacion_patrimonial;
    
                // Devuelve los JSON al frontend
                return response.status(200).send({
                    estadoResultado,
                    asientoCierre,
                    situacionPatrimonial
                });
            } else {
                response.status(500).send({ message: 'No se generaron resultados' });
            }
        });
    } catch (e) {
        response.status(500).send({ message: 'Error en el servidor', error: e.message });
    }
};