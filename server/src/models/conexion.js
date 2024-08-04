const mysql = require('mysql');

const conexion = mysql.createConnection({
    host: 'localhost',
    port: 3306,
    user: 'root',
<<<<<<< HEAD
    password: '',
    database: 'sis_contable',
    //trustServerCertificate: true
=======
    password: 'Lnear*07',
    database: 'sis_contable',
    trustServerCertificate: true
>>>>>>> origin/osvaldo
});


module.exports = conexion;