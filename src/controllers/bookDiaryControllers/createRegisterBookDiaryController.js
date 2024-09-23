const conexion = require('../../models/conexion.js');

module.exports = async (request, response) => {
    const registro = request.body;
    // Concatenar los valores de id_grupo, id_tipo, id_rubro, id_sub_rubro, id_cuenta
    const codigoCuentas = `${registro.id_grupo}.${registro.id_tipo}.${registro.id_rubro}.${registro.id_sub_rubro}.${registro.id_cuenta}`;
    // Asignar el valor de codigo_cuentas al objeto JSON recibido
    registro.codigo_cuenta = codigoCuentas;

    console.log(registro);
    try {
        //let registroJson = JSON.stringify(registro);

        conexion.query('CALL insertRegisterBookDiary(?)', [JSON.stringify(registro)], (error, result) => {
            
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
        response.status(500).send({ message: 'Error interno del servidor', error: e.message });
    }
};