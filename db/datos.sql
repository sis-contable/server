--
-- Base de datos: `sis_contable`
--

--
-- Volcado de datos para la tabla `cuentas`
--

INSERT INTO `cuentas` (`id_cuenta`, `cuenta`) VALUES
(1, 'Banco Galicia'),
(2, 'Banco Santander'),
(3, 'Caja'),
(4, 'Activo Fijo'),
(5, 'Aportes de los Propietarios'),
(6, 'Clientes'),
(7, 'Obligación Bancaria'),
(8, 'Ingresos Operacionales'),
(9, 'Gasto Administrativo');

--
-- Volcado de datos para la tabla `formas_pago`
--

INSERT INTO `formas_pago` (`id_forma_pago`, `forma_pago`) VALUES
(1, 'Efectivo'),
(2, 'Cheque'),
(3, 'Tranferencia'),
(4, 'Pagare');

--
-- Volcado de datos para la tabla `grupos`
--

INSERT INTO `grupos` (`id_grupo`, `grupo`) VALUES
(1, 'Activos'),
(2, 'Pasivos'),
(3, 'Patrimonio Neto'),
(4, 'Resultado Positivo'),
(5, 'Resultado Negativo');

--
-- Volcado de datos para la tabla `libro_diario`
--

INSERT INTO `libro_diario` (`id_libro_diario`, `asiento`, `id_usuario`, `id_rubro`, `id_sub_rubro`, `id_forma_pago`, `id_cuenta`, `fecha_registro`, `descripcion`, `debe`, `haber`, `gestion`, `activo`) VALUES
(33, 1, 1, 1, 1, 1, 3, '2024-01-01', 'entrada de dinero en efectivo', 500000.00, 0.00, 1, 1),
(34, 1, 1, 27, 48, 1, 3, '2024-01-01', 'capital social en efectivo para la caja', 0.00, 500000.00, 1, 1),
(35, 2, 1, 1, 81, 3, 1, '2024-01-15', 'entrada de dinero por billetera virtual', 300000.00, 0.00, 0, 1),
(36, 2, 1, 12, 31, 3, 1, '2024-01-15', 'prestamo demandado al bco galicia', 0.00, 300000.00, 0, 1),
(37, 3, 1, 7, 21, 1, 3, '2024-01-20', 'entrada de inmueble', 40000.00, 0.00, 1, 1),
(38, 3, 1, 1, 1, 1, 3, '2024-01-20', 'pago de inmueble', 0.00, 15000.00, 1, 1),
(39, 3, 1, 11, 30, 4, 1, '2024-01-20', 'deuda por inmueble', 0.00, 25000.00, 1, 1),
(40, 4, 1, 36, 66, 1, 3, '2024-01-28', 'aquiler cedido', 20000.00, 0.00, 1, 1),
(41, 4, 1, 1, 1, 1, 3, '2024-01-28', 'alquiler', 0.00, 20000.00, 1, 1),
(42, 5, 1, 40, 73, 1, 3, '2024-01-28', 'pago de publicidad', 5000.00, 0.00, 0, 1),
(43, 5, 1, 39, 71, 1, 3, '2024-01-28', 'honorarios', 10000.00, 0.00, 1, 1),
(44, 5, 1, 42, 78, 1, 3, '2024-01-28', 'pago servicio de luz', 4000.00, 0.00, 1, 1),
(45, 5, 1, 42, 78, 1, 3, '2024-01-28', 'pago servicio de gas', 4000.00, 0.00, 0, 1),
(46, 5, 1, 11, 30, 1, 3, '2024-01-28', 'acreedores varios', 0.00, 23000.00, 1, 1),
(47, 6, 1, 1, 1, 1, 3, '2024-01-31', 'cobro de venta', 70000.00, 0.00, 0, 1),
(48, 6, 1, 33, 59, 1, 3, '2024-01-31', 'venta de producto', 0.00, 70000.00, 1, 1),
(49, 7, 1, 38, 69, 1, 3, '2024-01-31', 'coste de mercaderia vendida', 20000.00, 0.00, 0, 1),
(50, 7, 1, 4, 13, 1, 3, '2024-01-31', 'mercaderias vendidas', 0.00, 20000.00, 0, 1),
(51, 8, 1, 39, 72, 3, 1, '2024-01-31', 'sueldo y jornada', 10000.00, 0.00, 0, 1),
(52, 8, 1, 13, 33, 3, 1, '2024-01-31', 'sueldos y jornadas  a pagar', 0.00, 10000.00, 0, 1),
(53, 9, 1, 11, 29, 4, 2, '2024-03-25', 'proveedores', 25000.00, 0.00, 0, 1),
(54, 9, 1, 11, 30, 4, 2, '2024-03-25', 'acreedores', 100000.00, 0.00, 0, 1),
(55, 9, 1, 1, 81, 4, 2, '2024-03-25', 'pago a proveedores y acreedores', 0.00, 125000.00, 0, 1);

--
-- Volcado de datos para la tabla `plan_cuenta`
--

INSERT INTO `plan_cuenta` (`codigo_cuenta`, `id_sub_rubro`, `id_cuenta`, `saldo_inicial`, `saldo_actual`, `saldo_acumulado`, `fecha_creacion`, `estado`) VALUES
('1.1.1.1.3', 1, 3, 1962, 587226, 587226, '2024-10-08', 1),
('1.1.1.3.1', 3, 1, 500000, 1000000, 1000000, '2024-10-10', 1),
('1.1.1.3.2', 3, 2, 1500000, 1500000, 1500000, '2024-10-11', 1),
('1.1.1.81.1', 81, 1, 300000, 300000, 300000, '2024-11-01', 1),
('1.1.1.81.2', 81, 2, -125000, -125000, -125000, '2024-11-02', 1),
('1.1.3.12.1', 12, 1, -727, -727, -727, '2024-10-10', 1),
('1.1.3.12.2', 12, 2, -1998, 2202, 2202, '2024-10-10', 1),
('1.1.3.12.3', 12, 3, -116, -324, -324, '2024-10-10', 1),
('1.1.3.9.1', 9, 1, -25000, -25000, -25000, '2024-10-08', 1),
('1.1.3.9.2', 9, 2, 727, -1475, -1475, '2024-10-10', 1),
('1.1.3.9.3', 9, 3, -1962, -26902, -26902, '2024-10-08', 1),
('1.1.4.13.3', 13, 3, -20000, -20000, -20000, '2024-11-02', 1),
('1.2.7.21.3', 21, 3, 40000, 40000, 40000, '2024-11-02', 1),
('2.1.11.29.2', 29, 2, -25000, -25000, -25000, '2024-11-02', 1),
('2.1.11.30.1', 30, 1, 25000, 25000, 25000, '2024-11-02', 1),
('2.1.11.30.2', 30, 2, -100000, -100000, -100000, '2024-11-02', 1),
('2.1.11.30.3', 30, 3, 120000, 23000, 23000, '2024-10-11', 1),
('2.1.12.31.1', 31, 1, 500000, 1300000, 1300000, '2024-10-10', 1),
('2.1.12.31.2', 31, 2, 1500000, 1500000, 1500000, '2024-10-11', 1),
('2.1.13.33.1', 33, 1, 10000, 10000, 10000, '2024-11-02', 1),
('3.3.26.45.3', 45, 3, -1500000, -1500000, -1500000, '2024-10-10', 1),
('3.3.26.46.1', 46, 1, -2500000, -2500000, -2500000, '2024-10-11', 1),
('3.3.27.47.2', 47, 2, 1500000, 1500000, 1500000, '2024-10-10', 1),
('3.3.27.48.1', 48, 1, 2500000, 2500000, 2500000, '2024-10-11', 1),
('3.3.27.48.3', 48, 3, 500000, 500000, 500000, '2024-11-01', 1),
('4.3.33.59.3', 59, 3, 70000, 70000, 70000, '2024-11-02', 1),
('4.3.36.66.3', 66, 3, -20000, -20000, -20000, '2024-11-02', 1),
('5.3.38.69.3', 69, 3, 20000, 20000, 20000, '2024-11-02', 1),
('5.3.39.71.3', 71, 3, 10000, 10000, 10000, '2024-11-02', 1),
('5.3.39.72.1', 72, 1, 10000, 10000, 10000, '2024-11-02', 1),
('5.3.40.73.3', 73, 3, 5000, 5000, 5000, '2024-11-02', 1),
('5.3.42.78.3', 78, 3, 4000, 8000, 8000, '2024-11-02', 1);

--
-- Volcado de datos para la tabla `rubros`
--

INSERT INTO `rubros` (`id_rubro`, `id_grupo`, `id_tipo`, `rubro`) VALUES
(1, 1, 1, 'Caja y Bancos'),
(2, 1, 1, 'Inversiones Temporales'),
(3, 1, 1, 'Créditos y Cuentas por Cobrar'),
(4, 1, 1, 'Bienes de Cambio'),
(5, 1, 1, 'Anticipos'),
(6, 1, 1, 'Otros créditos'),
(7, 1, 2, 'Bienes de Uso'),
(8, 1, 2, 'Inversiones a Largo Plazo'),
(9, 1, 2, 'Propiedades de Inversión'),
(10, 1, 2, 'Activos Intangibles'),
(11, 2, 1, 'Deudas Comerciales'),
(12, 2, 1, 'Préstamos a Corto Plazo'),
(13, 2, 1, 'Remuneraciones y Cargas Sociales'),
(14, 2, 1, 'Provisiones'),
(15, 2, 1, 'Impuestos por Pagar'),
(16, 2, 2, 'Préstamos a Largo Plazo'),
(17, 2, 2, 'Obligaciones Financieras a Largo Plazo'),
(18, 2, 2, 'Provisiones a Largo Plazo'),
(26, 3, 3, 'Aportes de los Propietarios'),
(27, 3, 3, 'Capital Social'),
(28, 3, 3, 'Primas de Emisión'),
(29, 3, 3, 'Resultados No Asignados'),
(30, 3, 3, 'Reservas'),
(31, 3, 3, 'Resultados Acumulados'),
(32, 3, 3, 'Resultado del Ejercicio'),
(33, 4, 3, 'Ventas'),
(34, 4, 3, 'Ingresos por Prestación de Servicios'),
(35, 4, 3, 'Ingresos Financieros'),
(36, 4, 3, 'Otros Ingresos Operacionales'),
(37, 4, 3, 'Ingresos No Operacionales'),
(38, 5, 3, 'Costos de Ventas'),
(39, 5, 3, 'Gastos de Administración'),
(40, 5, 3, 'Gastos de Comercialización'),
(41, 5, 3, 'Gastos Financieros'),
(42, 5, 3, 'Otros Gastos Operacionales'),
(43, 5, 3, 'Gastos No Operacionales');

--
-- Volcado de datos para la tabla `sub_rubros`
--

INSERT INTO `sub_rubros` (`id_sub_rubro`, `id_rubro`, `sub_rubro`) VALUES
(1, 1, 'Caja en Pesos'),
(2, 1, 'Caja en Dólares'),
(3, 1, 'Bancos en Pesos'),
(4, 1, 'Bancos en Dólares'),
(5, 2, 'Plazos Fijos en Pesos'),
(6, 2, 'Plazos Fijos en Dólares'),
(7, 2, 'Bonos de Corto Plazo'),
(8, 2, 'Acciones'),
(9, 3, 'Cuentas por Cobrar a Clientes'),
(10, 3, 'Cuentas por Cobrar Diversas'),
(11, 3, 'Préstamos Otorgados a Corto Plazo'),
(12, 3, 'Otros Créditos'),
(13, 4, 'Mercaderías'),
(14, 4, 'Materias Primas'),
(15, 4, 'Productos Terminados'),
(16, 4, 'Productos en Proceso'),
(17, 5, 'Anticipos a Proveedores'),
(18, 5, 'Anticipos a Empleados'),
(19, 6, 'Créditos Diversos'),
(20, 6, 'Créditos por Ajustes'),
(21, 7, 'Equipos de Oficina'),
(22, 7, 'Vehículos'),
(23, 8, 'Bonos a Largo Plazo'),
(24, 8, 'Acciones a Largo Plazo'),
(25, 9, 'Propiedades Comerciales'),
(26, 9, 'Propiedades Residenciales'),
(27, 10, 'Patentes'),
(28, 10, 'Marcas Registradas'),
(29, 11, 'Deudas a Proveedores'),
(30, 11, 'Deudas Diversas'),
(31, 12, 'Préstamos Bancarios a Corto Plazo'),
(32, 12, 'Préstamos Personales a Corto Plazo'),
(33, 13, 'Salarios a Pagar'),
(34, 13, 'Cargas Sociales a Pagar'),
(35, 14, 'Provisión para Impuestos'),
(36, 14, 'Provisión para Contingencias'),
(37, 15, 'IVA por Pagar'),
(38, 15, 'Impuesto a las Ganancias por Pagar'),
(39, 16, 'Préstamos Bancarios a Largo Plazo'),
(40, 16, 'Préstamos Personales a Largo Plazo'),
(41, 17, 'Obligaciones por Emisión de Bonos'),
(42, 17, 'Obligaciones por Créditos a Largo Plazo'),
(43, 18, 'Provisión para Jubilaciones'),
(44, 18, 'Provisión para Litigios'),
(45, 26, 'Aportes en Efectivo'),
(46, 26, 'Aportes en Especie'),
(47, 27, 'Capital Social Suscrito'),
(48, 27, 'Capital Social Pagado'),
(49, 28, 'Prima por Emisión de Acciones'),
(50, 28, 'Prima por Emisión de Bonos'),
(51, 29, 'Resultados del Ejercicio Anterior'),
(52, 29, 'Resultados de Ejercicios Anteriores'),
(53, 30, 'Reserva Legal'),
(54, 30, 'Reserva para Contingencias'),
(55, 31, 'Resultados Acumulados del Ejercicio'),
(56, 31, 'Resultados Acumulados de Ejercicios Anteriores'),
(57, 32, 'Resultado del Ejercicio Actual'),
(58, 32, 'Resultado del Ejercicio Anterior'),
(59, 33, 'Ventas de Productos'),
(60, 33, 'Ventas de Servicios'),
(61, 34, 'Servicios Profesionales'),
(62, 34, 'Servicios Técnicos'),
(63, 35, 'Intereses Ganados'),
(64, 35, 'Dividendos Recibidos'),
(65, 36, 'Ingresos por Venta de Activos'),
(66, 36, 'Ingresos por Alquileres'),
(67, 37, 'Ingresos por Venta de Bienes No Operacionales'),
(68, 37, 'Ingresos por Ganancias Excepcionales'),
(69, 38, 'Costo de Mercaderías Vendidas'),
(70, 38, 'Costo de Producción'),
(71, 39, 'Gastos de Oficina'),
(72, 39, 'Gastos de Sueldos Administrativos'),
(73, 40, 'Gastos de Publicidad'),
(74, 40, 'Gastos de Ventas'),
(75, 41, 'Intereses Pagados'),
(76, 41, 'Comisiones Financieras'),
(77, 42, 'Gastos de Mantenimiento'),
(78, 42, 'Gastos de Servicios Públicos'),
(79, 43, 'Pérdidas por Venta de Activos'),
(80, 43, 'Gastos por Multas'),
(81, 1, 'Banco Cta Corriente');

--
-- Volcado de datos para la tabla `tipos`
--

INSERT INTO `tipos` (`id_tipo`, `tipo`) VALUES
(1, 'Corriente'),
(2, 'No Corriente'),
(3, 'No Aplica');

--
-- Volcado de datos para la tabla `tipos_usuario`
--

INSERT INTO `tipos_usuario` (`id_tipo_usuario`, `tipo_usuario`) VALUES
(1, 'Administrador'),
(2, 'Espectador');

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `id_tipo_usuario`, `nombre`, `usuario`, `password`, `email`) VALUES
(1, 1, 'Luci Bellome', 'Lucifer', '$2b$10$WLdf9s55HoJ1alE8E9UmqupXPq0hJprw15ZNT5huOGPTWk6Z2mi1i', 'luci@hotmail.com'),
(2, 1, 'Osvaldo Plaza', 'ova', '1234', 'osvaldo@gmail.com'),
(20, 2, 'Esteban Lores', 'Esteban', 'es123', 'esteban@gmail.com');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
