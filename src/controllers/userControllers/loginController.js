const conexion = require('../../models/conexion');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const { SECRET_JWT_KEY } = require('../../models/config');

module.exports = async (request, response) => {
    const { usuario, clave } = request.body;

    try {
        conexion.query('CALL getLoginNew(?)', [usuario], async (error, result) => {
            if (error) {
                // Si hay un error en la consulta, envía la respuesta y termina la función
                return response.status(500).send(error);
            }

            // Verificar que result esté definido y que tenga resultados
            if (result && result.length > 0 && result[0].length > 0) {
                const hash1 = result[0][0].password;
                const valid = await bcrypt.compareSync(clave, hash1);
                const idUser = result[0][0].id_usuario; // Acceder a la primera fila del resultado
                if (valid) {
                    // Generar el token JWT
                    const token = jwt.sign(
                        { user: usuario, id_usuario: idUser },
                        SECRET_JWT_KEY, 
                        { expiresIn: '1h' } // Tiempo en el que expira 
                    );
                        
                    return response
                        .cookie('access_token', token, {
                            httpOnly: false, //Nos permita ingresar a la cookie desde frontend
                            secure: process.env.NODE_ENV === 'production',
                            sameSite: 'lax',
                            maxAge: 1000 * 60 * 60, // 1 hora
                        })
                        .json({ message: 'Inicio de sesión exitoso', success: true });
                    
                } else {
                    // Clave incorrecta
                    return response.status(401).send({ message: 'Clave incorrecta' });
                }
            } else {
                // Usuario incorrecto
                return response.status(401).send({ message: 'Usuario incorrecto' });
            }
        });
    } catch (err) {
        console.error('Error en el servidor:', err);
        return response.status(500).send({ error: 'Error en el servidor' });
    }
};