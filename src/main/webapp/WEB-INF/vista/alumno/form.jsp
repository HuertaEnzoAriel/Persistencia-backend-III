<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>alumno</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
</head>
<body>
<%@include file="/WEB-INF/vista/_menu.jspf"%>
<main>
    <h1>${empty alumno.idalumno ? 'Nuevo' : 'Editar'} alumno</h1>
    <p class="sub">Completá los datos y guardá.</p>
    <form class="tarjeta" action="${pageContext.request.contextPath}/alumno/guardar" method="post">
        <input type="hidden" name="idalumno" value="${alumno.idalumno}">
        <div class="campo"><label for="nombre">Nombre</label>
            <input type="text" id="nombre" name="nombre" maxlength="45" value="${alumno.nombre}" required></div>
        <div class="campo"><label for="registro">Registro</label>
            <input type="text" id="registro" name="registro" maxlength="20" value="${alumno.registro}" required></div>
        <div class="campo"><label for="carrera">Carrera</label>
            <select id="carrera" name="carrera" required>
                <option value="">-- Seleccionar carrera --</option>
                <c:forEach items="${carreras}" var="c">
                    <option value="${c.idcarrera}" ${alumno.carreraIdcarrera.idcarrera == c.idcarrera ? "selected" : ""}>${c.nombre} (${c.facultadIdfacultad.nombre})</option>
                </c:forEach>
            </select></div>
        <button class="btn verde" type="submit">Guardar</button>
        <a class="btn gris" href="${pageContext.request.contextPath}/alumno/listar">Cancelar</a>
    </form>
</main></body></html>
