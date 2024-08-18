-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 19-08-2024 a las 01:54:41
-- Versión del servidor: 8.0.32
-- Versión de PHP: 8.2.4

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

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `createUser` (IN `dataJson` JSON)   BEGIN
	DECLARE error_code INT DEFAULT 0;
    DECLARE user_exists INT DEFAULT 0;
	DECLARE total_users INT DEFAULT 0;
    
    -- Declarar variables para almacenar los valores extraídos del JSON
    DECLARE v_id_tipo_usuario INT;
    DECLARE v_nombre VARCHAR(255);
    DECLARE v_usuario VARCHAR(255);
    DECLARE v_password VARCHAR(255);
    DECLARE v_email VARCHAR(255);

    -- Extraer valores del JSON
    SET v_id_tipo_usuario = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.id_tipo_usuario'));
    SET v_nombre = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.nombre'));
    SET v_usuario = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.usuario'));
    SET v_password = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.password'));
    SET v_email = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.email'));
    
    SELECT COUNT(*) INTO user_exists
	FROM usuarios
	WHERE nombre COLLATE utf8mb4_spanish_ci = v_nombre
    OR usuario COLLATE utf8mb4_spanish_ci = v_usuario 
    OR email COLLATE utf8mb4_spanish_ci = v_email;

    IF user_exists > 0 THEN
    -- Si ya existe, se puede lanzar un error o manejar de otra forma
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario ya existe con el mismo nombre, usuario o email';
	ELSE
		-- Contar el total de usuarios en la tabla
		SELECT COUNT(*) INTO total_users FROM usuarios;

		IF total_users >= 5 THEN
			-- Si ya hay 5 usuarios, se lanza un error
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se pueden crear más de 5 usuarios';
		ELSE
		
			-- Iniciar la transacción
			START TRANSACTION;
			
			-- Intentar insertar el usuario
			INSERT INTO usuarios(id_usuario , id_tipo_usuario , nombre , usuario , password , email)
			VALUES(null , v_id_tipo_usuario , v_nombre , v_usuario , v_password , v_email);
			
			-- Verificar si hubo un error
			GET DIAGNOSTICS CONDITION 1 error_code = MYSQL_ERRNO;
			IF error_code != 0 THEN
				ROLLBACK;
			ELSE
				SELECT 'Operación completada exitosamente' AS MESSAGE;
				COMMIT;
			END IF;
		END IF;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteUser` (IN `id` INT)   BEGIN 
    DECLARE error_code INT DEFAULT 0;

    -- Iniciar la transacción
    START TRANSACTION;

    -- Intentar eliminar el usuario
    DELETE FROM usuarios WHERE id_usuario = id;

    -- Obtener el código de error si ocurrió uno
    GET DIAGNOSTICS CONDITION 1 error_code = MYSQL_ERRNO;

    -- Verificar si hubo un error
    IF error_code != 0 THEN
        SELECT 'SE ENCONTRO UN ERROR' AS MESSAGE;
        ROLLBACK;
    ELSE
        SELECT 'USUARIO ELIMINADO' AS MESSAGE; 
        COMMIT;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `editUser` (IN `dataJson` JSON)   BEGIN
	DECLARE error_code INT DEFAULT 0;
    
    -- Declarar variables para almacenar los valores extraídos del JSON
    DECLARE v_id_usuario INT;
    DECLARE v_id_tipo_usuario INT;
    DECLARE v_nombre VARCHAR(255);
    DECLARE v_usuario VARCHAR(255);
    DECLARE v_password VARCHAR(255);
    DECLARE v_email VARCHAR(255);

    -- Extraer valores del JSON
    SET v_id_usuario = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.id_usuario'));
    SET v_id_tipo_usuario = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.id_tipo_usuario'));
    SET v_nombre = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.nombre'));
    SET v_usuario = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.usuario'));
    SET v_password = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.password'));
    SET v_email = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.email'));

    -- Iniciar la transacción
    START TRANSACTION;

    -- Intentar insertar o actualizar el usuario
	UPDATE usuarios 
    SET id_tipo_usuario = v_id_tipo_usuario,
        nombre = v_nombre,
        usuario = v_usuario,
        password = v_password,
        email = v_email
    WHERE id_usuario = v_id_usuario;
    
    -- Verificar si hubo un error
    GET DIAGNOSTICS CONDITION 1 error_code = MYSQL_ERRNO;
    IF error_code != 0 THEN
        ROLLBACK;
    ELSE
        SELECT 'Operación completada exitosamente' AS MESSAGE;
        COMMIT;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllUser` ()   begin
	select * from usuarios; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getListUsers` ()   begin

	select usuarios.id_usuario , usuarios.id_tipo_usuario, usuarios.nombre , usuarios.usuario ,
	tipos_usuario.tipo_usuario , usuarios.password , usuarios.email  from usuarios , tipos_usuario
	where usuarios.id_tipo_usuario = tipos_usuario.id_tipo_usuario;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `login` (IN `json_text` TEXT)   begin
    DECLARE exit_handler BOOLEAN DEFAULT FALSE;
    DECLARE json_error VARCHAR(512) DEFAULT '';

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SET exit_handler = TRUE;
        GET DIAGNOSTICS CONDITION 1 json_error = MESSAGE_TEXT;
    END;

    -- SELECT USUARIO EXISTE 
    SELECT * FROM Usuarios 
    WHERE usuario = JSON_UNQUOTE(JSON_EXTRACT(json_text, '$.usuario'))
    AND password = JSON_UNQUOTE(JSON_EXTRACT(json_text, '$.clave'));

    IF exit_handler THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = json_error;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `caja_registro`
--

CREATE TABLE `caja_registro` (
  `id_caja_registro` int NOT NULL,
  `id_usuario` int NOT NULL,
  `id_categoria` int NOT NULL,
  `id_rubro` int NOT NULL,
  `id_forma_pago` int NOT NULL,
  `id_cuenta` int NOT NULL,
  `fecha_registrop` datetime NOT NULL,
  `descripcion` varchar(300) COLLATE utf8mb4_spanish_ci NOT NULL,
  `debe` decimal(10,2) DEFAULT NULL,
  `haber` decimal(10,2) DEFAULT NULL,
  `gestion` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id_categoria` int NOT NULL,
  `categoria` varchar(150) COLLATE utf8mb4_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuentas`
--

CREATE TABLE `cuentas` (
  `id_cuenta` int NOT NULL,
  `cuenta` varchar(150) COLLATE utf8mb4_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `formas_pago`
--

CREATE TABLE `formas_pago` (
  `id_forma_pago` int NOT NULL,
  `forma_pago` varchar(150) COLLATE utf8mb4_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `grupos`
--

CREATE TABLE `grupos` (
  `id_grupo` int NOT NULL,
  `grupo` varchar(150) COLLATE utf8mb4_spanish_ci NOT NULL
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
-- Estructura de tabla para la tabla `rubros`
--

CREATE TABLE `rubros` (
  `id_rubro` int NOT NULL,
  `id_grupo` int DEFAULT NULL,
  `id_tipo` int DEFAULT NULL,
  `rubro` varchar(150) COLLATE utf8mb4_spanish_ci NOT NULL
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
(26, 3, NULL, 'Aportes de los Propietarios'),
(27, 3, NULL, 'Capital Social'),
(28, 3, NULL, 'Primas de Emisión'),
(29, 3, NULL, 'Resultados No Asignados'),
(30, 3, NULL, 'Reservas'),
(31, 3, NULL, 'Resultados Acumulados'),
(32, 3, NULL, 'Resultado del Ejercicio'),
(33, 4, NULL, 'Ventas'),
(34, 4, NULL, 'Ingresos por Prestación de Servicios'),
(35, 4, NULL, 'Ingresos Financieros'),
(36, 4, NULL, 'Otros Ingresos Operacionales'),
(37, 4, NULL, 'Ingresos No Operacionales'),
(38, 5, NULL, 'Costos de Ventas'),
(39, 5, NULL, 'Gastos de Administración'),
(40, 5, NULL, 'Gastos de Comercialización'),
(41, 5, NULL, 'Gastos Financieros'),
(42, 5, NULL, 'Otros Gastos Operacionales'),
(43, 5, NULL, 'Gastos No Operacionales');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos`
--

CREATE TABLE `tipos` (
  `id_tipo` int NOT NULL,
  `tipo` varchar(12) COLLATE utf8mb4_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `tipos`
--

INSERT INTO `tipos` (`id_tipo`, `tipo`) VALUES
(1, 'Corriente'),
(2, 'No Corriente');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_usuario`
--

CREATE TABLE `tipos_usuario` (
  `id_tipo_usuario` int NOT NULL,
  `tipo_usuario` varchar(150) COLLATE utf8mb4_spanish_ci NOT NULL
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
  `id_usuario` int NOT NULL,
  `id_tipo_usuario` int NOT NULL,
  `nombre` varchar(150) COLLATE utf8mb4_spanish_ci NOT NULL,
  `usuario` varchar(150) COLLATE utf8mb4_spanish_ci NOT NULL,
  `password` varchar(150) COLLATE utf8mb4_spanish_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `id_tipo_usuario`, `nombre`, `usuario`, `password`, `email`) VALUES
(1, 1, 'Lucia Bellome', 'Luci', '1234', 'luci@gmail.com'),
(2, 1, 'Osvaldo Plaza', 'ova', '1234', 'osvaldo@gmail.com'),
(10, 2, 'user1', 'user12', 'asd-123', '12user@example.com'),
(11, 2, 'user12', 'user123', 'asd-123', '123user@example.com'),
(12, 2, 'user1234', 'user12345', 'asd-123', '12345user@example.com');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `caja_registro`
--
ALTER TABLE `caja_registro`
  ADD PRIMARY KEY (`id_caja_registro`),
  ADD KEY `id_caja_categoria_idx` (`id_categoria`),
  ADD KEY `id_caja_rubro_idx` (`id_rubro`),
  ADD KEY `id_caja_pago_idx` (`id_forma_pago`),
  ADD KEY `id_caja_cuenta_idx` (`id_cuenta`),
  ADD KEY `id_caja_usuario_idx` (`id_usuario`);

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id_categoria`);

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
-- Indices de la tabla `rubros`
--
ALTER TABLE `rubros`
  ADD PRIMARY KEY (`id_rubro`),
  ADD KEY `fk_rubro_grupo_idx` (`id_grupo`) USING BTREE,
  ADD KEY `fk_rubro_tipo_idx` (`id_tipo`) USING BTREE;

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
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id_categoria` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cuentas`
--
ALTER TABLE `cuentas`
  MODIFY `id_cuenta` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `formas_pago`
--
ALTER TABLE `formas_pago`
  MODIFY `id_forma_pago` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `grupos`
--
ALTER TABLE `grupos`
  MODIFY `id_grupo` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `rubros`
--
ALTER TABLE `rubros`
  MODIFY `id_rubro` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT de la tabla `tipos`
--
ALTER TABLE `tipos`
  MODIFY `id_tipo` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `tipos_usuario`
--
ALTER TABLE `tipos_usuario`
  MODIFY `id_tipo_usuario` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `caja_registro`
--
ALTER TABLE `caja_registro`
  ADD CONSTRAINT `id_caja_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`),
  ADD CONSTRAINT `id_caja_cuenta` FOREIGN KEY (`id_cuenta`) REFERENCES `cuentas` (`id_cuenta`),
  ADD CONSTRAINT `id_caja_pago` FOREIGN KEY (`id_forma_pago`) REFERENCES `formas_pago` (`id_forma_pago`),
  ADD CONSTRAINT `id_caja_rubro` FOREIGN KEY (`id_rubro`) REFERENCES `rubros` (`id_rubro`),
  ADD CONSTRAINT `id_caja_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `rubros`
--
ALTER TABLE `rubros`
  ADD CONSTRAINT `fk_rubro_corriente` FOREIGN KEY (`id_tipo`) REFERENCES `tipos` (`id_tipo`),
  ADD CONSTRAINT `fk_rubro_tipo` FOREIGN KEY (`id_grupo`) REFERENCES `grupos` (`id_grupo`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuario_tipos` FOREIGN KEY (`id_tipo_usuario`) REFERENCES `tipos_usuario` (`id_tipo_usuario`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
