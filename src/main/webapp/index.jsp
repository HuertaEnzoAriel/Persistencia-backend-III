<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Sistema Universidad</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
</head>
<body>
<%@include file="/WEB-INF/vista/_menu.jspf"%>
<main>
    <h1>Sistema Universidad</h1>
    <p class="sub">Elegí una facultad en el menú superior para ver sus carreras, o gestioná las entidades.</p>
    <div class="grid">
        <div class="tarjeta">
            <h2>Alumnos</h2><p>Alta, edición y baja de alumnos con su carrera.</p>
            <a class="btn" href="${pageContext.request.contextPath}/alumno/listar">Ver listado</a>
            <a class="btn verde" href="${pageContext.request.contextPath}/alumno/nuevo">Nuevo</a>
        </div>
        <div class="tarjeta">
            <h2>Materias</h2><p>Administración de las materias.</p>
            <a class="btn" href="${pageContext.request.contextPath}/materia/listar">Ver listado</a>
            <a class="btn verde" href="${pageContext.request.contextPath}/materia/nuevo">Nueva</a>
        </div>
        <div class="tarjeta">
            <h2>Carreras</h2><p>Carreras asociadas a cada facultad.</p>
            <a class="btn" href="${pageContext.request.contextPath}/carrera/listar">Ver listado</a>
            <a class="btn verde" href="${pageContext.request.contextPath}/carrera/nuevo">Nueva</a>
        </div>
    </div>
</main></body></html>
