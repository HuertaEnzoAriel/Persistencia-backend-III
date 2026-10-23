-- Sistema Alumnos - Base de datos completa (MySQL 8, esquema `universidad`).
-- Prácticos Persistencia 1 y 2. Un solo script, NO destructivo: no borra el esquema ni los datos
-- existentes y se puede ejecutar varias veces. Secciones:
--   1. Esquema y datos iniciales (facultad, carrera, alumno, materia, examen)
--   2. Docentes y equipo de cátedra (Práctico 2, Ej. 4)
--   3. Datos de prueba de docentes
--   4. Exámenes de julio de prueba (Práctico 2, Ej. 6)
SET NAMES utf8mb4;
CREATE SCHEMA IF NOT EXISTS `universidad` DEFAULT CHARACTER SET utf8mb4;
USE `universidad`;

-- ============================================================
-- 1. ESQUEMA Y DATOS INICIALES
-- ============================================================
CREATE TABLE IF NOT EXISTS `facultad` (
  `idfacultad` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre`     VARCHAR(45) NULL,
  PRIMARY KEY (`idfacultad`)
) ENGINE = InnoDB;

-- 1:n Non-Identifying: una facultad tiene varias carreras.
CREATE TABLE IF NOT EXISTS `carrera` (
  `idcarrera`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre`             VARCHAR(45) NULL,
  `facultad_idfacultad` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idcarrera`),
  INDEX `fk_carrera_facultad_idx` (`facultad_idfacultad`),
  CONSTRAINT `fk_carrera_facultad` FOREIGN KEY (`facultad_idfacultad`)
    REFERENCES `facultad` (`idfacultad`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- 1:n: una carrera tiene varios alumnos.
CREATE TABLE IF NOT EXISTS `alumno` (
  `idalumno`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre`            VARCHAR(45) NULL,
  `registro`          VARCHAR(20) NULL,
  `carrera_idcarrera` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idalumno`),
  INDEX `fk_alumno_carrera_idx` (`carrera_idcarrera`),
  CONSTRAINT `fk_alumno_carrera` FOREIGN KEY (`carrera_idcarrera`)
    REFERENCES `carrera` (`idcarrera`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `materia` (
  `idmateria` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre`    VARCHAR(45) NULL,
  PRIMARY KEY (`idmateria`)
) ENGINE = InnoDB;

-- n:m alumno-materia (alumno_has_materia renombrada examen). La fecha integra la PK:
-- un alumno puede rendir una materia varias veces.
CREATE TABLE IF NOT EXISTS `examen` (
  `materia_idmateria` INT UNSIGNED NOT NULL,
  `alumno_idalumno`   INT UNSIGNED NOT NULL,
  `fecha`             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `nota`              INT NULL,
  PRIMARY KEY (`materia_idmateria`, `alumno_idalumno`, `fecha`),
  INDEX `fk_examen_alumno_idx` (`alumno_idalumno`),
  CONSTRAINT `fk_examen_materia` FOREIGN KEY (`materia_idmateria`)
    REFERENCES `materia` (`idmateria`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_examen_alumno` FOREIGN KEY (`alumno_idalumno`)
    REFERENCES `alumno` (`idalumno`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- Datos iniciales (solo si las tablas están vacías).
INSERT INTO `facultad` (`nombre`)
SELECT v.n FROM (SELECT 'Ciencias Exactas' AS n UNION ALL SELECT 'Ingeniería') v
WHERE NOT EXISTS (SELECT 1 FROM `facultad`);

INSERT INTO `carrera` (`nombre`, `facultad_idfacultad`)
SELECT v.n, f.idfacultad
FROM (SELECT 'LCC' AS n, 'Ciencias Exactas' AS f
      UNION ALL SELECT 'LSI', 'Ciencias Exactas'
      UNION ALL SELECT 'Ing. Civil', 'Ingeniería') v
JOIN `facultad` f ON f.nombre = v.f
WHERE NOT EXISTS (SELECT 1 FROM `carrera`);

INSERT INTO `alumno` (`nombre`, `registro`, `carrera_idcarrera`)
SELECT v.n, v.r, c.idcarrera
FROM (SELECT 'Juan Álvarez' AS n, 'R-1001' AS r, 'LCC' AS c
      UNION ALL SELECT 'María López', 'R-1002', 'LCC'
      UNION ALL SELECT 'Pedro Ruiz', 'R-1003', 'LSI'
      UNION ALL SELECT 'Sofía Torres', 'R-1004', 'LSI'
      UNION ALL SELECT 'Carlos Méndez', 'R-1005', 'Ing. Civil') v
JOIN `carrera` c ON c.nombre = v.c
WHERE NOT EXISTS (SELECT 1 FROM `alumno`);

INSERT INTO `materia` (`nombre`)
SELECT v.n FROM (SELECT 'Programación I' AS n UNION ALL SELECT 'Bases de Datos'
                 UNION ALL SELECT 'Análisis Matemático') v
WHERE NOT EXISTS (SELECT 1 FROM `materia`);

-- ============================================================
-- 2. DOCENTES Y EQUIPO DE CÁTEDRA
-- ============================================================
-- Los nombres de materia reales no entran en 10 caracteres.
ALTER TABLE `materia` MODIFY `nombre` VARCHAR(45) NULL;

CREATE TABLE IF NOT EXISTS `docente` (
  `iddocente` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre`    VARCHAR(45)  NOT NULL,
  `cargo`     ENUM('TITULAR','ADJUNTO','JTP') NOT NULL,
  PRIMARY KEY (`iddocente`)
) ENGINE = InnoDB;

-- Equipo de cátedra: un docente dicta varias materias y una materia tiene varios docentes.
CREATE TABLE IF NOT EXISTS `materia_has_docente` (
  `materia_idmateria` INT UNSIGNED NOT NULL,
  `docente_iddocente` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`materia_idmateria`, `docente_iddocente`),
  INDEX `fk_mhd_docente_idx` (`docente_iddocente`),
  CONSTRAINT `fk_mhd_materia` FOREIGN KEY (`materia_idmateria`)
    REFERENCES `materia` (`idmateria`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_mhd_docente` FOREIGN KEY (`docente_iddocente`)
    REFERENCES `docente` (`iddocente`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

-- ============================================================
-- 3. DATOS DE PRUEBA: DOCENTES
-- ============================================================
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

-- ============================================================
-- 4. DATOS DE PRUEBA: EXÁMENES DE JULIO
-- ============================================================
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
