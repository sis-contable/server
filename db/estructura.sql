-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 03-11-2024 a las 02:08:03
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.0.28

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `formas_pago`
--

CREATE TABLE `formas_pago` (
  `id_forma_pago` int(11) NOT NULL,
  `forma_pago` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `grupos`
--

CREATE TABLE `grupos` (
  `id_grupo` int(11) NOT NULL,
  `grupo` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

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
  `gestion` int(11) NOT NULL DEFAULT 0 COMMENT '0 - No es gestion/ 1 - Si es gestion',
  `activo` int(11) NOT NULL DEFAULT 1 COMMENT '0 - Inactivo / 1 - Activo'
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sub_rubros`
--

CREATE TABLE `sub_rubros` (
  `id_sub_rubro` int(11) NOT NULL,
  `id_rubro` int(11) NOT NULL,
  `sub_rubro` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos`
--

CREATE TABLE `tipos` (
  `id_tipo` int(11) NOT NULL,
  `tipo` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_usuario`
--

CREATE TABLE `tipos_usuario` (
  `id_tipo_usuario` int(11) NOT NULL,
  `tipo_usuario` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

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
  MODIFY `id_cuenta` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `formas_pago`
--
ALTER TABLE `formas_pago`
  MODIFY `id_forma_pago` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `grupos`
--
ALTER TABLE `grupos`
  MODIFY `id_grupo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `libro_diario`
--
ALTER TABLE `libro_diario`
  MODIFY `id_libro_diario` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `rubros`
--
ALTER TABLE `rubros`
  MODIFY `id_rubro` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `sub_rubros`
--
ALTER TABLE `sub_rubros`
  MODIFY `id_sub_rubro` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipos`
--
ALTER TABLE `tipos`
  MODIFY `id_tipo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipos_usuario`
--
ALTER TABLE `tipos_usuario`
  MODIFY `id_tipo_usuario` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT;

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
