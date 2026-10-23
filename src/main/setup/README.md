# Instalación del Sistema Alumnos

Aplicación Jakarta EE 10 (WAR): JPA + EJB + JSP, base MySQL 8, servidor GlassFish 7.

## Requisitos

- JDK 11 o superior y Maven
- MySQL 8 (o MariaDB equivalente) corriendo en `localhost:3306`
- GlassFish Server 7.x
- Conector JDBC de MySQL (`mysql-connector-j`, p. ej. 8.x) copiado en `<glassfish>/glassfish/domains/domain1/lib/`

## 1. Base de datos

Ejecutar el script único (no borra datos, se puede repetir):

```bash
mysql -u root -p < src/main/setup/universidad.sql
```

O abrirlo en MySQL Workbench y ejecutarlo completo. Crea el esquema `universidad` con las tablas
`facultad`, `carrera`, `alumno`, `materia`, `examen`, `docente` y `materia_has_docente`, y carga datos
de prueba (alumnos, docentes, exámenes de julio del año en curso). La última sección muestra dos
consultas de verificación.

## 2. Pool de conexiones y data source en GlassFish

La unidad de persistencia usa el JNDI `jdbc/universidad`. Dos opciones:

**a) Línea de comandos** (con el dominio iniciado: `asadmin start-domain`):

```bash
cp src/main/setup/glassfish-resources.xml.ejemplo /tmp/glassfish-resources.xml
# editar /tmp/glassfish-resources.xml y reemplazar CAMBIAR_PASSWORD
asadmin add-resources /tmp/glassfish-resources.xml
asadmin ping-connection-pool universidadPool      # debe responder "Command ping-connection-pool executed successfully"
```

**b) Consola de administración** (http://localhost:4848):
Resources > JDBC > JDBC Connection Pools > New. Nombre `universidadPool`, tipo
`javax.sql.DataSource`, clase `com.mysql.cj.jdbc.MysqlDataSource`. En Additional Properties cargar
`URL=jdbc:mysql://localhost:3306/universidad?useUnicode=true&characterEncoding=UTF-8`, `User`,
`Password` y `useSSL=false`. Guardar y hacer **Ping**. Luego JDBC Resources > New con JNDI Name
`jdbc/universidad` y ese pool.

Para usar otros nombres de esquema o de JNDI hay que cambiarlos también en
`src/main/resources/META-INF/persistence.xml` y en el atributo `catalog` de las entidades.

## 3. Compilar y desplegar

```bash
mvn clean package
asadmin deploy --force target/Alumnos-1.0-SNAPSHOT.war
```

También se puede desplegar desde NetBeans (Run) o desde la consola de GlassFish.

## 4. Probar

Abrir http://localhost:8080/Alumnos-1.0-SNAPSHOT/ y verificar:

- El menú **Facultades** lista las facultades de la base y cada una muestra sus carreras.
- ABM de **Alumnos** (con selección de carrera y facultad en el listado), **Materias** y **Carreras**.
- Menú **Consultas**: mesas de julio, alumnos sin exámenes del año y docentes con más de 2 materias
  (con los datos de prueba: Ana Pérez dicta 3 materias).

## Problemas frecuentes

- *Falla el ping del pool*: revisar usuario/contraseña y que el conector JDBC esté en `domain1/lib`
  (reiniciar el dominio después de copiarlo).
- *La app no despliega, `jdbc/universidad` no existe*: falta el paso 2.
- *El menú de facultades aparece vacío*: la lista se carga al iniciar la app; si se cargan facultades
  nuevas en la base hay que redesplegar.
- *Error 1175 en Workbench*: el script ya desactiva el modo seguro solo durante la limpieza de docentes.
