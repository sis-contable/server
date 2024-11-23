const conexion = require('../../models/conexion');

module.exports = async (request, response) => {
    const { codigo } = request.params;

    try {
        conexion.query('CALL deletAccount(?)', [codigo], (error, result) => {

            if (error) {
                console.error("Error en la consulta:", error.message); // Log para depuración
                return response.status(500).json({ 
                    status: 500,
                    message: 'Error al procesar la solicitud' 
                });
            }

            // Verificar el mensaje devuelto por el SP
            const mensaje = result[0][0]?.mensaje_exito;

            if (mensaje === 'Cuenta eliminada correctamente') {
                return response.status(200).json({
                    status: 200,
                    message: mensaje
                });
            } else {
                return response.status(400).json({ // Cambiado a 400 (error del cliente)
                    status: 400,
                    message: mensaje
                });
            }
        });
    } catch (e) {
        console.error("Error inesperado:", e); // Mejor log de error
        response.status(500).json({
            status: 500,
            message: 'Error inesperado en el servidor'
        });
    }
};