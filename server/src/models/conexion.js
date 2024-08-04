const mysql = require('mysql');

const conexion = mysql.createConnection({
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: '',
    database: 'sis_contable',
    trustServerCertificate: true
});


module.exports = conexion;
