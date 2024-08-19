const conexion = require('../models/conexion');

module.exports = async (request, response) => {
    const newUser = request.body;

    try {
        let userJson = JSON.stringify(newUser);
        conexion.query('CALL createUser(?)', [userJson], (error, result) => {
            if (error) {
                console.error('Error al ejecutar la consulta:', error); // Agregar un log para depuración
                response.status(500).send({ message: 'Error al crear el usuario', error: error.message });
            } else {
                response.status(200).send({ message: 'Usuario creado exitosamente' });
            }
        });
    } catch (e) {
        console.error('Error inesperado:', e); // Agregar un log para depuración
        response.status(500).send({ message: 'Error interno del servidor', error: e.message });
    }
};