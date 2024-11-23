-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 04-11-2024 a las 03:20:23
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

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `createUser` (IN `dataJson` JSON)   BEGIN
	DECLARE error_code INT DEFAULT 0;
    DECLARE user_exists INT DEFAULT 0;
	DECLARE total_users INT DEFAULT 0;
    
    -- Declarar variables para almacenar los valores extraídos del JSON
    DECLARE v_nombre VARCHAR(255);
    DECLARE v_usuario VARCHAR(255);
    DECLARE v_password VARCHAR(255);
    DECLARE v_email VARCHAR(255);

    -- Extraer valores del JSON
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
			INSERT INTO usuarios(id_usuario , nombre , usuario , password , email)
			VALUES(null , v_nombre , v_usuario , v_password , v_email);
			
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `deletAccount` (IN `cuenta` VARCHAR(50))   BEGIN
    DECLARE mensaje VARCHAR(255);

    IF EXISTS (SELECT 1 FROM plan_cuenta WHERE codigo_cuenta = cuenta AND saldo_actual = 0) THEN
        DELETE FROM plan_cuenta WHERE codigo_cuenta = cuenta;
        SET mensaje = 'Cuenta eliminada correctamente';
    ELSE
        SET mensaje = 'El saldo de la cuenta debe estar en 0 para poder eliminarla';
    END IF;

    SELECT mensaje AS mensaje_exito;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteBookDiary` (IN `v_id_libro_diario` INT)   begin
	
	DECLARE error_code INT DEFAULT 0;
    DECLARE cuenta_exist INT DEFAULT 0;
    -- Declarar variables para almacenar los valores extraídos del JSON
    DECLARE v_id_grupo INT;
    DECLARE v_id_tipo INT;
    DECLARE v_id_rubro INT;
    DECLARE v_id_sub_rubro INT;
    DECLARE v_id_forma_pago INT;
    DECLARE v_id_cuenta INT;
    DECLARE v_debe DOUBLE;
    DECLARE v_haber DOUBLE;
   -- ID plan de cuenta
   	DECLARE v_saldo_actual DOUBLE;
   	DECLARE v_saldo_acumulado DOUBLE;
    DECLARE v_saldo_inicial DOUBLE;
    declare v_codigo_cuenta VARCHAR(50);
   
	-- Iniciar transacción
    START TRANSACTION;
   		SELECT rubros.id_grupo, rubros.id_tipo, libro_diario.id_rubro, libro_diario.id_sub_rubro, libro_diario.id_forma_pago, libro_diario.id_cuenta, libro_diario.debe, libro_diario.haber 
		INTO v_id_grupo, v_id_tipo, v_id_rubro, v_id_sub_rubro, v_id_forma_pago, v_id_cuenta, v_debe, v_haber
		FROM libro_diario
		JOIN rubros ON libro_diario.id_rubro = rubros.id_rubro
		WHERE libro_diario.id_libro_diario = v_id_libro_diario;
    -- Realizamos el DELETE
        DELETE FROM `libro_diario` WHERE id_libro_diario = v_id_libro_diario;
       
    -- Concatenar los valores para formar el código de cuenta
    	SET v_codigo_cuenta = CONCAT(v_id_grupo, '.', v_id_tipo, '.', v_id_rubro, '.', v_id_sub_rubro, '.', v_id_cuenta);
	-- Sumamos o Restamos de la cuenta y si la caja queda en 0 la eliminamos.
        SELECT saldo_inicial, saldo_actual, saldo_acumulado INTO v_saldo_inicial, v_saldo_actual, v_saldo_acumulado
        FROM plan_cuenta
        WHERE codigo_cuenta = v_codigo_cuenta;
       -- Verificar que el SELECT encontró datos
		IF v_saldo_inicial IS NULL THEN
		    -- Manejar el caso cuando el registro no existe
		    ROLLBACK;
		    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se encontró la cuenta para el código especificado';
		END IF;

        -- Actualizar los saldos según el debe y haber
    	IF v_debe != 0 then
       		SET v_saldo_inicial = v_saldo_inicial + v_debe;
        ELSE
       		SET v_saldo_inicial = v_saldo_inicial - v_haber;
        END IF;
       
	    IF v_saldo_inicial != 0 then
	    	IF v_debe != 0 then
		        SET v_saldo_actual = v_saldo_actual + v_debe;
	        	SET v_saldo_acumulado = v_saldo_acumulado + v_debe;
	        ELSE
	        	SET v_saldo_actual = v_saldo_actual - v_haber;
	        	SET v_saldo_acumulado = v_saldo_acumulado - v_haber;
	        END IF;
	       -- Actualizar la cuenta en plan_cuenta
	        UPDATE plan_cuenta
	        SET saldo_actual = v_saldo_actual,
	            saldo_acumulado = v_saldo_acumulado
	        WHERE codigo_cuenta = v_codigo_cuenta;
	       
		ELSE
	    	DELETE FROM `plan_cuenta` WHERE codigo_cuenta = v_codigo_cuenta;
	    	
	       
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
    DECLARE v_nombre VARCHAR(255);
    DECLARE v_usuario VARCHAR(255);
    DECLARE v_password VARCHAR(255);
    DECLARE v_email VARCHAR(255);

    -- Extraer valores del JSON
    SET v_id_usuario = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.id_usuario'));
    SET v_nombre = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.nombre'));
    SET v_usuario = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.usuario'));
    SET v_password = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.password'));
    SET v_email = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.email'));

    -- Iniciar la transacción
    START TRANSACTION;

    -- Intentar insertar o actualizar el usuario
	UPDATE usuarios 
    SET 
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAccounts` ()   begin
	SELECT * FROM `cuentas`;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllUser` ()   begin
	select * from usuarios; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAsientoCierre` (IN `desde` DATE, IN `hasta` DATE, OUT `resultado` JSON)   begin
	-- Declaramos las variables para el asiento de cierre
	DECLARE done_cierre INT DEFAULT FALSE;
	DECLARE rubro_cierre VARCHAR(100);
	DECLARE debe DOUBLE DEFAULT 0;
	DECLARE haber DOUBLE DEFAULT 0;
	DECLARE resultado_ejercico DOUBLE DEFAULT 0;
	DECLARE transaccion_iniciada BOOLEAN DEFAULT FALSE;

	-- JSON para almacenar datos
    DECLARE asiento_cierre JSON DEFAULT JSON_OBJECT('Asiento_cierre', JSON_OBJECT());
	
	-- Segundo cursor para Asiento_cierre
	-- Cursor para iterar sobre las cuentas
    DECLARE cur_cierre CURSOR FOR 
        SELECT 
            rubros.rubro,
            COALESCE(SUM(libro_diario.debe), 0) AS debe,
            COALESCE(SUM(libro_diario.haber), 0) AS haber
        FROM 
            libro_diario
        LEFT JOIN 
            rubros ON libro_diario.id_rubro = rubros.id_rubro
        LEFT JOIN 
        	grupos on rubros.id_grupo = grupos.id_grupo
        WHERE 
            grupos.id_grupo IN (4,5) AND 
            (libro_diario.fecha_registro BETWEEN desde AND hasta) 
            and libro_diario.descripcion = 'Asiento de cierre'
        GROUP BY 
            rubros.rubro;
	   
	-- DECLARAMOS HANDLRER PARA EL CIERRE, ESTE NOS PERMITE MANEJAR SI HAY UN ERROR AL RECORRER EL LOOP       
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done_cierre = TRUE;            
	       
   
    -- Iniciar la transacción
    START TRANSACTION;
  
	-- Calcular resultado_del_ejercicio
	    SELECT 
	        (COALESCE(SUM(totales.debe), 0) - COALESCE(SUM(totales.haber), 0)) AS resultado_ejercico
	    INTO 
	        resultado_ejercico
	    FROM (
	        SELECT 
	            rubros.rubro,
	            COALESCE(SUM(libro_diario.haber), 0) AS 'haber',
	            COALESCE(SUM(libro_diario.debe), 0) as 'debe'
	        FROM 
	            libro_diario
	        LEFT JOIN 
	            rubros ON libro_diario.id_rubro = rubros.id_rubro
	        LEFT JOIN 
	            grupos ON rubros.id_grupo = grupos.id_grupo
	        WHERE 
	            grupos.id_grupo IN (4, 5) and libro_diario.fecha_registro between  desde and hasta AND libro_diario.descripcion = 'Asiento de cierre'
	        GROUP BY 
	            rubros.rubro
	    ) AS totales;
	   
	-- Actualizar el JSON con la resultado del ejercicio
	SET asiento_cierre = JSON_SET(asiento_cierre, '$.Asiento_cierre.resultado_ejercico', resultado_ejercico);
	
	-- Inicializar los arrays en el JSON
	SET asiento_cierre = JSON_SET(
	    asiento_cierre,
	    '$.Asiento_cierre.cuentas_resultado_positivo', JSON_ARRAY(),
	    '$.Asiento_cierre.cuentas_resultado_negativo', JSON_ARRAY()
	);

-- Abre el cursor para Asiento_cierre
	OPEN cur_cierre;
	
	cierre_loop: LOOP
	    FETCH cur_cierre INTO rubro_cierre, haber, debe;
	
	    IF done_cierre THEN  -- Cambiado aquí
	        LEAVE cierre_loop;
	    END IF;
	
	    -- Agregar valores al JSON en Asiento_cierre según corresponda
	    IF haber > 0 THEN
	        SET asiento_cierre = JSON_ARRAY_APPEND(
	            asiento_cierre,
	            '$.Asiento_cierre.cuentas_resultado_negativo',
	            JSON_OBJECT('rubro', rubro_cierre, 'haber', haber)
	        );
	    END IF;
	
	    IF debe > 0 THEN
	        SET asiento_cierre = JSON_ARRAY_APPEND(
	            asiento_cierre,
	            '$.Asiento_cierre.cuentas_resultado_positivo',
	            JSON_OBJECT('rubro', rubro_cierre, 'debe', debe)
	        );
	    END IF;
	END LOOP;
	
	-- Cierra el cursor de Asiento_cierre
	CLOSE cur_cierre;

   -- Confirma la transacción
    COMMIT;
   
   -- Validación final
    IF asiento_cierre IS NULL THEN
        SET asiento_cierre = JSON_OBJECT('Error', 'balance_general no contiene datos');
    END IF;

    -- Devolver el JSON
    set resultado = asiento_cierre;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getBalanceGeneral` (IN `desde` DATE, IN `hasta` DATE)   BEGIN
    -- Declaración de variables para almacenar los resultados JSON de cada procedimiento
    DECLARE json_estado_resultado JSON;
    DECLARE json_asiento_cierre JSON;
    DECLARE json_situacion_patrimonial JSON;

    -- Manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;  -- Revertir la transacción en caso de error
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error en el procedimiento de getBalanceGeneral, se ha realizado un ROLLBACK';
    END;

    -- Iniciar la transacción
    START TRANSACTION;

	    -- Llamar a getEstadoResultado y capturar el resultado JSON en json_estado_resultado
	    CALL sis_contable.getEstadoResultado(desde, hasta, @json_estado_resultado);
	    SELECT @json_estado_resultado INTO json_estado_resultado;
	
	    IF json_estado_resultado IS NULL THEN
	        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error en getEstadoResultado: Resultado vacío o nulo';
	    END IF;
	
	    -- Llamar a getAsientoCierre y capturar el resultado JSON en json_asiento_cierre
	    CALL sis_contable.getAsientoCierre(desde, hasta, @json_asiento_cierre);
	    SELECT @json_asiento_cierre INTO json_asiento_cierre;
	
	    IF json_asiento_cierre IS NULL THEN
	        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error en getAsientoCierre: Resultado vacío o nulo';
	    END IF;
	
	    -- Llamar a getSituacionPatrimonial y capturar el resultado JSON en json_situacion_patrimonial
	    CALL sis_contable.getSituacionPatrimonial(desde, hasta, @json_situacion_patrimonial);
	    SELECT @json_situacion_patrimonial INTO json_situacion_patrimonial;
	
	    IF json_situacion_patrimonial IS NULL THEN
	        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error en getSituacionPatrimonial: Resultado vacío o nulo';
	    END IF;
	   
    -- Confirmar la transacción
    COMMIT;

    -- Devolver los JSON
    SELECT json_estado_resultado AS json_estado_resultado, 
           json_asiento_cierre AS json_asiento_cierre, 
           json_situacion_patrimonial AS json_situacion_patrimonial;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getEstadoResultado` (IN `desde` DATE, IN `hasta` DATE, OUT `resultado` JSON)   BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE total_positivo DOUBLE DEFAULT 0;
    DECLARE total_negativo DOUBLE DEFAULT 0;
    DECLARE ganancia_del_ejercicio DOUBLE DEFAULT 0;
    DECLARE ultimo_asiento INT DEFAULT 0;
    DECLARE asiento_existe INT DEFAULT 0;

    -- Variables para los datos de cada registro
    DECLARE id_grupo INT;
    DECLARE grupo VARCHAR(100);
    DECLARE id_rubro INT;
    DECLARE rubro VARCHAR(100);
    DECLARE id_sub_rubro INT;
    DECLARE id_forma_pago INT;
    DECLARE id_cuenta INT;
    DECLARE fecha_registro_er date;
   
    -- JSON para almacenar datos
    DECLARE estado_resultado JSON DEFAULT JSON_OBJECT('Estado_resultado', JSON_OBJECT());

    -- Cursor para iterar sobre las cuentas
    DECLARE cur CURSOR FOR 
        SELECT 
            grupos.id_grupo,
            grupos.grupo,
            rubros.id_rubro,
            rubros.rubro,
            libro_diario.id_sub_rubro,
            libro_diario.id_forma_pago,
            libro_diario.id_cuenta,
            COALESCE(SUM(libro_diario.haber), 0) AS total_positivo,
            COALESCE(SUM(libro_diario.debe), 0) AS total_negativo
        FROM 
            libro_diario
        LEFT JOIN 
            rubros ON libro_diario.id_rubro = rubros.id_rubro
        LEFT JOIN 
            grupos ON rubros.id_grupo = grupos.id_grupo
        WHERE 
            grupos.id_grupo IN (4, 5) AND libro_diario.fecha_registro BETWEEN desde AND hasta and libro_diario.descripcion != 'Asiento de Cierre'
        GROUP BY 
            rubros.rubro;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
   
   

    -- Verificar existencia de asiento de cierre
    SELECT COUNT(*) INTO asiento_existe FROM libro_diario WHERE descripcion = 'Asiento de cierre' and fecha_registro BETWEEN desde AND hasta;

    -- Iniciar la transacción
    START TRANSACTION;

    -- Calcular ganancia del ejercicio
    SELECT 
        (COALESCE(SUM(totales.total_positivo), 0) - COALESCE(SUM(totales.total_negativo), 0)) AS ganancia_del_ejercicio
    INTO 
        ganancia_del_ejercicio
    FROM (
        SELECT 
            rubros.rubro,
            COALESCE(SUM(libro_diario.haber), 0) AS total_positivo,
            COALESCE(SUM(libro_diario.debe), 0) AS total_negativo
        FROM 
            libro_diario
        LEFT JOIN 
            rubros ON libro_diario.id_rubro = rubros.id_rubro
        LEFT JOIN 
            grupos ON rubros.id_grupo = grupos.id_grupo
        WHERE 
            grupos.id_grupo IN (4, 5) and libro_diario.fecha_registro between  desde and hasta and libro_diario.descripcion != 'Asiento de cierre'
        GROUP BY 
            rubros.rubro
    ) AS totales;
   
   -- Insertar la ganacia_del_ejercicio en el libro_diario si corresponde
    IF asiento_existe = 0 then
    	
        -- Obtener el último asiento y calcular la ganancia del ejercicio
        SELECT COALESCE(MAX(asiento), 0) + 1, MAX(fecha_registro) INTO ultimo_asiento, fecha_registro_er FROM libro_diario;
        -- Insertar asiento de cierre
        INSERT INTO `libro_diario`(`id_libro_diario`, `asiento`, `id_usuario`, `id_rubro`, `id_sub_rubro`, `id_forma_pago`, `id_cuenta`, `fecha_registro`, `descripcion`, `debe`, `haber`, `gestion`, `activo`) 
        VALUES (NULL, ultimo_asiento, 1, 32, 57, 1, 3, fecha_registro_er, 'Resultado del ejercicio', ABS(ganancia_del_ejercicio), 0, 0, 0);
    END IF;

    -- Actualizar el JSON con la ganancia del ejercicio
    SET estado_resultado = JSON_SET(estado_resultado, '$.Estado_resultado.ganancia_del_ejercicio', ganancia_del_ejercicio);
    
    -- Inicializar los arrays en el JSON
    SET estado_resultado = JSON_SET(
        estado_resultado,
        '$.Estado_resultado.cuentas_resultado_positivo', JSON_ARRAY(),
        '$.Estado_resultado.cuentas_resultado_negativo', JSON_ARRAY()
    );
   
    -- Abre el cursor
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO id_grupo, grupo, id_rubro, rubro, id_sub_rubro, id_forma_pago, id_cuenta, total_positivo, total_negativo;

        IF done THEN
            LEAVE read_loop;
        END IF;

       -- Verifica que los valores de total sean mayores a cero antes de agregarlos al JSON
       -- Ya que si total_positivo es m
        IF total_positivo > 0 THEN
            SET estado_resultado = JSON_ARRAY_APPEND(
                estado_resultado,
                '$.Estado_resultado.cuentas_resultado_positivo',
                JSON_OBJECT(
                    'rubro', rubro,
                    'total', total_positivo
                )
            );
        END IF;

        IF total_negativo > 0 THEN
            SET estado_resultado = JSON_ARRAY_APPEND(
                estado_resultado,
                '$.Estado_resultado.cuentas_resultado_negativo',
                JSON_OBJECT(
                    'rubro', rubro,
                    'total', total_negativo
                )
            );
        END IF;

        -- Insertar asiento de cierre en libro_diario si corresponde
        IF asiento_existe = 0 THEN
            -- Obtener el último asiento y calcular la ganancia del ejercicio
            SELECT COALESCE(MAX(asiento), 0) + 1, MAX(fecha_registro) INTO ultimo_asiento, fecha_registro_er FROM libro_diario;
            -- Insertar asiento de cierre
            INSERT INTO `libro_diario`(`id_libro_diario`, `asiento`, `id_usuario`, `id_rubro`, `id_sub_rubro`, `id_forma_pago`, `id_cuenta`, `fecha_registro`, `descripcion`, `debe`, `haber`, `gestion`, `activo`) 
            VALUES (NULL, ultimo_asiento, 1, id_rubro, id_sub_rubro, id_forma_pago, id_cuenta, fecha_registro_er, 'Asiento de cierre', total_positivo, total_negativo, 0, 0);
        END IF;

    END LOOP;

    -- Cierra el cursor
    CLOSE cur;

    -- Confirma la transacción
    COMMIT;

    -- Validación final
    IF estado_resultado IS NULL THEN
        SET estado_resultado = JSON_OBJECT('Error', 'estado_resultado no contiene datos');
    END IF;

   -- Devolver el JSON
	set resultado = estado_resultado;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getGroupDiary` ()   begin
	SELECT * FROM `grupos` WHERE 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getLedger` (IN `codigo_cuentas` VARCHAR(50))   BEGIN
	DECLARE parte1 VARCHAR(10);
    DECLARE parte2 VARCHAR(10);
    DECLARE parte3 VARCHAR(10);
    DECLARE parte4 VARCHAR(10);
    DECLARE parte5 VARCHAR(10);
    DECLARE pc_saldo_acumulado INT;

    SET parte1 = SUBSTRING_INDEX(codigo_cuentas, '.', 1);
    SET parte2 = SUBSTRING_INDEX(SUBSTRING_INDEX(codigo_cuentas, '.', 2), '.', -1);
    SET parte3 = SUBSTRING_INDEX(SUBSTRING_INDEX(codigo_cuentas, '.', 3), '.', -1);
    SET parte4 = SUBSTRING_INDEX(SUBSTRING_INDEX(codigo_cuentas, '.', 4), '.', -1);
    SET parte5 = SUBSTRING_INDEX(SUBSTRING_INDEX(codigo_cuentas, '.', 5), '.', -1);
    
    SELECT plan_cuenta.saldo_acumulado
    INTO pc_saldo_acumulado
    FROM plan_cuenta
    WHERE plan_cuenta.codigo_cuenta = codigo_cuentas
    LIMIT 1;
    
	SELECT 
        libro_diario.asiento, 
        libro_diario.fecha_registro, 
        cuentas.cuenta,
        libro_diario.debe, 
        libro_diario.haber,
        sub_rubros.sub_rubro,

        -- Columna de saldo deudor, solo se muestra si el saldo acumulado es positivo
        CASE 
            WHEN SUM(libro_diario.debe - libro_diario.haber) OVER (ORDER BY libro_diario.id_libro_diario) > 0 THEN 
                SUM(libro_diario.debe - libro_diario.haber) OVER (ORDER BY libro_diario.id_libro_diario) 
            ELSE 
                0
        END AS saldo_deudor,

        -- Columna de saldo acreedor, solo se muestra si el saldo acumulado es negativo
        CASE 
            WHEN SUM(libro_diario.debe - libro_diario.haber) OVER (ORDER BY libro_diario.id_libro_diario) < 0 THEN 
                ABS(SUM(libro_diario.debe - libro_diario.haber) OVER (ORDER BY libro_diario.id_libro_diario)) 
            ELSE 
                0
        END AS saldo_acreedor,
		CASE 
            WHEN ROW_NUMBER() OVER (ORDER BY libro_diario.id_libro_diario) = 1 THEN pc_saldo_acumulado 
            ELSE NULL 
        END AS saldo_acumulado
    FROM libro_diario
    JOIN cuentas ON libro_diario.id_cuenta = cuentas.id_cuenta
    JOIN sub_rubros ON libro_diario.id_sub_rubro = sub_rubros.id_sub_rubro
    WHERE libro_diario.id_sub_rubro = parte4
    AND libro_diario.id_cuenta = parte5
    ORDER BY 
        libro_diario.id_libro_diario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getListAccountsPlan` ()   BEGIN
	select plan_cuenta.codigo_cuenta , sub_rubros.sub_rubro , cuentas.cuenta , 
	plan_cuenta.saldo_inicial , plan_cuenta.saldo_actual , plan_cuenta.saldo_acumulado , 
	plan_cuenta.fecha_creacion from plan_cuenta 
	join sub_rubros on plan_cuenta.id_sub_rubro = sub_rubros.id_sub_rubro
	join cuentas on plan_cuenta.id_cuenta = cuentas.id_cuenta;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getListAccountsPlanByKeyword` (IN `Keyword` VARCHAR(50))   BEGIN
	SELECT plan_cuenta.codigo_cuenta, sub_rubros.sub_rubro, cuentas.cuenta, 
			plan_cuenta.saldo_inicial, plan_cuenta.saldo_actual, plan_cuenta.saldo_acumulado, 
			plan_cuenta.fecha_creacion
	FROM plan_cuenta
	JOIN sub_rubros ON plan_cuenta.id_sub_rubro = sub_rubros.id_sub_rubro
	JOIN cuentas ON plan_cuenta.id_cuenta = cuentas.id_cuenta
	WHERE sub_rubros.sub_rubro LIKE CONCAT('%', Keyword, '%')
	OR cuentas.cuenta LIKE CONCAT('%', Keyword, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getListBookDiary` ()   begin
	SELECT libro_diario.id_libro_diario, grupos.grupo, tipos.tipo, rubros.rubro, sub_rubros.sub_rubro, 
			formas_pago.forma_pago, cuentas.cuenta, libro_diario.fecha_registro, libro_diario.descripcion, libro_diario.debe, 
			libro_diario.haber, libro_diario.gestion 
			FROM `libro_diario`, `cuentas`, `formas_pago`, `grupos`, `rubros`,`sub_rubros`, `tipos` 
			WHERE (libro_diario.id_rubro = rubros.id_rubro AND libro_diario.id_sub_rubro = sub_rubros.id_sub_rubro
            AND libro_diario.id_forma_pago = formas_pago.id_forma_pago 
            AND libro_diario.id_cuenta = cuentas.id_cuenta) 
			AND (rubros.id_grupo = grupos.id_grupo AND rubros.id_tipo = tipos.id_tipo) AND libro_diario.activo = 1
            ORDER by libro_diario.asiento;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getListUsers` ()   begin

	select usuarios.id_usuario , usuarios.nombre , usuarios.usuario, usuarios.password , usuarios.email  from usuarios ;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getLoginNew` (IN `usu` VARCHAR(150))   begin
	SELECT * FROM `usuarios` WHERE usuario = usu;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getLookForBookDiaryDate` (IN `desde` VARCHAR(10), IN `hasta` VARCHAR(10))   begin

	declare fecha_desde date;
    declare fecha_hasta date; 
    
    set fecha_desde = STR_TO_DATE(desde, '%Y-%m-%d');
    set fecha_hasta = STR_TO_DATE(hasta, '%Y-%m-%d');
   
   select libro_diario.id_libro_diario, libro_diario.fecha_registro, grupos.grupo, tipos.tipo, rubros.rubro, sub_rubros.sub_rubro, 
		   formas_pago.forma_pago, cuentas.cuenta, libro_diario.descripcion, libro_diario.debe, 
		   libro_diario.haber, libro_diario.gestion 
	FROM libro_diario
	JOIN cuentas ON libro_diario.id_cuenta = cuentas.id_cuenta
	JOIN formas_pago ON libro_diario.id_forma_pago = formas_pago.id_forma_pago
	JOIN rubros ON libro_diario.id_rubro = rubros.id_rubro
	JOIN sub_rubros ON libro_diario.id_sub_rubro = sub_rubros.id_sub_rubro
	JOIN grupos ON rubros.id_grupo = grupos.id_grupo
	JOIN tipos ON rubros.id_tipo = tipos.id_tipo
	WHERE libro_diario.fecha_registro BETWEEN fecha_desde AND fecha_hasta;
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getLookForBookDiaryWord` (IN `LookFor` VARCHAR(50))   BEGIN
	SELECT libro_diario.id_libro_diario, libro_diario.fecha_registro, grupos.grupo, tipos.tipo, rubros.rubro, sub_rubros.sub_rubro, 
       formas_pago.forma_pago, cuentas.cuenta, libro_diario.descripcion, libro_diario.debe, 
       libro_diario.haber, libro_diario.gestion 
FROM libro_diario
LEFT JOIN cuentas ON libro_diario.id_cuenta = cuentas.id_cuenta
LEFT JOIN formas_pago ON libro_diario.id_forma_pago = formas_pago.id_forma_pago
LEFT JOIN rubros ON libro_diario.id_rubro = rubros.id_rubro
LEFT JOIN sub_rubros ON libro_diario.id_sub_rubro = sub_rubros.id_sub_rubro
LEFT JOIN grupos ON rubros.id_grupo = grupos.id_grupo
LEFT JOIN tipos ON rubros.id_tipo = tipos.id_tipo
WHERE grupos.grupo LIKE CONCAT('%', LookFor, '%')
   OR tipos.tipo LIKE CONCAT('%', LookFor, '%')
   OR rubros.rubro LIKE CONCAT('%', LookFor, '%')
   OR sub_rubros.sub_rubro LIKE CONCAT('%', LookFor, '%')
   OR formas_pago.forma_pago LIKE CONCAT('%', LookFor, '%')
   OR cuentas.cuenta LIKE CONCAT('%', LookFor, '%')
   OR libro_diario.descripcion LIKE CONCAT('%', LookFor, '%')
   OR libro_diario.debe LIKE CONCAT('%', LookFor, '%')
   OR libro_diario.haber LIKE CONCAT('%', LookFor, '%')
   OR libro_diario.gestion LIKE CONCAT('%', LookFor, '%');

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getPaymentMethods` ()   begin
	SELECT * FROM `formas_pago`;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getRubro` (IN `id_g` INT, IN `id_t` INT)   BEGIN
	SELECT id_rubro, rubro 
	FROM rubros 
	WHERE id_grupo = id_g 
	AND id_tipo = id_t;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSituacionPatrimonial` (IN `desde` DATE, IN `hasta` DATE, OUT `resultado` JSON)   BEGIN
    DECLARE done INT DEFAULT FALSE;
    -- Totales para impctar al final de la situacion paatrimonial
    declare total_activos DOUBLE DEFAULT 0;
    DECLARE total_pasivos_pn DOUBLE DEFAULT 0;
   
   -- Total para impactar en cada array
    DECLARE total DOUBLE DEFAULT 0;
   
    DECLARE ultimo_asiento INT DEFAULT 0;
    DECLARE libro_activo INT DEFAULT 0;

    -- Variables para los datos de cada registro
    DECLARE grupo VARCHAR(100);
    DECLARE tipo VARCHAR(100);
    DECLARE rubro VARCHAR(100);
    DECLARE fecha_registro_er date;
   
    -- JSON para almacenar los datos de la situacion patrimonial
    DECLARE situacion_patrimonial JSON DEFAULT JSON_OBJECT('Situacion_patrimonial', JSON_OBJECT());

    -- Cursor para iterar sobre las cuentas
    DECLARE cur CURSOR FOR 
        SELECT 
		    grupos.grupo,
		    tipos.tipo,
		    rubros.rubro,
		    CASE 
		        WHEN grupos.id_grupo = 1 THEN COALESCE(SUM(libro_diario.debe), 0) - COALESCE(SUM(libro_diario.haber), 0)
		        WHEN grupos.id_grupo IN (2, 3) THEN COALESCE(SUM(libro_diario.haber), 0) - COALESCE(SUM(libro_diario.debe), 0)
		    END AS total
		FROM 
		    libro_diario
		LEFT JOIN 
		    rubros ON libro_diario.id_rubro = rubros.id_rubro
		LEFT JOIN 
		    grupos ON rubros.id_grupo = grupos.id_grupo
		LEFT JOIN 
		    tipos ON rubros.id_tipo = tipos.id_tipo
		WHERE 
		    grupos.id_grupo IN (1, 2, 3) 
		    AND libro_diario.fecha_registro BETWEEN desde AND hasta
		GROUP BY 
		    rubros.rubro;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
   
   -- Manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;  -- Revertir la transacción en caso de error
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error en el procedimiento, se ha realizado un ROLLBACK';
    END;

   
    -- Iniciar la transacción
    START TRANSACTION;

    -- Calcular el total de los activos teniendo en cuenta que:
    -- Aumento del activo  → Se registra en el debe.
    -- Disminución del activo → Se registra en el haber.
   SELECT 
        (COALESCE(SUM(totales.debe), 0) - COALESCE(SUM(totales.haber), 0)) AS total_activos
	into
	total_activos
    FROM (
        SELECT 
            rubros.rubro,
            COALESCE(SUM(libro_diario.haber), 0) AS haber,
            COALESCE(SUM(libro_diario.debe), 0) AS debe
        FROM 
            libro_diario
        LEFT JOIN 
            rubros ON libro_diario.id_rubro = rubros.id_rubro
        LEFT JOIN 
            grupos ON rubros.id_grupo = grupos.id_grupo
        WHERE 
            grupos.id_grupo IN (1) and libro_diario.fecha_registro between  desde and hasta
        GROUP BY 
            rubros.rubro
    ) AS totales;
    
    -- Actualizar el JSON con el total de activos
    SET situacion_patrimonial = JSON_SET(situacion_patrimonial, '$.Situacion_patrimonial.total_activos', total_activos);
    
   -- Calcular el total de los activos teniendo en cuenta que:
    -- Aumento del Pasivo  → Se registra en el haber.
    -- Disminución del Pasivo → Se registra en el debe.
    SELECT 
        (COALESCE(SUM(totales.haber), 0) - COALESCE(SUM(totales.debe), 0)) AS total_pasivos_pn
		INTO	
			total_pasivos_pn
	    FROM (
	        SELECT 
	            rubros.rubro,
	            COALESCE(SUM(libro_diario.haber), 0) AS haber,
	            COALESCE(SUM(libro_diario.debe), 0) AS debe
	        FROM 
	            libro_diario
	        LEFT JOIN 
	            rubros ON libro_diario.id_rubro = rubros.id_rubro
	        LEFT JOIN 
	            grupos ON rubros.id_grupo = grupos.id_grupo
	        WHERE 
	            grupos.id_grupo IN (2,3) and libro_diario.fecha_registro between  desde and hasta
	        GROUP BY 
	            rubros.rubro
	    ) AS totales;
	   -- Actualizar el JSON con el total de activos
    	SET situacion_patrimonial = JSON_SET(situacion_patrimonial, '$.Situacion_patrimonial.total_pasivos_pn', total_pasivos_pn);
    
   
    -- Inicializar los arrays en el JSON
    SET situacion_patrimonial = JSON_SET(
        situacion_patrimonial,
        '$.Situacion_patrimonial.activo_corriente', JSON_ARRAY(),
        '$.Situacion_patrimonial.activo_no_corriente', JSON_ARRAY(),
        '$.Situacion_patrimonial.pasivo_corriente', JSON_ARRAY(),
        '$.Situacion_patrimonial.pasivo_no_corriente', JSON_ARRAY(),
        '$.Situacion_patrimonial.patrimonio_neto', JSON_ARRAY()
    );
   
    -- Abre el cursor
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO grupo, tipo, rubro, total;

        IF done THEN
            LEAVE read_loop;
        END IF;

       -- Verifica que los valores de total sean mayores a cero antes de agregarlos al JSON
       -- Ya que si total_positivo es m
        IF grupo = 'Activos' THEN
		    IF tipo = 'Corriente' THEN
		        SET situacion_patrimonial = JSON_ARRAY_APPEND(
		            situacion_patrimonial,
		            '$.Situacion_patrimonial.activo_corriente',
		            JSON_OBJECT(
		                'rubro', rubro,
		                'total', total
		            )
		        );
		    ELSE
		        SET situacion_patrimonial = JSON_ARRAY_APPEND(
		            situacion_patrimonial,
		            '$.Situacion_patrimonial.activo_no_corriente',
		            JSON_OBJECT(
		                'rubro', rubro,
		                'total', total
		            )
		        );
		    END IF;
		ELSEIF grupo = 'Pasivos' THEN
		    IF tipo = 'Corriente' THEN
		        SET situacion_patrimonial = JSON_ARRAY_APPEND(
		            situacion_patrimonial,
		            '$.Situacion_patrimonial.pasivo_corriente',
		            JSON_OBJECT(
		                'rubro', rubro,
		                'total', total
		            )
		        );
		    ELSE
		        SET situacion_patrimonial = JSON_ARRAY_APPEND(
		            situacion_patrimonial,
		            '$.Situacion_patrimonial.pasivo_no_corriente',
		            JSON_OBJECT(
		                'rubro', rubro,
		                'total', total
		            )
		        );
		    END IF;
		else
			-- Patrimonio neto
		    SET situacion_patrimonial = JSON_ARRAY_APPEND(
		            situacion_patrimonial,
		            '$.Situacion_patrimonial.patrimonio_neto',
		            JSON_OBJECT(
		                'rubro', rubro,
		                'total', total
		            )
		        );
		END IF;

    END LOOP;

    -- Cierra el cursor
    CLOSE cur;
   
   -- Updateamos el libro diario para que ya no se pueda ver
       UPDATE `libro_diario` SET `activo`= 0 WHERE fecha_registro BETWEEN desde and hasta;

    -- Confirma la transacción
    COMMIT;

    -- Validación final
    IF situacion_patrimonial IS NULL THEN
        SET situacion_patrimonial = JSON_OBJECT('Error', 'situacion_patrimonial no contiene datos');
    END IF;

    -- Devolver el JSON
    set resultado = situacion_patrimonial;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSubRubro` (IN `id_ru` INT)   BEGIN
	SELECT id_sub_rubro, sub_rubro
	FROM sub_rubros
	WHERE id_rubro = id_ru;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getType` ()   begin
	SELECT * FROM `tipos` ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertRegisterBookDiary` (IN `dataJson` JSON)   begin
	DECLARE error_code INT DEFAULT 0;
    DECLARE cuenta_exist INT DEFAULT 0;
    DECLARE idx INT DEFAULT 0;
    DECLARE total INT;
    
    -- Declarar variables para almacenar los valores extraídos del JSON
    DECLARE v_asiento INT;
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
   
   SELECT IFNULL(MAX(asiento), 0) + 1 INTO v_asiento FROM libro_diario;
    
    -- Contar el número de registros (asientos) que contiene el JSON
    SET total = JSON_LENGTH(dataJson);

	-- Iniciar la transacción
    START TRANSACTION;
    
     -- Iterar sobre los registros (asientos) y hacer las inserciones
    WHILE idx < total DO
			-- Extraer cada registro del JSON
            SET v_id_usuario = JSON_UNQUOTE(JSON_EXTRACT(dataJson, CONCAT('$[', idx, '].id_usuario')));
            SET v_id_grupo = JSON_UNQUOTE(JSON_EXTRACT(dataJson, CONCAT('$[', idx, '].id_grupo')));
			SET v_id_rubro = JSON_UNQUOTE(JSON_EXTRACT(dataJson, CONCAT('$[', idx, '].id_rubro')));
			SET v_id_sub_rubro = JSON_UNQUOTE(JSON_EXTRACT(dataJson, CONCAT('$[', idx, '].id_sub_rubro')));
			SET v_id_forma_pago = JSON_UNQUOTE(JSON_EXTRACT(dataJson, CONCAT('$[', idx, '].id_forma_pago')));
			SET v_id_cuenta = JSON_UNQUOTE(JSON_EXTRACT(dataJson, CONCAT('$[', idx, '].id_cuenta')));
			SET v_fecha_registro = JSON_UNQUOTE(JSON_EXTRACT(dataJson, CONCAT('$[', idx, '].fecha_registro')));
			SET v_descripcion = JSON_UNQUOTE(JSON_EXTRACT(dataJson, CONCAT('$[', idx, '].descripcion')));
			SET v_debe = JSON_UNQUOTE(JSON_EXTRACT(dataJson, CONCAT('$[', idx, '].debe')));
			SET v_haber = JSON_UNQUOTE(JSON_EXTRACT(dataJson, CONCAT('$[', idx, '].haber')));
			SET v_gestion = JSON_UNQUOTE(JSON_EXTRACT(dataJson, CONCAT('$[', idx, '].gestion')));

		-- Realizar el insert
			INSERT INTO `libro_diario`(`id_libro_diario`, `asiento`,  `id_usuario`, `id_rubro`, `id_sub_rubro`, `id_forma_pago`, `id_cuenta`, `fecha_registro`, `descripcion`, `debe`, `haber`, `gestion`) 
			VALUES (null, v_asiento, v_id_usuario, v_id_rubro, v_id_sub_rubro, v_id_forma_pago, v_id_cuenta, v_fecha_registro, v_descripcion, v_debe, v_haber, v_gestion);
		
		-- Verificar si la cuenta ya existe
		SET v_codigo_cuenta = JSON_UNQUOTE(JSON_EXTRACT(dataJson, CONCAT('$[', idx, '].codigo_cuenta')));
		SELECT COUNT(*) INTO cuenta_exist FROM plan_cuenta WHERE codigo_cuenta = v_codigo_cuenta;
		IF cuenta_exist != 0 then

			-- Si ya existe, obtener los valores actuales
			SELECT saldo_actual, saldo_acumulado INTO v_saldo_actual, v_saldo_acumulado
			FROM plan_cuenta
			WHERE codigo_cuenta = v_codigo_cuenta;
	
			-- Actualizar los saldos según el debe y haber
            IF v_id_grupo = 1 OR v_id_grupo = 5 THEN 
			SET v_saldo_actual = v_saldo_actual + (v_debe - v_haber); 
            SET v_saldo_acumulado = v_saldo_acumulado + (v_debe - v_haber);
			END IF;
			
            IF v_id_grupo = 2 OR v_id_grupo = 3 OR v_id_grupo = 4 THEN 
			SET v_saldo_actual = v_saldo_actual + (v_haber - v_debe); 
            SET v_saldo_acumulado = v_saldo_acumulado + (v_haber - v_debe);
			END IF;
	
			-- Actualizar la cuenta en plan_cuenta
			UPDATE plan_cuenta
			SET saldo_actual = v_saldo_actual,
				saldo_acumulado = v_saldo_acumulado
			WHERE codigo_cuenta = v_codigo_cuenta;
		
		ELSE
			
            -- Inicializa el saldo si no existe la cuenta
			SET v_saldo_actual = 0;
			SET v_saldo_acumulado = 0;
        
			-- Actualizar los saldos según el debe y haber
			IF v_id_grupo = 1 OR v_id_grupo = 5 THEN 
			SET v_saldo_actual = v_saldo_actual + (v_debe - v_haber); 
			SET v_saldo_acumulado = v_saldo_acumulado + (v_debe - v_haber);
            
			END IF;
			
			IF v_id_grupo = 2 OR v_id_grupo = 3 OR v_id_grupo = 4 THEN 
			SET v_saldo_actual = v_saldo_actual + (v_haber - v_debe); 
			SET v_saldo_acumulado = v_saldo_acumulado + (v_haber - v_debe);
			END IF;
			
			-- Realizar el insert
			INSERT INTO plan_cuenta (codigo_cuenta, id_sub_rubro, id_cuenta, saldo_inicial, saldo_actual, saldo_acumulado, fecha_creacion, estado)
			VALUES (v_codigo_cuenta, v_id_sub_rubro, v_id_cuenta,  v_saldo_actual, v_saldo_actual, v_saldo_actual, CURDATE(), 1);
			
		END IF;
        
		SET idx = idx + 1;
        
	END WHILE;
    
	-- Verificar si hubo un error
	GET DIAGNOSTICS CONDITION 1 error_code = MYSQL_ERRNO;
	IF error_code != 0 THEN
		ROLLBACK;
		SELECT 'Ha ocurrido un error durante la operación' AS MESSAGE;
	ELSE
		COMMIT;
		SELECT 'Operación completada exitosamente' AS MESSAGE;
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `login` (IN `dataJson` JSON)   BEGIN
	 DECLARE user_not_found BOOLEAN DEFAULT FALSE;
    
    -- Declarar variables para almacenar los valores extraídos del JSON
    DECLARE v_id_usuario INT;
    DECLARE v_usuario VARCHAR(255);
    DECLARE v_password VARCHAR(255);

    -- Extraer valores del JSON
    SET v_usuario = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.usuario'));
    SET v_password = JSON_UNQUOTE(JSON_EXTRACT(dataJson, '$.clave'));
    
	SELECT id_usuario into v_id_usuario FROM Usuarios 
    WHERE usuario = v_usuario AND password = v_password;
		
	-- Verificar si no se encontró ningún usuario
    IF v_id_usuario IS NULL THEN
        SET user_not_found = TRUE;
    END IF;

    -- Si el usuario no fue encontrado, devolver un mensaje de error
    IF user_not_found THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuario o contraseña incorrectos';
    ELSE
        -- Si todo está bien, devolver el id_usuario
        SELECT v_id_usuario AS id_usuario;
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
  MODIFY `id_libro_diario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

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
