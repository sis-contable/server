const conexion = require('../models/conexion');

module.exports = async (request, response) => {
    
    const selectIdBookDiary = request.body;
    // Concatenar los valores de id_grupo, id_tipo, id_rubro, id_sub_rubro, id_cuenta
    const codigoCuenta = `${selectIdBookDiary.id_grupo}.${selectIdBookDiary.id_tipo}.${selectIdBookDiary.id_rubro}.${selectIdBookDiary.id_sub_rubro}.${selectIdBookDiary.id_cuenta}`;
    // Asignar el valor de codigo_cuentas al objeto JSON recibido
    const idBookDiary = selectIdBookDiary.id_libro_diario;

    console.log(registro);
    try {
        //let registroJson = JSON.stringify(registro);

        conexion.query('CALL insertRegisterBookDiary(?,?)', [ codigoCuenta, idBookDiary ], (error, result) => {
            
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