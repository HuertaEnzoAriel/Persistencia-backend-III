<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>carrera</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
</head>
<body>
<%@include file="/WEB-INF/vista/_menu.jspf"%>
<main>
    <h1>${empty carrera.idcarrera ? 'Nueva' : 'Editar'} carrera</h1>
    <p class="sub">Completá los datos y guardá.</p>
    <form class="tarjeta" action="${pageContext.request.contextPath}/carrera/guardar" method="post">
        <input type="hidden" name="idcarrera" value="${carrera.idcarrera}">
        <div class="campo"><label for="nombre">Nombre</label>
            <input type="text" id="nombre" name="nombre" maxlength="45" value="${carrera.nombre}" required></div>
        <div class="campo"><label for="facultad">Facultad</label>
            <select id="facultad" name="facultad" required>
                <option value="">-- Seleccionar facultad --</option>
                <c:forEach items="${listaFacultades}" var="f">
                    <option value="${f.idfacultad}" ${carrera.facultadIdfacultad.idfacultad == f.idfacultad ? "selected" : ""}>${f.nombre}</option>
                </c:forEach>
            </select></div>
        <button class="btn verde" type="submit">Guardar</button>
        <a class="btn gris" href="${pageContext.request.contextPath}/carrera/listar">Cancelar</a>
    </form>
</main></body></html>
