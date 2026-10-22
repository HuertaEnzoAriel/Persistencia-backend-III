-- Datos de prueba: mesas de examen del turno de julio del año en curso (después de 03_docente_datos.sql).
-- Usa los 3 primeros alumnos y las 2 primeras materias, así los demás alumnos quedan sin exámenes
-- (sirve para la consulta 6.2). Se puede ejecutar varias veces: INSERT IGNORE salta las PK repetidas.
-- Requiere filas en `alumno` y `materia`.
SET NAMES utf8mb4;
USE `universidad`;

INSERT IGNORE INTO `examen` (`materia_idmateria`, `alumno_idalumno`, `fecha`, `nota`)
SELECT m.idmateria,
       a.idalumno,
       DATE_ADD(CONCAT(YEAR(CURDATE()), '-07-10 09:00:00'), INTERVAL (m.idmateria MOD 3) * 7 DAY),
       4 + MOD(a.idalumno * 3 + m.idmateria * 2, 7)          -- nota entre 4 y 10
FROM (SELECT idalumno  FROM `alumno`  ORDER BY idalumno  LIMIT 3) a
CROSS JOIN (SELECT idmateria FROM `materia` ORDER BY idmateria LIMIT 2) m;

-- Un examen fuera de julio, para comprobar que la consulta 6.1 lo filtra.
INSERT IGNORE INTO `examen` (`materia_idmateria`, `alumno_idalumno`, `fecha`, `nota`)
SELECT m.idmateria, a.idalumno, CONCAT(YEAR(CURDATE()), '-12-05 09:00:00'), 8
FROM (SELECT idalumno  FROM `alumno`  ORDER BY idalumno  LIMIT 1) a
CROSS JOIN (SELECT idmateria FROM `materia` ORDER BY idmateria LIMIT 1) m;

-- Verificación: debe mostrar solo los de julio (6 filas con 3 alumnos y 2 materias).
SELECT a.nombre AS alumno, m.nombre AS materia, e.fecha, e.nota
FROM `examen` e
JOIN `alumno` a  ON a.idalumno  = e.alumno_idalumno
JOIN `materia` m ON m.idmateria = e.materia_idmateria
WHERE MONTH(e.fecha) = 7 AND YEAR(e.fecha) = YEAR(CURDATE())
ORDER BY e.fecha, m.nombre, a.nombre;
