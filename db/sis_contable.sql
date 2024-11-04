-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 04-11-2024 a las 03:36:50
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sis_contable`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuentas`
--

CREATE TABLE `cuentas` (
  `id_cuenta` int(11) NOT NULL,
  `cuenta` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `cuentas`
--

INSERT INTO `cuentas` (`id_cuenta`, `cuenta`) VALUES
(1, 'Banco Galicia'),
(2, 'Banco Santander'),
(3, 'Caja');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `formas_pago`
--

CREATE TABLE `formas_pago` (
  `id_forma_pago` int(11) NOT NULL,
  `forma_pago` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `formas_pago`
--

INSERT INTO `formas_pago` (`id_forma_pago`, `forma_pago`) VALUES
(1, 'Efectivo'),
(2, 'Cheque'),
(3, 'Tranferencia'),
(4, 'Pagare');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `grupos`
--

CREATE TABLE `grupos` (
  `id_grupo` int(11) NOT NULL,
  `grupo` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `grupos`
--

INSERT INTO `grupos` (`id_grupo`, `grupo`) VALUES
(1, 'Activos'),
(2, 'Pasivos'),
(3, 'Patrimonio Neto'),
(4, 'Resultado Positivo'),
(5, 'Resultado Negativo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `libro_diario`
--

CREATE TABLE `libro_diario` (
  `id_libro_diario` int(11) NOT NULL,
  `asiento` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_rubro` int(11) NOT NULL,
  `id_sub_rubro` int(11) NOT NULL,
  `id_forma_pago` int(11) NOT NULL,
  `id_cuenta` int(11) NOT NULL,
  `fecha_registro` date NOT NULL,
  `descripcion` varchar(300) NOT NULL,
  `debe` decimal(10,2) DEFAULT NULL,
  `haber` decimal(10,2) DEFAULT NULL,
  `gestion` int(11) NOT NULL,
  `activo` int(11) NOT NULL DEFAULT 1 COMMENT '1 - Activo / 0 - Desactivado'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `plan_cuenta`
--

CREATE TABLE `plan_cuenta` (
  `codigo_cuenta` varchar(50) NOT NULL,
  `id_sub_rubro` int(11) NOT NULL,
  `id_cuenta` int(11) NOT NULL,
  `saldo_inicial` double NOT NULL,
  `saldo_actual` double NOT NULL,
  `saldo_acumulado` double NOT NULL,
  `fecha_creacion` date NOT NULL,
  `estado` int(11) NOT NULL COMMENT '0 - Desactivado / 1 - Activado'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rubros`
--

CREATE TABLE `rubros` (
  `id_rubro` int(11) NOT NULL,
  `id_grupo` int(11) DEFAULT NULL,
  `id_tipo` int(11) DEFAULT NULL,
  `rubro` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sub_rubros`
--

CREATE TABLE `sub_rubros` (
  `id_sub_rubro` int(11) NOT NULL,
  `id_rubro` int(11) NOT NULL,
  `sub_rubro` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos`
--

CREATE TABLE `tipos` (
  `id_tipo` int(11) NOT NULL,
  `tipo` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `tipos`
--

INSERT INTO `tipos` (`id_tipo`, `tipo`) VALUES
(1, 'Corriente'),
(2, 'No Corriente'),
(3, 'No Aplica');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_usuario`
--

CREATE TABLE `tipos_usuario` (
  `id_tipo_usuario` int(11) NOT NULL,
  `tipo_usuario` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `tipos_usuario`
--

INSERT INTO `tipos_usuario` (`id_tipo_usuario`, `tipo_usuario`) VALUES
(1, 'Administrador'),
(2, 'Espectador');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `id_tipo_usuario` int(11) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `usuario` varchar(150) NOT NULL,
  `password` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `id_tipo_usuario`, `nombre`, `usuario`, `password`, `email`) VALUES
(1, 1, 'Luci Bellome', 'Lucifer', '$2b$10$WLdf9s55HoJ1alE8E9UmqupXPq0hJprw15ZNT5huOGPTWk6Z2mi1i', 'luci@hotmail.com'),
(2, 1, 'Osvaldo Plaza', 'ova', '1234', 'osvaldo@gmail.com'),
(20, 2, 'Esteban Lores', 'Esteban', 'es123', 'esteban@gmail.com');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cuentas`
--
ALTER TABLE `cuentas`
  ADD PRIMARY KEY (`id_cuenta`);

--
-- Indices de la tabla `formas_pago`
--
ALTER TABLE `formas_pago`
  ADD PRIMARY KEY (`id_forma_pago`);

--
-- Indices de la tabla `grupos`
--
ALTER TABLE `grupos`
  ADD PRIMARY KEY (`id_grupo`);

--
-- Indices de la tabla `libro_diario`
--
ALTER TABLE `libro_diario`
  ADD PRIMARY KEY (`id_libro_diario`) USING BTREE,
  ADD KEY `id_caja_rubro_idx` (`id_rubro`),
  ADD KEY `id_caja_pago_idx` (`id_forma_pago`),
  ADD KEY `id_caja_cuenta_idx` (`id_cuenta`),
  ADD KEY `id_caja_usuario_idx` (`id_usuario`),
  ADD KEY `id_sub_rubro_idx` (`id_sub_rubro`) USING BTREE;

--
-- Indices de la tabla `plan_cuenta`
--
ALTER TABLE `plan_cuenta`
  ADD PRIMARY KEY (`codigo_cuenta`),
  ADD KEY `id_sub_rubro` (`id_sub_rubro`),
  ADD KEY `id_cuenta` (`id_cuenta`);

--
-- Indices de la tabla `rubros`
--
ALTER TABLE `rubros`
  ADD PRIMARY KEY (`id_rubro`),
  ADD KEY `fk_rubro_grupo_idx` (`id_grupo`) USING BTREE,
  ADD KEY `fk_rubro_tipo_idx` (`id_tipo`) USING BTREE;

--
-- Indices de la tabla `sub_rubros`
--
ALTER TABLE `sub_rubros`
  ADD PRIMARY KEY (`id_sub_rubro`),
  ADD KEY `id_rubos_sub_rubros_fk` (`id_rubro`);

--
-- Indices de la tabla `tipos`
--
ALTER TABLE `tipos`
  ADD PRIMARY KEY (`id_tipo`);

--
-- Indices de la tabla `tipos_usuario`
--
ALTER TABLE `tipos_usuario`
  ADD PRIMARY KEY (`id_tipo_usuario`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD KEY `fk_usuario_tipos_idx` (`id_tipo_usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cuentas`
--
ALTER TABLE `cuentas`
  MODIFY `id_cuenta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `formas_pago`
--
ALTER TABLE `formas_pago`
  MODIFY `id_forma_pago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `grupos`
--
ALTER TABLE `grupos`
  MODIFY `id_grupo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `libro_diario`
--
ALTER TABLE `libro_diario`
  MODIFY `id_libro_diario` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `rubros`
--
ALTER TABLE `rubros`
  MODIFY `id_rubro` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT de la tabla `sub_rubros`
--
ALTER TABLE `sub_rubros`
  MODIFY `id_sub_rubro` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT de la tabla `tipos`
--
ALTER TABLE `tipos`
  MODIFY `id_tipo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tipos_usuario`
--
ALTER TABLE `tipos_usuario`
  MODIFY `id_tipo_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `libro_diario`
--
ALTER TABLE `libro_diario`
  ADD CONSTRAINT `id_caja_categoria` FOREIGN KEY (`id_sub_rubro`) REFERENCES `sub_rubros` (`id_sub_rubro`),
  ADD CONSTRAINT `id_caja_cuenta` FOREIGN KEY (`id_cuenta`) REFERENCES `cuentas` (`id_cuenta`),
  ADD CONSTRAINT `id_caja_pago` FOREIGN KEY (`id_forma_pago`) REFERENCES `formas_pago` (`id_forma_pago`),
  ADD CONSTRAINT `id_caja_rubro` FOREIGN KEY (`id_rubro`) REFERENCES `rubros` (`id_rubro`),
  ADD CONSTRAINT `id_caja_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `plan_cuenta`
--
ALTER TABLE `plan_cuenta`
  ADD CONSTRAINT `plan_cuenta_ibfk_1` FOREIGN KEY (`id_sub_rubro`) REFERENCES `sub_rubros` (`id_sub_rubro`),
  ADD CONSTRAINT `plan_cuenta_ibfk_2` FOREIGN KEY (`id_cuenta`) REFERENCES `cuentas` (`id_cuenta`);

--
-- Filtros para la tabla `rubros`
--
ALTER TABLE `rubros`
  ADD CONSTRAINT `fk_rubro_corriente` FOREIGN KEY (`id_tipo`) REFERENCES `tipos` (`id_tipo`),
  ADD CONSTRAINT `fk_rubro_tipo` FOREIGN KEY (`id_grupo`) REFERENCES `grupos` (`id_grupo`);

--
-- Filtros para la tabla `sub_rubros`
--
ALTER TABLE `sub_rubros`
  ADD CONSTRAINT `id_rubos_sub_rubros_fk` FOREIGN KEY (`id_rubro`) REFERENCES `rubros` (`id_rubro`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
