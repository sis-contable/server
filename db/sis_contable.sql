-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 08-09-2024 a las 02:14:35
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
			SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'No se pueden crear más de 5 usuarios';
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `getListBookDiary` ()   begin
	SELECT libro_diario.id_libro_diario, grupos.grupo, tipos.tipo, rubros.rubro, sub_rubros.sub_rubro, 
			formas_pago.forma_pago, cuentas.cuenta, libro_diario.descripcion, libro_diario.debe, 
			libro_diario.haber, libro_diario.gestion 
			FROM `libro_diario`, `cuentas`, `formas_pago`, `grupos`, `rubros`,`sub_rubros`, `tipos` 
			WHERE (libro_diario.id_rubro = rubros.id_rubro AND libro_diario.id_sub_rubro = sub_rubros.id_sub_rubro AND libro_diario.id_forma_pago = formas_pago.id_forma_pago AND libro_diario.id_cuenta = cuentas.id_cuenta) AND (rubros.id_grupo = grupos.id_grupo AND rubros.id_tipo = tipos.id_tipo);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getListUsers` ()   begin

	select usuarios.id_usuario , usuarios.id_tipo_usuario, usuarios.nombre , usuarios.usuario ,
	tipos_usuario.tipo_usuario , usuarios.password , usuarios.email  from usuarios , tipos_usuario
	where usuarios.id_tipo_usuario = tipos_usuario.id_tipo_usuario;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertRegisterBookDiary` (IN `dataJson` JSON)   begin
	DECLARE error_code INT DEFAULT 0;
    DECLARE cuenta_exist INT DEFAULT 0;
    -- Declarar variables para almacenar los valores extraídos del JSON
    DECLARE v_id_usuario INT;
    DECLARE v_id_rubro INT;
    DECLARE v_id_sub_rubro INT;
    DECLARE v_id_forma_pago INT;
    DECLARE v_id_cuenta INT;
    DECLARE v_fecha_registro DATE;
    DECLARE v_descripcion VARCHAR(255);
    DECLARE v_debe DOUBLE;
    DECLARE v_haber DOUBLE;
    DECLARE v_gestion INT;
   -- Datos para el plan de cuenta
    DECLARE v_codigo_cuenta VARCHAR(50);
    DECLARE v_id_grupo INT;
    DECLARE v_id_tipo INT;
   -- Variables por si existe la cuenta
   DECLARE v_saldo_actual DOUBLE;
   DECLARE v_saldo_acumulado DOUBLE;


    -- Extraer valores del JSON Libro diario
    SET v_id_usuario = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.id_usuario'));
    SET v_id_rubro = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.id_rubro'));
    SET v_id_sub_rubro = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.id_sub_rubro'));
    SET v_id_forma_pago  = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.id_forma_pago'));
    SET v_id_cuenta = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.id_cuenta'));
    SET v_fecha_registro = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.fecha_registro'));
    SET v_descripcion = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.descripcion'));
    SET v_debe = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.debe'));
    SET v_haber = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.haber'));
    SET v_gestion = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.gestion'));
    -- Extraer valores del JSON Plan de Cuenta
	SET v_codigo_cuenta = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.codigo_cuenta'));
    SET v_id_grupo = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.id_grupo'));
    SET v_id_tipo = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.id_tipo'));
   
 -- Iniciar transacción
    START TRANSACTION;

    -- Realizar el insert
        INSERT INTO `libro_diario`(`id_libro_diario`, `id_usuario`, `id_rubro`, `id_sub_rubro`, `id_forma_pago`, `id_cuenta`, `fecha_registro`, `descripcion`, `debe`, `haber`, `gestion`) 
        VALUES (null, v_id_usuario, v_id_rubro, v_id_sub_rubro, v_id_forma_pago, v_id_cuenta, v_fecha_registro, v_descripcion, v_debe, v_haber, v_gestion);
    
	-- Verificar si la cuenta ya existe
	    SELECT COUNT(*) INTO cuenta_exist FROM plan_cuenta WHERE codigo_cuenta = v_codigo_cuenta;
	    IF cuenta_exist != 0 then

	        -- Si ya existe, obtener los valores actuales
	        SELECT saldo_actual, saldo_acumulado INTO v_saldo_actual, v_saldo_acumulado
	        FROM plan_cuenta
	        WHERE codigo_cuenta = v_codigo_cuenta;
	
	        -- Actualizar los saldos según el debe y haber
	        SET v_saldo_actual = v_saldo_actual + v_debe - v_haber;
	        SET v_saldo_acumulado = v_saldo_acumulado + v_debe - v_haber;
	
	        -- Actualizar la cuenta en plan_cuenta
	        UPDATE plan_cuenta
	        SET saldo_actual = v_saldo_actual,
	            saldo_acumulado = v_saldo_acumulado
	        WHERE codigo_cuenta = v_codigo_cuenta;
	
	    ELSE

	       -- Actualizar los saldos según el debe y haber
	    	IF v_debe != 0 then
	        	SET v_saldo_actual = -v_debe;
	        ELSE
	        	SET v_saldo_actual = v_haber;
	        END IF;
	
	        -- Realizar el insert
	        INSERT INTO plan_cuenta (codigo_cuenta, id_sub_rubro, id_cuenta, saldo_inicial, saldo_actual, saldo_acumulado, fecha_creacion, estado)
	        VALUES (v_codigo_cuenta, v_id_sub_rubro, v_id_cuenta,  v_saldo_actual, v_saldo_actual, v_saldo_actual, CURDATE(), 1);
	
	        -- Verificar si hubo un error
	        GET DIAGNOSTICS CONDITION 1 error_code = MYSQL_ERRNO;
	        IF error_code != 0 THEN
	            ROLLBACK;
	            SELECT 'Ha ocurrido un error durante la operación' AS MESSAGE;
	        ELSE
	            COMMIT;
	            SELECT 'Operación completada exitosamente' AS MESSAGE;
	        END IF;
    	END IF;
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
  `id_usuario` int(11) NOT NULL,
  `id_rubro` int(11) NOT NULL,
  `id_sub_rubro` int(11) NOT NULL,
  `id_forma_pago` int(11) NOT NULL,
  `id_cuenta` int(11) NOT NULL,
  `fecha_registro` date NOT NULL,
  `descripcion` varchar(300) NOT NULL,
  `debe` decimal(10,2) DEFAULT NULL,
  `haber` decimal(10,2) DEFAULT NULL,
  `gestion` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `libro_diario`
--

INSERT INTO `libro_diario` (`id_libro_diario`, `id_usuario`, `id_rubro`, `id_sub_rubro`, `id_forma_pago`, `id_cuenta`, `fecha_registro`, `descripcion`, `debe`, `haber`, `gestion`) VALUES
(1, 1, 10, 1, 1, 1, '2024-08-31', 'pago a', 250000.00, NULL, 1),
(8, 1, 1, 1, 1, 1, '2024-09-07', 'Pago proveedor', 0.00, 1500.00, 1),
(9, 1, 1, 1, 1, 1, '2024-09-07', 'Pago proveedor', 1500.00, 0.00, 1);

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
  `estado` int(1) NOT NULL COMMENT '0 - Desactivado / 1 - Activado'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `plan_cuenta`
--

INSERT INTO `plan_cuenta` (`codigo_cuenta`, `id_sub_rubro`, `id_cuenta`, `saldo_inicial`, `saldo_actual`, `saldo_acumulado`, `fecha_creacion`, `estado`) VALUES
('1.1.1.1.1', 1, 1, -1500, 0, 0, '2024-09-07', 1);

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
(1, 10, 'gastos');

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
(1, 1, 'Lucia Bellome', 'Luci', '1234', 'luci@gmail.com'),
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
  MODIFY `id_libro_diario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `rubros`
--
ALTER TABLE `rubros`
  MODIFY `id_rubro` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT de la tabla `sub_rubros`
--
ALTER TABLE `sub_rubros`
  MODIFY `id_sub_rubro` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuario_tipos` FOREIGN KEY (`id_tipo_usuario`) REFERENCES `tipos_usuario` (`id_tipo_usuario`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
