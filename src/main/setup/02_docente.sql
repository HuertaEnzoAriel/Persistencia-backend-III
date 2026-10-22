-- Práctico 2 - Ejercicio 4: entidad Docente y equipo de cátedra (N:M con materia).
-- Script NO destructivo: no borra el esquema ni los datos existentes. Se puede ejecutar varias veces.
SET NAMES utf8mb4;
USE `universidad`;

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
