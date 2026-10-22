# Estado del proyecto Alumnos vs. Prácticos Persistencia 1 y 2

Proyecto: Jakarta EE 10 (WAR) con JPA, EJB y JSP. Fuente: `src/main`.

## Hecho

| Ítem | Dónde |
|---|---|
| P1 – Entidades Alumno, Materia, Carrera, Facultad, Examen (+ `ExamenPK`) | `com.mycompany.alumnos` |
| P1 – CRUD Alumno / Materia / Carrera | `Manejador` + `WEB-INF/vista/*` |
| P2 Ej.1 – Menú dinámico de facultades | `Manejador.init()` + `_menu.jspf` |
| P2 Ej.2 – Carreras de la facultad elegida | `/Facultad` + `facultad/carreras.jsp` |
| P2 Ej.3 – Alta de alumno con `<select>` de carreras | `alumno/form.jsp` |
| P2 Ej.4 – Docente en la BD | `src/main/setup/02_docente.sql`, `03_docente_datos.sql` |
| P2 Ej.5 – Entidad y bean Docente | `Docente`, `Cargo`, `DocenteFacade`, relación en `Materia` |
| P2 Ej.6.1 – Mesas de julio | `ExamenFacade.findMesasJulio` + `consulta/julio.jsp` |
| P2 Ej.6.2 – Alumnos sin exámenes en el año | `AlumnoFacade.findSinExamenesEnAnio` + `consulta/sinexamenes.jsp` |
| P2 Ej.6.3 – Docentes con más de 2 materias | `DocenteFacade.findConMasDeMaterias` + `consulta/docentes.jsp` |
| Limpieza | plantilla REST borrada; CRUD solo con Facades; `eliminar` por POST; parámetros validados |

## Pendiente

- [ ] Probar de punta a punta: correr los scripts 02 y 03 en la base `universidad`, desplegar y revisar las tres consultas.
- [ ] Primer commit, subir a un repositorio y compartir el link (límite **30-oct**).
- [ ] Opcional: formulario para cargar `Examen` desde la app (hoy solo por SQL).

## Notas

- Pool JDBC `jdbc/universidad`: ejemplo en `src/main/setup/glassfish-resources.xml.ejemplo` (completar la contraseña).
- `target/` está en `.gitignore`.
