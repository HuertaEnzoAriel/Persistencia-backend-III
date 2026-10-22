-- Datos de prueba para docentes (después de 02_docente.sql). Se puede ejecutar varias veces sin duplicar.
-- Pérez dicta las 3 primeras materias (sirve para la consulta "más de 2 materias"),
-- Gómez dicta 2 y Díaz 1. Requiere que la tabla `materia` tenga al menos 3 filas.
SET NAMES utf8mb4;
USE `universidad`;

-- 1) Limpieza de duplicados de corridas anteriores (se conserva el docente de menor id por nombre).
--    Las filas de materia_has_docente de los borrados caen por ON DELETE CASCADE.
--    El modo seguro de Workbench (error 1175) rechaza este DELETE, así que se apaga solo durante el paso.
SET @safe_anterior = @@SQL_SAFE_UPDATES;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM `docente`
WHERE `iddocente` NOT IN (
  SELECT `keep_id` FROM (SELECT MIN(`iddocente`) AS `keep_id` FROM `docente` GROUP BY `nombre`) k
);
SET SQL_SAFE_UPDATES = @safe_anterior;

-- 2) Docentes (solo si no existen).
INSERT INTO `docente` (`nombre`, `cargo`)
SELECT v.nombre, v.cargo
FROM (SELECT 'Ana Pérez' AS nombre, 'TITULAR' AS cargo
      UNION ALL SELECT 'Luis Gómez', 'ADJUNTO'
      UNION ALL SELECT 'Marta Díaz', 'JTP') v
WHERE NOT EXISTS (SELECT 1 FROM `docente` d WHERE d.nombre = v.nombre);

-- 3) Equipo de cátedra. INSERT IGNORE salta los pares que ya existen (PK compuesta).
INSERT IGNORE INTO `materia_has_docente` (`materia_idmateria`, `docente_iddocente`)
SELECT m.idmateria, d.iddocente
FROM (SELECT idmateria FROM `materia` ORDER BY idmateria LIMIT 3) m
JOIN `docente` d ON d.nombre = 'Ana Pérez';

INSERT IGNORE INTO `materia_has_docente` (`materia_idmateria`, `docente_iddocente`)
SELECT m.idmateria, d.iddocente
FROM (SELECT idmateria FROM `materia` ORDER BY idmateria LIMIT 2) m
JOIN `docente` d ON d.nombre = 'Luis Gómez';

INSERT IGNORE INTO `materia_has_docente` (`materia_idmateria`, `docente_iddocente`)
SELECT m.idmateria, d.iddocente
FROM (SELECT idmateria FROM `materia` ORDER BY idmateria LIMIT 1) m
JOIN `docente` d ON d.nombre = 'Marta Díaz';

-- Verificación: debería mostrar Pérez=3, Gómez=2, Díaz=1.
SELECT d.nombre, COUNT(h.materia_idmateria) AS materias
FROM `docente` d LEFT JOIN `materia_has_docente` h ON h.docente_iddocente = d.iddocente
GROUP BY d.iddocente, d.nombre;
